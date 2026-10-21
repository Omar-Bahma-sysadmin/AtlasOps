# Testplan

Führe alle Tests in einer eigenen Linux-VM oder einer Umgebung aus, die du administrieren darfst.

## Health Check
- [ ] `./scripts/health_check.sh` endet ohne Fehler.
- [ ] `reports/latest.json` wird erstellt und ist gültiges JSON.
- [ ] `python3 scripts/report.py --input reports/latest.json` zeigt einen Bericht.
- [ ] Teste `ATLASOPS_SERVICE=does-not-exist ./scripts/health_check.sh`, um einen fehlenden Dienst zu simulieren.

## Backup
- [ ] Lege Testdaten in einem temporären Verzeichnis an.
- [ ] Erstelle ein Backup in einem separaten Zielverzeichnis.
- [ ] Prüfe die Prüfsumme mit `sha256sum -c DATEI.tar.gz.sha256`.
- [ ] Liste den Archivinhalt mit `tar -tzf DATEI.tar.gz`.
- [ ] Übe eine Wiederherstellung in ein anderes Testverzeichnis.

## Ansible
- [ ] Passe `ansible/inventory.ini` an deine Lab-VM an.
- [ ] Prüfe zuerst: `ansible-playbook -i ansible/inventory.ini ansible/site.yml --check --diff`
- [ ] Führe es nur aus, wenn der Zielhost korrekt ist und du die Änderungen verstehst.
- [ ] Führe das Playbook ein zweites Mal aus und dokumentiere, ob Änderungen nötig waren.

## Portfolio
- [ ] Füge Datum, Betriebssystem und Testergebnis hinzu.
- [ ] Ergänze Screenshots ohne private IPs, Benutzernamen oder sensible Daten.
- [ ] Beschreibe mindestens einen Fehler, seine Ursache und die Lösung.
