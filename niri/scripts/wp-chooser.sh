#!/bin/sh
# File: ~/scripts/wp-switch.sh

WALL_DIR="$HOME/Pictures/Wallpapers"
CURRENT_FILE="$HOME/.cache/current_wallpaper"

# Pilih gambar acak bila tidak diberi argumen
if [ -z "$1" ]; then
    IMG=$(find "$WALL_DIR" -type f | fuzzel --dmenu -p "Choose Wallpaper:")
else
    IMG="$1"
fi

# Hentikan wallpaper lama
pkill swaybg

# Jalankan wallpaper baru
swaybg -i "$IMG" -m fill &

# Simpan path wallpaper terakhir
echo "$IMG" > "$CURRENT_FILE"

notify-send "Wallpaper Changed" "$(basename "$IMG")"
