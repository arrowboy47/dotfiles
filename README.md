# How to Restore From Your Dotfiles

If you wipe your system, you just:

## Clone your dotfiles:


git clone https://github.com/yourusername/dotfiles ~/dotfiles

## Recreate the symlinks:

ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.config/gtk-3.0 ~/.config/gtk-3.0

## Restore GNOME settings:

dconf load / < ~/dotfiles/gnome/dconf-settings.ini


