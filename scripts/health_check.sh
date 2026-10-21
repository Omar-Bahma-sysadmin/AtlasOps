#!/bin/bash
# AtlasOps - System Health Check Script
# Erstellt einen JSON-Bericht über den Systemzustand

REPORT_DIR="reports"
mkdir -p "$REPORT_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_FILE="$REPORT_DIR/health_$TIMESTAMP.json"
LATEST_FILE="$REPORT_DIR/latest.json"

echo "=== Starte System-Health-Check ==="

# Daten sammeln
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
MEMORY_USAGE=$(free -m | awk 'NR==2 {printf "%.2f%%", $3*100/$2}')

# JSON-Bericht erstellen
cat <<EOF > "$REPORT_FILE"
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "hostname": "$HOSTNAME",
  "uptime": "$UPTIME",
  "disk_usage_root": "$DISK_USAGE",
  "memory_usage": "$MEMORY_USAGE",
  "status": "OK"
}
EOF

# Als latest.json kopieren
cp "$REPORT_FILE" "$LATEST_FILE"

echo "[OK] Bericht erfolgreich erstellt: $LATEST_FILE"
