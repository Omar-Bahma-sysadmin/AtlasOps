#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/backup.sh /path/to/source /path/to/backup-directory
# Use only on data you own or are authorized to administer.

if [[ $# -ne 2 ]]; then
  echo "Verwendung: $0 QUELLVERZEICHNIS BACKUP_VERZEICHNIS" >&2
  exit 2
fi

SOURCE_DIR="$(realpath "$1")"
BACKUP_DIR="$2"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Fehler: Quellverzeichnis existiert nicht: $SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR"
BACKUP_DIR="$(realpath "$BACKUP_DIR")"

case "$BACKUP_DIR/" in
  "$SOURCE_DIR/"*)
    echo "Fehler: Backup-Ziel liegt innerhalb des Quellverzeichnisses." >&2
    exit 1
    ;;
esac

TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
HOST="$(hostname | tr -cd '[:alnum:]._-')"
ARCHIVE="$BACKUP_DIR/${HOST}_${TIMESTAMP}.tar.gz"
CHECKSUM="${ARCHIVE}.sha256"

tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
sha256sum "$ARCHIVE" > "$CHECKSUM"

echo "Backup erstellt: $ARCHIVE"
echo "Prüfsumme gespeichert: $CHECKSUM"
echo "Hinweis: Teste die Wiederherstellung in einem separaten Verzeichnis."
