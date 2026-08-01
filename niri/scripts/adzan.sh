#!/bin/bash
CACHE_FILE="$HOME/.cache/adzan-today.json"

# Kalau cache belum ada (misal belum pernah fetch sama sekali), fetch dulu
if [ ! -f "$CACHE_FILE" ]; then
  ~/.config/niri/scripts/adzan-fetch.sh
fi

# Baca dari cache, bukan dari API langsung
FAJR=$(jq -r '.Fajr' "$CACHE_FILE")
DHUHR=$(jq -r '.Dhuhr' "$CACHE_FILE")
ASR=$(jq -r '.Asr' "$CACHE_FILE")
MAGHRIB=$(jq -r '.Maghrib' "$CACHE_FILE")
ISHA=$(jq -r '.Isha' "$CACHE_FILE")

notify-send "🕌 Jadwal Sholat" "Fajr     $FAJR
Dhuhr    $DHUHR
Asr      $ASR
Maghrib  $MAGHRIB
Isha     $ISHA" --expire-time=10000
