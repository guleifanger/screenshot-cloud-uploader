# Changelog

All notable changes to Screenshot Cloud Uploader will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-01-03

### Added
- Initial release of Screenshot Cloud Uploader
- Automatic screenshot monitoring for `~/Pictures/Screenshots`
- Upload to Catbox.moe (primary service, no expiration)
- Fallback to Imgur if Catbox fails
- Fallback to Filebin.net if Imgur fails
- Automatic clipboard copy of shareable links
- Desktop notifications on upload completion
- Service management aliases (ss-start, ss-stop, ss-status, ss-log)
- Auto-start on shell initialization
- GNOME Wayland compatibility
- Comprehensive installation script
- Full documentation and contribution guidelines
- MIT License

### Features
- Support for PNG, JPG, JPEG, GIF, and WebP formats
- Graceful error handling with multiple fallback services
- Color-coded logging for better readability
- Dependency checking during installation
- GNOME screenshot settings auto-configuration

[Unreleased]: https://github.com/YOUR_USERNAME/screenshot-cloud-uploader/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/YOUR_USERNAME/screenshot-cloud-uploader/releases/tag/v1.0.0
