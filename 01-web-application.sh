#!/bin/bash
#==============================================================================
# 🌐 Web Application Pentesting — 122+ Tools Installer
# HackNow Red Team Toolbox
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

#==============================================================================
# SECTIONS
#==============================================================================

install_subdomain_enum() {
    print_section "🔍 Subdomain Enumeration (8 tools)"
    ensure_go
    go_install "subfinder"    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    go_install "amass"        "github.com/owasp-amass/amass/v4/...@master"
    go_install "assetfinder"  "github.com/tomnomnom/assetfinder@latest"
    go_install "chaos"        "github.com/projectdiscovery/chaos-client/cmd/chaos@latest"
    go_install "alterx"       "github.com/projectdiscovery/alterx/cmd/alterx@latest"
    go_install "shuffledns"   "github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest"
    ensure_python
    pip_install "sublist3r"   "sublist3r"
    pip_install "theHarvester" "theHarvester"
}

install_dns_port_http() {
    print_section "📡 DNS / Port Scanning / HTTP Probing (13 tools)"
    ensure_go
    # DNS
    go_install "dnsx"         "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
    apt_install "dnsrecon"    "dnsrecon"  "dnsrecon"  "dnsrecon"
    apt_install "fierce"      "fierce"    "fierce"    "fierce"
    # Port scanning
    go_install "naabu"        "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
    apt_install "nmap"        "nmap"      "nmap"      "nmap"
    apt_install "masscan"     "masscan"   "masscan"   "masscan"
    ensure_rust
    cargo_install "rustscan"  "rustscan"
    # HTTP probing
    go_install "httpx"        "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    go_install "httprobe"     "github.com/tomnomnom/httprobe@latest"
    go_install "tlsx"         "github.com/projectdiscovery/tlsx/cmd/tlsx@latest"
    go_install "cdncheck"     "github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest"
    apt_install "whatweb"     "whatweb"    "whatweb"   "whatweb"
    apt_install "wafw00f"     "wafw00f"   "wafw00f"   "wafw00f"
}

install_crawling_url_param() {
    print_section "🕸️ Crawling / URL Discovery / Parameters (12 tools)"
    ensure_go
    # Crawling
    go_install "katana"       "github.com/projectdiscovery/katana/cmd/katana@latest"
    go_install "hakrawler"    "github.com/hakluke/hakrawler@latest"
    go_install "gospider"     "github.com/jaeles-project/gospider@latest"
    # URL discovery
    go_install "waybackurls"  "github.com/tomnomnom/waybackurls@latest"
    go_install "gau"          "github.com/lc/gau/v2/cmd/gau@latest"
    ensure_python
    pip_install "waymore"     "waymore"
    go_install "meg"          "github.com/tomnomnom/meg@latest"
    # Parameters
    pip_install "arjun"       "arjun"
    pip_install "paramspider" "paramspider"
    ensure_rust
    cargo_install "x8"        "x8"
    # Screenshots & ASN
    ensure_go
    go_install "gowitness"    "github.com/sensepost/gowitness@latest"
    go_install "asnmap"       "github.com/projectdiscovery/asnmap/cmd/asnmap@latest"
    go_install "mapcidr"      "github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest"
    go_install "uncover"      "github.com/projectdiscovery/uncover/cmd/uncover@latest"
}

install_scanners() {
    print_section "🎯 Scanners (8 tools)"
    ensure_go
    go_install "nuclei"       "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    # Update nuclei templates
    if command_exists nuclei; then
        print_installing "Nuclei templates"
        nuclei -update-templates 2>/dev/null || true
        print_success "Nuclei templates updated"
    fi
    apt_install "nikto"       "nikto"     "nikto"     "nikto"
    apt_install "wpscan"      "wpscan"    ""          ""
    apt_install "zaproxy"     "zaproxy"   ""          ""
    apt_install "sslscan"     "sslscan"   "sslscan"   "sslscan"
    apt_install "testssl"     "testssl.sh" ""         ""
    # Burp & Caido are manual downloads
    print_info "Burp Suite — https://portswigger.net/burp (manual download)"
    print_info "Caido — https://caido.io (manual download)"
}

install_fuzzers() {
    print_section "🔄 Fuzzing Tools (6 tools)"
    ensure_go
    go_install "ffuf"         "github.com/ffuf/ffuf/v2@latest"
    go_install "gobuster"     "github.com/OJ/gobuster/v3@latest"
    ensure_rust
    cargo_install "feroxbuster" "feroxbuster"
    ensure_python
    pip_install "wfuzz"       "wfuzz"
    pip_install "dirsearch"   "dirsearch"
    apt_install "dirb"        "dirb"      "dirb"      ""
}

