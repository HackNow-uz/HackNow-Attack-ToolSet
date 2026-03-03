#!/bin/bash
#==============================================================================
# 📚 Wordlists & Payloads — Barcha Yo'nalishlar Uchun
# HackNow Red Team Toolbox
#
# Har bir red team yo'nalishi uchun maxsus wordlistlar, payloadlar,
# templatelar va rule-setlar yuklab o'rnatadi.
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

WORDLIST_DIR="$TOOLS_DIR/Wordlists"
mkdir -p "$WORDLIST_DIR"

#==============================================================================
# 1. UNIVERSAL — Umumiy (har bir yo'nalish uchun kerak)
#==============================================================================
install_universal() {
    print_section "📚 Universal Wordlists (5 packages, ~3GB)"

    # SecLists — eng katta va eng ko'p ishlatiladigan
    git_install "SecLists" \
        "https://github.com/danielmiessler/SecLists.git" \
        "Wordlists"
    
    # PayloadsAllTheThings — barcha zaiflik payloadlari
    git_install "PayloadsAllTheThings" \
        "https://github.com/swisskyrepo/PayloadsAllTheThings.git" \
        "Wordlists"
    
    # OneListForAll — birlashtirilgan katta wordlist
    git_install "OneListForAll" \
        "https://github.com/six2dez/OneListForAll.git" \
        "Wordlists"
    
    # FuzzDB — fuzzing uchun DBlar
    git_install "FuzzDB" \
        "https://github.com/fuzzdb-project/fuzzdb.git" \
        "Wordlists"

    # RobotsDisallowed — robots.txt dan yig'ilgan pathlar
    git_install "RobotsDisallowed" \
        "https://github.com/danielmiessler/RobotsDisallowed.git" \
        "Wordlists"
    
    print_info "SecLists tarkibi: Discovery, Fuzzing, Passwords, Usernames, Web-Shells, ..."
}

#==============================================================================
# 2. WEB APPLICATION — Web maxsus
#==============================================================================
install_web_wordlists() {
    print_section "🌐 Web Application Wordlists (8 packages)"
    
    mkdir -p "$WORDLIST_DIR/Web"
    
    # Nuclei Templates — zaiflik shablonlari
    git_install "nuclei-templates" \
        "https://github.com/projectdiscovery/nuclei-templates.git" \
        "Wordlists/Web"
    
    # Fuzzing templates
    git_install "fuzzing-templates" \
        "https://github.com/projectdiscovery/fuzzing-templates.git" \
        "Wordlists/Web"
    
    # Community nuclei templates
    git_install "nuclei-templates-community" \
        "https://github.com/pikpikcu/nuclei-templates.git" \
        "Wordlists/Web"
    
    # GF Patterns — XSS, SQLi, SSRF, LFI, RCE, IDOR patternlari
    git_install "Gf-Patterns" \
        "https://github.com/1ndianl33t/Gf-Patterns.git" \
        "Wordlists/Web"
    mkdir -p "$USER_HOME/.gf"
    cp "$WORDLIST_DIR/Web/Gf-Patterns/"*.json "$USER_HOME/.gf/" 2>/dev/null || true
    
    # GF Secrets — secret detection patternlari
    git_install "gf-secrets" \
        "https://github.com/dwisiswant0/gf-secrets.git" \
        "Wordlists/Web"
    cp "$WORDLIST_DIR/Web/gf-secrets/.gf/"*.json "$USER_HOME/.gf/" 2>/dev/null || true
    
    # Assetnote Wordlists — API va web endpoint so'zliklar
    git_install "Assetnote-Wordlists" \
        "https://github.com/assetnote/wordlists.git" \
        "Wordlists/Web"
    
    # Web shells collection
    git_install "webshells" \
        "https://github.com/BlackArch/webshells.git" \
        "Wordlists/Web"
    
    # Intruder payloads (Burp-style)
    git_install "IntruderPayloads" \
        "https://github.com/1N3/IntruderPayloads.git" \
        "Wordlists/Web"
    
    print_info "GF patterns ~/.gf/ ga nusxalandi"
    print_info "Nuclei templates: nuclei -update-templates"
}

