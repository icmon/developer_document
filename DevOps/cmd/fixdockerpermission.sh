#!/bin/bash
# sudo chmod -R 777 /home/cmon/appcmon
# sudo chmod -R 777 /home/cmon/developer_document/DevOps/cmd
# developer_document/DevOps/cmd
# สคริปต์ติดตั้ง Docker, Python, Node.js และ Docker Compose บน Ubuntu
# โดย: [ใส่ชื่อผู้สร้าง]
# วันที่: $(date)  y
# sudo ./docker.sh
#!/bin/bash
# sudo ./fixdockerpermission.sh

# สคริปต์ติดตั้ง Docker, Python, Node.js และ Docker Compose บน Ubuntu
# แก้ไขปัญหา docker-compose command not found
#!/bin/bash

# สคริปต์แก้ไขปัญหา Docker Permission Denied และ Docker Compose Issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

fix_docker_permission() {
    print_status "กำลังแก้ไขปัญหา Docker permission..."
    
    # ตรวจสอบว่ามี Docker หรือไม่
    if ! command -v docker &> /dev/null; then
        print_error "ไม่พบ Docker กรุณาติดตั้ง Docker ก่อน"
        exit 1
    fi
    
    # ตรวจสอบผู้ใช้ปัจจุบัน
    CURRENT_USER=$(whoami)
    print_status "ผู้ใช้ปัจจุบัน: $CURRENT_USER"
    
    # ตรวจสอบว่า user อยู่ใน docker group หรือไม่
    if groups $CURRENT_USER | grep -q '\bdocker\b'; then
        print_success "ผู้ใช้ $CURRENT_USER อยู่ใน docker group แล้ว"
    else
        print_status "เพิ่มผู้ใช้ $CURRENT_USER เข้า docker group..."
        sudo usermod -aG docker $CURRENT_USER
        print_success "เพิ่มผู้ใช้เข้า docker group สำเร็จ"
    fi
    
    # ตรวจสอบสิทธิ์ docker socket
    DOCKER_SOCK="/var/run/docker.sock"
    if [ -S $DOCKER_SOCK ]; then
        SOCK_PERM=$(stat -c "%A %U %G" $DOCKER_SOCK)
        print_status "สิทธิ์ Docker socket: $SOCK_PERM"
        
        if [ ! -w $DOCKER_SOCK ]; then
            print_warning "ผู้ใช้ไม่มีสิทธิ์เขียน Docker socket"
            print_status "กำลังแก้ไขสิทธิ์ชั่วคราว..."
            sudo chmod 666 $DOCKER_SOCK
            print_success "แก้ไขสิทธิ์ Docker socket สำเร็จ"
        fi
    fi
    
    # แก้ไขปัญหา SELinux (ถ้ามี)
    if command -v getenforce &> /dev/null; then
        if [ "$(getenforce)" = "Enforcing" ]; then
            print_status "ตรวจพบ SELinux ในโหมด Enforcing"
            print_status "กำลังติดตั้ง docker-selinux..."
            sudo yum install -y docker-selinux 2>/dev/null || true
            print_status "ตั้งค่า SELinux context..."
            sudo chcon -t docker_var_run_t $DOCKER_SOCK 2>/dev/null || true
        fi
    fi
    
    print_success "แก้ไขปัญหา Docker permission สำเร็จ"
}