install_exploitation() {
    print_section "💉 Web Exploitation Tools (16 tools)"
    # SQLi
    apt_install "sqlmap"      "sqlmap"    "sqlmap"    "sqlmap"
    ensure_python
    pip_install "ghauri"      "ghauri"
    # XSS
    ensure_go
    go_install "dalfox"       "github.com/hahwul/dalfox/v2@latest"
    git_install "XSStrike" "https://github.com/s0md3v/XSStrike.git" "Exploitation" \
        "python3 -m venv venv && ./venv/bin/pip install -r requirements.txt 2>/dev/null"
    # Command injection
    apt_install "commix"      "commix"    ""          ""
    # SSRF / XXE / SSTI
    git_install "SSRFMap"     "https://github.com/swisskyrepo/SSRFmap.git" "Exploitation"
    git_install "XXEinjector" "https://github.com/enjoiz/XXEinjector.git" "Exploitation"
    git_install "tplmap"      "https://github.com/epinna/tplmap.git" "Exploitation"
    # CORS/CSRF
    pip_install "corsy"       "corsy"
    # Deserialization
    git_install "phpggc"      "https://github.com/ambionics/phpggc.git" "Exploitation"
    # Metasploit
    apt_install "metasploit"  "metasploit-framework" "metasploit" ""
    apt_install "exploitdb"   "exploitdb" ""         ""
}

install_api_secrets() {
    print_section "🔐 API Security & Secrets (7 tools)"
    ensure_go
    go_install "kiterunner"   "github.com/assetnote/kiterunner/cmd/kr@latest"
    go_install "gitleaks"     "github.com/gitleaks/gitleaks/v8@latest"
    go_install "trufflehog"   "github.com/trufflesecurity/trufflehog/v3@latest"
    git_install "jwt_tool"    "https://github.com/ticarpi/jwt_tool.git" "API-Testing" \
        "python3 -m venv venv && ./venv/bin/pip install -r requirements.txt 2>/dev/null"
    ensure_python
    pip_install "graphqlmap"  "graphqlmap"
    pip_install "semgrep"     "semgrep"
}

install_pipeline() {
    print_section "🧰 Pipeline & Utilities (11 tools)"
    ensure_go
    go_install "anew"         "github.com/tomnomnom/anew@latest"
    go_install "qsreplace"    "github.com/tomnomnom/qsreplace@latest"
    go_install "unfurl"       "github.com/tomnomnom/unfurl@latest"
    go_install "gf"           "github.com/tomnomnom/gf@latest"
    go_install "notify"       "github.com/projectdiscovery/notify/cmd/notify@latest"
    go_install "interactsh-client" "github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest"
    ensure_python
    pip_install "uro"         "uro"
    apt_install "proxychains" "proxychains4" "proxychains-ng" "proxychains"
    apt_install "socat"       "socat"     "socat"     "socat"
    apt_install "netcat"      "netcat-openbsd" "openbsd-netcat" "nc"
    apt_install "tor"         "tor"       "tor"       "tor"
    # GF Patterns
    mkdir -p "$USER_HOME/.gf"
    git_install "Gf-Patterns" "https://github.com/1ndianl33t/Gf-Patterns.git" "Wordlists"
    if [[ -d "$TOOLS_DIR/Wordlists/Gf-Patterns" ]]; then
        cp "$TOOLS_DIR/Wordlists/Gf-Patterns/"*.json "$USER_HOME/.gf/" 2>/dev/null || true
    fi
}

install_wordlists() {
    print_section "📚 Wordlists & Templates (5 packages)"
    mkdir -p "$TOOLS_DIR/Wordlists"
    git_install "SecLists"    "https://github.com/danielmiessler/SecLists.git" "Wordlists"
    git_install "PayloadsAllTheThings" "https://github.com/swisskyrepo/PayloadsAllTheThings.git" "Wordlists"
    git_install "OneListForAll" "https://github.com/six2dez/OneListForAll.git" "Wordlists"
    git_install "fuzzdb"      "https://github.com/fuzzdb-project/fuzzdb.git" "Wordlists"
    # Nuclei community templates
    mkdir -p "$TOOLS_DIR/nuclei-templates"
    git_install "fuzzing-templates" "https://github.com/projectdiscovery/fuzzing-templates.git" "nuclei-templates"
}

#==============================================================================
# MAIN
#==============================================================================
main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "WEB APPLICATION PENTESTING" "🌐"
        install_subdomain_enum
        install_dns_port_http
        install_crawling_url_param
        install_scanners
        install_fuzzers
        install_exploitation
        install_api_secrets
        install_pipeline
        install_wordlists
        print_summary "🌐 Web Application Pentesting"
        return
    fi
    
    print_menu_header "WEB APPLICATION PENTESTING" "🌐"
    
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo ""
    
    show_section_menu "🌐 Web Application Pentesting" \
        install_subdomain_enum     "🔍  Subdomain Enumeration (8 tools)" \
        install_dns_port_http      "📡  DNS / Port / HTTP Probing (13 tools)" \
        install_crawling_url_param "🕸️   Crawling / URL / Params (12 tools)" \
        install_scanners           "🎯  Scanners — Nuclei, Nikto, WPScan (8 tools)" \
        install_fuzzers            "🔄  Fuzzing — FFuf, Feroxbuster (6 tools)" \
        install_exploitation       "💉  Exploitation — SQLi, XSS, SSRF (16 tools)" \
        install_api_secrets        "🔐  API / Secrets / SAST (7 tools)" \
        install_pipeline           "🧰  Pipeline Utilities (11 tools)" \
        install_wordlists          "📚  Wordlists & Templates (5 packages)"

    print_summary "🌐 Web Application Pentesting"
}

main "$@"
