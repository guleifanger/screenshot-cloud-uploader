# Screenshot Cloud Uploader 📸☁️

[![GitHub stars](https://img.shields.io/github/stars/guleifanger/screenshot-cloud-uploader?style=social)](https://github.com/guleifanger/screenshot-cloud-uploader/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/guleifanger/screenshot-cloud-uploader)](https://github.com/guleifanger/screenshot-cloud-uploader/issues)
[![GitHub license](https://img.shields.io/github/license/guleifanger/screenshot-cloud-uploader)](https://github.com/guleifanger/screenshot-cloud-uploader/blob/main/LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/guleifanger/screenshot-cloud-uploader)](https://github.com/guleifanger/screenshot-cloud-uploader/releases)

**Automatic cloud upload for GNOME Wayland screenshots** - Take a screenshot, get an instant shareable link!

A lightweight background service that automatically uploads your screenshots to the cloud and copies the link to your clipboard. Perfect for quick sharing on chat, social media, or documentation.

## ✨ Features

- 🔄 **Fully Automatic** - No manual upload needed, just take screenshots normally
- 🚀 **Instant Upload** - Screenshots are uploaded immediately after capture
- 📋 **Auto-copy Link** - URL automatically copied to clipboard
- 🔔 **Desktop Notifications** - Get notified when upload completes
- 🌐 **Multiple Services** - Fallback to alternative services if primary fails
- 🔒 **Privacy-focused** - Uses trusted, established file hosting services
- 🐧 **GNOME Native** - Works seamlessly with GNOME's built-in screenshot tools
- 🌊 **Wayland Compatible** - Designed specifically for modern Wayland sessions

## 🎯 Supported Services

1. **[Catbox.moe](https://catbox.moe)** (Primary)
   - No expiration
   - Up to 200MB per file
   - No registration required

2. **[Imgur](https://imgur.com)** (Fallback #1)
   - Popular image hosting
   - Reliable and fast
   - No expiration

3. **[Filebin.net](https://filebin.net)** (Fallback #2)
   - Simple file sharing
   - 6 month retention
   - No size limits

## 📋 Requirements

- **OS**: Ubuntu 24.04+ or any GNOME-based Linux distribution
- **Desktop**: GNOME on Wayland
- **Dependencies**:
  - `inotify-tools` - File system monitoring
  - `curl` - HTTP uploads
  - `wl-clipboard` - Clipboard integration
  - `libnotify` - Desktop notifications

## 🚀 Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/guleifanger/screenshot-cloud-uploader/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/guleifanger/screenshot-cloud-uploader.git
cd screenshot-cloud-uploader
chmod +x install.sh
./install.sh
```

## 📖 Usage

### Taking Screenshots

Use GNOME's native screenshot shortcuts:

| Shortcut | Action |
|----------|--------|
| `Print Screen` | Interactive screenshot tool |
| `Shift + Print Screen` | Capture entire screen |
| `Alt + Print Screen` | Capture active window |
| `Ctrl + Print Screen` | Copy screenshot to clipboard only (no upload) |

**Note**: Screenshots are saved to `~/Pictures/Screenshots/` and automatically uploaded.

### Managing the Service

```bash
# Check service status
ss-status

# Start the service
ss-start

# Stop the service
ss-stop

# View live logs
ss-log
```

### Manual Upload

You can also manually upload any screenshot:

```bash
~/.local/bin/screenshot-uploader-manual /path/to/image.png
```

## ⚙️ Configuration

### Auto-start on Login

The service automatically starts when you open a new terminal. To disable:

```bash
# Edit ~/.bashrc and comment out the auto-start line:
# pgrep -f screenshot-uploader >/dev/null || nohup ~/.local/bin/screenshot-uploader > /tmp/screenshot-uploader.log 2>&1 &
```

### Change Screenshot Directory

Edit `~/.local/bin/screenshot-uploader` and modify:

```bash
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"  # Change this path
```

Then restart the service: `ss-stop && ss-start`

### Change Upload Service Priority

Edit the `upload_file()` function in `~/.local/bin/screenshot-uploader` to reorder or add services.

## 🛠️ How It Works

1. **Monitor**: Uses `inotifywait` to watch `~/Pictures/Screenshots/` for new files
2. **Detect**: When a new screenshot is saved, it's automatically detected
3. **Upload**: File is uploaded to cloud service (tries multiple services if needed)
4. **Notify**: Desktop notification shows the shareable link
5. **Clipboard**: Link is automatically copied for quick sharing

```
┌─────────────────┐
│  Take Screenshot │  (Print Screen)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Save to Folder │  ~/Pictures/Screenshots/
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Auto Detect    │  (inotifywait)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Upload to Cloud│  (catbox.moe)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Copy Link      │  (wl-copy)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Show Notification
└─────────────────┘
```

## 🐛 Troubleshooting

### Service not running

```bash
ss-status  # Check if running
ss-start   # Start if stopped
ss-log     # Check for errors
```

### Screenshots not uploading

1. Verify screenshots are saved to `~/Pictures/Screenshots/`
2. Check GNOME settings: `gsettings get org.gnome.gnome-screenshot auto-save-directory`
3. Check internet connectivity: `curl -I https://catbox.moe`
4. View logs: `ss-log`

### Clipboard not working

Ensure `wl-clipboard` is installed:
```bash
sudo apt install wl-clipboard
```

### Wrong desktop environment

This tool is designed for **GNOME on Wayland**. Check your session:
```bash
echo $XDG_SESSION_TYPE  # Should output: wayland
echo $XDG_CURRENT_DESKTOP  # Should output: ubuntu:GNOME or GNOME
```

## 🤝 Contributing

Contributions are welcome! Here are some ways you can help:

- 🐛 Report bugs
- 💡 Suggest new features
- 🔧 Submit pull requests
- 📖 Improve documentation
- 🌐 Add support for other upload services

### Adding a New Upload Service

Edit `~/.local/bin/screenshot-uploader` and add a new block to the `upload_file()` function:

```bash
# Your service
echo "  Trying your-service.com..."
URL=$(curl -F "file=@$filepath" https://your-service.com/api/upload 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$URL" ]; then
    echo "$URL" | wl-copy 2>/dev/null
    notify "Screenshot uploaded!" "Link copied: $URL"
    echo "✓ Upload complete!"
    echo "  URL: $URL"
    return 0
fi
```

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- GNOME Project for the excellent screenshot tools
- All the free file hosting services that make this possible
- The Linux community for tools like inotify-tools and wl-clipboard

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/guleifanger/screenshot-cloud-uploader/issues)
- **Discussions**: [GitHub Discussions](https://github.com/guleifanger/screenshot-cloud-uploader/discussions)

## ⭐ Show Your Support

If you find this tool useful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💬 Sharing with friends
- ☕ [Buying me a coffee](https://buymeacoffee.com/guleifanger) (optional)

---

**Made with ❤️ for the GNOME/Linux community**

🔗 **Quick share your screenshots without the hassle!**