#==============================================================================
# 3. ACTIVE DIRECTORY — AD maxsus
#==============================================================================
install_ad_wordlists() {
    print_section "🏰 Active Directory Wordlists (5 packages)"
    
    mkdir -p "$WORDLIST_DIR/AD"
    
    # AD usernames — umumiy AD username formatlar
    git_install "statistically-likely-usernames" \
        "https://github.com/insidetrust/statistically-likely-usernames.git" \
        "Wordlists/AD"
    
    # AD passwords — corporate environment passwords
    git_install "probable-wordlists" \
        "https://github.com/berzerk0/Probable-Wordlists.git" \
        "Wordlists/AD"
    
    # Hashcat rules — hash cracking uchun
    git_install "hashcat-rules" \
        "https://github.com/NotSoSecure/password_cracking_rules.git" \
        "Wordlists/AD"
    
    # OneRuleToRuleThemAll — eng yaxshi hashcat rule
    git_install "OneRuleToRuleThemAll" \
        "https://github.com/NotSoSecure/password_cracking_rules.git" \
        "Wordlists/AD/OneRule"
    
    # Default credentials
    git_install "DefaultCreds-cheat-sheet" \
        "https://github.com/ihebski/DefaultCreds-cheat-sheet.git" \
        "Wordlists/AD"
    
    # Download rockyou.txt if not exists
    if [[ ! -f "$WORDLIST_DIR/AD/rockyou.txt" ]]; then
        print_installing "rockyou.txt"
        if [[ -f "/usr/share/wordlists/rockyou.txt.gz" ]]; then
            cp /usr/share/wordlists/rockyou.txt.gz "$WORDLIST_DIR/AD/"
            gunzip -k "$WORDLIST_DIR/AD/rockyou.txt.gz" 2>/dev/null || true
            print_success "rockyou.txt extracted from system"
        elif [[ -f "/usr/share/wordlists/rockyou.txt" ]]; then
            cp /usr/share/wordlists/rockyou.txt "$WORDLIST_DIR/AD/"
            print_success "rockyou.txt copied from system"
        else
            print_warning "rockyou.txt topilmadi — apt install wordlists"
        fi
    else
        print_skip "rockyou.txt"
    fi
    
    print_info "Hashcat rules: hashcat -r $WORDLIST_DIR/AD/hashcat-rules/..."
    print_info "Kerberoast: $WORDLIST_DIR/AD/probable-wordlists/"
}

#==============================================================================
# 4. NETWORK — Tarmoq maxsus
#==============================================================================
install_network_wordlists() {
    print_section "📡 Network Wordlists (4 packages)"
    
    mkdir -p "$WORDLIST_DIR/Network"
    
    # Default credentials — router, switch, firewall
    git_install "DefaultCreds-cheat-sheet" \
        "https://github.com/ihebski/DefaultCreds-cheat-sheet.git" \
        "Wordlists/Network"
    
    # SNMP community strings
    git_install "snmp-community-strings" \
        "https://github.com/fuzzdb-project/fuzzdb.git" \
        "Wordlists/Network/snmp"
    
    # Nmap scripts va NSE custom
    git_install "nmap-vulners" \
        "https://github.com/vulnersCom/nmap-vulners.git" \
        "Wordlists/Network"
    
    # Vulscan — nmap vulnerability scanner DB
    git_install "vulscan" \
        "https://github.com/scipag/vulscan.git" \
        "Wordlists/Network"
    # Copy to nmap scripts dir
    if [[ -d "/usr/share/nmap/scripts" ]]; then
        sudo cp -r "$WORDLIST_DIR/Network/vulscan" /usr/share/nmap/scripts/vulscan 2>/dev/null || true
        sudo nmap --script-updatedb 2>/dev/null || true
        print_info "Vulscan nmap scripts ga nusxalandi"
    fi
    
    print_info "Default creds: $WORDLIST_DIR/Network/DefaultCreds-cheat-sheet/"
}

