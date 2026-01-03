# Publishing Guide

This document explains how to publish this project to GitHub and potentially contribute to GNOME/Ubuntu.

## 📦 Publishing to GitHub

### 1. Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `screenshot-cloud-uploader`
3. Description: "Automatic cloud upload for GNOME screenshots - take a screenshot, get an instant shareable link!"
4. Make it **Public**
5. **Do NOT** initialize with README, .gitignore, or license (we already have them)
6. Click "Create repository"

### 2. Push to GitHub

```bash
cd ~/screenshot-cloud-uploader

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/screenshot-cloud-uploader.git

# Push to main branch (rename master to main if needed)
git branch -M main
git push -u origin main
```

### 3. Configure Repository Settings

On GitHub repository page:

1. **About section** (top right):
   - Add description
   - Add website (if you have one)
   - Add topics: `gnome`, `wayland`, `screenshot`, `linux`, `ubuntu`, `cloud-upload`, `automation`, `bash`

2. **Enable Discussions** (Settings → General → Features):
   - Check "Discussions"

3. **Add repository topics** to help people discover your project

### 4. Create First Release

1. Go to "Releases" → "Create a new release"
2. Tag: `v1.0.0`
3. Title: `v1.0.0 - Initial Release`
4. Description: Copy from CHANGELOG.md
5. Click "Publish release"

### 5. Add Screenshots/Demo

Create a demo GIF showing:
1. Taking a screenshot with Print Screen
2. Notification appearing
3. Link being pasted from clipboard

Tools to create demo:
- [Peek](https://github.com/phw/peek) - Screen recorder for Linux
- [SimpleScreenRecorder](https://www.maartenbaert.be/simplescreenrecorder/)

Add to repository:
```bash
mkdir -p docs/images
# Add your demo.gif to docs/images/
git add docs/images/demo.gif
git commit -m "Add demo GIF"
git push
```

Update README.md to include the demo:
```markdown
## 🎬 Demo

![Demo](docs/images/demo.gif)
```

## 🤝 Contributing to GNOME

### Option 1: GNOME Extensions

Consider creating a GNOME Shell extension for tighter integration:

1. **Learn GNOME Extension Development**:
   - https://gjs.guide/extensions/
   - https://wiki.gnome.org/Projects/GnomeShell/Extensions

2. **Create Extension**:
   - Hook into GNOME screenshot service
   - Add upload directly in the screenshot UI
   - Submit to https://extensions.gnome.org/

3. **Benefits**:
   - Better UI integration
   - No background service needed
   - Native GNOME look and feel

### Option 2: Submit Feature Request

1. Go to GNOME GitLab: https://gitlab.gnome.org/GNOME/gnome-screenshot
2. Create an issue proposing built-in cloud upload feature
3. Link to your implementation as proof of concept
4. Be prepared to:
   - Discuss privacy implications
   - Consider user consent and settings
   - Follow GNOME design guidelines

### Option 3: Contribute to gnome-screenshot

1. **Fork** gnome-screenshot on GitLab
2. **Implement** cloud upload as optional feature
3. **Follow** GNOME contribution guidelines
4. **Submit** merge request
5. **Discuss** with maintainers

Note: GNOME has strict quality and privacy standards. They may prefer:
- Optional feature (disabled by default)
- User-controlled service selection
- Local-first approach
- Privacy-preserving design

## 🐧 Contributing to Ubuntu

### Package for Ubuntu/Debian

1. **Create Debian package**:
   ```bash
   # Learn: https://wiki.debian.org/Packaging
   # Tools: debhelper, dh-make
   ```

2. **Submit to Ubuntu PPA**:
   - Create PPA on Launchpad
   - Build package for different Ubuntu versions
   - Link: https://launchpad.net/

3. **Eventually submit to main repository**:
   - Must be stable and well-maintained
   - Need to follow Debian packaging guidelines
   - Get sponsorship from Ubuntu developer

### Snap Package

Easier alternative to .deb:

```bash
# Install snapcraft
sudo apt install snapcraft

# Create snapcraft.yaml
# Build snap
snapcraft

# Publish to Snap Store
snapcraft upload screenshot-cloud-uploader_1.0.0_amd64.snap
```

### Flatpak

Another universal packaging option:

```bash
# Create flatpak manifest
# Build and publish to Flathub
# Guide: https://docs.flatpak.org/
```

## 📢 Promoting Your Project

1. **Reddit**:
   - r/linux
   - r/gnome
   - r/Ubuntu
   - r/opensource

2. **Social Media**:
   - Twitter/X with #GNOME #Linux #Ubuntu
   - Mastodon (especially fosstodon.org)

3. **Forums**:
   - Ubuntu Forums
   - GNOME Discourse
   - LinuxQuestions.org

4. **News Sites** (if popular):
   - OMG! Ubuntu
   - Phoronix
   - Linux Uprising

## ⭐ Growing Your Project

1. **Add badges** to README:
   ```markdown
   ![GitHub stars](https://img.shields.io/github/stars/YOUR_USERNAME/screenshot-cloud-uploader)
   ![GitHub issues](https://img.shields.io/github/issues/YOUR_USERNAME/screenshot-cloud-uploader)
   ![License](https://img.shields.io/github/license/YOUR_USERNAME/screenshot-cloud-uploader)
   ```

2. **Write blog post** explaining the project

3. **Create video tutorial** for YouTube

4. **Respond to issues** promptly

5. **Accept pull requests** and credit contributors

## 📊 Success Metrics

Track on GitHub:
- ⭐ Stars (popularity)
- 👁️ Watchers (interested users)
- 🔱 Forks (developers contributing)
- 📥 Downloads/Clones
- 🐛 Issues (user engagement)
- 💬 Discussions (community)

Good luck! 🚀
