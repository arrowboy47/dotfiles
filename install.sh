#!/usr/bin/env bash
set -e

echo "=== AK Fedora GNOME Dotfiles Installer ==="

# --- Prereqs ---
sudo dnf install -y git stow dconf util-linux-user zsh

# --- DNF Packages ---
if [ -f "dnf-packages.txt" ]; then
  echo "[+] Installing DNF packages..."
  sudo dnf install -y $(cat dnf-packages.txt)
fi

# --- Flatpaks ---
if [ -f "flatpaks.txt" ]; then
  echo "[+] Installing Flatpak packages..."
  flatpak install -y $(cat flatpaks.txt)
fi

# --- GNOME Settings ---
if [ -f "gnome-settings.dconf" ]; then
  echo "[+] Restoring GNOME settings..."
  dconf load / < gnome-settings.dconf
fi

# --- GNOME Extensions ---
if [ -f "extensions.txt" ]; then
  echo "[+] Installing GNOME extensions..."
  cat extensions.txt | xargs -I {} gnome-extensions install {}
fi

# --- Copy assets if USB is mounted ---
ASSETS="/run/media/$USER/dotfiles-assets"
if [ -d "$ASSETS" ]; then
  echo "[+] Copying assets from USB..."
  mkdir -p ~/.local/share/fonts ~/.local/share/icons
  cp -r $ASSETS/local/share/fonts/* ~/.local/share/fonts/ 2>/dev/null || true
  cp -r $ASSETS/local/share/icons/* ~/.local/share/icons/ 2>/dev/null || true
  fc-cache -fv
else
  echo "[!] Assets USB not found — skipping font/icon restore."
fi

# --- Apply configs using stow ---
echo "[+] Applying dotfiles with stow..."
for dir in .config; do
  [ -d "$dir" ] && stow -t ~ "$dir"
done

# --- Shell setup ---
if [ -f ".zshrc" ]; then
  echo "[+] Setting up .zshrc..."
  stow -t ~ .zshrc 2>/dev/null || cp .zshrc ~/
fi

echo "=== Setup Complete! :P ==="

