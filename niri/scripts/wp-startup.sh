#!/bin/sh
# File: ~/scripts/wp-startup.sh

CACHE_FILE="$HOME/.cache/current_wallpaper"

# GANTI INI dengan wallpaper default/cadangan Anda
DEFAULT_WALLPAPER="$HOME/Pictures/Wallpapers/default-kece.png"

# Cek apakah file cache ada DAN tidak kosong
if [ -s "$CACHE_FILE" ]; then
  # File ada dan berisi, gunakan wallpaper terakhir
  IMG=$(cat "$CACHE_FILE")
else
  # File kosong atau tidak ada, gunakan default
  IMG="$DEFAULT_WALLPAPER"

  # (Opsional) Langsung simpan wallpaper default ini sebagai cache
  echo "$IMG" >"$CACHE_FILE"
fi

# Hentikan instans lama jika ada (untuk kebersihan saat startup)
pkill swaybg

# Set wallpaper
swaybg -i "$IMG" -m fill &
