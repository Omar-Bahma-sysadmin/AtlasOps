#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$ROOT_DIR/reports"
REPORT_FILE="$REPORT_DIR/latest.json"
mkdir -p "$REPORT_DIR"

command -v python3 >/dev/null 2>&1 || {
  echo "Fehler: python3 ist erforderlich." >&2
  exit 1
}

HOSTNAME_VALUE="$(hostname)"
OS_VALUE="$(. /etc/os-release 2>/dev/null && printf '%s' "${PRETTY_NAME:-unknown}" || printf 'unknown')"
UPTIME_VALUE="$(uptime -p 2>/dev/null || uptime)"
LOAD_VALUE="$(awk '{print $1" "$2" "$3}' /proc/loadavg 2>/dev/null || echo unknown)"
MEMORY_VALUE="$(free -b 2>/dev/null | awk '/^Mem:/ {printf "{\"total_bytes\":%s,\"used_bytes\":%s,\"available_bytes\":%s}",$2,$3,$7}' || echo '{}')"
DISK_VALUE="$(df -P -B1 / 2>/dev/null | awk 'NR==2 {printf "{\"mount\":\"%s\",\"total_bytes\":%s,\"used_bytes\":%s,\"available_bytes\":%s,\"use_percent\":\"%s\"}",$6,$2,$3,$4,$5}' || echo '{}')"

SERVICE_NAME="${ATLASOPS_SERVICE:-ssh}"
if command -v systemctl >/dev/null 2>&1; then
  if systemctl is-active --quiet "$SERVICE_NAME"; then
    SERVICE_STATUS="active"
  else
    SERVICE_STATUS="inactive_or_missing"
  fi
else
  SERVICE_STATUS="systemctl_unavailable"
fi

export HOSTNAME_VALUE OS_VALUE UPTIME_VALUE LOAD_VALUE MEMORY_VALUE DISK_VALUE SERVICE_NAME SERVICE_STATUS
python3 - "$REPORT_FILE" <<'PY'
import json, os, sys
from datetime import datetime, timezone

def parse_json(name):
    try:
        return json.loads(os.environ.get(name, "{}"))
    except json.JSONDecodeError:
        return {}

report = {
    "generated_at_utc": datetime.now(timezone.utc).isoformat(),
    "hostname": os.environ.get("HOSTNAME_VALUE", "unknown"),
    "operating_system": os.environ.get("OS_VALUE", "unknown"),
    "uptime": os.environ.get("UPTIME_VALUE", "unknown"),
    "load_average_1_5_15": os.environ.get("LOAD_VALUE", "unknown"),
    "memory": parse_json("MEMORY_VALUE"),
    "root_filesystem": parse_json("DISK_VALUE"),
    "service_check": {
        "service": os.environ.get("SERVICE_NAME", "ssh"),
        "status": os.environ.get("SERVICE_STATUS", "unknown")
    }
}
with open(sys.argv[1], "w", encoding="utf-8") as f:
    json.dump(report, f, indent=2, ensure_ascii=False)
print(f"Bericht erstellt: {sys.argv[1]}")
print(f"Host: {report['hostname']} | Dienst {report['service_check']['service']}: {report['service_check']['status']}")
PY
