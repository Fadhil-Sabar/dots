#!/bin/bash

# --- Konfigurasi ---
# Ganti nama folder di bawah ini jika nama folder backup Git Anda berbeda
BACKUP_DIR="$HOME/.config/dotfiles_config_backup" # Asumsi Anda membuat folder ini di ~/.config/
CONFIG_SOURCE="$HOME/.config"

# Daftar folder yang akan dicopy (harus ada di ~/.config/)
FOLDERS_TO_COPY=("niri" "waybar" "hypr")
# --------------------

echo "🔄 Memulai update konfigurasi untuk Git..."

# 1. Memastikan direktori backup sudah ada
if [ ! -d "$BACKUP_DIR" ]; then
  echo "⚠️ PERINGATAN: Direktori backup '$BACKUP_DIR' tidak ditemukan. Membuatnya sekarang."
  mkdir -p "$BACKUP_DIR"
  if [ $? -ne 0 ]; then
    echo "❌ ERROR: Gagal membuat direktori backup. Periksa izin akses."
    exit 1
  fi
fi

echo "📂 Direktori target: $BACKUP_DIR"
echo "-------------------------------------"

# 2. Menyalin dan menimpa setiap folder yang ditentukan
for FOLDER in "${FOLDERS_TO_COPY[@]}"; do
  SOURCE_PATH="$CONFIG_SOURCE/$FOLDER"
  DEST_PATH="$BACKUP_DIR/" # Copy ke dalam folder backup

  if [ -d "$SOURCE_PATH" ]; then
    echo "✅ Menyalin dan menimpa $FOLDER/ ke $BACKUP_DIR/$FOLDER/"
    # -r: rekursif, -f: force/menimpa tanpa konfirmasi, -v: verbose
    cp -rfv "$SOURCE_PATH" "$DEST_PATH"
  else
    echo "⚠️ PERINGATAN: Folder konfigurasi '$SOURCE_PATH' tidak ditemukan. Melewati folder ini."
  fi
done

echo "-------------------------------------"
echo "🎉 Update selesai! Folder Anda siap di-commit ke Git."
echo "Jangan lupa: cd $BACKUP_DIR && git add . && git commit -m 'update' && git push"
