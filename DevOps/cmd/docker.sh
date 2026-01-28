#!/bin/bash
# sudo chmod -R 777 /home/cmon/appcmon
# sudo chmod -R 777 /home/cmon/developer_document/DevOps/cmd
# developer_document/DevOps/cmd
# สคริปต์ติดตั้ง Docker, Python, Node.js และ Docker Compose บน Ubuntu
# โดย: [ใส่ชื่อผู้สร้าง]
# วันที่: $(date)  y
# sudo ./docker.sh
#!/bin/bash

# สคริปต์ติดตั้ง Docker, Python, Node.js และ Docker Compose บน Ubuntu
# แก้ไขปัญหา docker-compose command not found

set -e

# ฟังก์ชันแสดงข้อความสถานะ
print_status() {
    echo -e "\n\033[1;34m==>\033[0m \033[1m$1\033[0m"
}

# ฟังก์ชันแสดงข้อความสำเร็จ
print_success() {
    echo -e "\033[1;32m✓\033[0m $1"
}

# ฟังก์ชันแสดงข้อความผิดพลาด
print_error() {
    echo -e "\033[1;31m✗\033[0m $1" >&2
}

# ฟังก์ชันติดตั้ง Docker Compose (แก้ไขใหม่)
install_docker_compose() {
    print_status "กำลังติดตั้ง Docker Compose..."
    
    # ตรวจสอบว่ามี docker-compose อยู่แล้วหรือไม่
    if command -v docker-compose &> /dev/null; then
        print_status "พบ Docker Compose อยู่แล้ว: $(docker-compose --version)"
        return 0
    fi
    
    # วิธีที่ 1: ดาวน์โหลด Docker Compose เวอร์ชันล่าสุด
    print_status "กำลังดาวน์โหลด Docker Compose..."
    
    # ตรวจสอบเวอร์ชันล่าสุด
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    
    echo "กำลังติดตั้ง Docker Compose เวอร์ชัน: $COMPOSE_VERSION"
    
    # ดาวน์โหลด Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    if [ $? -eq 0 ]; then
        # กำหนดสิทธิ์การรัน
        chmod +x /usr/local/bin/docker-compose
        
        # สร้าง symbolic link ไปยัง /usr/bin
        ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose 2>/dev/null || true
        
        # ตรวจสอบการติดตั้ง
        if /usr/local/bin/docker-compose --version &> /dev/null; then
            print_success "ติดตั้ง Docker Compose สำเร็จ: $(/usr/local/bin/docker-compose --version)"
        else
            # ลองวิธีที่ 2: ติดตั้งผ่าน pip
            print_status "ลองติดตั้งผ่าน pip..."
            pip3 install docker-compose
            
            # ตรวจสอบอีกครั้ง
            if docker-compose --version &> /dev/null; then
                print_success "ติดตั้ง Docker Compose ผ่าน pip สำเร็จ"
            else
                # วิธีที่ 3: ใช้ docker compose plugin (Docker v2)
                print_status "ลองใช้ Docker Compose Plugin..."
                if docker compose version &> /dev/null; then
                    print_success "ใช้ Docker Compose Plugin สำเร็จ"
                    # สร้าง alias สำหรับ docker-compose
                    echo 'alias docker-compose="docker compose"' >> /etc/profile.d/docker-compose.sh
                    chmod +x /etc/profile.d/docker-compose.sh
                    source /etc/profile.d/docker-compose.sh
                else
                    print_error "ไม่สามารถติดตั้ง Docker Compose ได้"
                    return 1
                fi
            fi
        fi
    else
        print_error "ดาวน์โหลด Docker Compose ล้มเหลว"
        return 1
    fi
    
    # ตรวจสอบ PATH
    print_status "ตรวจสอบ PATH..."
    echo "PATH: $PATH"
    echo "ตำแหน่ง docker-compose: $(which docker-compose 2>/dev/null || echo 'ไม่พบ')"
    
    return 0
}

# ฟังก์ชันติดตั้ง Docker
install_docker() {
    print_status "กำลังติดตั้ง Docker..."
    
    # ติดตั้งแพ็คเกจที่จำเป็น
    apt-get update
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        gnupg \
        lsb-release
    
    # เพิ่ม Docker GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # เพิ่ม Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # อัพเดทแพ็คเกจลิสต์
    apt-get update
    
    # ติดตั้ง Docker Engine
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    
    # เริ่มต้นและเปิดใช้งาน Docker service
    systemctl start docker
    systemctl enable docker
    
    # เพิ่มผู้ใช้งานปัจจุบันเข้า Docker group
    if [ "$SUDO_USER" != "" ]; then
        usermod -aG docker $SUDO_USER
        print_status "เพิ่มผู้ใช้งาน $SUDO_USER เข้า Docker group แล้ว"
    fi
    
    # ตรวจสอบการติดตั้ง
    docker --version
    
    print_success "ติดตั้ง Docker สำเร็จแล้ว"
}

# ฟังก์ชันติดตั้ง Python
install_python() {
    print_status "กำลังติดตั้ง Python..."
    apt-get install -y python3 python3-pip python3-venv
    print_success "ติดตั้ง Python สำเร็จ: $(python3 --version)"
}