fix_docker_compose_syntax() {
    print_status "ตรวจสอบไฟล์ docker-compose.yml..."
    
    COMPOSE_FILE="docker-compose.yml"
    
    if [ -f "$COMPOSE_FILE" ]; then
        print_status "พบไฟล์ $COMPOSE_FILE"
        
        # ตรวจสอบว่ามี version attribute หรือไม่
        if grep -q '^version:' "$COMPOSE_FILE"; then
            print_warning "พบ version attribute ใน $COMPOSE_FILE"
            
            # สำรองไฟล์เดิม
            BACKUP_FILE="${COMPOSE_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
            cp "$COMPOSE_FILE" "$BACKUP_FILE"
            print_status "สร้างไฟล์สำรอง: $BACKUP_FILE"
            
            # ลบ version line
            sed -i '/^version:/d' "$COMPOSE_FILE"
            
            # แก้ไข syntax ถ้าจำเป็น
            if grep -q '^services:' "$COMPOSE_FILE"; then
                print_success "ลบ version attribute ออกแล้ว"
            else
                # แปลงจาก syntax เก่า
                print_status "กำลังแปลง syntax docker-compose.yml..."
                
                # นี่คือตัวอย่างการแปลงพื้นฐาน
                # ในกรณีจริงอาจต้องการ conversion tool
                print_warning "อาจต้องแก้ไข syntax ด้วยมือ"
            fi
        else
            print_success "ไฟล์ $COMPOSE_FILE ใช้ syntax ที่ถูกต้องแล้ว"
        fi
    else
        print_warning "ไม่พบไฟล์ $COMPOSE_FILE"
        
        # สร้างตัวอย่างไฟล์ docker-compose.yml
        print_status "สร้างไฟล์ docker-compose.yml ตัวอย่าง..."
        
        cat > docker-compose.yml << 'EOF'
services:
  app:
    image: nginx:alpine
    container_name: web-app
    ports:
      - "80:80"
    restart: unless-stopped

  db:
    image: postgres:alpine
    container_name: database
    environment:
      POSTGRES_PASSWORD: example
    volumes:
      - db_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  db_data:
EOF
        
        print_success "สร้างไฟล์ docker-compose.yml ตัวอย่างสำเร็จ"
    fi
}

test_docker() {
    print_status "ทดสอบ Docker..."
    
    if docker ps &> /dev/null; then
        print_success "Docker ทำงานได้ปกติ"
        
        # ทดสอบรัน container
        print_status "ทดสอบรัน container..."
        if docker run --rm hello-world &> /dev/null; then
            print_success "สามารถรัน container ได้"
        else
            print_error "ไม่สามารถรัน container ได้"
        fi
    else
        print_error "Docker ไม่สามารถเชื่อมต่อได้"
        return 1
    fi
}

test_docker_compose() {
    print_status "ทดสอบ Docker Compose..."
    
    # ตรวจสอบว่าใช้คำสั่งอะไร
    if docker compose version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
        print_status "ใช้ Docker Compose Plugin"
    elif command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
        print_status "ใช้ Docker Compose Standalone"
    else
        print_error "ไม่พบ Docker Compose"
        return 1
    fi
    
    # ทดสอบคำสั่ง
    if $DOCKER_COMPOSE_CMD version &> /dev/null; then
        print_success "Docker Compose ทำงานได้ปกติ"
        
        # ทดสอบ validate docker-compose.yml
        if [ -f "docker-compose.yml" ]; then
            print_status "ตรวจสอบ syntax docker-compose.yml..."
            if $DOCKER_COMPOSE_CMD config &> /dev/null; then
                print_success "ไฟล์ docker-compose.yml syntax ถูกต้อง"
            else
                print_error "ไฟล์ docker-compose.yml มี syntax error"
                return 1
            fi
        fi
    else
        print_error "Docker Compose ไม่ทำงาน"
        return 1
    fi
}

show_instructions() {
    echo ""
    print_status "คำแนะนำหลังจากแก้ไขปัญหา:"
    echo ""
    echo "1. ${GREEN}Logout และ Login ใหม่${NC}"
    echo "   หลังจากเพิ่มผู้ใช้เข้า docker group"
    echo ""
    echo "2. ${GREEN}หรือรันคำสั่งนี้แทน:${NC}"
    echo "   newgrp docker"
    echo ""
    echo "3. ${GREEN}ทดสอบ Docker:${NC}"
    echo "   docker ps"
    echo "   docker run hello-world"
    echo ""
    echo "4. ${GREEN}ทดสอบ Docker Compose:${NC}"
    echo "   docker compose version"
    echo "   หรือ docker-compose version"
    echo ""
    echo "5. ${GREEN}ตรวจสอบไฟล์ docker-compose.yml:${NC}"
    echo "   docker compose config"
    echo ""
    echo "6. ${GREEN}รัน Docker Compose:${NC}"
    echo "   docker compose up -d"
    echo ""
}

main() {
    echo "=========================================="
    echo "  แก้ไขปัญหา Docker Permission Denied     "
    echo "=========================================="
    
    # แก้ไขปัญหา
    fix_docker_permission
    fix_docker_compose_syntax
    
    # ทดสอบ
    test_docker
    test_docker_compose
    
    # แสดงคำแนะนำ
    show_instructions
    
    print_success "การแก้ไขปัญหาเสร็จสมบูรณ์!"
    echo ""
    print_warning "สำคัญ: กรุณา logout และ login ใหม่เพื่อให้การเปลี่ยนแปลงมีผล"
}

# รันสคริปต์
main "$@"