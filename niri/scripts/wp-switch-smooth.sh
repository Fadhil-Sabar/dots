#!/bin/sh
WALL_DIR="$HOME/Pictures/Wallpapers"
CURRENT_FILE="$HOME/.cache/current_wallpaper"

# Tidak perlu menjalankan init, asumsi swww daemon sudah jalan
# Jika belum, kamu bisa jalankan manual: swww daemon &

# Pilih wallpaper acak apabila argumen kosong
if [ -z "$1" ]; then
    IMG=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | shuf -n1)
else
    IMG="$1"
fi

# Jalankan perintah ganti wallpaper dengan perbaikan opsi--fill-color tanpa '#'
swww img "$IMG" \
    --transition-type fade \
    --transition-duration 1.5 \
    --fill-color "000000" \
    --resize crop

echo "$IMG" > "$CURRENT_FILE"

notify-send "Wallpaper Updated" "$(basename "$IMG")"
