#!/usr/bin/env bash

CURRENT=$(powerprofilesctl get)
case "$CURRENT" in
  performance) ICON="⚡";;
  balanced)    ICON="✔";;
  "power-saver"|"power-saver") ICON="🌙";;
  *)           ICON="❓";;
esac

TEXT="$ICON $CURRENT"
echo "{\"text\":\"$TEXT\",\"icon\":\"$ICON\",\"profile\":\"$CURRENT\"}"
