
#!/bin/bash
# AtlasOps - Linux System Health Check

set -u

REPORT_DIR="reports"
mkdir -p "$REPORT_DIR" || exit 1

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_FILE="$REPORT_DIR/health_$TIMESTAMP.json"
LATEST_FILE="$REPORT_DIR/latest.json"

HOSTNAME_VALUE=$(hostname)
OS_VALUE=$(grep '^PRETTY_NAME=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
UPTIME_VALUE=$(uptime -p 2>/dev/null || uptime)
LOAD_VALUE=$(awk '{print $1 ", " $2 ", " $3}' /proc/loadavg)

MEMORY_TOTAL=$(free -b | awk '/^Mem:/ {print $2}')
MEMORY_AVAILABLE=$(free -b | awk '/^Mem:/ {print $7}')
DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')
DISK_AVAILABLE=$(df -B1 / | awk 'NR==2 {print $4}')

SERVICE_STATUS="not_checked"

cat <<EOF > "$REPORT_FILE"
{
  "generated_at_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "hostname": "$HOSTNAME_VALUE",
  "operating_system": "$OS_VALUE",
  "uptime": "$UPTIME_VALUE",
  "load_average_1_5_15": "$LOAD_VALUE",
  "memory": {
    "total_bytes": $MEMORY_TOTAL,
    "available_bytes": $MEMORY_AVAILABLE
  },
  "root_filesystem": {
    "use_percent": "$DISK_USAGE",
    "available_bytes": $DISK_AVAILABLE
  },
  "service_check": {
    "service": "not_configured",
    "status": "$SERVICE_STATUS"
  }
}
EOF

if [ $? -ne 0 ]; then
    echo "[ERROR] JSON-Bericht konnte nicht erstellt werden."
    exit 1
fi

cp "$REPORT_FILE" "$LATEST_FILE" || exit 1

echo "[OK] System-Health-Check abgeschlossen."
echo "[OK] Bericht: $LATEST_FILE"
