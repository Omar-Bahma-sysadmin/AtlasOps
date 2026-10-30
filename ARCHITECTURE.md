# Architektur

## Ausgangssituation
Eine fiktive kleine Firma betreibt Linux-Server. Die IT möchte Zustandsdaten erfassen und wiederkehrende Tätigkeiten reproduzierbar ausführen.

## Komponenten
- **Health Check (Bash):** sammelt Host-, RAM-, Load-, Root-Dateisystem- und Dienststatus.
- **Report Renderer (Python):** liest den JSON-Bericht und zeigt ihn kompakt an.
- **Backup Script (Bash):** erstellt ein datiertes Archiv und eine SHA-256-Prüfsumme.

## Datenfluss
1. Administrator führt `./scripts/health_check.sh` aus.
2. Der Health Check schreibt `reports/latest.json`.
3. Der Renderer liest die JSON-Datei mit `python3 report.py --input reports/latest.json`.
4. Das Backup wird mit Quell- und Zielpfad explizit über `./backup.sh` gestartet.
5. Die Integrität des Archivs wird mit `sha256sum -c` geprüft.

## Grenzen und geplante Erweiterungen
Das Projekt enthält noch kein zentrales Monitoring und keine automatische Alarmierung. Eine Ansible-Automatisierung ist als zukünftige Erweiterung geplant und noch nicht Bestandteil der aktuellen Projektversion. Die Wiederherstellung von Backups muss in einer geeigneten Testumgebung praktisch geprüft und dokumentiert werden.
