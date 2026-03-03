#!/bin/bash
#==============================================================================
# HackNow Red Team Toolbox — Common Library
# Shared functions for all direction installers
#==============================================================================

#==============================================================================
# COLORS & FORMATTING
#==============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'

#==============================================================================
# GLOBAL VARIABLES
#==============================================================================
OS_TYPE=""
PKG_MANAGER=""
PKG_INSTALL=""
PKG_UPDATE=""
TOOLS_DIR=""
USER_HOME=""
FAILED_TOOLS=()
INSTALLED_TOOLS=()
SKIPPED_TOOLS=()
TOTAL_TOOLS=0
CURRENT_TOOL=0

#==============================================================================
# HELPERS
#==============================================================================
print_info()      { echo -e "  ${BLUE}[ℹ]${NC} $1"; }
print_success()   { echo -e "  ${GREEN}[✓]${NC} $1"; }
print_warning()   { echo -e "  ${YELLOW}[⚠]${NC} $1"; }
print_error()     { echo -e "  ${RED}[✗]${NC} $1"; }
print_installing(){ echo -e "  ${PURPLE}[→]${NC} Installing ${BOLD}$1${NC}..."; }
print_skip()      { echo -e "  ${GRAY}[—]${NC} Skipping $1 (already installed)"; }

command_exists() { command -v "$1" &>/dev/null; }

print_section() {
    echo ""
    echo -e "${CYAN}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${WHITE}${BOLD}  $1${NC}"
    echo -e "${CYAN}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r  ${GRAY}[${NC}"
    printf "${GREEN}%0.s█${NC}" $(seq 1 $filled 2>/dev/null) 
    printf "${GRAY}%0.s░${NC}" $(seq 1 $empty 2>/dev/null)
    printf "${GRAY}]${NC} ${WHITE}%3d%%${NC} (%d/%d)" "$percentage" "$current" "$total"
}

#==============================================================================
# OS DETECTION
#==============================================================================
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS_NAME="$NAME"
        OS_ID="$ID"

        if command_exists apt || command_exists apt-get; then
            OS_TYPE="debian"
            PKG_MANAGER="apt"
            PKG_UPDATE="apt update -qq"
            PKG_INSTALL="apt install -y -qq"
        elif command_exists pacman; then
            OS_TYPE="arch"
            PKG_MANAGER="pacman"
            PKG_UPDATE="pacman -Sy --noconfirm"
            PKG_INSTALL="pacman -S --noconfirm --needed"
        elif command_exists dnf; then
            OS_TYPE="fedora"
            PKG_MANAGER="dnf"
            PKG_UPDATE="dnf check-update"
            PKG_INSTALL="dnf install -y -q"
        elif command_exists yum; then
            OS_TYPE="rhel"
            PKG_MANAGER="yum"
            PKG_UPDATE="yum check-update"
            PKG_INSTALL="yum install -y -q"
        elif command_exists zypper; then
            OS_TYPE="opensuse"
            PKG_MANAGER="zypper"
            PKG_UPDATE="zypper refresh"
            PKG_INSTALL="zypper install -y"
        else
            print_error "Supported OS topilmadi!"
            print_error "Qo'llab-quvvatlangan: Debian/Ubuntu/Kali, Arch/Manjaro, Fedora/RHEL, openSUSE"
            exit 1
        fi
    else
        print_error "/etc/os-release topilmadi"
        exit 1
    fi
}

#==============================================================================
# PRIVILEGE & DIRECTORIES
#==============================================================================
setup_environment() {
    if [[ $EUID -eq 0 ]]; then
        TOOLS_DIR="/opt/hacknow-tools"
        USER_HOME="/root"
    else
        TOOLS_DIR="$HOME/HackNow-Tools"
        USER_HOME="$HOME"
    fi

    ZSHRC="$USER_HOME/.zshrc"
    BASHRC="$USER_HOME/.bashrc"

    export GOPATH="$USER_HOME/go"
    export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin:$USER_HOME/.cargo/bin:$USER_HOME/.local/bin"
}

#==============================================================================
# INSTALL HELPERS
#==============================================================================
pkg_install() {
    # Install system package with OS auto-detection
    local pkg_debian="$1"
    local pkg_arch="${2:-$1}"
    local pkg_fedora="${3:-$1}"
    
    case $OS_TYPE in
        debian)  sudo $PKG_INSTALL "$pkg_debian" 2>/dev/null ;;
        arch)    sudo $PKG_INSTALL "$pkg_arch" 2>/dev/null ;;
        fedora|rhel) sudo $PKG_INSTALL "$pkg_fedora" 2>/dev/null ;;
        opensuse) sudo $PKG_INSTALL "$pkg_fedora" 2>/dev/null ;;
    esac
}

