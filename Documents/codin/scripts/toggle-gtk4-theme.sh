#!/bin/bash
set -euo pipefail

# TARGET directory used by GTK4/libadwaita
TARGET="${HOME}/.config/gtk-4.0"

# >>> EDIT THESE TWO to point at your Catppuccin source dirs <<<
# You already gave me the dark path; set LIGHT_SRC to your light variant.
DARK_SRC="${HOME}/Downloads/Catppuccin-BL-MB-dark-Macchiato/Catppuccin-BL-MB-Dark-Macchiato/gtk-4.0"
LIGHT_SRC="${HOME}/Downloads/Catppuccin-BL-MB-light-Macchiato/Catppuccin-BL-MB-Light-Macchiato/gtk-4.0" 

# Use rsync if available (safer replace), else fallback to cp -r
copy_dir() {
  local src="$1" dst="$2"
  mkdir -p "$dst"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$src"/ "$dst"/
  else
    # delete everything except settings.ini (if you want to keep it)
    find "$dst" -mindepth 1 ! -name 'settings.ini' -exec rm -rf {} +
    cp -r "$src"/. "$dst"/
  fi
}

# Decide current state from marker in TARGET
current="light"
if [[ -f "${TARGET}/.dark" ]]; then
  current="dark"
elif [[ -f "${TARGET}/.light" ]]; then
  current="light"
else
  # no marker — try to infer; default to "light"
  current="light"
fi

# Toggle
if [[ "$current" == "dark" ]]; then
  # switch to LIGHT
  if [[ ! -d "$LIGHT_SRC" ]]; then
    echo "LIGHT_SRC not found: $LIGHT_SRC" >&2
    exit 1
  fi
  copy_dir "$LIGHT_SRC" "$TARGET"
  rm -f "${TARGET}/.dark"
  : > "${TARGET}/.light"
  # Optional: tell GNOME to prefer light
  gsettings set org.gnome.desktop.interface color-scheme 'default' >/dev/null 2>&1 || true
  command -v notify-send >/dev/null && notify-send "🌞 GTK4 Light theme applied"
  echo "Switched to LIGHT theme."
else
  # switch to DARK
  if [[ ! -d "$DARK_SRC" ]]; then
    echo "DARK_SRC not found: $DARK_SRC" >&2
    exit 1
  fi
  copy_dir "$DARK_SRC" "$TARGET"
  rm -f "${TARGET}/.light"
  : > "${TARGET}/.dark"
  # Optional: tell GNOME to prefer dark
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' >/dev/null 2>&1 || true
  command -v notify-send >/dev/null && notify-send "🌙 GTK4 Dark theme applied"
  echo "Switched to DARK theme."
fi

# Optional: poke GNOME Shell to refresh visuals (usually not needed)
# killall -SIGUSR1 gnome-shell 2>/dev/null || true

