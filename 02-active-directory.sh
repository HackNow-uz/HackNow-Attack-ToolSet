#!/bin/bash
#==============================================================================
# 🏰 Active Directory Attack — 95+ Tools Installer
# HackNow Red Team Toolbox
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

install_ad_enum() {
    print_section "🔍 AD Enumeration & Discovery (10 tools)"
    ensure_python
    pip_install "ldapdomaindump" "ldapdomaindump"
    pip_install "enum4linux-ng"  "enum4linux-ng"
    pip_install "bloodyad"       "bloodyad"
    ensure_go
    go_install "windapsearch"    "github.com/ropnop/go-windapsearch@latest"
    git_install "BloodHound"     "https://github.com/BloodHoundAD/BloodHound.git" "AD"
    git_install "ADRecon"        "https://github.com/sense-of-security/ADRecon.git" "AD"
    git_install "PowerSploit"    "https://github.com/PowerShellMafia/PowerSploit.git" "AD"
    apt_install "smbclient"      "smbclient"    "smbclient"    "samba-client"
    apt_install "ldap-utils"     "ldap-utils"   "openldap"     "openldap-clients"
    print_info "PingCastle — https://pingcastle.com (Windows .exe — manual)"
    print_info "SharpHound — run from Windows target"
}

install_kerberos() {
    print_section "🔑 Kerberos Attacks (7 tools)"
    ensure_go
    go_install "kerbrute"    "github.com/ropnop/kerbrute@latest"
    ensure_python
    pip_install "impacket"   "impacket"
    print_info "Impacket oʻrnatildi — GetNPUsers.py, GetUserSPNs.py, ticketer.py tayyor"
    git_install "PKINITtools" "https://github.com/dirkjanm/PKINITtools.git" "AD"
    git_install "krbrelayx"  "https://github.com/dirkjanm/krbrelayx.git" "AD"
    print_info "Rubeus — .exe binary (Windows da ishlaydi)"
}

install_credential_dump() {
    print_section "🔓 Credential Access & Dumping (12 tools)"
    ensure_python
    pip_install "pypykatz"    "pypykatz"
    pip_install "donpapi"     "donpapi"
    pip_install "lsassy"      "lsassy"
    git_install "LaZagne"     "https://github.com/AlessandroZ/LaZagne.git" "AD"
    git_install "Responder"   "https://github.com/lgandx/Responder.git" "AD"
    git_install "Inveigh"     "https://github.com/Kevin-Robertson/Inveigh.git" "AD"
    apt_install "hashcat"     "hashcat"   "hashcat"   "hashcat"
    apt_install "john"        "john"      "john"      "john"
    apt_install "hydra"       "hydra"     "hydra"     "hydra"
    print_info "Mimikatz — Windows .exe (manual download)"
    print_info "secretsdump.py — Impacket built-in"
    print_info "NTLMRelayx.py — Impacket built-in"
}

install_lateral_movement() {
    print_section "🔀 Lateral Movement (10 tools)"
    ensure_python
    # Impacket tools (already installed above)
    if ! command_exists impacket-psexec 2>/dev/null; then
        pip_install "impacket" "impacket"
    fi
    print_info "psexec.py, smbexec.py, wmiexec.py, atexec.py, dcomexec.py — Impacket built-in"
    pip_install "crackmapexec" "crackmapexec"
    pip_install "netexec"      "netexec"
    apt_install "evil-winrm"   "evil-winrm" ""         ""
    apt_install "freerdp"      "freerdp2-x11" "freerdp" "freerdp"
    apt_install "smbclient"    "smbclient"  "smbclient" "samba-client"
    apt_install "rpcclient"    "samba-common-bin" "samba" "samba-client"
}

install_post_exploit() {
    print_section "🏃 Post-Exploitation & Persistence (10 tools)"
    git_install "Nishang"       "https://github.com/samratashok/nishang.git" "AD"
    git_install "SharpCollection" "https://github.com/Flangvik/SharpCollection.git" "AD"
    ensure_python
    pip_install "certipy-ad"    "certipy-ad"
    git_install "Certify"       "https://github.com/GhostPack/Certify.git" "AD"
    git_install "Whisker"       "https://github.com/eladshamir/Whisker.git" "AD"
    git_install "StandIn"       "https://github.com/FuzzySecurity/StandIn.git" "AD"
    pip_install "mitm6"         "mitm6"
    print_info "Seatbelt, SharpUp — GhostPack .exe (Windows)"
}

install_c2() {
    print_section "🔴 C2 Frameworks (5 tools)"
    apt_install "metasploit"    "metasploit-framework" "metasploit" ""
    git_install "Sliver"        "https://github.com/BishopFox/sliver.git" "C2"
    git_install "Havoc"         "https://github.com/HavocFramework/Havoc.git" "C2"
    git_install "Mythic"        "https://github.com/its-a-feature/Mythic.git" "C2"
    print_info "Cobalt Strike — Licensed (manual)"
    print_info "Brute Ratel — Licensed (manual)"
}

install_evasion() {
    print_section "🔒 Evasion & AV Bypass (6 tools)"
    ensure_go
    git_install "ScareCrow"    "https://github.com/optiv/ScareCrow.git" "Evasion"
    git_install "Donut"        "https://github.com/TheWover/donut.git" "Evasion"
    git_install "Freeze"       "https://github.com/optiv/Freeze.git" "Evasion"
    git_install "NimPackt"     "https://github.com/chvancooten/NimPackt-v1.git" "Evasion"
    print_info "AMSI.fail — https://amsi.fail (web-based)"
}

main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "ACTIVE DIRECTORY ATTACK" "🏰"
        install_ad_enum; install_kerberos; install_credential_dump
        install_lateral_movement; install_post_exploit; install_c2; install_evasion
        print_summary "🏰 Active Directory Attack"
        return
    fi

    print_menu_header "ACTIVE DIRECTORY ATTACK" "🏰"
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo ""

    show_section_menu "🏰 Active Directory Attack" \
        install_ad_enum          "🔍  AD Enumeration & Discovery (10 tools)" \
        install_kerberos         "🔑  Kerberos Attacks (7 tools)" \
        install_credential_dump  "🔓  Credential Access & Dumping (12 tools)" \
        install_lateral_movement "🔀  Lateral Movement (10 tools)" \
        install_post_exploit     "🏃  Post-Exploitation & Persistence (10 tools)" \
        install_c2               "🔴  C2 Frameworks (5 tools)" \
        install_evasion          "🔒  Evasion & AV Bypass (6 tools)"

    print_summary "🏰 Active Directory Attack"
}

main "$@"
