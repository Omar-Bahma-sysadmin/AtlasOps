#!/bin/bash
# AtlasOps - Secure Backup Script with SHA-256 Checksum

SOURCE_DIR=$1
BACKUP_DIR=$2

if [ -z "$SOURCE_DIR" ] || [ -z "$BACKUP_DIR" ]; then
    echo "Fehler: Bitte Quell- und Zielverzeichnis angeben!"
    echo "Verwendung: $0 <Quellverzeichnis> <Zielverzeichnis>"
    exit 1
fi

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="backup_$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

echo "=== Starte Backup von $SOURCE_DIR ==="
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# SHA-256 Prüfsumme generieren
cd "$BACKUP_DIR"
sha256sum "$ARCHIVE_NAME" > "${ARCHIVE_NAME}.sha256"

echo "[OK] Backup erstellt: $ARCHIVE_PATH"
echo "[OK] Prüfsumme generiert: ${ARCHIVE_NAME}.sha256"
