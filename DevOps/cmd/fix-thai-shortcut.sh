#!/bin/bash
# fix-thai-shortcut.sh
# ตั้งค่าปัดเปลี่ยนภาษาไทย-อังกฤษด้วย Alt+Ctrl

echo "========================================"
echo "   ตั้งค่าปัดเปลี่ยนภาษาไทย-อังกฤษ"
echo "          (Alt+Ctrl Version)"
echo "========================================"
echo ""

# ตรวจสอบสิทธิ์
if [ "$EUID" -eq 0 ]; then 
    echo "⚠️  ไม่ควรรันสคริปต์นี้ด้วย sudo"
    echo "   ออกจากโหมด root และรันใหม่"
    exit 1
fi

# ฟังก์ชันหลัก
main() {
    show_current_status
    set_alt_ctrl_shortcut
    verify_settings
    create_direct_shortcuts
    fix_common_issues
    show_usage_guide
}

# แสดงสถานะปัจจุบัน
show_current_status() {
    echo "=== สถานะปัจจุบัน ==="
    
    # ตรวจสอบการติดตั้งภาษาไทย
    echo -n "✓ ตรวจสอบภาษาไทย: "
    if gsettings get org.gnome.desktop.input-sources sources | grep -q "'th'"; then
        echo "ติดตั้งแล้ว"
    else
        echo "⚠️  ยังไม่ได้ติดตั้ง"
        echo "   โปรดติดตั้งภาษาไทยใน Settings → Region & Language ก่อน"
        echo "   หรือรัน: sudo apt install language-pack-th ibus-anthy"
        exit 1
    fi
    
    # แสดงปุ่มลัดปัจจุบัน
    CURRENT_SHORTCUT=$(gsettings get org.gnome.desktop.wm.keybindings switch-input-source)
    echo "✓ ปุ่มเปลี่ยนภาษาปัจจุบัน: $CURRENT_SHORTCUT"
    
    # แสดงจำนวนภาษา
    SOURCE_COUNT=$(gsettings get org.gnome.desktop.input-sources sources | grep -o "'" | wc -l)
    SOURCE_COUNT=$((SOURCE_COUNT/2))
    echo "✓ จำนวนภาษาที่ติดตั้ง: $SOURCE_COUNT"
    
    # แสดงภาษาทั้งหมด
    echo "✓ ภาษาทั้งหมด:"
    gsettings get org.gnome.desktop.input-sources sources | sed "s/'/\n/g" | grep -v "\[" | grep -v "\]" | grep -v "^$" | while read -r lang; do
        echo "   - $lang"
    done
    echo ""
}

# ตั้งค่า Alt+Ctrl เป็นปุ่มเปลี่ยนภาษา
set_alt_ctrl_shortcut() {
    echo "=== ตั้งค่า Alt+Ctrl เป็นปุ่มเปลี่ยนภาษา ==="
    
    # ตัวเลือกการตั้งค่า Alt+Ctrl
    echo "เลือกแบบที่ต้องการ:"
    echo "1) Alt+Ctrl (ปุ่มเดียวพร้อมกัน)"
    echo "2) Left Alt+Left Ctrl"
    echo "3) Right Alt+Right Ctrl"
    echo "4) Alt+Ctrl+Space"
    echo "5) Alt+Ctrl แล้วปล่อย แล้วกด Space"
    echo ""
    
    read -p "เลือกตัวเลือก (1-5): " option
    
    case $option in
        1)
            echo "ตั้งค่า: Alt+Ctrl (พร้อมกัน)"
            gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt><Control>']"
            ;;
        2)
            echo "ตั้งค่า: Left Alt+Left Ctrl"
            gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>L<Control>L']"
            ;;
        3)
            echo "ตั้งค่า: Right Alt+Right Ctrl"
            gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>R<Control>R']"
            ;;
        4)
            echo "ตั้งค่า: Alt+Ctrl+Space"
            gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt><Control>space']"
            ;;
        5)
            echo "ตั้งค่า: Alt+Ctrl แล้ว Space"
            setup_two_step_shortcut
            ;;
        *)
            echo "ตั้งค่าแบบมาตรฐาน: Alt+Ctrl"
            gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt><Control>']"
            ;;
    esac
    
    # ตั้งค่าปุ่มย้อนกลับ
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Alt><Control>']"
    
    echo "✓ ตั้งค่า Alt+Ctrl สำเร็จ"
    echo ""
}

