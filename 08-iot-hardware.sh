#!/bin/bash
#==============================================================================
# 🔌 IoT / Embedded / Hardware — 55+ Tools Installer
# HackNow Red Team Toolbox
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

install_firmware() {
    print_section "📦 Firmware Analysis (8 tools)"
    apt_install "binwalk"       "binwalk"       "binwalk"       "binwalk"
    apt_install "squashfs"      "squashfs-tools" "squashfs-tools" "squashfs-tools"
    apt_install "cramfs"        "cramfsprogs"   ""               ""
    ensure_python
    pip_install "ubi-reader"    "ubi-reader"
    git_install "firmware-mod-kit" "https://github.com/rampageX/firmware-mod-kit.git" "IoT"
    git_install "EMBA"          "https://github.com/e-m-b-a/emba.git" "IoT"
    git_install "firmwalker"    "https://github.com/craigz28/firmwalker.git" "IoT"
    git_install "FirmAE"        "https://github.com/pr0v3rbs/FirmAE.git" "IoT"
}

install_hardware() {
    print_section "🔧 Hardware Interfaces (6 tools)"
    apt_install "openocd"       "openocd"       "openocd"       "openocd"
    apt_install "minicom"       "minicom"       "minicom"       "minicom"
    apt_install "screen"        "screen"        "screen"        "screen"
    apt_install "picocom"       "picocom"       "picocom"       "picocom"
    apt_install "sigrok"        "sigrok"        "sigrok-cli"    ""
    print_info "Bus Pirate — UART/SPI/I2C/JTAG hardware ($30)"
    print_info "JTAGulator — JTAG pin finder hardware"
    print_info "Shikra — SPI/UART/JTAG/I2C interface"
    print_info "Logic Analyzer — Saleae ($400) or cheap ($10)"
}

install_iot_protocols() {
    print_section "📡 IoT Protocols (6 tools)"
    apt_install "mosquitto"     "mosquitto"     "mosquitto"     "mosquitto"
    apt_install "mosquitto-clients" "mosquitto-clients" "mosquitto" "mosquitto"
    ensure_python
    pip_install "paho-mqtt"     "paho-mqtt"
    git_install "MQTT-Explorer" "https://github.com/thomasnordquist/MQTT-Explorer.git" "IoT"
    git_install "CoAPthon"      "https://github.com/Tanganelli/CoAPthon.git" "IoT"
    git_install "KillerBee"     "https://github.com/riverloopsec/killerbee.git" "IoT"
    print_info "KillerBee — Zigbee sniffer (ApiMote hardware kerak)"
}

install_reverse() {
    print_section "🔬 Reverse Engineering (8 tools)"
    apt_install "radare2"       "radare2"       "radare2"       "radare2"
    apt_install "gdb"           "gdb"           "gdb"           "gdb"
    apt_install "strace"        "strace"        "strace"        "strace"
    apt_install "ltrace"        "ltrace"        "ltrace"        "ltrace"
    ensure_python
    pip_install "pwntools"      "pwntools"
    pip_install "capstone"      "capstone"
    pip_install "keystone-engine" "keystone-engine"
    print_info "Ghidra — https://ghidra-sre.org (free NSA tool)"
    print_info "IDA Pro — https://hex-rays.com (licensed)"
    print_info "Binary Ninja — https://binary.ninja (licensed)"
}

install_iot_vuln() {
    print_section "🔓 IoT Vulnerability Scanning (5 tools)"
    git_install "HomePWN"       "https://github.com/ElevenPaths/HomePWN.git" "IoT"
    git_install "IoTSeeker"     "https://github.com/rapid7/IoTSeeker.git" "IoT"
    ensure_python
    pip_install "shodan"        "shodan"
    print_info "Shodan — IoT device search engine"
    print_info "Censys — certificate and host search"
    print_info "NMAP --script=iot* — IoT NSE scripts"
}

main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "IoT / EMBEDDED / HARDWARE" "🔌"
        install_firmware; install_hardware; install_iot_protocols
        install_reverse; install_iot_vuln
        print_summary "🔌 IoT / Embedded / Hardware"
        return
    fi

    print_menu_header "IoT / EMBEDDED / HARDWARE" "🔌"
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo ""

    show_section_menu "🔌 IoT / Embedded / Hardware" \
        install_firmware       "📦  Firmware Analysis (8 tools)" \
        install_hardware       "🔧  Hardware Interfaces (6 tools)" \
        install_iot_protocols  "📡  IoT Protocols (6 tools)" \
        install_reverse        "🔬  Reverse Engineering (8 tools)" \
        install_iot_vuln       "🔓  IoT Vulnerability Scanning (5 tools)"

    print_summary "🔌 IoT / Embedded / Hardware"
}

main "$@"
