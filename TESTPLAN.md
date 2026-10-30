# Testplan

## Testumgebung und Nachweis

Die automatisierten Integrationstests wurden am **30.10.2026** auf einem GitHub-gehosteten Runner mit **Ubuntu 24.04.5 LTS** ausgeführt.

- Workflow-Lauf: [AtlasOps Integration Tests – erfolgreicher Lauf](https://github.com/Omar-Bahma-sysadmin/AtlasOps/actions/runs/41091067906)
- Ergebnis: Alle zehn Workflow-Schritte erfolgreich abgeschlossen.
- Artefakt: [atlasops-test-evidence](https://github.com/Omar-Bahma-sysadmin/AtlasOps/actions/runs/41091067906/artifacts/12992903857) (enthält den JSON-Testbericht).
- Die vollständigen Konsolenprotokolle sind im Workflow-Lauf einsehbar.

Die folgenden CI-Prüfungen sind als erfolgreich dokumentiert. Manuelle Tests in einer eigenen VM sind davon getrennt zu betrachten.

## Linux und systemd

- [x] Linux-Umgebung erkannt (Ubuntu 24.04.5 LTS).
- [x] systemd-Laufzeitumgebung erkannt.
- [x] OpenSSH-Server im CI-Runner installiert und gestartet.
- [x] Vorhandener Dienst `ssh` als aktiv erkannt.
- [x] Nicht vorhandener Dienst als `not_found` erkannt.

## Health Check und Report Renderer

- [x] Health-Check-Skript im CI-Test ausgeführt.
- [x] Bericht als JSON erzeugt.
- [x] Gültige JSON-Daten mit dem Python-Renderer verarbeitet.
- [x] Fehlerhaftes JSON zurückgewiesen.
- [x] JSON mit falscher Datenstruktur zurückgewiesen.

## Backup

- [x] Backup-Archiv erstellt.
- [x] SHA-256-Prüfsummendatei erstellt.
- [x] Prüfsumme erfolgreich verifiziert (`sha256sum -c`).
- [x] Archiv in ein separates Verzeichnis wiederhergestellt.
- [x] Wiederhergestellte Dateien mit den Quelldateien verglichen (`cmp`).
- [x] Fehlendes Quellverzeichnis korrekt zurückgewiesen.
- [x] Backup-Ziel innerhalb des Quellverzeichnisses korrekt zurückgewiesen.
- [x] Ungültiges Backup-Ziel korrekt zurückgewiesen.
- [x] Simulierten Fehler beim Erstellen des Archivs erkannt.
- [x] Bei fehlgeschlagener Archiverstellung bleiben weder Archiv noch Prüfsummen- oder temporäre Dateien zurück.
- [x] Bei fehlgeschlagener Prüfsummenerstellung werden keine unvollständigen Backup-Dateien veröffentlicht.
- [x] Temporäre Dateien werden nach Fehlern entfernt.
- [x] Bereits vorhandene Zieldateien werden beim Veröffentlichen nicht überschrieben.

## Noch ausstehende manuelle Prüfungen

- [ ] Health Check manuell in einer eigenen Ubuntu-Server-VM ausführen.
- [ ] JSON-Bericht und Report-Ausgabe in dieser VM kontrollieren.
- [ ] Backup und Wiederherstellung in dieser VM zusätzlich durchführen.
- [ ] Verhalten auf einer weiteren Linux-Distribution prüfen.
- [ ] Screenshots aus einer tatsächlichen Testausführung ergänzen (ohne sensible Daten).

## Geplante Erweiterungen

- [ ] Ansible-Playbook entwickeln und in einer isolierten Lab-VM testen.
