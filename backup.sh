#!/bin/bash

# --- Konfigurasi ---
# Ganti nama folder di bawah ini jika nama folder backup Git Anda berbeda
BACKUP_DIR="$HOME/.config/dotfiles_config_backup" # Folder backup Git Anda
CONFIG_SOURCE="$HOME/.config"

# Daftar folder yang di-copy (menimpa)
COPY_FOLDERS=("niri" "waybar")

# Folder yang di-zip
ZIP_FOLDER="hypr"
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

# 2. Menyalin folder niri dan waybar (menimpa)
for FOLDER in "${COPY_FOLDERS[@]}"; do
  SOURCE_PATH="$CONFIG_SOURCE/$FOLDER"
  DEST_PATH="$BACKUP_DIR/"

  if [ -d "$SOURCE_PATH" ]; then
    echo "✅ Menyalin dan menimpa $FOLDER/ ke $BACKUP_DIR/$FOLDER/"
    # -r: rekursif, -f: force/menimpa tanpa konfirmasi, -v: verbose
    cp -rfv "$SOURCE_PATH" "$DEST_PATH"
  else
    echo "⚠️ PERINGATAN: Folder konfigurasi '$SOURCE_PATH' tidak ditemukan. Melewati folder ini."
  fi
done

echo "-------------------------------------"

# 3. Mengompres folder Hypr ke dalam file ZIP
HYPR_SOURCE="$CONFIG_SOURCE/$ZIP_FOLDER"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ZIP_FILE="${ZIP_FOLDER}_${TIMESTAMP}.zip"
ZIP_DEST="$BACKUP_DIR/$ZIP_FILE"

if [ -d "$HYPR_SOURCE" ]; then
  echo "📦 Membuat ZIP untuk $ZIP_FOLDER dan menyimpannya ke $ZIP_FILE"

  # Perintah zip. Pindah ke direktori induk untuk kompresi yang lebih rapi.
  # -r: rekursif, -9: kompresi maksimal
  (cd "$CONFIG_SOURCE" && zip -r9 "$ZIP_DEST" "$ZIP_FOLDER")

  if [ $? -eq 0 ]; then
    echo "✅ File ZIP '$ZIP_FILE' berhasil dibuat dan disimpan."
  else
    echo "❌ ERROR: Gagal membuat file ZIP untuk Hypr. Periksa apakah paket 'zip' sudah terinstal."
  fi
else
  echo "⚠️ PERINGATAN: Folder konfigurasi '$HYPR_SOURCE' tidak ditemukan. Melewati kompresi Hypr."
fi

echo "-------------------------------------"
echo "🎉 Update selesai!"
echo "Data konfigurasi Anda siap di-commit ke Git. File Hypr yang lama di folder backup tidak akan tertimpa, melainkan ada file ZIP baru."