#==============================================================================
# 5. CLOUD — Cloud maxsus
#==============================================================================
install_cloud_wordlists() {
    print_section "☁️ Cloud Wordlists (4 packages)"
    
    mkdir -p "$WORDLIST_DIR/Cloud"
    
    # AWS S3 bucket names
    git_install "AWSBucketDump-wordlist" \
        "https://github.com/sa7mon/S3Scanner.git" \
        "Wordlists/Cloud/s3"
    
    # Cloud enum wordlists
    git_install "cloud_enum" \
        "https://github.com/initstring/cloud_enum.git" \
        "Wordlists/Cloud"
    
    # Azure/AWS/GCP specific
    git_install "cloud-service-enum" \
        "https://github.com/NotSoSecure/cloud-service-enum.git" \
        "Wordlists/Cloud"
    
    # Custom cloud wordlist yaratish
    if [[ ! -f "$WORDLIST_DIR/Cloud/common-bucket-names.txt" ]]; then
        print_installing "Common cloud bucket/blob names wordlist"
        cat > "$WORDLIST_DIR/Cloud/common-bucket-names.txt" <<'CLOUDEOF'
backup
backups
dev
development
staging
stage
prod
production
test
testing
data
logs
assets
media
static
uploads
config
configs
private
public
internal
external
admin
db
database
sql
mysql
postgres
redis
elastic
elasticsearch
monitoring
grafana
prometheus
jenkins
ci
cd
deploy
deployment
terraform
ansible
k8s
kubernetes
docker
containers
lambda
functions
api
api-v1
api-v2
secrets
credentials
keys
certs
certificates
ssl
tls
vpn
CLOUDEOF
        print_success "Cloud bucket wordlist yaratildi"
    fi
    
    print_info "S3 scan: aws s3 ls s3://TARGET-BUCKET"
}

#==============================================================================
# 6. WIRELESS — WiFi maxsus
#==============================================================================
install_wireless_wordlists() {
    print_section "📻 Wireless Wordlists (3 packages)"
    
    mkdir -p "$WORDLIST_DIR/Wireless"
    
    # WiFi parollar
    git_install "wifi-wordlists" \
        "https://github.com/kennyn510/wpa2-wordlists.git" \
        "Wordlists/Wireless"
    
    # WPA/WPA2 probable passwords
    git_install "WPA-Wordlists" \
        "https://github.com/brezocordero/WPA-Wordlists.git" \
        "Wordlists/Wireless"
    
    # Common WiFi vendor passwords
    if [[ ! -f "$WORDLIST_DIR/Wireless/common-wifi-passwords.txt" ]]; then
        print_installing "Common WiFi passwords wordlist"
        cat > "$WORDLIST_DIR/Wireless/common-wifi-passwords.txt" <<'WIFIEOF'
password
12345678
123456789
1234567890
qwerty123
password1
admin1234
welcome1
changeme
letmein1
football1
baseball1
iloveyou1
trustno1
sunshine1
princess1
1q2w3e4r
qwerty12
password123
admin123
guest1234
default1
wifi1234
wifipassword
internet
wireless
WIFIEOF
        print_success "Common WiFi passwords yaratildi"
    fi
    
    # Rockyou reference
    if [[ -f "$WORDLIST_DIR/AD/rockyou.txt" ]]; then
        print_info "rockyou.txt mavjud: $WORDLIST_DIR/AD/rockyou.txt"
    fi
    
    print_info "WPA crack: hashcat -m 22000 capture.hc22000 wordlist.txt"
    print_info "PMKID crack: hashcat -m 22000 pmkid.hc22000 wordlist.txt"
}

