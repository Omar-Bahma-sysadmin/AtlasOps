AtlasOps – Smart Server Care & Automation

Ein praxisnahes Portfolio-Projekt für Fachinformatiker/in für Systemintegration (FISI).

AtlasOps ist ein Administrations-Toolkit für eine fiktive kleine Firma mit Linux-Servern. Es unterstützt typische Aufgaben der Systemadministration und macht wiederkehrende Tätigkeiten nachvollziehbar und reproduzierbar.

Projektstatus: Lern- und Lab-Projekt. Die Skripte wurden noch nicht vollständig in einer Linux-Testumgebung geprüft. Nicht ungeprüft auf Produktivsystemen einsetzen.

Funktionen

Linux-Systeminformationen sammeln und einen JSON-Bericht erstellen

Systemberichte lesbar in der Konsole anzeigen

Verzeichnisse als komprimierte Backups sichern

SHA-256-Prüfsummen für Backup-Dateien erstellen

Grundlagen der Serveradministration und Automatisierung demonstrieren

Technologien

Linux, Bash, Python 3, Ansible, Git, Markdown

Projektstruktur

AtlasOps/
├── scripts/
│   ├── health_check.sh
│   └── backup.sh
├── report.py
├── reports/
└── README.md

Schnellstart

1. Skripte ausführbar machen

chmod +x scripts/*.sh

2. System-Health-Check ausführen

./scripts/health_check.sh

Der Bericht wird unter reports/latest.json gespeichert.

3. JSON-Bericht anzeigen

python3 report.py --input reports/latest.json

Backup testen

Mit selbst erstellten Testdaten:

mkdir -p /tmp/atlasops-demo/source
echo "Testdaten" > /tmp/atlasops-demo/source/demo.txt

Backup erstellen:

./scripts/backup.sh /tmp/atlasops-demo/source /tmp/atlasops-demo/backups

Das Skript erstellt eine komprimierte Backup-Datei und eine SHA-256-Prüfsummendatei.

Sicherheit

Keine Passwörter, Tokens, privaten Schlüssel oder echten Kundendaten committen.

Skripte zuerst in einer VM oder isolierten Testumgebung prüfen.

Ansible-Änderungen zunächst mit --check --diff testen.

Backup-Wiederherstellung, Berechtigungen und Aufbewahrungsfristen vor einem produktiven Einsatz prüfen.

Roadmap

Projektstruktur und erste Skriptversionen erstellen

Health-Check-Skript implementieren

Backup-Skript mit SHA-256-Prüfsumme implementieren

JSON-Report-Renderer implementieren

Skripte in einer Ubuntu-Server-VM testen

Backup-Wiederherstellung und Prüfsummenprüfung testen

Ansible-Playbook erstellen und in einer isolierten VM testen

Screenshots und Testergebnisse dokumentieren

Deutsche Projektpräsentation für Bewerbungen vorbereiten

Warum dieses Projekt?

AtlasOps demonstriert grundlegende Aufgaben der Fachinformatik für Systemintegration: Linux-Systeme überwachen, Daten sichern, Systeminformationen auswerten und wiederkehrende administrative Aufgaben automatisieren.

Die Projektergebnisse sollen durch Tests, Screenshots und eine kurze Fehleranalyse dokumentiert werden.
