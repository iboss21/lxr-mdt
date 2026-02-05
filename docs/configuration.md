# 🐺 LXR-MDT - Configuration Guide

```
   ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ ██╗   ██╗██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
  ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ ██║   ██║██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
  ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗██║   ██║██████╔╝███████║   ██║   ██║██║   ██║██╔██╗ ██║
  ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║██║   ██║██╔══██╗██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
  ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝╚██████╔╝██║  ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
```

**🐺 wolves.land Production Resource**  
© 2026 iBoss21 / The Lux Empire

---

## 📋 Complete Configuration Reference

All configuration is done in `config.lua`. This guide explains every section and option.

---

## 🌐 Server Information

```lua
Config.ServerInfo = {
    name          = 'The Land of Wolves 🐺',
    tagline       = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description   = 'ისტორია ცოცხლდება აქ!',
    type          = 'Serious Hardcore Roleplay',
    access        = 'Discord & Whitelisted',
    website       = 'https://www.wolves.land',
    discord       = 'https://discord.gg/CrKcWdfd3A',
    github        = 'https://github.com/iBoss21',
    store         = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer     = 'iBoss21 / The Lux Empire',
    tags          = {'RedM','Georgian','SeriousRP','Whitelist','Economy','RPG','MDT'},
}
```

**Purpose:** Server branding and identity displayed in startup banner and logs.

---

## 🎨 Framework Configuration

```lua
Config.Framework = 'auto'  -- 'auto' | 'lxr-core' | 'rsg-core' | 'vorp' | 'standalone'
```

### Options

- **`'auto'`** (Recommended) - Auto-detects framework in priority order:
  1. LXR-Core
  2. RSG-Core
  3. VORP Core
  4. Standalone (fallback)

- **`'lxr-core'`** - Force LXR-Core
- **`'rsg-core'`** - Force RSG-Core
- **`'vorp'`** - Force VORP Core
- **`'standalone'`** - Force standalone mode

---

## 🗣️ Language

```lua
Config.Lang = 'en'  -- 'en' | 'ka' (Georgian) | 'es' | 'fr' | 'de'
```

Future: Multi-language support. Currently English only.

---

## ⚙️ General Settings

```lua
Config.General = {
    -- Feature Toggles
    enableMedicalMDT    = true,   -- Medical MDT system
    enableLawMDT        = true,   -- Law MDT system
    enableDeathCerts    = true,   -- Death certificates
    enablePrescriptions = true,   -- Prescription system
    enableWarrants      = true,   -- Warrant system
    enableBounties      = true,   -- Bounty system
    enableEvidenceLog   = true,   -- Evidence locker
    enableSupplyTrack   = true,   -- Supply tracking
    
    -- Access Methods
    enableCommand       = true,   -- /mdt command
    enableItems         = true,   -- Journal/book items
    enableTargets       = true,   -- Physical terminals
    enableKeybind       = false,  -- Keybind (disabled by default)
    
    -- Debug
    debug               = false,  -- Verbose logging
    debugSQL            = false,  -- SQL query logging
    logActions          = true,   -- Log MDT actions
    logToDiscord        = false,  -- Discord webhook
}
```

---

## 🎮 Key Configuration

```lua
Config.Keys = {
    openMDT = 0x760A9C6F,  -- [G] key hash
    closeUI = 0x156F7119,  -- [Backspace/ESC]
    
    descriptions = {
        openMDT = 'Open MDT Terminal',
        closeUI = 'Close MDT Interface',
    }
}
```

**Key Hashes:** RedM uses key hashes instead of key codes.  
Find more at: https://docs.fivem.net/docs/game-references/controls/

---

## 👔 Jobs Configuration

```lua
Config.Jobs = {
    -- Medical Jobs (Access Medical MDT)
    medical = {
        'doctor',
        'surgeon',
        'medic',
        'nurse',
        'pharmacist',
    },
    
    -- Law Jobs (Access Law MDT)
    law = {
        'sheriff',
        'deputy',
        'marshal',
        'lawman',
        'police',
    },
    
    -- Minimum Grades
    minGrades = {
        doctor  = 0,  -- Any grade
        surgeon = 1,  -- Grade 1+
        sheriff = 0,
        marshal = 1,
    },
}
```

