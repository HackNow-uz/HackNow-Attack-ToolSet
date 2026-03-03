#!/bin/bash
#==============================================================================
# 🕵️ OSINT — Open Source Intelligence — 70+ Tools Installer
# HackNow Red Team Toolbox
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

install_people() {
    print_section "👤 People & Social Media OSINT (10 tools)"
    ensure_python
    pip_install "sherlock"     "sherlock-project"
    pip_install "maigret"      "maigret"
    pip_install "holehe"       "holehe"
    pip_install "socialscan"   "socialscan"
    git_install "GHunt"        "https://github.com/mxrch/GHunt.git" "OSINT"
    git_install "Twint"        "https://github.com/twintproject/twint.git" "OSINT"
    pip_install "instaloader"  "instaloader"
    git_install "PhoneInfoga"  "https://github.com/sundowndev/phoneinfoga.git" "OSINT"
    git_install "Maltego"      "https://github.com/MaltegoTech/maltego-trx.git" "OSINT"
    print_info "Maltego CE — https://maltego.com (free community edition)"
}

install_domain_infra() {
    print_section "🌐 Domain & Infrastructure OSINT (10 tools)"
    ensure_python
    pip_install "theHarvester"  "theHarvester"
    pip_install "shodan"        "shodan"
    pip_install "censys"        "censys"
    apt_install "whois"         "whois"         "whois"         "whois"
    apt_install "dnsutils"      "dnsutils"      "bind-tools"    "bind-utils"
    apt_install "traceroute"    "traceroute"    "traceroute"    "traceroute"
    git_install "Recon-ng"      "https://github.com/lanmaster53/recon-ng.git" "OSINT"
    git_install "SpiderFoot"    "https://github.com/smicallef/spiderfoot.git" "OSINT"
    pip_install "dnstwist"      "dnstwist"
    ensure_go
    go_install "subfinder"      "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
}

install_email_breach() {
    print_section "📧 Email & Breach Data (7 tools)"
    ensure_python
    pip_install "h8mail"       "h8mail"
    git_install "pwndb"        "https://github.com/davidtavarez/pwndb.git" "OSINT"
    git_install "WhatBreach"   "https://github.com/Ekultek/WhatBreach.git" "OSINT"
    git_install "breach-parse" "https://github.com/hmaverickadams/breach-parse.git" "OSINT"
    pip_install "emailfinder"  "emailfinder"
    print_info "Hunter.io — https://hunter.io (email finder, API key kerak)"
    print_info "DeHashed — https://dehashed.com (breach database, API)"
}

install_metadata() {
    print_section "📄 Document & Metadata OSINT (5 tools)"
    apt_install "exiftool"     "libimage-exiftool-perl" "perl-image-exiftool" "perl-Image-ExifTool"
    ensure_python
    pip_install "metagoofil"   "metagoofil"
    git_install "FOCA"         "https://github.com/ElevenPaths/FOCA.git" "OSINT"
    apt_install "pdfinfo"      "poppler-utils"  "poppler"       "poppler-utils"
    apt_install "strings"      "binutils"       "binutils"      "binutils"
    print_info "Google Dorking cheatsheet: DOCS modulida mavjud"
}

install_geo_physical() {
    print_section "🗺️ Geolocation & Physical OSINT (5 tools)"
    git_install "Creepy"       "https://github.com/ilektrojohn/creepy.git" "OSINT"
    ensure_python
    pip_install "geopy"        "geopy"
    print_info "Google Earth Pro — free download"
    print_info "Wigle.net — WiFi network mapping"
    print_info "SunCalc — sun position for photo analysis"
    print_info "Google Lens — image reverse search"
    print_info "TinEye — reverse image search"
}

install_osint_framework() {
    print_section "🧰 OSINT Frameworks & Automation (5 tools)"
    git_install "reconftw"     "https://github.com/six2dez/reconftw.git" "OSINT"
    git_install "Photon"       "https://github.com/s0md3v/Photon.git" "OSINT"
    git_install "ReconDog"     "https://github.com/s0md3v/ReconDog.git" "OSINT"
    ensure_python
    pip_install "osrframework"  "osrframework"
    print_info "OSINT Framework — https://osintframework.com"
}

main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "OSINT — OPEN SOURCE INTELLIGENCE" "🕵️"
        install_people; install_domain_infra; install_email_breach
        install_metadata; install_geo_physical; install_osint_framework
        print_summary "🕵️ OSINT"
        return
    fi

    print_menu_header "OSINT — OPEN SOURCE INTELLIGENCE" "🕵️"
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo ""

    show_section_menu "🕵️ OSINT" \
        install_people          "👤  People & Social Media (10 tools)" \
        install_domain_infra    "🌐  Domain & Infrastructure (10 tools)" \
        install_email_breach    "📧  Email & Breach Data (7 tools)" \
        install_metadata        "📄  Document & Metadata (5 tools)" \
        install_geo_physical    "🗺️   Geolocation & Physical (5 tools)" \
        install_osint_framework "🧰  Frameworks & Automation (5 tools)"

    print_summary "🕵️ OSINT"
}

main "$@"
