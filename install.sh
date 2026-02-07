#!/usr/bin/env bash

set -euo pipefail

# -----------------------------
# Hyprkai Banner (Red → Purple, Enhanced)
# -----------------------------

echo
echo -e "\033[38;2;90;30;55m──────────────────────────────────────────────────────────\033[0m"

echo -e "\033[38;2;180;40;80m   __ __              __        _ "
echo -e "\033[38;2;160;35;95m  / // /_ _____  ____/ /_____  (_)"
echo -e "\033[38;2;140;45;120m / _  / // / _ \\/ __/  '_/ _ \\/ / "
echo -e "\033[38;2;120;55;145m/_//_/\\_, / .__/_/ /_/\\_\\\\_,__/_/  "
echo -e "\033[38;2;105;65;165m     /___/_/                      "

echo
echo -e "\033[38;2;135;75;185m              Hyprkai · Minimal Hyprland Dotfiles\033[0m"
echo -e "\033[38;2;90;30;55m──────────────────────────────────────────────────────────\033[0m"
echo
# -----------------------------
# Paths
# -----------------------------
BASE_DIR="$HOME/Hyprkai"
DOTS_DIR="$BASE_DIR/dots"
CONFIG_DIR="$HOME/.testing"
BACKUP_DIR="$HOME/config-backup-$(date +%Y%m%d%H%M)"



# -----------------------------
# Packages (edit this list)
# -----------------------------
PACKAGES=(
  # -----------------------------
  # Core system & essentials
  # -----------------------------
  base-devel
  man-db
  reflector
  networkmanager
  nm-connection-editor
  polkit-gnome
  fontconfig
  jq
  tar
  unzip
  7zip
  file-roller
  downgrade

  # -----------------------------
  # Audio / Video / PipeWire
  # -----------------------------
  pipewire
  pipewire-alsa
  pipewire-pulse
  pipewire-audio
  jack2
  mpd
  mpc
  playerctl
  cava
  mpv
  wf-recorder
  brightnessctl

  # -----------------------------
  # Wayland / Hyprland stack
  # -----------------------------
  hyprland
  hyprlock
  hyprpicker
  waybar
  swaync
  swayosd
  wlogout
  swww
  grim
  slurp
  swappy
  wl-clipboard
  wl-clip-persist

  # -----------------------------
  # GTK / Qt / Theming
  # -----------------------------
  gtk-doc
  gtk3
  gtk4
  gtk-layer-shell
  gtk4-layer-shell
  gtk-update-icon-cache
  gtk-vnc
  adw-gtk-theme-git
  papirus-folders
  colloid-icon-theme-git
  nwg-look
  nwg-displays

  # -----------------------------
  # Qt5 stack
  # -----------------------------
  qt5-base
  qt5-declarative
  qt5-3d
  qt5-gamepad
  qt5-graphicaleffects
  qt5-imageformats
  qt5-location
  qt5-multimedia
  qt5-networkauth
  qt5-quickcontrols
  qt5-quickcontrols2
  qt5-script
  qt5-sensors
  qt5-serialport
  qt5-speech
  qt5-svg
  qt5-tools
  qt5-translations
  qt5-virtualkeyboard
  qt5-wayland
  qt5-x11extras
  qt5-xmlpatterns

  # -----------------------------
  # Qt6 stack
  # -----------------------------
  qt6-base
  qt6-declarative
  qt6-5compat
  qt6-imageformats
  qt6-multimedia
  qt6-multimedia-ffmpeg
  qt6-networkauth
  qt6-positioning
  qt6-scxml
  qt6-shadertools
  qt6-speech
  qt6-svg
  qt6-tools
  qt6-translations
  qt6-virtualkeyboard
  qt6-wayland
  qt6-webchannel
  qt6-webengine
  # -----------------------------
  # File managers / launchers
  # -----------------------------
  thunar
  rofi
  rofi-emoji
  yazi
  feh
  loupe

  # -----------------------------
  # Terminal / Shell
  # -----------------------------
  zsh
  starship
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-syntax-highlighting
  zsh-theme-powerlevel10k-git
  fzf
  fzf-tab-git
  tmux
  kitty
  fastfetch
  btop

  # -----------------------------
  # Development / Programming
  # -----------------------------
  neovim
  ripgrep
  fd
  lazygit
  nodejs
  npm
  python
  lua
  luarocks
  hererocks
  tree-sitter-cli
  opencv
  python-opencv
  visual-studio-code-insiders-bin

  # -----------------------------
  # Media / Graphics / OCR
  # -----------------------------
  imagemagick
  libnotify
  tesseract
  tesseract-data-eng
  satty

  # -----------------------------
  # Display manager
  # -----------------------------
  sddm

  # -----------------------------
  # Browsers
  # -----------------------------
  brave-bin

  # -----------------------------
  # Icons / Fonts
  # -----------------------------
  otf-font-awesome
  otf-space-grotesk
  noto-fonts-cjk
  ttf-jetbrains-mono-nerd
  ttf-material-symbols-variable-git
  ttf-readex-pro
  ttf-rubik-vf
  ttf-twemoji

  # -----------------------------
  # Misc / Extras
  # -----------------------------
  matugen
  rmpc-git
  quickshell-git
)

                                                                                                                            
# -----------------------------
# Step 1: Confirm install
# -----------------------------
read -rp "Proceed installation? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Installation cancelled."
  exit 0