# ตั้งค่าปุ่ม 2 ขั้นตอน (Alt+Ctrl แล้ว Space)
setup_two_step_shortcut() {
    echo "กำลังตั้งค่าปุ่ม 2 ขั้นตอน..."
    
    # สร้างไดเรกทอรีสคริปต์
    SCRIPT_DIR="$HOME/.local/bin/thai-switch"
    mkdir -p "$SCRIPT_DIR"
    
    # สคริปต์ตรวจสอบและเปลี่ยนภาษา
    cat > "$SCRIPT_DIR/two-step-switch.sh" << 'EOF'
#!/bin/bash
# สคริปต์เปลี่ยนภาษา 2 ขั้นตอน

LOCK_FILE="/tmp/alt-ctrl-pressed.lock"
TIMEOUT=2  # 2 วินาที

# ถ้ามีไฟล์ lock และยังไม่หมดเวลา
if [ -f "$LOCK_FILE" ]; then
    LOCK_TIME=$(stat -c %Y "$LOCK_FILE")
    CURRENT_TIME=$(date +%s)
    
    if [ $((CURRENT_TIME - LOCK_TIME)) -lt $TIMEOUT ]; then
        # เปลี่ยนภาษา
        gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space']"
        sleep 0.1
        xdotool key super+space
        rm -f "$LOCK_FILE"
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi

# สร้างไฟล์ lock
touch "$LOCK_FILE"
echo "✓ กด Alt+Ctrl แล้ว"
echo "  กด Space ภายใน 2 วินาทีเพื่อเปลี่ยนภาษา"

# รอจนกว่าจะหมดเวลา
sleep $TIMEOUT
rm -f "$LOCK_FILE"
echo "หมดเวลา"
EOF
    
    # สคริปต์ตรวจจับ Alt+Ctrl
    cat > "$SCRIPT_DIR/detect-alt-ctrl.sh" << 'EOF'
#!/bin/bash
# ตรวจจับการกด Alt+Ctrl

# รันสคริปต์หลัก
bash "$HOME/.local/bin/thai-switch/two-step-switch.sh"
EOF
    
    chmod +x "$SCRIPT_DIR"/*.sh
    
    echo "✓ สร้างสคริปต์ใน $SCRIPT_DIR"
    echo "  ตั้งค่า shortcut ใน Keyboard Settings ให้เรียก detect-alt-ctrl.sh"
    echo ""
}

# สร้างปุ่มลัดเปลี่ยนภาษาโดยตรง
create_direct_shortcuts() {
    echo "=== สร้างปุ่มลัดเปลี่ยนภาษาโดยตรง ==="
    
    # สร้างไดเรกทอรี
    SCRIPT_DIR="$HOME/.local/bin"
    mkdir -p "$SCRIPT_DIR"
    
    # สคริปต์เปลี่ยนเป็นภาษาอังกฤษ
    cat > "$SCRIPT_DIR/thai-en.sh" << 'EOF'
#!/bin/bash
# เปลี่ยนเป็นภาษาอังกฤษ (ตำแหน่งที่ 0)

# ตรวจสอบว่ามีภาษาอังกฤษหรือไม่
LANG_LIST=$(gsettings get org.gnome.desktop.input-sources sources)
if echo "$LANG_LIST" | grep -q "'xkb:us::eng'\|'xkb:en::eng'"; then
    # หาตำแหน่งภาษาอังกฤษ
    POS=0
    gsettings set org.gnome.desktop.input-sources current $POS
    echo "✓ เปลี่ยนเป็นภาษาอังกฤษ"
else
    echo "⚠️  ไม่พบภาษาอังกฤษในรายการ"
fi
EOF
    
    # สคริปต์เปลี่ยนเป็นภาษาไทย
    cat > "$SCRIPT_DIR/thai-th.sh" << 'EOF'
#!/bin/bash
# เปลี่ยนเป็นภาษาไทย (ตำแหน่งที่ 1)

# ตรวจสอบว่ามีภาษาไทยหรือไม่
LANG_LIST=$(gsettings get org.gnome.desktop.input-sources sources)
if echo "$LANG_LIST" | grep -q "'th'"; then
    # หาตำแหน่งภาษาไทย
    COUNT=$(echo "$LANG_LIST" | grep -o "'th'" | wc -l)
    if [ $COUNT -gt 0 ]; then
        # หาตำแหน่งแรกของไทย
        POS=$(echo "$LANG_LIST" | grep -o "'th'" -n | head -1 | cut -d: -f1)
        POS=$(( (POS - 1) / 2 ))
        gsettings set org.gnome.desktop.input-sources current $POS
        echo "✓ เปลี่ยนเป็นภาษาไทย"
    fi
else
    echo "⚠️  ไม่พบภาษาไทยในรายการ"
fi
EOF
    
    # สคริปต์สลับภาษา
    cat > "$SCRIPT_DIR/thai-toggle.sh" << 'EOF'
#!/bin/bash
# สลับภาษาไทย-อังกฤษ

CURRENT=$(gsettings get org.gnome.desktop.input-sources current | awk '{print $2}')
TOTAL=$(gsettings get org.gnome.desktop.input-sources sources | grep -o "'" | wc -l)
TOTAL=$((TOTAL/2))

NEXT=$(( (CURRENT + 1) % TOTAL ))
gsettings set org.gnome.desktop.input-sources current $NEXT

# แสดงสถานะ
LANG_LIST=$(gsettings get org.gnome.desktop.input-sources sources)
CURRENT_LANG=$(echo "$LANG_LIST" | sed "s/'/\n/g" | grep -v "\[" | grep -v "\]" | grep -v "^$" | sed -n "$((CURRENT*2+1))p")
NEXT_LANG=$(echo "$LANG_LIST" | sed "s/'/\n/g" | grep -v "\[" | grep -v "\]" | grep -v "^$" | sed -n "$((NEXT*2+1))p")

echo "เปลี่ยนจาก $CURRENT_LANG → $NEXT_LANG"
EOF
    
    # ให้สิทธิ์実行
    chmod +x "$SCRIPT_DIR"/thai-*.sh
    
    echo "✓ สร้างสคริปต์สำเร็จ:"
    echo "  thai-en.sh     - เปลี่ยนเป็นภาษาอังกฤษ"
    echo "  thai-th.sh     - เปลี่ยนเป็นภาษาไทย"
    echo "  thai-toggle.sh - สลับภาษา"
    echo ""
    echo "สามารถตั้งค่า Custom Shortcuts ใน Keyboard Settings:"
    echo "  Alt+1 → bash $SCRIPT_DIR/thai-en.sh"
    echo "  Alt+2 → bash $SCRIPT_DIR/thai-th.sh"
    echo "  Alt+Tab → bash $SCRIPT_DIR/thai-toggle.sh"
    echo ""
}

# แก้ไขปัญหาทั่วไป
fix_common_issues() {
    echo "=== แก้ไขปัญหาทั่วไป ==="
    
    # ยกเลิกปุ่มลัดที่อาจขัดแย้งกับ Alt+Ctrl
    echo "ยกเลิกปุ่มลัดที่อาจขัดแย้ง..."
    
    # ตรวจสอบความขัดแย้ง
    CONFLICTS=$(gsettings list-recursively | grep -i "keybindings" | grep -i "'alt.*control\|'control.*alt" | grep -v "switch-input-source")
    
    if [ ! -z "$CONFLICTS" ]; then
        echo "พบความขัดแย้ง:"
        echo "$CONFLICTS"
        echo ""
        echo "ต้องการยกเลิกหรือไม่? (y/N)"
        read -p "เลือก: " choice
        
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            # ยกเลิกบางปุ่มลัดที่พบบ่อย
            gsettings set org.gnome.desktop.wm.keybindings switch-panels "[]"
            gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward "[]"
            echo "✓ ยกเลิกปุ่มลัดที่ขัดแย้ง"
        fi
    else
        echo "✓ ไม่พบความขัดแย้ง"
    fi
    
    # ตั้งค่า IBus
    echo "ตั้งค่า IBus..."
    if command -v ibus &> /dev/null; then
        gsettings set org.freedesktop.ibus.general.hotkey triggers "['<Alt><Control>']"
        echo "✓ ตั้งค่า IBus hotkey"
    fi
    
    echo ""
}

# ตรวจสอบการตั้งค่า
verify_settings() {
    echo "=== ตรวจสอบการตั้งค่า ==="
    
    NEW_SHORTCUT=$(gsettings get org.gnome.desktop.wm.keybindings switch-input-source)
    echo "✓ ปุ่มเปลี่ยนภาษาที่ตั้ง: $NEW_SHORTCUT"
    
    if [[ "$NEW_SHORTCUT" == *"Alt"* ]] && [[ "$NEW_SHORTCUT" == *"Control"* ]]; then
        echo "✓ ตั้งค่า Alt+Ctrl สำเร็จ!"
    else
        echo "⚠️  การตั้งค่าไม่ถูกต้อง โปรดลองอีกครั้ง"
    fi
    
    echo ""
}

# แสดงคำแนะนำการใช้งาน
show_usage_guide() {
    echo "========================================"
    echo "          คำแนะนำการใช้งาน"
    echo "========================================"
    echo ""
    echo "📝 วิธีใช้ปุ่ม Alt+Ctrl:"
    echo "   กดปุ่ม Alt และ Ctrl พร้อมกันเพื่อเปลี่ยนภาษา"
    echo ""
    echo "🔄 วิธีทดสอบ:"
    echo "   1. เปิดโปรแกรมใดก็ได้ (เช่น Text Editor)"
    echo "   2. พิมพ์ข้อความภาษาอังกฤษ"
    echo "   3. กด Alt+Ctrl"
    echo "   4. พิมพ์ข้อความภาษาไทย"
    echo "   5. กด Alt+Ctrl อีกครั้งเพื่อเปลี่ยนกลับ"
    echo ""
    echo "⚙️  ปุ่มลัดเพิ่มเติม:"
    echo "   - Alt+1      : เปลี่ยนเป็นภาษาอังกฤษ"
    echo "   - Alt+2      : เปลี่ยนเป็นภาษาไทย"
    echo "   - Alt+Tab    : สลับภาษา"
    echo ""
    echo "🔧 หากปุ่มลัดไม่ทำงาน:"
    echo "   1. ตรวจสอบว่าได้เพิ่มภาษาไทยในระบบแล้ว"
    echo "   2. ลองออกจากระบบและล็อกอินใหม่"
    echo "   3. รันคำสั่ง: gsettings reset org.gnome.desktop.wm.keybindings switch-input-source"
    echo "   4. แล้วรันสคริปต์นี้อีกครั้ง"
    echo ""
    echo "📁 สคริปต์ที่สร้าง:"
    echo "   ~/.local/bin/thai-en.sh"
    echo "   ~/.local/bin/thai-th.sh"
    echo "   ~/.local/bin/thai-toggle.sh"
    echo ""
    echo "========================================"
    echo "ตั้งค่าเสร็จสิ้น! 🎉"
    echo "========================================"
}

# รันฟังก์ชันหลัก
main "$@"

# บันทึกการตั้งค่า
echo "$(date): ตั้งค่า Alt+Ctrl shortcut" >> ~/.thai-shortcut.log