#!/usr/bin/env bash

# Script untuk switch profil performa + notifikasi
OPTIONS="performance\nbalanced\npower-saver"
CHOICE=$(echo -e "$OPTIONS" | wofi --dmenu --prompt="Select power profile:")

if [[ -z "$CHOICE" ]]; then
  exit 0
fi

case "$CHOICE" in
  performance)
    powerprofilesctl set performance
    ICON="⚡"
    MSG="Switched to Performance mode"
    ;;
  balanced)
    powerprofilesctl set balanced
    ICON="✔"
    MSG="Switched to Balanced mode"
    ;;
  "power-saver")
    powerprofilesctl set power-saver
    ICON="🌙"
    MSG="Switched to Power-Saver mode"
    ;;
  *)
    exit 0
    ;;
esac

# Kirim notifikasi
notify-send -u normal -i battery-symbolic "${ICON} ${MSG}"