fi

# -----------------------------
# Step 2: Backup ~/.config
# -----------------------------
echo "📦 Backing up $CONFIG_DIR → $BACKUP_DIR"
if [[ -d "$CONFIG_DIR" ]]; then
  cp -a "$CONFIG_DIR" "$BACKUP_DIR"
else
  echo "⚠ $CONFIG_DIR not found, skipping backup"
fi

# -----------------------------
# Step 3: Ask to install packages
# -----------------------------
read -rp "Install required packages? (y/n): " install_pkgs

# -----------------------------
# Step 4: Install packages (if yes)
# -----------------------------
install_yay() {
  echo "📦 yay not found. Installing yay..."
  sudo pacman -S --needed --noconfirm git base-devel

  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
}

if [[ "$install_pkgs" == "y" ]]; then
  echo -e "\033[38;2;120;55;145m 📦 Installing packages..."

  if ! command -v yay &>/dev/null; then
    install_yay
  fi

  #yay -Syu --noconfirm
  yay -S --needed --noconfirm "${PACKAGES[@]}"
else
  echo "⏭ Skipping package installation"
fi

# -----------------------------
# Ensure rsync is installed
# -----------------------------
if ! command -v rsync &>/dev/null; then
  echo "📦 rsync not found. Installing rsync..."
  sudo pacman -S --needed --noconfirm rsync
fi


# -----------------------------
# Step 5: Copy dotfiles
# -----------------------------
echo "⚙ Applying dotfiles to $CONFIG_DIR"

if [[ ! -d "$DOTS_DIR" ]]; then
  echo -e "\033[38;2;120;55;145m ❌ Dots directory not found: $DOTS_DIR"
  exit 1
fi

mkdir -p "$CONFIG_DIR"
rsync -a \
  --exclude='.git' \
  --exclude='.gitignore' \
  "$BASE_DIR/dots"/ \
  "$CONFIG_DIR"/

# -----------------------------
# Step 6: Set GTK theme
# -----------------------------
echo -e "\033[38;2;34;173;175m 🎨 Setting GTK theme..."

if ! command -v gsettings &>/dev/null; then
  echo -e "\033[38;2;120;55;145m 📦 gsettings not found. Installing glib2..."
  sudo pacman -S --needed --noconfirm glib2
fi

# try setting theme (do not fail script if it errors)
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark" || true


# -----------------------------
# Step 7: Final messages
# -----------------------------
echo "✅ Theme installed"
echo "🗄 Config backup stored at:"
echo "   $BACKUP_DIR"
echo "🎉 Installation complete"
