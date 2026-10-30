#!/usr/bin/env bash
set -Eeuo pipefail

# AtlasOps - System Health Check
# Generates reports/latest.json

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$ROOT_DIR/reports"
REPORT_FILE="$REPORT_DIR/latest.json"

mkdir -p "$REPORT_DIR"

for cmd in python3 hostname awk df; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Fehler: $cmd ist erforderlich." >&2
        exit 1
    fi
done

HOSTNAME_VALUE="$(hostname)"
OS_VALUE="unknown"
if [[ -r /etc/os-release ]]; then
    OS_VALUE="$(
        . /etc/os-release
        printf '%s' "${PRETTY_NAME:-unknown}"
    )"
fi

UPTIME_VALUE="$(uptime -p 2>/dev/null || uptime 2>/dev/null || echo unknown)"
LOAD_VALUE="unknown"
if [[ -r /proc/loadavg ]]; then
    LOAD_VALUE="$(awk '{print $1" "$2" "$3}' /proc/loadavg)"
fi

MEMORY_VALUE='{}'
if command -v free >/dev/null 2>&1; then
    MEMORY_VALUE="$(
        free -b 2>/dev/null |
        awk '$1 == "Mem:" {
            printf "{\"total_bytes\":%s,\"used_bytes\":%s,\"available_bytes\":%s}", $2, $3, $7
        }'
    )"
    [[ -n "$MEMORY_VALUE" ]] || MEMORY_VALUE='{}'
fi

DISK_VALUE="$(
    df -P -B1 / 2>/dev/null |
    awk 'NR == 2 {
        printf "{\"mount\":\"%s\",\"total_bytes\":%s,\"used_bytes\":%s,\"available_bytes\":%s,\"use_percent\":\"%s\"}", $6, $2, $3, $4, $5
    }'
)"
[[ -n "$DISK_VALUE" ]] || DISK_VALUE='{}'

SERVICE_NAME="${ATLASOPS_SERVICE:-ssh}"
if command -v systemctl >/dev/null 2>&1 && [[ -d /run/systemd/system ]]; then
    LOAD_STATE="$(systemctl show "$SERVICE_NAME" --property=LoadState --value 2>/dev/null || echo unknown)"
    if [[ "$LOAD_STATE" == "not-found" ]]; then
        SERVICE_STATUS="not_found"
    elif [[ "$LOAD_STATE" == "loaded" ]]; then
        if systemctl is-active --quiet "$SERVICE_NAME"; then
            SERVICE_STATUS="active"
        else
            SERVICE_STATUS="inactive"
        fi
    else
        SERVICE_STATUS="check_failed"
    fi
else
    SERVICE_STATUS="systemd_unavailable"
fi

export HOSTNAME_VALUE OS_VALUE UPTIME_VALUE LOAD_VALUE
export MEMORY_VALUE DISK_VALUE SERVICE_NAME SERVICE_STATUS

python3 - "$REPORT_FILE" <<'PY'
import json
import os
import sys
from datetime import datetime, timezone


def parse_object(name):
    try:
        value = json.loads(os.environ.get(name, "{}"))
        return value if isinstance(value, dict) else {}
    except (json.JSONDecodeError, TypeError):
        return {}


report = {
    "generated_at_utc": datetime.now(timezone.utc).isoformat(),
    "hostname": os.environ.get("HOSTNAME_VALUE", "unknown"),
    "operating_system": os.environ.get("OS_VALUE", "unknown"),
    "uptime": os.environ.get("UPTIME_VALUE", "unknown"),
    "load_average_1_5_15": os.environ.get("LOAD_VALUE", "unknown"),
    "memory": parse_object("MEMORY_VALUE"),
    "root_filesystem": parse_object("DISK_VALUE"),
    "service_check": {
        "service": os.environ.get("SERVICE_NAME", "ssh"),
        "status": os.environ.get("SERVICE_STATUS", "unknown"),
    },
}

with open(sys.argv[1], "w", encoding="utf-8") as file:
    json.dump(report, file, indent=2, ensure_ascii=False)

print(f"Bericht erstellt: {sys.argv[1]}")
print(f"Host: {report['hostname']}")
print(f"RAM: {report['memory']}")
print(f"Disk: {report['root_filesystem']}")
print(
    f"Dienstprüfung: {report['service_check']['service']} = "
    f"{report['service_check']['status']}"
)
PY

echo "Health Check erfolgreich abgeschlossen."