go_install() {
    # Install Go tool
    local name="$1"
    local path="$2"
    
    if command_exists "$name"; then
        print_skip "$name"
        SKIPPED_TOOLS+=("$name")
        return 0
    fi
    
    print_installing "$name"
    if go install "$path" 2>/dev/null; then
        print_success "$name installed"
        INSTALLED_TOOLS+=("$name")
    else
        print_error "$name installation failed"
        FAILED_TOOLS+=("$name")
    fi
}

pip_install() {
    # Install Python tool via pipx or pip
    local name="$1"
    local package="${2:-$1}"
    
    if command_exists "$name"; then
        print_skip "$name"
        SKIPPED_TOOLS+=("$name")
        return 0
    fi
    
    print_installing "$name"
    if pipx install "$package" 2>/dev/null || pip3 install --user "$package" 2>/dev/null; then
        print_success "$name installed"
        INSTALLED_TOOLS+=("$name")
    else
        print_error "$name installation failed"
        FAILED_TOOLS+=("$name")
    fi
}

git_install() {
    # Clone git repo into tools directory
    local name="$1"
    local repo="$2"
    local subdir="${3:-Misc}"
    local setup_cmd="${4:-}"
    
    local target_dir="$TOOLS_DIR/$subdir/$name"
    
    if [[ -d "$target_dir" ]]; then
        print_skip "$name (directory exists)"
        SKIPPED_TOOLS+=("$name")
        return 0
    fi
    
    print_installing "$name"
    mkdir -p "$TOOLS_DIR/$subdir"
    if git clone --depth 1 "$repo" "$target_dir" 2>/dev/null; then
        if [[ -n "$setup_cmd" ]]; then
            (cd "$target_dir" && eval "$setup_cmd" 2>/dev/null)
        fi
        print_success "$name installed → $target_dir"
        INSTALLED_TOOLS+=("$name")
    else
        print_error "$name clone failed"
        FAILED_TOOLS+=("$name")
    fi
}

cargo_install() {
    local name="$1"
    local package="${2:-$1}"
    
    if command_exists "$name"; then
        print_skip "$name"
        SKIPPED_TOOLS+=("$name")
        return 0
    fi
    
    print_installing "$name"
    source "$USER_HOME/.cargo/env" 2>/dev/null || true
    if cargo install "$package" 2>/dev/null; then
        print_success "$name installed"
        INSTALLED_TOOLS+=("$name")
    else
        print_error "$name installation failed"
        FAILED_TOOLS+=("$name")
    fi
}

apt_install() {
    # Install system package (auto OS detect)
    local name="$1"
    local pkg_debian="$2"
    local pkg_arch="${3:-$2}"
    local pkg_fedora="${4:-$2}"
    
    print_installing "$name"
    if pkg_install "$pkg_debian" "$pkg_arch" "$pkg_fedora"; then
        print_success "$name installed"
        INSTALLED_TOOLS+=("$name")
    else
        print_warning "$name — not available on this OS, skipped"
        SKIPPED_TOOLS+=("$name")
    fi
}

#==============================================================================
# PRE-REQUISITES
#==============================================================================
ensure_go() {
    if ! command_exists go; then
        print_section "⚙️  Go muhiti o'rnatilmoqda..."
        GO_VERSION=$(curl -sL "https://golang.org/VERSION?m=text" | head -1)
        wget -q "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf /tmp/go.tar.gz
        rm /tmp/go.tar.gz
        export PATH="$PATH:/usr/local/go/bin"
        mkdir -p "$GOPATH"/{bin,src,pkg}
        print_success "Go $GO_VERSION installed"
    fi
    export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"
}

ensure_rust() {
    if ! command_exists cargo; then
        print_section "⚙️  Rust muhiti o'rnatilmoqda..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 2>/dev/null
        source "$USER_HOME/.cargo/env"
        print_success "Rust installed"
    fi
    export PATH="$USER_HOME/.cargo/bin:$PATH"
    source "$USER_HOME/.cargo/env" 2>/dev/null || true
}

ensure_python() {
    if ! command_exists pip3 && ! command_exists pipx; then
        print_section "⚙️  Python muhiti o'rnatilmoqda..."
        case $OS_TYPE in
            debian)  sudo $PKG_INSTALL python3 python3-pip python3-venv python3-full pipx 2>/dev/null ;;
            arch)    sudo $PKG_INSTALL python python-pip python-pipx 2>/dev/null ;;
            fedora|rhel) sudo $PKG_INSTALL python3 python3-pip 2>/dev/null && pip3 install --user pipx ;;
        esac
        python3 -m pipx ensurepath 2>/dev/null || pipx ensurepath 2>/dev/null || true
        print_success "Python environment ready"
    fi
    export PATH="$USER_HOME/.local/bin:$PATH"
}