**Add your custom jobs** to these arrays. Job names must match your framework's job system.

---

## 🔐 Permissions System

```lua
Config.Permissions = {
    medical = {
        [0] = {  -- Grade 0: Trainee/Nurse
            viewRecords     = true,
            createRecords   = false,
            editRecords     = false,
            deleteRecords   = false,
            viewReports     = true,
            createReports   = false,
            prescribe       = false,
            deathCerts      = false,
            manageSupplies  = false,
        },
        [1] = {  -- Grade 1: Doctor
            viewRecords     = true,
            createRecords   = true,
            editRecords     = true,
            deleteRecords   = false,
            viewReports     = true,
            createReports   = true,
            prescribe       = true,
            deathCerts      = true,
            manageSupplies  = true,
        },
        [2] = {  -- Grade 2: Surgeon/Chief
            viewRecords     = true,
            createRecords   = true,
            editRecords     = true,
            deleteRecords   = true,  -- Full access
            viewReports     = true,
            createReports   = true,
            prescribe       = true,
            deathCerts      = true,
            manageSupplies  = true,
        },
    },
    
    law = {
        [0] = {  -- Grade 0: Deputy
            viewRecords     = true,
            createRecords   = true,
            editRecords     = false,
            deleteRecords   = false,
            viewWarrants    = true,
            issueWarrants   = false,
            arrest          = true,
            manageBounties  = false,
            viewEvidence    = true,
            manageEvidence  = false,
        },
        [1] = {  -- Grade 1: Sheriff
            viewRecords     = true,
            createRecords   = true,
            editRecords     = true,
            deleteRecords   = false,
            viewWarrants    = true,
            issueWarrants   = true,
            arrest          = true,
            manageBounties  = true,
            viewEvidence    = true,
            manageEvidence  = true,
        },
        [2] = {  -- Grade 2: Marshal/Chief
            viewRecords     = true,
            createRecords   = true,
            editRecords     = true,
            deleteRecords   = true,  -- Full access
            viewWarrants    = true,
            issueWarrants   = true,
            arrest          = true,
            manageBounties  = true,
            viewEvidence    = true,
            manageEvidence  = true,
        },
    },
}
```

**Customize** permissions per grade for your server's hierarchy.

---

## 🗄️ Database Tables

```lua
Config.DatabaseTables = {
    players           = 'mdt_players',
    medicalRecords    = 'mdt_medical_records',
    medicalReports    = 'mdt_medical_reports',
    prescriptions     = 'mdt_prescriptions',
    treatmentHistory  = 'mdt_treatment_history',
    deaths            = 'mdt_deaths',
    criminalRecords   = 'mdt_criminal_records',
    warrants          = 'mdt_warrants',
    arrests           = 'mdt_arrests',
    jailHistory       = 'mdt_jail_history',
    bounties          = 'mdt_bounties',
    evidence          = 'mdt_evidence',
    mdtLogs           = 'mdt_logs',
    supplies          = 'mdt_supplies',
}
```

**Don't change unless you know what you're doing.** All tables use `mdt_` prefix.

---

## 🛡️ Security Configuration

```lua
Config.Security = {
    -- Anti-Abuse Toggles
    enableCooldowns       = true,   -- Per-action cooldowns
    enableRateLimiting    = true,   -- Rate limit requests
    enableDistanceChecks  = true,   -- Proximity checks for terminals
    enableJobValidation   = true,   -- Always validate job server-side
    enableSuspicionLog    = true,   -- Log suspicious behavior
    
    -- Cooldowns (seconds)
    cooldowns = {
        openMDT         = 2,    -- Between MDT opens
        createReport    = 30,   -- Report creation
        issueWarrant    = 15,   -- Warrant issuance
        issueBounty     = 20,   -- Bounty creation
        prescribe       = 10,   -- Prescription creation
    },
    
    -- Rate Limits (actions per minute)
    rateLimits = {
        searchQueries   = 30,   -- Max searches/min
        recordCreation  = 10,   -- Max records/min
        reportCreation  = 5,    -- Max reports/min
    },
    
    -- Distance Checks
    maxTerminalDistance = 3.0,  -- Max distance from terminal (meters)
    
    -- Discord Logging (Optional)
    discordWebhook = '',  -- Your webhook URL (leave empty to disable)
    discordLogActions = {
        warrants        = true,
        bounties        = true,
        arrests         = true,
        deathCerts      = true,
        suspiciousBehavior = true,
    },
}
```

