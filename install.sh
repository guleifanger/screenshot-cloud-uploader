#!/bin/bash
################################################################################
# Screenshot Cloud Uploader - Installation Script
#
# This script installs the Screenshot Cloud Uploader service on your system
#
# Usage: ./install.sh
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
INSTALL_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Screenshot Cloud Uploader - Installer        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running on supported system
check_system() {
    echo -e "${BLUE}→${NC} Checking system compatibility..."

    if [[ "$XDG_SESSION_TYPE" != "wayland" ]]; then
        echo -e "${YELLOW}⚠${NC}  Warning: You're not running Wayland (detected: $XDG_SESSION_TYPE)"
        echo "   This tool works best with GNOME on Wayland"
        read -p "   Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]]; then
        echo -e "${YELLOW}⚠${NC}  Warning: You're not running GNOME (detected: $XDG_CURRENT_DESKTOP)"
        echo "   This tool is optimized for GNOME"
        read -p "   Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    echo -e "${GREEN}✓${NC} System compatible"
    echo ""
}

# Install dependencies
install_dependencies() {
    echo -e "${BLUE}→${NC} Checking dependencies..."

    local missing_deps=()

    command -v inotifywait &>/dev/null || missing_deps+=("inotify-tools")
    command -v curl &>/dev/null || missing_deps+=("curl")
    command -v notify-send &>/dev/null || missing_deps+=("libnotify-bin")
    command -v wl-copy &>/dev/null || missing_deps+=("wl-clipboard")

    if [[ ${#missing_deps[@]} -eq 0 ]]; then
        echo -e "${GREEN}✓${NC} All dependencies installed"
        echo ""
        return 0
    fi

    echo -e "${YELLOW}⚠${NC}  Missing dependencies: ${missing_deps[*]}"
    echo ""
    echo "To install dependencies, run:"
    echo -e "${BLUE}sudo apt install ${missing_deps[*]}${NC}"
    echo ""
    read -p "Install now? (Y/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${RED}✗${NC} Installation cancelled"
        exit 1
    fi

    echo ""
    echo "Installing dependencies..."
    if sudo apt update && sudo apt install -y "${missing_deps[@]}"; then
        echo -e "${GREEN}✓${NC} Dependencies installed successfully"
        echo ""
    else
        echo -e "${RED}✗${NC} Failed to install dependencies"
        exit 1
    fi
}

# Install the uploader script
install_script() {
    echo -e "${BLUE}→${NC} Installing screenshot-uploader..."

    mkdir -p "$INSTALL_DIR"
    mkdir -p "$SCREENSHOT_DIR"

    if cp screenshot-uploader "$INSTALL_DIR/screenshot-uploader"; then
        chmod +x "$INSTALL_DIR/screenshot-uploader"
        echo -e "${GREEN}✓${NC} Script installed to $INSTALL_DIR/screenshot-uploader"
        echo ""
    else
        echo -e "${RED}✗${NC} Failed to install script"
        exit 1
    fi
}

# Configure GNOME to save screenshots to the correct directory
configure_gnome() {
    echo -e "${BLUE}→${NC} Configuring GNOME screenshot settings..."

    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.gnome-screenshot auto-save-directory "file://$SCREENSHOT_DIR/"
        echo -e "${GREEN}✓${NC} GNOME configured to save screenshots to $SCREENSHOT_DIR"
        echo ""
    else
        echo -e "${YELLOW}⚠${NC}  Could not configure GNOME (gsettings not found)"
        echo ""
    fi
}

# Add aliases to shell configuration
configure_shell() {
    echo -e "${BLUE}→${NC} Configuring shell aliases..."

    local shell_config=""

    if [[ -f "$ZSHRC" ]]; then
        shell_config="$ZSHRC"
    elif [[ -f "$BASHRC" ]]; then
        shell_config="$BASHRC"
    else
        echo -e "${YELLOW}⚠${NC}  No .bashrc or .zshrc found, skipping shell configuration"
        echo ""
        return 0
    fi

    # Check if already configured
    if grep -q "screenshot-uploader" "$shell_config"; then
        echo -e "${YELLOW}⚠${NC}  Shell already configured, skipping"
        echo ""
        return 0
    fi

    cat >> "$shell_config" << 'EOF'

# Screenshot Cloud Uploader aliases
alias ss-start='nohup ~/.local/bin/screenshot-uploader > /tmp/screenshot-uploader.log 2>&1 &'
alias ss-stop='pkill -f screenshot-uploader'
alias ss-status='ps aux | grep screenshot-uploader | grep -v grep || echo "Service not running"'
alias ss-log='tail -f /tmp/screenshot-uploader.log'

# Auto-start screenshot uploader (comment out to disable)
pgrep -f screenshot-uploader >/dev/null || nohup ~/.local/bin/screenshot-uploader > /tmp/screenshot-uploader.log 2>&1 &
EOF

    echo -e "${GREEN}✓${NC} Shell configured with aliases"
    echo ""
}

# Start the service
start_service() {
    echo -e "${BLUE}→${NC} Starting screenshot uploader service..."

    # Kill any existing instances
    pkill -f screenshot-uploader 2>/dev/null || true
    sleep 1

    # Start the service
    nohup "$INSTALL_DIR/screenshot-uploader" > /tmp/screenshot-uploader.log 2>&1 &
    local pid=$!

    sleep 2

    if ps -p $pid > /dev/null; then
        echo -e "${GREEN}✓${NC} Service started successfully (PID: $pid)"
        echo ""
    else
        echo -e "${RED}✗${NC} Failed to start service"
        echo "Check logs: tail -f /tmp/screenshot-uploader.log"
        echo ""
        exit 1
    fi
}

# Print installation summary
print_summary() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ Installation Complete!                     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "  • Press Print Screen to take screenshots"
    echo "  • Links will be automatically copied to clipboard"
    echo "  • Screenshots saved to: $SCREENSHOT_DIR"
    echo ""
    echo -e "${BLUE}Service Management:${NC}"
    echo "  ss-status   - Check if service is running"
    echo "  ss-start    - Start the service"
    echo "  ss-stop     - Stop the service"
    echo "  ss-log      - View live logs"
    echo ""
    echo -e "${BLUE}Note:${NC}"
    echo "  Reload your shell or run: source ~/.bashrc"
    echo ""
    echo -e "${GREEN}Happy screenshotting! 📸${NC}"
    echo ""
}

# Main installation flow
main() {
    check_system
    install_dependencies
    install_script
    configure_gnome
    configure_shell
    start_service
    print_summary
}

main
