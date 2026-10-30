#!/usr/bin/env python3
"""Render a human-readable summary from AtlasOps health-check JSON."""

import argparse
import json
from pathlib import Path


def format_bytes(value):
    try:
        value = float(value)
    except (TypeError, ValueError):
        return "n/a"

    if value < 0:
        return "n/a"

    units = ["B", "KB", "MB", "GB", "TB"]
    for unit in units:
        if value < 1024 or unit == units[-1]:
            return f"{value:.2f} {unit}"
        value /= 1024
    return "n/a"


def main():
    parser = argparse.ArgumentParser(
        description="AtlasOps Systembericht anzeigen"
    )
    parser.add_argument(
        "--input",
        default="reports/latest.json",
        help="Pfad zur JSON-Datei",
    )
    args = parser.parse_args()
    path = Path(args.input)

    if not path.is_file():
        raise SystemExit(
            f"Datei nicht gefunden: {path}. "
            "Zuerst ./scripts/health_check.sh ausführen."
        )

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError) as error:
        raise SystemExit(f"Bericht konnte nicht gelesen werden: {error}")

    if not isinstance(data, dict):
        raise SystemExit("Bericht konnte nicht gelesen werden: JSON-Objekt erwartet.")

    memory = data.get("memory") or {}
    disk = data.get("root_filesystem") or {}
    service = data.get("service_check") or {}
    if not all(isinstance(item, dict) for item in (memory, disk, service)):
        raise SystemExit("Bericht enthält ungültige Datenstrukturen.")

    total_memory = memory.get("total_bytes")
    available_memory = memory.get("available_bytes")
    if isinstance(total_memory, (int, float)) and total_memory > 0:
        used_percent = (
            (total_memory - available_memory) / total_memory * 100
            if isinstance(available_memory, (int, float))
            and 0 <= available_memory <= total_memory
            else None
        )
        memory_usage = f"{used_percent:.1f}%" if used_percent is not None else "n/a"
    else:
        memory_usage = "n/a"

    print("=== AtlasOps Systembericht ===")
    print(f"Erstellt (UTC): {data.get('generated_at_utc', 'unbekannt')}")
    print(f"Host:           {data.get('hostname', 'unbekannt')}")
    print(f"Betriebssystem: {data.get('operating_system', 'unbekannt')}")
    print(f"Uptime:         {data.get('uptime', 'unbekannt')}")
    print(f"Load Average:   {data.get('load_average_1_5_15', 'n/a')}")
    print(f"RAM-Auslastung: {memory_usage}")
    print(f"RAM gesamt:     {format_bytes(total_memory)}")
    print(f"RAM verfügbar:  {format_bytes(available_memory)}")
    print(f"Festplatte:     {disk.get('use_percent', 'n/a')}")
    print(f"Freier Speicher: {format_bytes(disk.get('available_bytes'))}")
    print(
        f"Dienstprüfung:  {service.get('service', 'n/a')} = "
        f"{service.get('status', 'n/a')}"
    )


if __name__ == "__main__":
    main()
