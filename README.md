# AtlasOps – Smart Server Care & Automation

**Ein praxisnahes Portfolio-Projekt für Fachinformatiker/in für Systemintegration (FISI).**

AtlasOps ist ein selbst entwickeltes Administrations-Toolkit für eine fiktive kleine Firma mit Linux-Servern. Es hilft, wiederkehrende Admin-Aufgaben nachvollziehbar, sicher und reproduzierbar auszuführen.

> Status: Lern-/Lab-Projekt. Nicht ungeprüft auf Produktivsystemen einsetzen.

## Funktionen
- Systemzustand prüfen und JSON-Bericht erzeugen
- ausgewählte Daten sichern und SHA-256-Prüfsumme erstellen
- Bericht lesbar in der Konsole anzeigen
- wiederholbare Serverkonfiguration mit Ansible vorbereiten

## Technologien
Linux, Bash, Python 3, Ansible, Git, Markdown

## Schnellstart
```bash
chmod +x scripts/*.sh
./scripts/health_check.sh
python3 scripts/report.py --input reports/latest.json
```

Backup-Test mit selbst erstellten Testdaten:
```bash
mkdir -p /tmp/atlasops-demo/source
echo "Testdaten" > /tmp/atlasops-demo/source/demo.txt
./scripts/backup.sh /tmp/atlasops-demo/source /tmp/atlasops-demo/backups
```

## Sicherheit
- Keine Passwörter, Tokens, privaten Schlüssel oder echten Kundendaten committen.
- Erst in einer VM oder Testumgebung testen.
- Ansible zuerst mit `--check --diff` prüfen.
- Restore, Berechtigungen und Aufbewahrungsfristen vor produktiver Nutzung testen.

## Roadmap
- [x] Projektstruktur und erste Health-Check-Version
- [x] Backup-Skript mit Prüfsumme
- [x] JSON-Report-Renderer
- [ ] Tests in Ubuntu Server VM dokumentieren
- [ ] Ansible-Playbook in einer isolierten VM testen
- [ ] Screenshots und Testergebnisse ergänzen
- [ ] Deutsche Projektpräsentation für Bewerbungen vorbereiten

## Warum dieses Projekt?
Es zeigt typische FISI-Aufgaben: Systeme prüfen, Daten sichern, Linux verwalten und wiederkehrende Tätigkeiten automatisieren. Belege deine Ergebnisse mit Tests, Screenshots und einer kurzen Fehleranalyse.