# ฟังก์ชันติดตั้ง Node.js
install_nodejs() {
    print_status "กำลังติดตั้ง Node.js 22.20.0..."
    
    # ติดตั้ง curl หากยังไม่มี
    apt-get install -y curl
    
    # ติดตั้ง Node.js 22.x
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt-get install -y nodejs
    
    # ติดตั้ง n สำหรับจัดการเวอร์ชัน
    npm install -g n
    
    # ติดตั้ง Node.js 22.20.0
    n 22.20.0
    
    # อัพเดท PATH
    export PATH="$PATH:/usr/local/bin"
    
    print_success "ติดตั้ง Node.js สำเร็จ: $(node --version)"
}

# ฟังก์ชันแก้ไขปัญหา PATH
fix_path_issues() {
    print_status "กำลังแก้ไขปัญหา PATH..."
    
    # เพิ่ม /usr/local/bin ไปยัง PATH หากยังไม่มี
    if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
        echo 'export PATH="/usr/local/bin:$PATH"' >> /etc/profile.d/custom_path.sh
        chmod +x /etc/profile.d/custom_path.sh
        export PATH="/usr/local/bin:$PATH"
        print_success "เพิ่ม /usr/local/bin ไปยัง PATH แล้ว"
    fi
    
    # สร้าง symbolic link สำรอง
    if [ -f /usr/local/bin/docker-compose ] && [ ! -f /usr/bin/docker-compose ]; then
        ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
        print_success "สร้าง symbolic link สำหรับ docker-compose แล้ว"
    fi
    
    # สร้าง alias สำหรับ docker compose plugin
    if ! command -v docker-compose &> /dev/null && docker compose version &> /dev/null; then
        echo 'alias docker-compose="docker compose"' >> /etc/profile.d/docker-alias.sh
        chmod +x /etc/profile.d/docker-alias.sh
        source /etc/profile.d/docker-alias.sh
        print_success "สร้าง alias docker-compose='docker compose' แล้ว"
    fi
}

# ฟังก์ชันตรวจสอบการติดตั้ง
verify_installation() {
    print_status "\nกำลังตรวจสอบการติดตั้ง..."
    
    echo ""
    echo "=== ผลการตรวจสอบ ==="
    
    # ตรวจสอบ Python
    if command -v python3 &> /dev/null; then
        echo "✓ Python: $(python3 --version 2>/dev/null || echo 'ติดตั้งแล้ว')"
    else
        echo "✗ Python: ไม่พบ"
    fi
    
    # ตรวจสอบ Node.js
    if command -v node &> /dev/null; then
        echo "✓ Node.js: $(node --version 2>/dev/null || echo 'ติดตั้งแล้ว')"
    else
        echo "✗ Node.js: ไม่พบ"
    fi
    
    # ตรวจสอบ Docker
    if command -v docker &> /dev/null; then
        echo "✓ Docker: $(docker --version 2>/dev/null || echo 'ติดตั้งแล้ว')"
    else
        echo "✗ Docker: ไม่พบ"
    fi
    
    # ตรวจสอบ Docker Compose
    if command -v docker-compose &> /dev/null; then
        echo "✓ Docker Compose: $(docker-compose --version 2>/dev/null || echo 'ติดตั้งแล้ว')"
    elif docker compose version &> /dev/null; then
        echo "✓ Docker Compose Plugin: $(docker compose version --short 2>/dev/null || echo 'ใช้งานได้')"
    else
        echo "✗ Docker Compose: ไม่พบ"
    fi
    
    echo ""
}

# ฟังก์ชันแสดงวิธีแก้ไขปัญหา
show_troubleshooting() {
    echo ""
    echo "=== แก้ไขปัญหา docker-compose not found ==="
    echo ""
    echo "หากยังพบปัญหา ให้ลองวิธีต่อไปนี้:"
    echo ""
    echo "1. อัพเดท PATH:"
    echo "   source /etc/profile.d/custom_path.sh"
    echo ""
    echo "2. ใช้ Docker Compose Plugin:"
    echo "   docker compose version"
    echo ""
    echo "3. สร้าง alias:"
    echo "   alias docker-compose='docker compose'"
    echo ""
    echo "4. ตรวจสอบตำแหน่งไฟล์:"
    echo "   ls -la /usr/local/bin/docker-compose"
    echo "   ls -la /usr/bin/docker-compose"
    echo ""
    echo "5. รีสตาร์ท terminal หรือ logout/login ใหม่"
}

# ฟังก์ชันหลัก
main() {
    echo "=========================================="
    echo "   สคริปต์ติดตั้ง Docker Stack บน Ubuntu   "
    echo "=========================================="
    
    # ตรวจสอบสิทธิ์ root
    if [[ $EUID -ne 0 ]]; then
        print_error "ต้องใช้สิทธิ์ root (sudo) ในการรันสคริปต์นี้"
        exit 1
    fi
    
    # ขอการยืนยัน
    read -p "ต้องการติดตั้งตอนนี้หรือไม่? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "ยกเลิกการติดตั้ง"
        exit 0
    fi
    
    # ติดตั้งตามลำดับ
    install_python
    install_nodejs
    install_docker
    install_docker_compose
    fix_path_issues
    
    # ตรวจสอบการติดตั้ง
    verify_installation
    
    # แสดงวิธีแก้ไขปัญหา
    show_troubleshooting
    
    echo ""
    print_success "การติดตั้งเสร็จสมบูรณ์!"
    echo "หมายเหตุ: กรุณาเปิด terminal ใหม่หรือรัน 'source ~/.bashrc' เพื่อให้การเปลี่ยนแปลงมีผล"
}

# รันฟังก์ชันหลัก
main "$@"