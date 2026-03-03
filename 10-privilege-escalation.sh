#!/bin/bash
#==============================================================================
# 🐧🪟 OS Privilege Escalation — 65+ Tools Installer
# HackNow Red Team Toolbox
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

install_linux_privesc() {
    print_section "🐧 Linux Privilege Escalation (12 tools)"
    mkdir -p "$TOOLS_DIR/PrivEsc/Linux"
    git_install "linPEAS"        "https://github.com/carlospolop/PEASS-ng.git" "PrivEsc/Linux"
    git_install "linux-exploit-suggester" "https://github.com/mzet-/linux-exploit-suggester.git" "PrivEsc/Linux"
    git_install "linux-smart-enumeration" "https://github.com/diego-treitos/linux-smart-enumeration.git" "PrivEsc/Linux"
    git_install "pspy"           "https://github.com/DominicBreuker/pspy.git" "PrivEsc/Linux"
    git_install "sudo_killer"    "https://github.com/TH3xACE/SUDO_KILLER.git" "PrivEsc/Linux"
    git_install "SUID3NUM"       "https://github.com/Anon-Exploiter/SUID3NUM.git" "PrivEsc/Linux"
    git_install "traitor"        "https://github.com/liamg/traitor.git" "PrivEsc/Linux"
    git_install "GTFOBLookup"    "https://github.com/nccgroup/GTFOBLookup.git" "PrivEsc/Linux"
    git_install "linuxprivchecker" "https://github.com/sleventyeleven/linuxprivchecker.git" "PrivEsc/Linux"
    git_install "BeRoot"         "https://github.com/AlessandroZ/BeRoot.git" "PrivEsc/Linux"
    # Kernel exploits collection
    git_install "linux-kernel-exploits" "https://github.com/SecWiki/linux-kernel-exploits.git" "PrivEsc/Linux"
    print_info "GTFOBins — https://gtfobins.github.io"
}

install_windows_privesc() {
    print_section "🪟 Windows Privilege Escalation (14 tools)"
    mkdir -p "$TOOLS_DIR/PrivEsc/Windows"
    # PEASS-ng already has WinPEAS
    if [[ ! -d "$TOOLS_DIR/PrivEsc/Linux/linPEAS" ]]; then
        git_install "PEASS-ng"   "https://github.com/carlospolop/PEASS-ng.git" "PrivEsc/Windows"
    else
        print_info "PEASS-ng (WinPEAS) — allaqachon linPEAS bilan birga o'rnatilgan"
    fi
    git_install "PowerUp"        "https://github.com/PowerShellMafia/PowerSploit.git" "PrivEsc/Windows"
    git_install "SharpCollection" "https://github.com/Flangvik/SharpCollection.git" "PrivEsc/Windows"
    git_install "JAWS"           "https://github.com/411Hall/JAWS.git" "PrivEsc/Windows"
    git_install "PrivescCheck"   "https://github.com/itm4n/PrivescCheck.git" "PrivEsc/Windows"
    git_install "Watson"         "https://github.com/rasta-mouse/Watson.git" "PrivEsc/Windows"
    git_install "PrintSpoofer"   "https://github.com/itm4n/PrintSpoofer.git" "PrivEsc/Windows"
    git_install "GodPotato"      "https://github.com/BeichenDream/GodPotato.git" "PrivEsc/Windows"
    git_install "JuicyPotato"    "https://github.com/ohpe/juicy-potato.git" "PrivEsc/Windows"
    git_install "SweetPotato"    "https://github.com/CCob/SweetPotato.git" "PrivEsc/Windows"
    git_install "RottenPotato"   "https://github.com/foxglovesec/RottenPotato.git" "PrivEsc/Windows"
    git_install "windows-kernel-exploits" "https://github.com/SecWiki/windows-kernel-exploits.git" "PrivEsc/Windows"
    print_info "LOLBAS — https://lolbas-project.github.io"
    print_info "Seatbelt, SharpUp — GhostPack (SharpCollection ichida)"
}

install_persistence() {
    print_section "🔒 Persistence & Backdoors (8 tools)"
    mkdir -p "$TOOLS_DIR/PrivEsc/Persistence"
    git_install "SharPersist"    "https://github.com/mandiant/SharPersist.git" "PrivEsc/Persistence"
    git_install "RegRipper"      "https://github.com/keydet89/RegRipper3.0.git" "PrivEsc/Persistence"
    git_install "Nishang"        "https://github.com/samratashok/nishang.git" "PrivEsc/Persistence"
    git_install "PowerSploit"    "https://github.com/PowerShellMafia/PowerSploit.git" "PrivEsc/Persistence"
    git_install "Reptile"        "https://github.com/f0rb1dd3n/Reptile.git" "PrivEsc/Persistence"
    print_info "ssh-keygen persistence — manual technique"
    print_info "crontab backdoor — manual technique"
    print_info "Sticky keys / Utilman — Windows accessibility backdoor"
}

install_enum_general() {
    print_section "🔍 General Enumeration (6 tools)"
    ensure_python
    pip_install "impacket"       "impacket"
    apt_install "net-tools"      "net-tools"     "net-tools"     "net-tools"
    apt_install "procps"         "procps"        "procps-ng"     "procps-ng"
    apt_install "lsof"           "lsof"          "lsof"          "lsof"
    apt_install "strace"         "strace"        "strace"        "strace"
    apt_install "ltrace"         "ltrace"        "ltrace"        "ltrace"
}

main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "OS PRIVILEGE ESCALATION" "🐧🪟"
        install_linux_privesc; install_windows_privesc
        install_persistence; install_enum_general
        print_summary "🐧🪟 OS Privilege Escalation"
        return
    fi

    print_menu_header "OS PRIVILEGE ESCALATION" "🐧🪟"
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo ""

    show_section_menu "🐧🪟 OS Privilege Escalation" \
        install_linux_privesc    "🐧  Linux PrivEsc (12 tools)" \
        install_windows_privesc  "🪟  Windows PrivEsc (14 tools)" \
        install_persistence      "🔒  Persistence & Backdoors (8 tools)" \
        install_enum_general     "🔍  General Enumeration (6 tools)"

    print_summary "🐧🪟 OS Privilege Escalation"
}

main "$@"
