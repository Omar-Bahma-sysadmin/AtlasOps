#!/usr/bin/env bash
set -Eeuo pipefail

# Usage: ./backup.sh /path/to/source /path/to/backup-directory
# Use only on data you own or are authorized to administer.

if [[ $# -ne 2 ]]; then
  echo "Verwendung: $0 QUELLVERZEICHNIS BACKUP_VERZEICHNIS" >&2
  exit 2
fi

for cmd in realpath tar sha256sum date hostname tr mktemp mv; do
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

ARCHIVE_TMP=""
CHECKSUM_TMP=""
cleanup() {
  local status=$?
  if [[ -n "$ARCHIVE_TMP" ]]; then
    rm -f -- "$ARCHIVE_TMP"
  fi
  if [[ -n "$CHECKSUM_TMP" ]]; then
    rm -f -- "$CHECKSUM_TMP"
  fi
  # If either publication step fails, do not leave a partial final backup.
  if [[ $status -ne 0 ]]; then
    rm -f -- "$ARCHIVE" "$CHECKSUM"
  fi
  return "$status"
}
trap cleanup EXIT

ARCHIVE_TMP="$(mktemp "$BACKUP_DIR/.atlasops-archive.XXXXXX")"
CHECKSUM_TMP="$(mktemp "$BACKUP_DIR/.atlasops-checksum.XXXXXX")"

# Build and hash temporary files first. Publish only after both succeed.
tar -czf "$ARCHIVE_TMP" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
ARCHIVE_HASH="$(sha256sum "$ARCHIVE_TMP" | awk '{print $1}')"
printf '%s  %s\n' "$ARCHIVE_HASH" "$ARCHIVE" > "$CHECKSUM_TMP"

mv -- "$ARCHIVE_TMP" "$ARCHIVE"
ARCHIVE_TMP=""
mv -- "$CHECKSUM_TMP" "$CHECKSUM"
CHECKSUM_TMP=""

echo "Backup erstellt: $ARCHIVE"
echo "Prüfsumme gespeichert: $CHECKSUM"
echo "Hinweis: Teste die Wiederherstellung in einem separaten Verzeichnis."
