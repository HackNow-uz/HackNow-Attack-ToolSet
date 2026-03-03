#!/bin/bash
#==============================================================================
# 📱 Mobile Application Pentesting — 60+ Tools Installer
# HackNow Red Team Toolbox
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

install_android() {
    print_section "🤖 Android Pentesting (14 tools)"
    ensure_python
    # Core tools
    apt_install "apktool"      "apktool"       "apktool"       ""
    apt_install "adb"          "android-tools-adb" "android-tools" "android-tools"
    apt_install "aapt"         "aapt"          ""              ""
    pip_install "frida-tools"  "frida-tools"
    pip_install "objection"    "objection"
    git_install "jadx"         "https://github.com/skylot/jadx.git" "Mobile"
    print_info "Jadx binary: https://github.com/skylot/jadx/releases"
    git_install "MobSF"        "https://github.com/MobSF/Mobile-Security-Framework-MobSF.git" "Mobile" \
        "python3 -m venv venv 2>/dev/null"
    git_install "drozer"       "https://github.com/WithSecureLabs/drozer.git" "Mobile"
    git_install "APKLeaks"     "https://github.com/dwisiswant0/apkleaks.git" "Mobile"
    pip_install "apkleaks"     "apkleaks"
    git_install "QARK"         "https://github.com/linkedin/qark.git" "Mobile"
    git_install "AndroBugs"    "https://github.com/AndroBugs/AndroBugs_Framework.git" "Mobile"
    # Decompilation
    apt_install "dex2jar"      "dex2jar"       ""              ""
    apt_install "smali"        "smali"         ""              ""
}

install_ios() {
    print_section "🍎 iOS Pentesting (8 tools)"
    ensure_python
    pip_install "frida-tools"  "frida-tools"
    pip_install "objection"    "objection"
    git_install "idb"          "https://github.com/nicklockwood/iVersion.git" "Mobile"
    print_info "checkra1n — https://checkra.in (iOS jailbreak)"
    print_info "Hopper Disassembler — https://hopperapp.com (licensed)"
    print_info "class-dump — macOS only tool"
    print_info "SSL Kill Switch 2 — Cydia tweak (jailbroken iOS)"
    print_info "Needle — https://github.com/FSecureLABS/needle"
}

install_mobile_proxy() {
    print_section "🔍 Traffic Interception & API Testing (6 tools)"
    ensure_python
    pip_install "mitmproxy"    "mitmproxy"
    print_info "Burp Suite — https://portswigger.net/burp (proxy for mobile)"
    print_info "Charles Proxy — https://charlesproxy.com (macOS)"
    apt_install "wireshark"    "wireshark"     "wireshark-qt"  "wireshark"
    apt_install "tcpdump"      "tcpdump"       "tcpdump"       "tcpdump"
    # SSL pinning bypass helpers
    git_install "ssl-pinning-bypass" "https://github.com/nicholascw/frida-ssl-pinning-bypass.git" "Mobile"
}

install_mobile_static() {
    print_section "📊 Static Analysis & Reverse Engineering (6 tools)"
    apt_install "radare2"      "radare2"       "radare2"       "radare2"
    apt_install "binwalk"      "binwalk"       "binwalk"       "binwalk"
    apt_install "strings"      "binutils"      "binutils"      "binutils"
    ensure_python
    pip_install "androguard"   "androguard"
    print_info "Ghidra — https://ghidra-sre.org (NSA reverse engineering)"
    print_info "IDA Pro — https://hex-rays.com (licensed)"
}

main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "MOBILE APPLICATION PENTESTING" "📱"
        install_android; install_ios; install_mobile_proxy; install_mobile_static
        print_summary "📱 Mobile Application Pentesting"
        return
    fi

    print_menu_header "MOBILE APPLICATION PENTESTING" "📱"
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo ""

    show_section_menu "📱 Mobile App Pentesting" \
        install_android       "🤖  Android Pentesting (14 tools)" \
        install_ios            "🍎  iOS Pentesting (8 tools)" \
        install_mobile_proxy   "🔍  Traffic Interception & API (6 tools)" \
        install_mobile_static  "📊  Static Analysis & RE (6 tools)"

    print_summary "📱 Mobile Application Pentesting"
}

main "$@"
