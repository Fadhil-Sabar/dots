#!/bin/bash
# Cek apakah sekarang waktu sholat, lalu kirim notif jika iya

CACHE_FILE="$HOME/.cache/adzan-today.json"

# Kalau cache belum ada, fetch dulu
if [ ! -f "$CACHE_FILE" ]; then
  ~/.config/niri/scripts/adzan-fetch.sh
fi

NOW_H=$(date +%H)
NOW_M=$(date +%M)
NOW_MIN=$((10#$NOW_H * 60 + 10#$NOW_M))

# Refresh cache setiap hari jam 00:01
if [ "$NOW_H" = "00" ] && [ "$NOW_M" = "01" ]; then
  ~/.config/niri/scripts/adzan-fetch.sh
fi

# Loop tiap waktu sholat, cek apakah waktunya pas atau 5 menit lagi
for PRAYER in Fajr Dhuhr Asr Maghrib Isha; do
  PTIME=$(jq -r ".$PRAYER" "$CACHE_FILE")
  PH=$(echo "$PTIME" | cut -d: -f1)
  PM=$(echo "$PTIME" | cut -d: -f2)
  PMIN=$((10#$PH * 60 + 10#$PM))

  if [ "$PMIN" -eq "$NOW_MIN" ]; then
    # Tepat waktu sholat — urgent, bunyi
    notify-send "🕌 Waktu Sholat" "$PRAYER - $PTIME" \
      --urgency=critical --expire-time=15000
  elif [ $((PMIN - NOW_MIN)) -eq 5 ]; then
    # 5 menit sebelumnya — warning
    notify-send "⏰ Pengingat Sholat" "$PRAYER dalam 5 menit ($PTIME)" \
      --urgency=normal --expire-time=10000
  fi
done
