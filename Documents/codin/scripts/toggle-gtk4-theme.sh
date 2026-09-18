#!/bin/bash
set -euo pipefail

# TARGET directory used by GTK4/libadwaita
TARGET="${HOME}/.config/gtk-4.0"

# >>> EDIT THESE TWO to point at your Catppuccin source dirs <<<
DARK_SRC="${HOME}/Downloads/Catppuccin-BL-MB-dark-Macchiato/Catppuccin-BL-MB-Dark-Macchiato/gtk-4.0"
LIGHT_SRC="${HOME}/Downloads/Catppuccin-BL-MB-light-Macchiato/Catppuccin-BL-MB-Light-Macchiato/gtk-4.0"

# Helper to copy theme directories
copy_dir() {
  local src="$1" dst="$2"
  mkdir -p "$dst"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$src"/ "$dst"/
  else
    find "$dst" -mindepth 1 ! -name 'settings.ini' -exec rm -rf {} +
    cp -r "$src"/. "$dst"/
  fi
}

# Detect current GTK state
current="light"
if [[ -f "${TARGET}/.dark" ]]; then
  current="dark"
elif [[ -f "${TARGET}/.light" ]]; then
  current="light"
else
  current="light" # default
fi

# Toggle theme
if [[ "$current" == "dark" ]]; then
  # Switch to LIGHT
  if [[ ! -d "$LIGHT_SRC" ]]; then
    echo "LIGHT_SRC not found: $LIGHT_SRC" >&2
    exit 1
  fi
  copy_dir "$LIGHT_SRC" "$TARGET"
  rm -f "${TARGET}/.dark"
  : > "${TARGET}/.light"
  gsettings set org.gnome.desktop.interface color-scheme 'default' >/dev/null 2>&1 || true
  command -v notify-send >/dev/null && notify-send "🌞 GTK4 Light theme applied"
  echo "Switched to LIGHT theme."

  # --- Spicetify: switch to Latte ---
  echo "Applying Catppuccin Latte theme to Spotify..."
  spicetify config current_theme catppuccin
  spicetify config color_scheme latte
  spicetify config inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1
  spicetify apply

else
  # Switch to DARK
  if [[ ! -d "$DARK_SRC" ]]; then
    echo "DARK_SRC not found: $DARK_SRC" >&2
    exit 1
  fi
  copy_dir "$DARK_SRC" "$TARGET"
  rm -f "${TARGET}/.light"
  : > "${TARGET}/.dark"
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' >/dev/null 2>&1 || true
  command -v notify-send >/dev/null && notify-send "🌙 GTK4 Dark theme applied"
  echo "Switched to DARK theme."

  # --- Spicetify: switch to Mocha ---
  echo "Applying Catppuccin Mocha theme to Spotify..."
  spicetify config current_theme catppuccin
  spicetify config color_scheme mocha
  spicetify config inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1
  spicetify apply
fi

# Optional: refresh GNOME visuals
killall -SIGUSR1 gnome-shell 2>/dev/null || true

