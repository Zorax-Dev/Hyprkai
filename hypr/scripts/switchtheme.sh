#!/bin/bash
GTK_COLORS="$HOME/.config/gtk-3.0/colors.css"

enable_colors() {
  if [ -f "$GTK_COLORS.disabled" ]; then
    mv "$GTK_COLORS.disabled" "$GTK_COLORS"
  fi
}

disable_colors() {
  if [ -f "$GTK_COLORS" ]; then
    mv "$GTK_COLORS" "$GTK_COLORS.disabled"
  fi
}

THEME="$1"

case "$THEME" in
catppuccin)
  enable_colors
  gsettings set org.gnome.desktop.interface gtk-theme \
    "catppuccin-mocha-blue-standard+default"
  ;;
tokyonight)
  enable_colors
  gsettings set org.gnome.desktop.interface gtk-theme \
    "Tokyonight-Dark"
  ;;
gruvbox)
  # set neutral GTK theme
  enable_colors
  gsettings set org.gnome.desktop.interface gtk-theme \
    "Gruvbox-Dark"
  ;;
kanagawaDark)
  enable_colors
  # set neutral GTK theme
  gsettings set org.gnome.desktop.interface gtk-theme \
    "Kanagawa-Dark"
  ;;

everforest)
  enable_colors
  # set neutral GTK theme
  gsettings set org.gnome.desktop.interface gtk-theme \
    "Everforest-Dark"
  ;;
nightfox)
  enable_colors
  # set neutral GTK theme
  gsettings set org.gnome.desktop.interface gtk-theme \
    "Nightfox-Dark"
  ;;
matugen)
  enable_colors
  # set neutral GTK theme
  gsettings set org.gnome.desktop.interface gtk-theme \
    "adw-gtk3-dark"
  ;;
osaka)
  enable_colors
  # set neutral GTK theme
  gsettings set org.gnome.desktop.interface gtk-theme \
    "Osaka-Dark"
  ;;
*)
  exit 0
  ;;
esac
