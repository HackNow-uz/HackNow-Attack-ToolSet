#!/bin/bash
#==============================================================================
# 🎣 Social Engineering — 45+ Tools Installer
# HackNow Red Team Toolbox
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

install_phishing() {
    print_section "📧 Phishing Frameworks (8 tools)"
    ensure_go
    git_install "gophish"      "https://github.com/gophish/gophish.git" "SE"
    git_install "evilginx2"    "https://github.com/kgretzky/evilginx2.git" "SE"
    git_install "king-phisher" "https://github.com/securestate/king-phisher.git" "SE"
    git_install "SocialFish"   "https://github.com/UndeadSec/SocialFish.git" "SE"
    git_install "Modlishka"    "https://github.com/drk1wi/Modlishka.git" "SE"
    git_install "zphisher"     "https://github.com/htr-tech/zphisher.git" "SE"
    git_install "AdvPhishing"  "https://github.com/Ignitetch/AdvPhishing.git" "SE"
    print_info "Gophish binary: https://github.com/gophish/gophish/releases"
}

install_payload() {
    print_section "💣 Payload Delivery & Weaponization (8 tools)"
    apt_install "set"          "set"           ""              ""
    git_install "SET"          "https://github.com/trustedsec/social-engineer-toolkit.git" "SE"
    git_install "MacroPack"    "https://github.com/sevagas/macro_pack.git" "SE"
    git_install "Villain"      "https://github.com/t3l3machus/Villain.git" "SE"
    git_install "LNKUp"        "https://github.com/Plazmaz/LNKUp.git" "SE"
    git_install "EvilClippy"   "https://github.com/outflanknl/EvilClippy.git" "SE"
    git_install "Follina"      "https://github.com/JohnHammond/msdt-follina.git" "SE"
    git_install "Macro-Less"   "https://github.com/Mr-Un1k0d3r/MaliciousMacroMSBuild.git" "SE"
}

install_infra() {
    print_section "🌐 Infrastructure & Delivery (6 tools)"
    apt_install "postfix"      "postfix"       "postfix"       "postfix"
    apt_install "swaks"        "swaks"         "swaks"         "swaks"
    git_install "GoReport"     "https://github.com/chrismaddalena/GoReport.git" "SE"
    print_info "SMTP server, domain spoofing, DKIM/SPF bypass texnikalar"
    print_info "Namecheap/Cloudflare — domain sozlash"
    print_info "Let's Encrypt — SSL sertifikat"
    pip_install "dns-twist"    "dnstwist"
    ensure_python
    pip_install "dnstwist"     "dnstwist"
}

install_physical() {
    print_section "🔌 Physical & Hardware (6 tools)"
    print_info "Proxmark3 — RFID/NFC cloning (hardware required)"
    print_info "Flipper Zero — multi-tool hardware device"
    print_info "USB Rubber Ducky — HID attack device"
    print_info "Bash Bunny — USB attack platform"
    print_info "LAN Turtle — covert network access"
    print_info "WiFi Pineapple — rogue AP device"
    print_info "Bu toollar maxsus hardware talab qiladi"
}

main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "SOCIAL ENGINEERING" "🎣"
        install_phishing; install_payload; install_infra; install_physical
        print_summary "🎣 Social Engineering"
        return
    fi

    print_menu_header "SOCIAL ENGINEERING" "🎣"
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo ""

    show_section_menu "🎣 Social Engineering" \
        install_phishing  "📧  Phishing Frameworks (8 tools)" \
        install_payload   "💣  Payload Delivery (8 tools)" \
        install_infra     "🌐  Infrastructure & Delivery (6 tools)" \
        install_physical  "🔌  Physical & Hardware (info)"

    print_summary "🎣 Social Engineering"
}

main "$@"
