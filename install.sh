#!/bin/bash
#==============================================================================
#  _   _            _    _   _                 ____          _   _____                  
# | | | | __ _  ___| | _| \ | | _____      __ |  _ \ ___  __| | |_   _|__  __ _ _ __ ___  
# | |_| |/ _` |/ __| |/ /  \| |/ _ \ \ /\ / / | |_) / _ \/ _` |   | |/ _ \/ _` | '_ ` _ \ 
# |  _  | (_| | (__|   <| |\  | (_) \ V  V /  |  _ <  __/ (_| |   | |  __/ (_| | | | | | |
# |_| |_|\__,_|\___|_|\_\_| \_|\___/ \_/\_/   |_| \_\___|\__,_|   |_|\___|\__,_|_| |_| |_|
#                                                                                            
#==============================================================================
# HackNow Red Team Toolbox — Main Launcher
# Version: 1.0.0
# 10 ta yo'nalish — 720+ professional tools
#==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

print_banner() {
    clear
    echo ""
    echo -e "${RED}"
    echo "  ╔══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                              ║"
    echo "  ║   🔴  HACKNOW RED TEAM TOOLBOX — INSTALLER v1.0             ║"
    echo "  ║                                                              ║"
    echo "  ║        Full Red Team Engagement — 720+ Tools                ║"
    echo "  ║        Auto-detect: Debian • Arch • Fedora • RHEL           ║"
    echo "  ║                                                              ║"
    echo "  ╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_directions() {
    echo -e "  ${WHITE}${BOLD}Yo'nalishni tanlang:${NC}"
    echo ""
    echo -e "    ${CYAN} 1)${NC}  🌐  Web Application Pentesting          ${GRAY}(122+ tools)${NC}"
    echo -e "    ${CYAN} 2)${NC}  🏰  Active Directory Attack             ${GRAY}(95+ tools)${NC}"
    echo -e "    ${CYAN} 3)${NC}  📡  Network Pentesting                  ${GRAY}(85+ tools)${NC}"
    echo -e "    ${CYAN} 4)${NC}  📱  Mobile Application Pentesting       ${GRAY}(60+ tools)${NC}"
    echo -e "    ${CYAN} 5)${NC}  ☁️   Cloud Security                      ${GRAY}(75+ tools)${NC}"
    echo -e "    ${CYAN} 6)${NC}  🎣  Social Engineering                  ${GRAY}(45+ tools)${NC}"
    echo -e "    ${CYAN} 7)${NC}  📻  Wireless Pentesting                 ${GRAY}(50+ tools)${NC}"
    echo -e "    ${CYAN} 8)${NC}  🔌  IoT / Embedded / Hardware           ${GRAY}(55+ tools)${NC}"
    echo -e "    ${CYAN} 9)${NC}  🕵️   OSINT (Open Source Intel)           ${GRAY}(70+ tools)${NC}"
    echo -e "    ${CYAN}10)${NC}  🐧  OS Privilege Escalation             ${GRAY}(65+ tools)${NC}"
    echo -e "    ${CYAN}11)${NC}  📚  Wordlists & Payloads                ${GRAY}(40+ packages)${NC}"
    echo ""
    echo -e "    ${GREEN} A)${NC}  ${BOLD}🚀  MEGA INSTALL — Hammasi (720+ tools)${NC}"
    echo -e "    ${YELLOW} Q)${NC}  Chiqish"
    echo ""
}

run_direction() {
    local script="$SCRIPT_DIR/$1"
    if [[ -f "$script" ]]; then
        chmod +x "$script"
        bash "$script"
    else
        print_error "Script topilmadi: $script"
    fi
}

main() {
    print_banner
    
    # Auto-detect OS
    detect_os
    setup_environment
    
    echo -e "  ${WHITE}${BOLD}Sistema:${NC} $OS_NAME ${GRAY}($OS_TYPE / $PKG_MANAGER)${NC}"
    echo -e "  ${WHITE}${BOLD}Tools:${NC}   $TOOLS_DIR"
    echo ""
    echo -e "  ${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    print_directions
    
    echo -ne "  ${WHITE}Tanlov [1-11/A/Q]: ${NC}"
    read -r choice
    
    case "$choice" in
        1)  run_direction "01-web-application.sh" ;;
        2)  run_direction "02-active-directory.sh" ;;
        3)  run_direction "03-network-pentest.sh" ;;
        4)  run_direction "04-mobile-application.sh" ;;
        5)  run_direction "05-cloud-security.sh" ;;
        6)  run_direction "06-social-engineering.sh" ;;
        7)  run_direction "07-wireless-pentest.sh" ;;
        8)  run_direction "08-iot-hardware.sh" ;;
        9)  run_direction "09-osint.sh" ;;
        10) run_direction "10-privilege-escalation.sh" ;;
        11) run_direction "11-wordlists.sh" ;;
        [Aa])
            echo ""
            print_info "🚀 MEGA INSTALL — barcha yo'nalishlar o'rnatilmoqda..."
            echo ""
            read -p "$(echo -e "  ${YELLOW}Bu 720+ tool o'rnatadi. Davom etsinmi? [y/N]: ${NC}")" confirm
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                print_error "Bekor qilindi"
                exit 1
            fi
            for script in "$SCRIPT_DIR"/[0-9]*.sh; do
                if [[ -f "$script" ]]; then
                    chmod +x "$script"
                    bash "$script" --all
                fi
            done
            echo ""
            echo -e "${GREEN}  ╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}  ║    🎉  MEGA INSTALL YAKUNLANDI — 720+ tools o'rnatildi!     ║${NC}"
            echo -e "${GREEN}  ╚══════════════════════════════════════════════════════════════╝${NC}"
            ;;
        [Qq])
            echo -e "  ${YELLOW}Ko'rishguncha! 👋${NC}"
            exit 0
            ;;
        *)
            # Support comma-separated: 1,3,5
            IFS=',' read -ra SELECTIONS <<< "$choice"
            for sel in "${SELECTIONS[@]}"; do
                sel=$(echo "$sel" | tr -d ' ')
                case "$sel" in
                    1)  run_direction "01-web-application.sh" ;;
                    2)  run_direction "02-active-directory.sh" ;;
                    3)  run_direction "03-network-pentest.sh" ;;
                    4)  run_direction "04-mobile-application.sh" ;;
                    5)  run_direction "05-cloud-security.sh" ;;
                    6)  run_direction "06-social-engineering.sh" ;;
                    7)  run_direction "07-wireless-pentest.sh" ;;
                    8)  run_direction "08-iot-hardware.sh" ;;
                    9)  run_direction "09-osint.sh" ;;
                    10) run_direction "10-privilege-escalation.sh" ;;
                    11) run_direction "11-wordlists.sh" ;;
                    *)  print_warning "Noto'g'ri tanlov: $sel" ;;
                esac
            done
            ;;
    esac
}

main "$@"
