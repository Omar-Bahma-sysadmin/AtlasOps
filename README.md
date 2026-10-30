
<h1 align="center">AtlasOps</h1>

<h3 align="center">Smart Server Care & Automation</h3>

<p align="center">
  Linux System Administration | Monitoring | Backup Automation
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Linux-System%20Administration-blue?logo=linux" alt="Linux">
  <img src="https://img.shields.io/badge/Bash-Automation-green?logo=gnubash" alt="Bash">
  <img src="https://img.shields.io/badge/Python-3-yellow?logo=python" alt="Python">
  <img src="https://img.shields.io/badge/Git-GitHub-orange?logo=github" alt="GitHub">
  <img src="https://img.shields.io/badge/Project-Learning%20Lab-blueviolet" alt="Learning Lab">
</p>

<p align="center">
  <strong>Portfolio-Projekt für Fachinformatiker/in für Systemintegration</strong>
</p>

---

<p align="center">
  <img src="assets/banner.png" alt="AtlasOps Banner" width="100%">
</p>

---

## Projektübersicht

AtlasOps ist ein praxisorientiertes Portfolio-Projekt für die Linux-Systemadministration und Automatisierung.

Das Toolkit wurde für das Szenario eines fiktiven kleinen Unternehmens mit Linux-Servern konzipiert. Es unterstützt typische administrative Aufgaben und hilft dabei, wiederkehrende Tätigkeiten nachvollziehbar und reproduzierbar auszuführen.

**Projektstatus:** Lern- und Lab-Projekt. Die Skripte wurden noch nicht vollständig in einer Linux-Testumgebung geprüft. Nicht ungeprüft auf Produktivsystemen einsetzen.

## Funktionen

- Linux-Systeminformationen erfassen
- Systeminformationen als JSON-Bericht speichern
- Systemberichte über ein Python-Skript lesbar anzeigen
- Verzeichnisse als komprimierte Backups sichern
- SHA-256-Prüfsummen für Backup-Dateien erstellen
- Wiederkehrende administrative Aufgaben mit Bash automatisieren

## Technologien

- Linux
- Bash
- Python 3
- Git
- GitHub
- Markdown

## Warum dieses Projekt?

Ich habe AtlasOps entwickelt, um meine Kenntnisse in der Linux-Systemadministration und Automatisierung praktisch zu vertiefen.

Dabei beschäftige ich mich mit typischen Aufgaben eines Fachinformatikers für Systemintegration, zum Beispiel dem Erfassen von Systeminformationen, der Erstellung von Berichten und der Automatisierung von Backups.

Mit diesem Projekt möchte ich meine technischen Fähigkeiten weiterentwickeln und mein Verständnis für den Betrieb und die Wartung von IT-Systemen verbessern.

## Projektstruktur

```text
AtlasOps/
├── assets/
│   ├── banner.png
│   └── screenshots/
├── scripts/
│   ├── health_check.sh
│   └── backup.sh
├── report.py
├── reports/
└── README.md
```

## Schnellstart

### Voraussetzungen

- Linux-System oder Ubuntu-VM
- Bash
- Python 3

### 1. Repository herunterladen

```bash
git clone https://github.com/Omar-Bahma-sysadmin/AtlasOps.git
cd AtlasOps
```

### 2. Skripte ausführbar machen

```bash
chmod +x scripts/*.sh
```

### 3. System-Health-Check ausführen

```bash
./scripts/health_check.sh
```

Der Bericht wird unter `reports/latest.json` gespeichert.

### 4. JSON-Bericht anzeigen

```bash
python3 report.py --input reports/latest.json
```

## Backup testen

Für einen ersten Test können eigene Testdaten erstellt werden:

```bash
mkdir -p /tmp/atlasops-demo/source
echo "Testdaten" > /tmp/atlasops-demo/source/demo.txt
```

Backup erstellen:

```bash
./scripts/backup.sh /tmp/atlasops-demo/source /tmp/atlasops-demo/backups
```

Das Skript erstellt eine komprimierte Backup-Datei und eine SHA-256-Prüfsummendatei.

## Sicherheit

- Keine Passwörter, Tokens, privaten Schlüssel oder echten Kundendaten committen.
- Skripte zuerst in einer virtuellen oder isolierten Testumgebung prüfen.
- Änderungen an Ansible-Konfigurationen vor der Ausführung mit `--check --diff` testen.
- Backup-Wiederherstellung, Dateiberechtigungen und Aufbewahrungsfristen vor einem produktiven Einsatz prüfen.

## Screenshots

Screenshots aus einer realen Linux-Testumgebung werden nach Durchführung der Tests hier ergänzt.

## Roadmap

- [x] Projektstruktur und erste Skriptversionen erstellen
- [x] Health-Check-Skript implementieren
- [x] Backup-Skript mit SHA-256-Prüfsumme implementieren
- [x] JSON-Report-Renderer implementieren
- [ ] Skripte in einer Ubuntu-Server-VM testen
- [ ] Backup-Wiederherstellung und Prüfsummenprüfung testen
- [ ] Ansible-Playbook erstellen und in einer isolierten VM testen
- [ ] Screenshots und Testergebnisse dokumentieren
- [ ] Deutsche Projektpräsentation für Bewerbungen vorbereiten

---

<p align="center">
  <strong>AtlasOps – Learning by Building.</strong>
</p>

<p align="center">
  Portfolio-Projekt von Omar Bahma
</p>
