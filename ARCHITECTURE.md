# Architektur

## Ausgangssituation

Eine fiktive kleine Firma betreibt Linux-Server. Die IT möchte Zustandsdaten erfassen und wiederkehrende Tätigkeiten reproduzierbar ausführen.

## Komponenten

- **Health Check (Bash):** sammelt Host-, RAM-, Load-, Root-Dateisystem- und Dienststatus.
- **Report Renderer (Python):** liest den JSON-Bericht, prüft grundlegende Datenstrukturen und zeigt ihn kompakt an.
- **Backup Script (Bash):** erstellt ein datiertes Archiv und eine SHA-256-Prüfsumme.
- **CI-Workflow (GitHub Actions):** führt automatisierte Integrationstests in einer Ubuntu-24.04-Umgebung mit systemd aus.

## Datenfluss

1. Administrator führt `./scripts/health_check.sh` aus.
2. Der Health Check schreibt `reports/latest.json`.
3. Der Renderer liest die JSON-Datei mit `python3 report.py --input reports/latest.json`.
4. Das Backup wird mit Quell- und Zielpfad explizit über `./backup.sh` gestartet.
5. Die Integrität des Archivs wird mit `sha256sum -c` geprüft.
6. Für die Wiederherstellung wird das Archiv in ein separates Testverzeichnis entpackt und der Inhalt mit den Quelldaten verglichen.

## Qualitätssicherung

Der GitHub-Actions-Workflow prüft unter anderem den Dienststatus mit systemd, die Verarbeitung gültiger und ungültiger JSON-Daten sowie Backup-Erstellung, SHA-256-Prüfung, Wiederherstellung und ausgewählte Fehlerfälle.

Der erfolgreiche CI-Lauf vom 30.10.2026 ist in [GitHub Actions](https://github.com/Omar-Bahma-sysadmin/AtlasOps/actions/runs/41091067906) dokumentiert. Diese Tests laufen in einer GitHub-gehosteten Ubuntu-Umgebung. Zusätzliche manuelle Tests in einer eigenen Ubuntu-Server-VM und auf weiteren Distributionen stehen noch aus.

## Grenzen und geplante Erweiterungen

Das Projekt enthält noch kein zentrales Monitoring und keine automatische Alarmierung. Eine Ansible-Automatisierung ist als zukünftige Erweiterung geplant und noch nicht Bestandteil der aktuellen Projektversion. Die Skripte sind als Lern- und Lab-Projekt gedacht und nicht ohne zusätzliche Prüfung für produktive Systeme vorgesehen.
