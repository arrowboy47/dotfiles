#!/usr/bin/env bash
sudo dnf install -y $(cat dnf-packages.txt)
flatpak install -y $(cat flatpaks.txt)
dconf load / < gnome-settings.dconf
gnome-extensions install $(cat extensions.txt)
stow config