**Security Best Practices:**
- Keep cooldowns enabled
- Monitor suspicious activity
- Set up Discord logging for important actions
- Never trust client input

---

## ⚡ Performance Configuration

```lua
Config.Performance = {
    -- Zero-Tick Architecture
    useThreads          = false,  -- No idle threads
    
    -- Caching
    enableCache         = true,   -- Cache player records
    cacheTTL            = 300,    -- Cache lifetime (seconds)
    cachePlayerLimit    = 100,    -- Max cached records
    
    -- Database
    batchInserts        = true,   -- Batch inserts
    batchSize           = 50,     -- Records per batch
    queryTimeout        = 5000,   -- Query timeout (ms)
    
    -- Update Intervals
    playerDataUpdate    = 60000,  -- Update cache (ms)
    onlinePlayerCheck   = 30000,  -- Online check (ms)
}
```

**Optimization Tips:**
- Keep caching enabled
- Adjust cache TTL based on server size
- Monitor database performance
- Use batch operations when possible

---

## 📦 Items Configuration

```lua
Config.Items = {
    medical = {
        'doctor_book',
        'medical_journal',
        'surgeon_notes',
    },
    law = {
        'law_book',
        'sheriff_ledger',
        'marshal_journal',
    },
}
```

**Integration:** Add these items to your framework's item database.  
Using an item opens the corresponding MDT.

---

## 📍 Terminal Locations

```lua
Config.Targets = {
    -- Medical MDT Terminals
    medical = {
        {
            coords = vector3(-281.85, 808.64, 119.39),  -- Valentine Doctor
            heading = 0.0,
            label = 'Medical MDT Terminal',
            distance = 2.0,
        },
        {
            coords = vector3(2721.25, -1230.32, 50.37),  -- Saint Denis Hospital
            heading = 0.0,
            label = 'Medical MDT Terminal',
            distance = 2.0,
        },
    },
    
    -- Law MDT Terminals
    law = {
        {
            coords = vector3(-275.47, 805.91, 119.38),  -- Valentine Sheriff
            heading = 0.0,
            label = 'Law MDT Terminal',
            distance = 2.0,
        },
        {
            coords = vector3(2503.93, -1308.88, 49.25),  -- Saint Denis Police
            heading = 0.0,
            label = 'Law MDT Terminal',
            distance = 2.0,
        },
    },
}
```

**Add your server's locations.** Find coords in-game using `/getcoords` or similar.

---

## 🔔 Notifications

```lua
Config.Notifications = {
    style = 'auto',  -- Auto-detected per framework
    duration = 5000,  -- Display time (ms)
    
    enableSounds = true,
    sounds = {
        open    = 'sounds/open.ogg',
        close   = 'sounds/close.ogg',
        success = 'sounds/success.ogg',
        error   = 'sounds/error.ogg',
    },
}
```

---

## 🐛 Debug Configuration

```lua
Config.Debug = {
    printStartup        = true,   -- Startup banner
    printFramework      = true,   -- Framework detection
    printEvents         = false,  -- Event triggers
    printDatabase       = false,  -- DB queries
    printPermissions    = false,  -- Permission checks
    printCache          = false,  -- Cache operations
    printSecurity       = false,  -- Security validations
}
```

**Enable debug options** when troubleshooting. Disable in production for cleaner logs.

---

## 💡 Configuration Tips

1. **Start with defaults** - Test before customizing
2. **Document changes** - Keep notes of what you modify
3. **Test incrementally** - Change one section at a time
4. **Backup config** - Before major changes
5. **Monitor performance** - Adjust cache/limits as needed
6. **Review security** - Ensure anti-abuse is enabled

---

**🐺 wolves.land** | The Land of Wolves  
**Developer:** iBoss21 / The Lux Empire  
**License:** Proprietary - wolves.land Exclusive
