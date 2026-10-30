#!/usr/bin/env bash
set -Eeuo pipefail

# Usage: ./backup.sh /path/to/source /path/to/backup-directory
# Use only on data you own or are authorized to administer.

if [[ $# -ne 2 ]]; then
  echo "Verwendung: $0 QUELLVERZEICHNIS BACKUP_VERZEICHNIS" >&2
  exit 2
fi

for cmd in realpath tar sha256sum date hostname tr; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Fehler: $cmd ist erforderlich." >&2
    exit 1
  fi
done

if [[ ! -d "$1" ]]; then
  echo "Fehler: Quellverzeichnis existiert nicht: $1" >&2
  exit 1
fi

SOURCE_DIR="$(realpath "$1")"
BACKUP_DIR="$(realpath -m "$2")"

# Normalize the source prefix; this also handles SOURCE_DIR="/".
SOURCE_PREFIX="$SOURCE_DIR"
if [[ "$SOURCE_PREFIX" != "/" ]]; then
  SOURCE_PREFIX+="/"
fi

case "$BACKUP_DIR/" in
  "$SOURCE_PREFIX"*)
    echo "Fehler: Backup-Ziel liegt innerhalb des Quellverzeichnisses." >&2
    exit 1
    ;;
esac

# Create the destination only after validating that it is outside the source.
mkdir -p "$BACKUP_DIR"
BACKUP_DIR="$(realpath "$BACKUP_DIR")"

TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
HOST="$(hostname | tr -cd '[:alnum:]._-' )"
ARCHIVE="$BACKUP_DIR/${HOST:-host}_${TIMESTAMP}.tar.gz"
CHECKSUM="${ARCHIVE}.sha256"

if [[ -e "$ARCHIVE" || -e "$CHECKSUM" ]]; then
  echo "Fehler: Backup-Datei für diesen Zeitstempel existiert bereits." >&2
  exit 1
fi

tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
sha256sum "$ARCHIVE" > "$CHECKSUM"

echo "Backup erstellt: $ARCHIVE"
echo "Prüfsumme gespeichert: $CHECKSUM"
echo "Hinweis: Teste die Wiederherstellung in einem separaten Verzeichnis."
