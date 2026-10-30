# Testplan

Führe alle Tests in einer eigenen Linux-VM oder einer Umgebung aus, die du administrieren darfst.

## Health Check
- [ ] `./scripts/health_check.sh` endet ohne Fehler.
- [ ] `reports/latest.json` wird erstellt und ist gültiges JSON.
- [ ] Prüfe die JSON-Datei mit `python3 -m json.tool reports/latest.json`.
- [ ] `python3 report.py --input reports/latest.json` zeigt einen Bericht.
- [ ] Teste `ATLASOPS_SERVICE=does-not-exist ./scripts/health_check.sh`.
- [ ] Dokumentiere, ob systemd verfügbar war und welchen Dienststatus das Skript meldet.

## Backup
- [ ] Lege eigene Testdaten in einem temporären Quellverzeichnis an.
- [ ] Erstelle ein Backup mit `./backup.sh QUELLVERZEICHNIS BACKUP_VERZEICHNIS`.
- [ ] Prüfe die Prüfsumme mit `sha256sum -c DATEI.tar.gz.sha256`.
- [ ] Liste den Archivinhalt mit `tar -tzf DATEI.tar.gz`.
- [ ] Übe eine Wiederherstellung in ein anderes Testverzeichnis.
- [ ] Prüfe, dass ein Backup-Ziel innerhalb des Quellverzeichnisses abgelehnt wird.

## Report Renderer
- [ ] Teste das Skript mit einer gültigen JSON-Datei.
- [ ] Teste einen nicht vorhandenen Dateipfad.
- [ ] Teste eine ungültige JSON-Datei.
- [ ] Prüfe die Ausgabe bei fehlenden RAM- oder Festplattenwerten.

## Portfolio
- [ ] Füge Datum, Betriebssystem und Testergebnis hinzu.
- [ ] Ergänze Screenshots ohne private IPs, Benutzernamen oder sensible Daten.
- [ ] Beschreibe mindestens einen Fehler, seine Ursache und die Lösung.

## Geplante Erweiterungen
- [ ] Ansible-Playbook entwickeln und in einer isolierten Lab-VM testen.