#==============================================================================
# 7. OSINT — OSINT maxsus
#==============================================================================
install_osint_wordlists() {
    print_section "🕵️ OSINT Wordlists (4 packages)"
    
    mkdir -p "$WORDLIST_DIR/OSINT"
    
    # Umumiy usernames ro'yxati
    git_install "username-wordlists" \
        "https://github.com/jeanphorn/wordlist.git" \
        "Wordlists/OSINT"
    
    # Email formats
    git_install "email-templates" \
        "https://github.com/khast3x/h8mail.git" \
        "Wordlists/OSINT/email"
    
    # Google Dorks
    git_install "google-dorks" \
        "https://github.com/Proviesec/google-dorks.git" \
        "Wordlists/OSINT"
    
    # Common names (firstname, lastname)
    git_install "common-names" \
        "https://github.com/dominictarr/random-name.git" \
        "Wordlists/OSINT"
    
    print_info "Google Dorks: $WORDLIST_DIR/OSINT/google-dorks/"
    print_info "SecLists/Usernames/ ham mavjud"
}

#==============================================================================
# 8. IoT — IoT maxsus
#==============================================================================
install_iot_wordlists() {
    print_section "🔌 IoT Default Credentials (2 packages)"
    
    mkdir -p "$WORDLIST_DIR/IoT"
    
    # IoT default credentials
    git_install "iot-default-creds" \
        "https://github.com/ihebski/DefaultCreds-cheat-sheet.git" \
        "Wordlists/IoT"
    
    # Common IoT default passwords
    if [[ ! -f "$WORDLIST_DIR/IoT/iot-defaults.txt" ]]; then
        print_installing "IoT default credentials"
        cat > "$WORDLIST_DIR/IoT/iot-defaults.txt" <<'IOTEOF'
# Format: vendor:username:password
generic:admin:admin
generic:admin:password
generic:admin:1234
generic:admin:12345
generic:root:root
generic:root:toor
generic:user:user
hikvision:admin:12345
dahua:admin:admin
axis:root:pass
dlink:admin:
dlink:admin:admin
tplink:admin:admin
netgear:admin:password
linksys:admin:admin
ubiquiti:ubnt:ubnt
mikrotik:admin:
cisco:cisco:cisco
cisco:admin:admin
juniper:root:
fortinet:admin:
zyxel:admin:1234
huawei:admin:admin
samsung:admin:1111111
hikvision:admin:Hikvision
avtech:admin:admin
foscam:admin:
reolink:admin:
amcrest:admin:admin
IOTEOF
        print_success "IoT defaults yaratildi"
    fi
    
    print_info "IoT Shodan dorks: 'Server: GoAhead' port:81, 'Server: Boa' port:80"
}

#==============================================================================
# 9. MOBILE — Mobile maxsus
#==============================================================================
install_mobile_wordlists() {
    print_section "📱 Mobile Application Wordlists (2 packages)"
    
    mkdir -p "$WORDLIST_DIR/Mobile"
    
    # Android specific payloads
    git_install "android-security" \
        "https://github.com/nicklockwood/iVersion.git" \
        "Wordlists/Mobile"
    
    # Mobile API endpoints
    if [[ ! -f "$WORDLIST_DIR/Mobile/mobile-api-paths.txt" ]]; then
        print_installing "Mobile API paths wordlist"
        cat > "$WORDLIST_DIR/Mobile/mobile-api-paths.txt" <<'MOBEOF'
/api/v1/
/api/v2/
/api/v3/
/api/mobile/
/api/app/
/api/auth/login
/api/auth/register
/api/auth/token
/api/auth/refresh
/api/user/profile
/api/user/settings
/api/user/update
/api/push/register
/api/push/token
/api/config
/api/config/app
/api/version
/api/update
/api/debug
/api/debug/info
/api/health
/api/status
/graphql
/graphql/v1
/.well-known/
/firebase/
/api/firebase/
/oauth/token
/oauth/authorize
/api/payment/
/api/checkout/
/api/order/
/api/notification/
/swagger.json
/api-docs
/openapi.json
MOBEOF
        print_success "Mobile API paths yaratildi"
    fi
    
    print_info "PayloadsAllTheThings/Mobile/ ham mavjud"
}

