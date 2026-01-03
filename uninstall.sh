#!/bin/bash
################################################################################
# Screenshot Cloud Uploader - Uninstallation Script
#
# This script removes Screenshot Cloud Uploader from your system
#
# Usage: ./uninstall.sh
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

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Screenshot Cloud Uploader - Uninstaller      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Confirm uninstallation
read -p "Are you sure you want to uninstall? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled"
    exit 0
fi

echo ""

# Stop the service
echo -e "${BLUE}→${NC} Stopping screenshot uploader service..."
if pkill -f screenshot-uploader 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Service stopped"
else
    echo -e "${YELLOW}⚠${NC}  Service was not running"
fi
echo ""

# Remove the script
echo -e "${BLUE}→${NC} Removing script..."
if rm -f "$INSTALL_DIR/screenshot-uploader"; then
    echo -e "${GREEN}✓${NC} Script removed"
else
    echo -e "${YELLOW}⚠${NC}  Script not found"
fi
echo ""

# Remove shell configuration
echo -e "${BLUE}→${NC} Cleaning shell configuration..."

for config in "$BASHRC" "$ZSHRC"; do
    if [[ -f "$config" ]]; then
        # Create backup
        cp "$config" "${config}.backup-$(date +%Y%m%d)"

        # Remove screenshot-uploader configuration
        sed -i '/# Screenshot Cloud Uploader/,/pgrep -f screenshot-uploader/d' "$config"

        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}✓${NC} Cleaned $(basename $config) (backup created)"
        fi
    fi
done
echo ""

# Remove log file
echo -e "${BLUE}→${NC} Removing log file..."
if rm -f /tmp/screenshot-uploader.log; then
    echo -e "${GREEN}✓${NC} Log file removed"
fi
echo ""

# Ask about screenshots directory
echo -e "${YELLOW}?${NC} Keep ~/Pictures/Screenshots directory and its contents? (Y/n) "
read -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${BLUE}→${NC} Removing screenshots directory..."
    rm -rf "$HOME/Pictures/Screenshots"
    echo -e "${GREEN}✓${NC} Screenshots directory removed"
    echo ""
else
    echo -e "${BLUE}ℹ${NC}  Screenshots directory preserved"
    echo ""
fi

echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ Uninstallation Complete!                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Note:${NC}"
echo "  Reload your shell or run: source ~/.bashrc"
echo ""
echo "Thank you for using Screenshot Cloud Uploader! 👋"
echo ""
