# 🐺 LXR-MDT - Installation Guide

```
  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗      █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║
  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
```

**🐺 wolves.land Production Resource**  
© 2026 iBoss21 / The Lux Empire

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Steps](#installation-steps)
3. [Database Setup](#database-setup)
4. [Configuration](#configuration)
5. [Framework Integration](#framework-integration)
6. [Verification](#verification)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before installing LXR-MDT, ensure you have:

### Required
- ✅ **RedM Server** (Latest prerelease build)
- ✅ **MySQL/MariaDB** database server
- ✅ **oxmysql** resource (database connector)
- ✅ **Framework** (one of the following):
  - LXR-Core (recommended)
  - RSG-Core
  - VORP Core
  - Standalone (basic functionality)

### Recommended
- Server restart capability
- Database management tool (HeidiSQL, phpMyAdmin, etc.)
- FTP/SSH access to server files
- Backup of existing database

---

## Installation Steps

### Step 1: Download Resource

#### Option A: GitHub Clone
```bash
cd resources
git clone https://github.com/iBoss21/lxr-mdt.git
```

#### Option B: Manual Download
1. Download ZIP from GitHub repository
2. Extract to your `resources` folder
3. Ensure folder is named **exactly** `lxr-mdt`

### Step 2: Verify Folder Structure

Your `resources/lxr-mdt/` folder should contain:
```
lxr-mdt/
├── client/
├── server/
├── shared/
├── html/
├── sql/
├── docs/
├── config.lua
├── fxmanifest.lua
└── README.md
```

**CRITICAL:** The folder **MUST** be named `lxr-mdt` (not `lxr-mdt-main` or `lxr-mdt-master`).  
The resource has a built-in name guard that will prevent startup if renamed.

---

## Database Setup

### Step 1: Access Your Database

Using your preferred database management tool:
- HeidiSQL
- phpMyAdmin
- MySQL Workbench
- Command line

### Step 2: Import Schema

1. Navigate to `resources/lxr-mdt/sql/install.sql`
2. Open the file in your database tool
3. Execute the SQL script

**What it creates:**
- `mdt_players` - Player identity records
- `mdt_medical_records` - Medical history
- `mdt_treatment_history` - Treatment logs
- `mdt_prescriptions` - Prescription system
- `mdt_medical_reports` - Medical reports
- `mdt_deaths` - Death certificates
- `mdt_criminal_records` - Criminal history
- `mdt_warrants` - Warrant system
- `mdt_arrests` - Arrest records
- `mdt_jail_history` - Incarceration logs
- `mdt_bounties` - Bounty system
- `mdt_evidence` - Evidence locker
- `mdt_supplies` - Supply tracking
- `mdt_logs` - Action audit trail

### Step 3: Verify Tables

Run this query to verify all tables were created:
```sql
SHOW TABLES LIKE 'mdt_%';
```

You should see 14 tables.

---

## Configuration

### Step 1: Open Config File

Navigate to `resources/lxr-mdt/config.lua`

### Step 2: Configure Server Info (Optional)

The default configuration uses wolves.land branding. You can customize:

```lua
Config.ServerInfo = {
    name          = 'Your Server Name',
    tagline       = 'Your Server Tagline',
    description   = 'Your Description',
    website       = 'https://your-website.com',
    discord       = 'https://discord.gg/your-invite',
    -- ... more options
}
```

### Step 3: Configure Framework

**Auto-Detection (Recommended):**
```lua
Config.Framework = 'auto'
```

**Manual Selection:**
```lua
Config.Framework = 'lxr-core'  -- or 'rsg-core', 'vorp', 'standalone'
```

### Step 4: Configure Jobs

Define which jobs can access which MDT type:

```lua
Config.Jobs = {
    medical = {
        'doctor',
        'surgeon',
        'medic',
        -- Add your medical jobs
    },
    law = {
        'sheriff',
        'deputy',
        'marshal',
        -- Add your law jobs
    },
}
```

### Step 5: Configure Permissions

Set permissions by job grade:

```lua
Config.Permissions = {
    medical = {
        [0] = {  -- Trainee/Nurse
            viewRecords     = true,
            createRecords   = false,
            -- ...
        },
        [1] = {  -- Doctor
            viewRecords     = true,
            createRecords   = true,
            -- ...
        },
    },
    -- ...
}
```

---

## Framework Integration

### LXR-Core / RSG-Core

No additional setup required. The resource will:
1. Auto-detect framework
2. Use framework's player data structure
3. Integrate with framework notifications
4. Use framework's job system

### VORP Core

No additional setup required. VORP integration is automatic.

### Standalone Mode

If no framework is detected, the resource runs in standalone mode with:
- Basic functionality
- Mock job system for testing
- Native FiveM notifications

---

## Server Configuration

### Step 1: Add to server.cfg

Add to your `server.cfg`:

```cfg
# LXR-MDT System
ensure oxmysql
ensure lxr-mdt
```

**Load Order:**
1. Database connector (oxmysql)
2. Framework (lxr-core, rsg-core, or vorp_core)
3. LXR-MDT

### Step 2: Restart Server

```bash
restart lxr-mdt
```

Or full server restart (recommended for first install).

---

## Verification

### Step 1: Check Console

Look for the startup banner:

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🐺 LXR-MDT - MEDICAL & LAW DATABASE TERMINAL                            ║
║                                                                           ║
║   Version:        1.0.0                                                   ║
║   Framework:      [Detected Framework Name]                               ║
║   Medical MDT:    ✓ ENABLED                                               ║
║   Law MDT:        ✓ ENABLED                                               ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

### Step 2: Test Commands

In-game, test these commands:

```
/mdt      # Opens MDT based on your job
/medmdt   # Opens Medical MDT (medical jobs only)
/lawmdt   # Opens Law MDT (law jobs only)
```

### Step 3: Check Database

Verify player records are being created:

```sql
SELECT * FROM mdt_players LIMIT 10;
```

---

## Troubleshooting

### Resource Won't Start

**Error:** "Resource name mismatch"
- **Solution:** Folder MUST be named exactly `lxr-mdt`

**Error:** "Database connection failed"
- **Solution:** Ensure oxmysql is running and configured correctly

**Error:** "Framework object not found"
- **Solution:** Ensure your framework is loaded BEFORE lxr-mdt

### Commands Not Working

**Issue:** `/mdt` command does nothing
- **Check:** Console for errors
- **Verify:** Framework is detected correctly
- **Confirm:** Your job is in `Config.Jobs.medical` or `Config.Jobs.law`

### UI Won't Open

**Issue:** MDT command works but UI doesn't appear
- **Check:** Browser console (F12) for JavaScript errors
- **Verify:** All HTML files are in `html/` folder
- **Clear:** FiveM cache and reconnect

### Database Errors

**Issue:** "Table doesn't exist"
- **Solution:** Re-run `sql/install.sql`
- **Verify:** Tables exist with `SHOW TABLES LIKE 'mdt_%';`

### Permission Issues

**Issue:** Player can access MDT but can't perform actions
- **Check:** `Config.Permissions` for their job grade
- **Verify:** Job grade is correct
- **Review:** Server console for permission denied messages

---

## Post-Installation

### Recommended Next Steps

1. **Review Documentation**
   - Read [configuration.md](configuration.md) for all options
   - Read [security.md](security.md) for security best practices
   - Read [performance.md](performance.md) for optimization

2. **Customize Configuration**
   - Set your server branding
   - Configure jobs and permissions
   - Set up Discord webhooks (optional)
   - Configure terminal locations

3. **Test Thoroughly**
   - Test both Medical and Law MDT
   - Test all permission levels
   - Test database persistence
   - Monitor performance

4. **Train Staff**
   - Teach medical staff how to use Medical MDT
   - Teach law enforcement how to use Law MDT
   - Provide documentation links
   - Create server-specific guidelines

---

## Support

### Need Help?

- **Documentation:** Read all docs in `/docs` folder
- **Discord:** [wolves.land Community](https://discord.gg/CrKcWdfd3A)
- **GitHub:** [Report Issues](https://github.com/iBoss21/lxr-mdt/issues)

### Before Asking for Help

Please provide:
1. Server console output (with errors)
2. Your framework (LXR/RSG/VORP)
3. Config file (sanitized of sensitive info)
4. Steps to reproduce the issue

---

**🐺 wolves.land** | The Land of Wolves  
**Developer:** iBoss21 / The Lux Empire  
**License:** Proprietary - wolves.land Exclusive
