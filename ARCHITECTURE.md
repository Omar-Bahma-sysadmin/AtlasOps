# Architektur

## Ausgangssituation
Eine fiktive kleine Firma betreibt Linux-Server. Die IT möchte Zustandsdaten erfassen und wiederkehrende Tätigkeiten reproduzierbar ausführen.

## Komponenten
- **Health Check (Bash):** sammelt Host-, RAM-, Load-, Root-Dateisystem- und Dienststatus.
- **Report Renderer (Python):** zeigt den JSON-Bericht kompakt an.
- **Backup Script (Bash):** erstellt ein datiertes Archiv und SHA-256-Prüfsumme.
- **Ansible:** führt eine nachvollziehbare Aufgabe auf einer ausdrücklich konfigurierten Lab-VM aus.

## Datenfluss
1. Administrator führt den Health Check aus.
2. Der Check schreibt `reports/latest.json`.
3. Der Renderer liest JSON und zeigt eine Textübersicht.
4. Backup wird mit Quell- und Zielpfad explizit gestartet.
5. Ansible wird zuerst im Check-Modus geprüft und erst danach im Lab ausgeführt.

## Grenzen
Das Projekt enthält noch kein zentrales Monitoring, keine automatische Alarmierung und keine getestete Wiederherstellung. Diese Punkte gehören zur späteren Roadmap.
