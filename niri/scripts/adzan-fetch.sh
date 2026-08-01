#!/bin/bash
# Fetch jadwal dari API dan simpan ke cache file
# Dipanggil sekali sehari, bukan setiap menit

CACHE_FILE="$HOME/.cache/adzan-today.json"

curl -s "https://api.aladhan.com/v1/timings/$(date +%d-%m-%Y)?latitude=-6.2897&longitude=106.6577&method=20" \
  | jq '.data.timings | {Fajr, Dhuhr, Asr, Maghrib, Isha}' \
  > "$CACHE_FILE"
