#!/usr/bin/env python3
"""Render a human-readable summary from AtlasOps health-check JSON."""

import argparse
import json
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(
        description="AtlasOps Systembericht anzeigen"
    )
    parser.add_argument(
        "--input",
        default="reports/latest.json",
        help="Pfad zur JSON-Datei"
    )
    args = parser.parse_args()

    path = Path(args.input)

    if not path.is_file():
        raise SystemExit(
            f"Datei nicht gefunden: {path}. "
            "Zuerst scripts/health_check.sh ausführen."
        )

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as error:
        raise SystemExit(f"Ungültige JSON-Datei: {error}")

    print("=== AtlasOps Systembericht ===")
    print(f"Erstellt (UTC): {data.get('timestamp', 'unbekannt')}")
    print(f"Host:           {data.get('hostname', 'unbekannt')}")
    print(f"Uptime:         {data.get('uptime', 'unbekannt')}")
    print(f"RAM-Auslastung: {data.get('memory_usage', 'n/a')}")
    print(f"Festplatten:    {data.get('disk_usage_root', 'n/a')}")
    print(f"Status:         {data.get('status', 'unbekannt')}")


if __name__ == "__main__":
    main()
        print(f"Freier Speicher: {disk.get('available_bytes', 'n/a')} Bytes")
    print(f"Dienstprüfung:  {service.get('service', 'n/a')} = {service.get('status', 'n/a')}")

if __name__ == "__main__":
    main()
