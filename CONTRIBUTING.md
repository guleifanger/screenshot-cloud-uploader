# Contributing to Screenshot Cloud Uploader

Thank you for considering contributing to Screenshot Cloud Uploader! 🎉

## How Can I Contribute?

### Reporting Bugs 🐛

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the behavior
- **Expected vs actual behavior**
- **System information**:
  - OS and version (e.g., Ubuntu 24.04)
  - Desktop environment (e.g., GNOME 46)
  - Session type (`echo $XDG_SESSION_TYPE`)
- **Logs** from `tail -f /tmp/screenshot-uploader.log`

### Suggesting Enhancements 💡

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description** of the suggested enhancement
- **Use case** - why would this be useful?
- **Possible implementation** (if you have ideas)

### Adding Upload Services 🌐

Want to add support for a new file hosting service? Great! Here's how:

1. **Research the service's API** - ensure it:
   - Has a simple upload API (preferably curl-friendly)
   - Doesn't require complex authentication
   - Is reliable and well-maintained
   - Respects user privacy

2. **Implement the upload function** in `screenshot-uploader`:

```bash
upload_yourservice() {
    local filepath="$1"
    local url

    # Your upload logic here
    url=$(curl -F "file=@$filepath" https://yourservice.com/api/upload 2>/dev/null)

    if [[ -n "$url" ]]; then
        echo "$url"
        return 0
    fi
    return 1
}
```

3. **Add it to the upload chain** in the `upload_file()` function

4. **Update documentation** - mention the service in README.md

5. **Test thoroughly** - ensure uploads work and URLs are valid

### Pull Request Process

1. **Fork** the repository
2. **Create a branch** for your feature (`git checkout -b feature/amazing-feature`)
3. **Make your changes**
4. **Test thoroughly** on a clean GNOME Wayland environment
5. **Commit your changes** with clear, descriptive messages
6. **Push to your branch** (`git push origin feature/amazing-feature`)
7. **Open a Pull Request**

#### Commit Message Guidelines

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters
- Reference issues and pull requests after the first line

Examples:
```
Add support for dropbox uploads

- Implement OAuth flow for Dropbox
- Add dropbox dependency check
- Update README with Dropbox instructions

Fixes #123
```

### Code Style

- **Bash scripting**: Follow [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Use shellcheck**: Run `shellcheck screenshot-uploader` before committing
- **Comments**: Add comments for complex logic
- **Error handling**: Use `set -euo pipefail` and handle errors gracefully
- **Functions**: Keep functions focused and single-purpose

### Testing

Before submitting a PR, test:

1. **Fresh installation** on Ubuntu 24.04+ GNOME
2. **All upload services** (ensure fallbacks work)
3. **Service management** (start, stop, status, logs)
4. **Edge cases**:
   - No internet connection
   - Large files
   - Different image formats
   - Service failures

### Documentation

- Update `README.md` if you change functionality
- Add inline comments for complex code
- Update `install.sh` if you add dependencies

## Project Structure

```
screenshot-cloud-uploader/
├── README.md              # Main documentation
├── LICENSE                # MIT license
├── CONTRIBUTING.md        # This file
├── screenshot-uploader    # Main script
├── install.sh             # Installation script
└── .gitignore            # Git ignore rules
```

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/screenshot-cloud-uploader.git
cd screenshot-cloud-uploader

# Make changes to screenshot-uploader
vim screenshot-uploader

# Test locally
chmod +x screenshot-uploader
./screenshot-uploader

# Run shellcheck
shellcheck screenshot-uploader install.sh
```

## Community

- Be respectful and constructive
- Help others when you can
- Follow the [Code of Conduct](CODE_OF_CONDUCT.md) (if exists)

## Questions?

Feel free to open an issue with the `question` label or start a discussion in GitHub Discussions.

---

Thank you for contributing! 🙏