ensure_git() {
    if ! command_exists git; then
        case $OS_TYPE in
            debian) sudo apt install -y git ;;
            arch) sudo pacman -S --noconfirm git ;;
            fedora|rhel) sudo dnf install -y git ;;
        esac
    fi
}

ensure_base() {
    detect_os
    setup_environment
    ensure_git
    
    case $OS_TYPE in
        debian)  sudo $PKG_INSTALL curl wget unzip build-essential jq 2>/dev/null ;;
        arch)    sudo $PKG_INSTALL curl wget unzip base-devel jq 2>/dev/null ;;
        fedora|rhel) sudo $PKG_INSTALL curl wget unzip gcc make jq 2>/dev/null ;;
    esac
}

#==============================================================================
# SUMMARY
#==============================================================================
print_summary() {
    local direction_name="$1"
    echo ""
    echo -e "${GREEN}  ╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}  ║         ✅  O'RNATISH YAKUNLANDI!                            ║${NC}"
    echo -e "${GREEN}  ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${WHITE}${BOLD}Yo'nalish:${NC}     $direction_name"
    echo -e "  ${WHITE}${BOLD}OS:${NC}            $OS_NAME ($OS_TYPE)"
    echo -e "  ${WHITE}${BOLD}Tools dir:${NC}     $TOOLS_DIR"
    echo ""
    echo -e "  ${GREEN}${BOLD}O'rnatildi:${NC}    ${#INSTALLED_TOOLS[@]} tools"
    echo -e "  ${GRAY}${BOLD}Oldin bor:${NC}     ${#SKIPPED_TOOLS[@]} tools"
    
    if [[ ${#FAILED_TOOLS[@]} -gt 0 ]]; then
        echo -e "  ${RED}${BOLD}Xato:${NC}          ${#FAILED_TOOLS[@]} tools"
        echo ""
        echo -e "  ${RED}Failed tools:${NC}"
        for t in "${FAILED_TOOLS[@]}"; do
            echo -e "    ${RED}✗${NC} $t"
        done
    fi
    
    echo ""
    echo -e "  ${YELLOW}Keyingi qadam: ${CYAN}source ~/.zshrc${NC} yoki ${CYAN}exec bash${NC}"
    echo ""
}

#==============================================================================
# MENU HELPERS
#==============================================================================
print_menu_header() {
    local title="$1"
    local emoji="$2"
    clear
    echo ""
    echo -e "${RED}  ╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}  ║                                                              ║${NC}"
    echo -e "${RED}  ║   ${WHITE}${BOLD}$emoji  $title${NC}${RED}${NC}"
    echo -e "${RED}  ║                                                              ║${NC}"
    echo -e "${RED}  ╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_section_menu() {
    # Usage: show_section_menu "Section Name" section1_func "Section 1 Label" section2_func "Section 2 Label" ...
    local direction_name="$1"
    shift
    
    local -a funcs=()
    local -a labels=()
    local i=0
    
    while [[ $# -gt 0 ]]; do
        funcs+=("$1")
        labels+=("$2")
        shift 2
        ((i++))
    done
    
    local total=${#funcs[@]}
    
    echo -e "  ${WHITE}${BOLD}Bo'limlar:${NC}"
    echo ""
    for ((j=0; j<total; j++)); do
        printf "    ${CYAN}%2d)${NC} %s\n" "$((j+1))" "${labels[$j]}"
    done
    echo ""
    echo -e "    ${GREEN} A)${NC} ${BOLD}Hammasini o'rnatish${NC}"
    echo -e "    ${YELLOW} Q)${NC} Chiqish"
    echo ""
    echo -ne "  ${WHITE}Tanlov [1-${total}/A/Q]: ${NC}"
    read -r choice
    
    case "$choice" in
        [Qq])
            echo -e "  ${YELLOW}Bekor qilindi.${NC}"
            exit 0
            ;;
        [Aa])
            echo ""
            print_info "Barcha bo'limlar o'rnatilmoqda..."
            for ((j=0; j<total; j++)); do
                ${funcs[$j]}
            done
            ;;
        *)
            if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= total )); then
                local idx=$((choice - 1))
                ${funcs[$idx]}
            else
                # Support comma-separated: 1,3,5
                IFS=',' read -ra SELECTIONS <<< "$choice"
                for sel in "${SELECTIONS[@]}"; do
                    sel=$(echo "$sel" | tr -d ' ')
                    if [[ "$sel" =~ ^[0-9]+$ ]] && (( sel >= 1 && sel <= total )); then
                        local idx=$((sel - 1))
                        ${funcs[$idx]}
                    fi
                done
            fi
            ;;
    esac
}
