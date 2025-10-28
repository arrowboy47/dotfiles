# How to Restore From Your Dotfiles


# Fedora GNOME Dotfiles Setup

## Prerequisites and Setup

Run these commands on a fresh Fedora GNOME install:

sudo dnf install -y git stow dconf util-linux-user zsh
cd ~
git clone https://github.com/arrowboy47/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh

If you have your assets (fonts, icons) stored on a USB drive, plug it in before running the script. It should be mounted at /run/media/$USER/dotfiles-assets.
