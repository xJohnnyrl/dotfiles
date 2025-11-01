# My dotfiles for MacOS, Linux and Windows

## Requirements

- [git](https://git-scm.com)
- [stow](https://www.gnu.org/software/stow/)

Clone with this

```bash
git clone --recurse-submodules https://github.com/xJohnnyrl/dotfiles.git
cd dotfiles
```

## Setup

Run the bootstrap script to set up your dotfiles. It will automatically detect your OS and install the appropriate configuration files.

```bash
./bootstrap.sh
```

This script uses `stow` to symlink your dotfiles:
- On **Linux**: stows `linux/` and `shared/` folders
- On **macOS**: stows `macos/` and `shared/` folders

If there are conflicts with existing dotfiles, the script will prompt you to choose:
1. **Backup and adopt** (recommended): Backs up your existing files into the dotfiles repo and creates symlinks
2. **Skip**: Don't stow that directory
3. **Overwrite**: Removes local files and overwrites with dotfiles versions
4. **Manual**: You'll resolve conflicts later

**Note**: If you choose option 1, check `git status` in your dotfiles repo - your old files will appear as unstaged changes. Review and commit them if you want to keep your previous configurations.

## Updating

After making changes to your dotfiles, run the update script to apply them:

```bash
./update.sh
```

This will automatically restow all your dotfiles without prompts. If there are conflicts, it will unstow and restow to ensure everything is up to date.

## Global Packages and Programs I use between MacOS and Linux (Windows might be different)

- ghostty
- tmux
- nvim
- Lazyvim
- fzf
- Yazi
- Obsidian
- OBS
- [Zen Browser](https://zen-browser.app)
- Chrome
- Bitwarden
- Cursor
- Vscode
- Photoshop/Gimp(Linux)
- Docker
- DockerDesktop(Linux, could just use the cli)/OrbStack
- LocalSend
- Tailscale
- [nvm](https://github.com/nvm-sh/nvm)
- Python
- [UV](https://github.com/astral-sh/uv)
- Bun
- Go
- C/C++
- Rust

## My Folder structure

Here's a quick overview of how I organize my directories:

```
├── personal/
├── work/
├── school/
└── Documents/
```

## Setting up ssh on both Linux and MacOS

```bash
ssh-keygen -t ed25519 -C "name@email.com"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```