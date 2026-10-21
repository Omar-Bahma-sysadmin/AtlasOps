#!/usr/bin/env python3
"""Render a compact human-readable summary from AtlasOps health-check JSON."""
import argparse
import json
from pathlib import Path

def main():
    parser = argparse.ArgumentParser(description="AtlasOps JSON-Bericht lesbar anzeigen")
    parser.add_argument("--input", default="reports/latest.json", help="Pfad zur JSON-Datei")
    args = parser.parse_args()
    path = Path(args.input)

    if not path.is_file():
        raise SystemExit(f"Datei nicht gefunden: {path}. Zuerst scripts/health_check.sh ausführen.")

    data = json.loads(path.read_text(encoding="utf-8"))
    memory = data.get("memory", {})
    disk = data.get("root_filesystem", {})
    service = data.get("service_check", {})

    print("=== AtlasOps Systembericht ===")
    print(f"Erstellt (UTC): {data.get('generated_at_utc', 'unbekannt')}")
    print(f"Host:           {data.get('hostname', 'unbekannt')}")
    print(f"Betriebssystem: {data.get('operating_system', 'unbekannt')}")
    print(f"Uptime:         {data.get('uptime', 'unbekannt')}")
    print(f"Load Average:   {data.get('load_average_1_5_15', 'unbekannt')}")
    if memory:
        print(f"RAM gesamt:     {memory.get('total_bytes', 'n/a')} Bytes")
        print(f"RAM verfügbar:  {memory.get('available_bytes', 'n/a')} Bytes")
    if disk:
        print(f"Root-Dateisyst.: {disk.get('use_percent', 'n/a')} belegt")
        print(f"Freier Speicher: {disk.get('available_bytes', 'n/a')} Bytes")
    print(f"Dienstprüfung:  {service.get('service', 'n/a')} = {service.get('status', 'n/a')}")

if __name__ == "__main__":
    main()
