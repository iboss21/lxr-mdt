# 🐺 LXR-MDT - SQL Database Schema

```
  ███████╗ ██████╗ ██╗     
  ██╔════╝██╔═══██╗██║     
  ███████╗██║   ██║██║     
  ╚════██║██║▄▄ ██║██║     
  ███████║╚██████╔╝███████╗
  ╚══════╝ ╚══▀▀═╝ ╚══════╝
```

**🐺 wolves.land Production Resource**  
© 2026 iBoss21 / The Lux Empire

---

## 📋 Overview

This folder contains the **database schema** for LXR-MDT.

## File

- **install.sql** - Complete database schema with all 14 tables

## Tables Created

| Table | Purpose |
|-------|---------|
| `mdt_players` | Player identity records |
| `mdt_medical_records` | Medical history |
| `mdt_treatment_history` | Treatment logs |
| `mdt_prescriptions` | Prescription system |
| `mdt_medical_reports` | Medical reports |
| `mdt_deaths` | Death certificates |
| `mdt_criminal_records` | Criminal history |
| `mdt_warrants` | Warrant system |
| `mdt_arrests` | Arrest records |
| `mdt_jail_history` | Incarceration logs |
| `mdt_bounties` | Bounty system |
| `mdt_evidence` | Evidence locker |
| `mdt_supplies` | Supply tracking |
| `mdt_logs` | Action audit trail |

## Installation

1. Open your MySQL/MariaDB database
2. Run `install.sql`
3. Verify all tables created: `SHOW TABLES LIKE 'mdt_%';`

All tables use `mdt_` prefix for organization.

---

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🐺 LXR-MDT Database Layer - Persistent World Records                   ║
║                                                                           ║
║   Built with ❤️ for wolves.land by iBoss21 / The Lux Empire              ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```
