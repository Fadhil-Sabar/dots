#!/bin/sh

# Direktori wallpaper
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Membuat daftar input untuk wofi dengan format: img:<path>:text:<filename>
# Ini akan menampilkan thumbnail di wofi
wofi_input=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | \
while read -r img; do
    echo "img:$img:text:$(basename "$img")"
done)

# Menjalankan wofi dengan input yang sudah diformat
IMG_PATH_WITH_PREFIX=$(echo "$wofi_input" | wofi --dmenu --image-size 64 --width 500 --height 400 -p "Pilih Wallpaper: ")

# Terapkan wallpaper jika pengguna memilih gambar
if [ -n "$IMG_PATH_WITH_PREFIX" ]; then
    # Ekstrak path file asli dari output wofi
    IMG_PATH=$(echo "$IMG_PATH_WITH_PREFIX" | sed 's/img:\(.*\):text:.*/\1/')

    pkill swaybg
    swaybg -i "$IMG_PATH" &
fi