#==============================================================================
# 10. SOCIAL ENGINEERING — SE maxsus
#==============================================================================
install_se_wordlists() {
    print_section "🎣 Social Engineering Wordlists (2 packages)"
    
    mkdir -p "$WORDLIST_DIR/SE"
    
    # Phishing domains
    git_install "dnstwist" \
        "https://github.com/elceef/dnstwist.git" \
        "Wordlists/SE"
    
    # Disposable email domains
    git_install "disposable-email" \
        "https://github.com/disposable-email-domains/disposable-email-domains.git" \
        "Wordlists/SE"
    
    print_info "Gophish phishing templates: /opt/gophish/templates/"
    print_info "SET templates: /usr/share/set/"
}

#==============================================================================
# SUMMARY
#==============================================================================
show_stats() {
    print_section "📊 Wordlist Statistikasi"
    if [[ -d "$WORDLIST_DIR" ]]; then
        local total_size=$(du -sh "$WORDLIST_DIR" 2>/dev/null | cut -f1)
        local total_files=$(find "$WORDLIST_DIR" -type f | wc -l)
        local total_dirs=$(find "$WORDLIST_DIR" -type d | wc -l)
        echo ""
        echo -e "  ${WHITE}${BOLD}Umumiy hajm:${NC}     $total_size"
        echo -e "  ${WHITE}${BOLD}Fayllar soni:${NC}    $total_files"
        echo -e "  ${WHITE}${BOLD}Papkalar:${NC}        $total_dirs"
        echo -e "  ${WHITE}${BOLD}Joylashuv:${NC}       $WORDLIST_DIR"
        echo ""
        echo -e "  ${WHITE}${BOLD}Kategoriyalar:${NC}"
        for dir in "$WORDLIST_DIR"/*/; do
            if [[ -d "$dir" ]]; then
                local dir_name=$(basename "$dir")
                local dir_size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                echo -e "    📂 $dir_name — $dir_size"
            fi
        done
    fi
    echo ""
}

#==============================================================================
# MAIN
#==============================================================================
main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "WORDLISTS & PAYLOADS — ALL DIRECTIONS" "📚"
        install_universal
        install_web_wordlists
        install_ad_wordlists
        install_network_wordlists
        install_cloud_wordlists
        install_wireless_wordlists
        install_osint_wordlists
        install_iot_wordlists
        install_mobile_wordlists
        install_se_wordlists
        show_stats
        print_summary "📚 Wordlists & Payloads (All)"
        return
    fi
    
    print_menu_header "WORDLISTS & PAYLOADS" "📚"
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo -e "  ${WHITE}${BOLD}Dir:${NC} $WORDLIST_DIR"
    echo ""
    
    show_section_menu "📚 Wordlists & Payloads" \
        install_universal          "📚  Universal — SecLists, Payloads, FuzzDB (~3GB)" \
        install_web_wordlists      "🌐  Web — Nuclei templates, GF patterns, Intruder (8 pkg)" \
        install_ad_wordlists       "🏰  AD — Usernames, Hashcat rules, rockyou (5 pkg)" \
        install_network_wordlists  "📡  Network — Default creds, SNMP, Nmap vulners (4 pkg)" \
        install_cloud_wordlists    "☁️   Cloud — S3 buckets, Azure blobs (4 pkg)" \
        install_wireless_wordlists "📻  Wireless — WPA wordlists, WiFi passwords (3 pkg)" \
        install_osint_wordlists    "🕵️   OSINT — Usernames, Google dorks, Emails (4 pkg)" \
        install_iot_wordlists      "🔌  IoT — Default credentials, vendors (2 pkg)" \
        install_mobile_wordlists   "📱  Mobile — API paths, payloads (2 pkg)" \
        install_se_wordlists       "🎣  SE — Phishing domains, disposable emails (2 pkg)"
    
    show_stats
    print_summary "📚 Wordlists & Payloads"
}

main "$@"
