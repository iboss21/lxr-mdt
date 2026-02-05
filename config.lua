--[[
  ███████╗██╗  ██╗███╗   ███╗ █████╗ ███╗   ██╗██╗███████╗███████╗███████╗████████╗
  ██╔════╝╚██╗██╔╝████╗ ████║██╔══██╗████╗  ██║██║██╔════╝██╔════╝██╔════╝╚══██╔══╝
  █████╗   ╚███╔╝ ██╔████╔██║███████║██╔██╗ ██║██║█████╗  █████╗  ███████╗   ██║   
  ██╔══╝   ██╔██╗ ██║╚██╔╝██║██╔══██║██║╚██╗██║██║██╔══╝  ██╔══╝  ╚════██║   ██║   
  ██║     ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║██║ ╚████║██║██║     ███████╗███████║   ██║   
  ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   
  
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - CONFIGURATION FILE
  ═══════════════════════════════════════════════════════════════════════════════════
  
  PURPOSE:
  Central configuration hub for the LXR-MDT system.
  Every setting, permission, security rule, and customization option lives here.
  This is a production-grade configuration matching wolves.land standards.
  
  ═══════════════════════════════════════════════════════════════════════════════════
  SERVER INFORMATION
  ═══════════════════════════════════════════════════════════════════════════════════
  Server:           The Land of Wolves 🐺
  Community:        Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
  Tagline:          History Lives Here! | ისტორია ცოცხლდება აქ!
  Type:             Serious Hardcore Roleplay
  Website:          https://www.wolves.land
  Discord:          https://discord.gg/CrKcWdfd3A
  Developer:        iBoss21 / The Lux Empire
  
  ═══════════════════════════════════════════════════════════════════════════════════
  VERSION & PERFORMANCE
  ═══════════════════════════════════════════════════════════════════════════════════
  Version:          1.0.0
  Target:           <0.03ms idle | 0.00ms resmon
  Architecture:     Zero-tick, event-driven, server-authority
  
  ═══════════════════════════════════════════════════════════════════════════════════
  FRAMEWORK SUPPORT
  ═══════════════════════════════════════════════════════════════════════════════════
  ✓ LXR-Core        (Primary)
  ✓ RSG-Core        (Primary)
  ✓ VORP Core       (Supported)
  ○ Standalone      (Fallback)
  
  ═══════════════════════════════════════════════════════════════════════════════════
  COPYRIGHT
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire. All Rights Reserved.
  wolves.land Exclusive Production Resource
  
  ═══════════════════════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = 'lxr-mdt'
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        
        ╔═══════════════════════════════════════════════════════════════════════════╗
        ║                                                                           ║
        ║   ⚠️  CRITICAL RESOURCE NAME MISMATCH DETECTED                           ║
        ║                                                                           ║
        ║   Resource: LXR-MDT                                                       ║
        ║   Expected: %s                                                            ║
        ║   Current:  %s                                                            ║
        ║                                                                           ║
        ║   This resource MUST be in a folder named '%s'                            ║
        ║                                                                           ║
        ║   WHY THIS MATTERS:                                                       ║
        ║   - Events are namespaced to resource name                                ║
        ║   - Database tables use resource prefix                                   ║
        ║   - Security checks validate resource identity                            ║
        ║   - Cross-resource communication requires exact name                      ║
        ║                                                                           ║
        ║   ACTION REQUIRED:                                                        ║
        ║   1. Stop your server                                                     ║
        ║   2. Rename folder to: %s                                                 ║
        ║   3. Restart server                                                       ║
        ║                                                                           ║
        ║   🐺 wolves.land | The Land of Wolves | iBoss21                           ║
        ║                                                                           ║
        ╚═══════════════════════════════════════════════════════════════════════════╝
        
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME, REQUIRED_RESOURCE_NAME))
end

-- ════════════════════════════════════════════════════════════════════════════════
-- GLOBAL CONFIG TABLE
-- ════════════════════════════════════════════════════════════════════════════════
Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name          = 'The Land of Wolves 🐺',
    tagline       = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description   = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type          = 'Serious Hardcore Roleplay',
    access        = 'Discord & Whitelisted',
    website       = 'https://www.wolves.land',
    discord       = 'https://discord.gg/CrKcWdfd3A',
    github        = 'https://github.com/iBoss21',
    store         = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer     = 'iBoss21 / The Lux Empire',
    tags          = {'RedM','Georgian','SeriousRP','Whitelist','Economy','RPG','MDT','Medical','Law'},
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core (Primary)
    2. RSG-Core (Primary)
    3. VORP Core (Supported)
    4. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' | 'lxr-core' | 'rsg-core' | 'vorp' | 'standalone'

Config.FrameworkSettings = {
    ['lxr-core'] = {
        resourceName = 'lxr-core',
        object       = 'LXRCore',
        events = {
            playerLoaded    = 'LXR:Client:OnPlayerLoaded',
            playerUnload    = 'LXR:Client:OnPlayerUnload',
            jobUpdate       = 'LXR:Client:OnJobUpdate',
            setJob          = 'LXR:Server:SetJob',
        },
        notifications = {
            type = 'lxr', -- Uses LXR native notifications
        },
    },
    
    ['rsg-core'] = {
        resourceName = 'rsg-core',
        object       = 'RSGCore',
        events = {
            playerLoaded    = 'RSGCore:Client:OnPlayerLoaded',
            playerUnload    = 'RSGCore:Client:OnPlayerUnload',
            jobUpdate       = 'RSGCore:Client:OnJobUpdate',
            setJob          = 'RSGCore:Server:SetJob',
        },
        notifications = {
            type = 'rsg', -- Uses RSG native notifications
        },
    },
    
    ['vorp'] = {
        resourceName = 'vorp_core',
        object       = 'VORP',
        events = {
            playerLoaded    = 'vorp:SelectedCharacter',
            playerUnload    = 'vorp:PlayerForceRespawn',
            jobUpdate       = 'vorp:updateJob',
            setJob          = 'vorp:setJob',
        },
        notifications = {
            type = 'vorp', -- Uses VORP native notifications
        },
    },
    
    ['standalone'] = {
        resourceName = nil,
        object       = nil,
        events = {
            playerLoaded    = 'lxr-mdt:standalone:playerReady',
            playerUnload    = 'lxr-mdt:standalone:playerUnload',
            jobUpdate       = 'lxr-mdt:standalone:jobUpdate',
            setJob          = 'lxr-mdt:standalone:setJob',
        },
        notifications = {
            type = 'native', -- Uses native FiveM notifications
        },
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en' -- 'en' | 'ka' (Georgian) | 'es' | 'fr' | 'de'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.General = {
    -- Enable/Disable Features
    enableMedicalMDT    = true,   -- Medical MDT system
    enableLawMDT        = true,   -- Law enforcement MDT system
    enableDeathCerts    = true,   -- Death certificate system
    enablePrescriptions = true,   -- Prescription system
    enableWarrants      = true,   -- Warrant system
    enableBounties      = true,   -- Bounty system
    enableEvidenceLog   = true,   -- Evidence locker
    enableSupplyTrack   = true,   -- Supply tracking (medical/law)
    
    -- Access Methods
    enableCommand       = true,   -- /mdt command
    enableItems         = true,   -- Journal/book items
    enableTargets       = true,   -- Location-based terminals
    enableKeybind       = false,  -- Keybind access (disabled by default)
    
    -- Debug & Logging
    debug               = false,  -- Debug mode (verbose console logging)
    debugSQL            = false,  -- SQL query logging
    logActions          = true,   -- Log MDT actions to database
    logToDiscord        = false,  -- Send logs to Discord webhook
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ KEYS CONFIGURATION ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Keys = {
    -- Primary MDT Key (if keybind enabled)
    openMDT = 0x760A9C6F, -- [G] key hash
    
    -- UI Navigation
    closeUI = 0x156F7119, -- [Backspace/ESC]
    
    -- Description for clarity
    descriptions = {
        openMDT = 'Open MDT Terminal',
        closeUI = 'Close MDT Interface',
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ROLES / JOBS CONFIGURATION ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

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
    
    -- Minimum grades per job (optional - set to 0 for all grades)
    minGrades = {
        doctor  = 0,
        surgeon = 1,
        medic   = 0,
        nurse   = 0,
        sheriff = 0,
        deputy  = 0,
        marshal = 1,
    },
}

-- ════════════════════════════════════════════════════════════════════════════════
-- ██████╗ ███████╗██████╗ ███╗   ███╗██╗███████╗███╗   ███████╗██████╗ ███╗  ██╗███████╗
-- ██╔══██╗██╔════╝██╔══██╗████╗ ████║██║██╔════╝████╗ ████╔════╝██╔══██╗████╗  ██║██╔════╝
-- ██████╔╝█████╗  ██████╔╝██╔████╔██║██║███████╗██╔████╔██║█████╗██║  ██║██╔██╗ ██║███████╗
-- ██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██║╚════██║██║╚██╔╝██║╚════██║██║  ██║██║╚██╗██║╚════██║
-- ██║     ███████╗██║  ██║██║ ╚═╝ ██║██║███████║██║ ╚═╝ ██║███████║██████╔╝██║ ╚████║███████║
-- ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═══╝╚══════╝
-- ════════════════════════════════════════════════════════════════════════════════

Config.Permissions = {
    -- Medical MDT Permissions by Grade
    medical = {
        [0] = { -- Trainee/Nurse
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
        [1] = { -- Doctor
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
        [2] = { -- Surgeon/Chief
            viewRecords     = true,
            createRecords   = true,
            editRecords     = true,
            deleteRecords   = true,
            viewReports     = true,
            createReports   = true,
            prescribe       = true,
            deathCerts      = true,
            manageSupplies  = true,
        },
    },
    
    -- Law MDT Permissions by Grade
    law = {
        [0] = { -- Deputy
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
        [1] = { -- Sheriff
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
        [2] = { -- Marshal/Chief
            viewRecords     = true,
            createRecords   = true,
            editRecords     = true,
            deleteRecords   = true,
            viewWarrants    = true,
            issueWarrants   = true,
            arrest          = true,
            manageBounties  = true,
            viewEvidence    = true,
            manageEvidence  = true,
        },
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DATABASE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.DatabaseTables = {
    -- Table names (prefixed automatically)
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

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY & ANTI-ABUSE █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    -- Anti-Abuse
    enableCooldowns       = true,   -- Per-action cooldowns
    enableRateLimiting    = true,   -- Rate limit requests
    enableDistanceChecks  = true,   -- Validate player proximity for terminal access
    enableJobValidation   = true,   -- Always validate job server-side
    enableSuspicionLog    = true,   -- Log suspicious behavior
    
    -- Cooldowns (seconds)
    cooldowns = {
        openMDT         = 2,    -- Cooldown between MDT opens
        createReport    = 30,   -- Create report cooldown
        issueWarrant    = 15,   -- Issue warrant cooldown
        issueBounty     = 20,   -- Issue bounty cooldown
        prescribe       = 10,   -- Prescription cooldown
    },
    
    -- Rate Limits (actions per minute)
    rateLimits = {
        searchQueries   = 30,   -- Max searches per minute
        recordCreation  = 10,   -- Max records created per minute
        reportCreation  = 5,    -- Max reports created per minute
    },
    
    -- Distance Checks (if terminal-based access)
    maxTerminalDistance = 3.0,  -- Max distance from terminal to access
    
    -- Discord Webhook (optional logging)
    discordWebhook = '', -- Leave empty to disable
    discordLogActions = {
        warrants        = true,
        bounties        = true,
        arrests         = true,
        deathCerts      = true,
        suspiciousBehavior = true,
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PERFORMANCE OPTIMIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Performance = {
    -- Zero-Tick Architecture
    useThreads          = false,  -- No idle threads (event-driven only)
    
    -- Caching
    enableCache         = true,   -- Cache player records in memory
    cacheTTL            = 300,    -- Cache time-to-live (seconds)
    cachePlayerLimit    = 100,    -- Max cached player records
    
    -- Database Optimization
    batchInserts        = true,   -- Batch database inserts
    batchSize           = 50,     -- Records per batch
    queryTimeout        = 5000,   -- Query timeout (ms)
    
    -- Update Intervals (ms)
    playerDataUpdate    = 60000,  -- Update player data cache every 60s
    onlinePlayerCheck   = 30000,  -- Check online players every 30s
}

-- ════════════════════════════════════════════════════════════════════════════════
-- ██╗████████╗███████╗███╗   ███╗███████╗
-- ██║╚══██╔══╝██╔════╝████╗ ████║██╔════╝
-- ██║   ██║   █████╗  ██╔████╔██║███████╗
-- ██║   ██║   ██╔══╝  ██║╚██╔╝██║╚════██║
-- ██║   ██║   ███████╗██║ ╚═╝ ██║███████║
-- ╚═╝   ╚═╝   ╚══════╝╚═╝     ╚═╝╚══════╝
-- ════════════════════════════════════════════════════════════════════════════════
-- ITEMS CONFIGURATION
-- Items that can open MDT (journals, books, ledgers)
-- ════════════════════════════════════════════════════════════════════════════════

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

-- ════════════════════════════════════════════════════════════════════════════════
-- ████████╗ █████╗ ██████╗  ██████╗ ███████╗████████╗███████╗
-- ╚══██╔══╝██╔══██╗██╔══██╗██╔════╝ ██╔════╝╚══██╔══╝██╔════╝
--    ██║   ███████║██████╔╝██║  ███╗█████╗     ██║   ███████╗
--    ██║   ██╔══██║██╔══██╗██║   ██║██╔══╝     ██║   ╚════██║
--    ██║   ██║  ██║██║  ██║╚██████╔╝███████╗   ██║   ███████║
--    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝
-- ════════════════════════════════════════════════════════════════════════════════
-- TARGET/PROMPT LOCATIONS (Optional)
-- Physical terminal locations in the world
-- ════════════════════════════════════════════════════════════════════════════════

Config.Targets = {
    -- Medical MDT Terminals
    medical = {
        {
            coords = vector3(-281.85, 808.64, 119.39), -- Valentine Doctor
            heading = 0.0,
            label = 'Medical MDT Terminal',
            distance = 2.0,
        },
        {
            coords = vector3(2721.25, -1230.32, 50.37), -- Saint Denis Hospital
            heading = 0.0,
            label = 'Medical MDT Terminal',
            distance = 2.0,
        },
    },
    
    -- Law MDT Terminals
    law = {
        {
            coords = vector3(-275.47, 805.91, 119.38), -- Valentine Sheriff
            heading = 0.0,
            label = 'Law MDT Terminal',
            distance = 2.0,
        },
        {
            coords = vector3(2503.93, -1308.88, 49.25), -- Saint Denis Police
            heading = 0.0,
            label = 'Law MDT Terminal',
            distance = 2.0,
        },
    },
}

-- ════════════════════════════════════════════════════════════════════════════════
-- ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗  ██╗███████╗
-- ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
-- ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
-- ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
-- ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
-- ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
-- ════════════════════════════════════════════════════════════════════════════════

Config.Notifications = {
    -- Notification style per framework (set by bridge)
    style = 'auto', -- auto-detected
    
    -- Notification duration (ms)
    duration = 5000,
    
    -- Sound effects
    enableSounds = true,
    sounds = {
        open    = 'sounds/open.ogg',
        close   = 'sounds/close.ogg',
        success = 'sounds/success.ogg',
        error   = 'sounds/error.ogg',
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG SETTINGS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = {
    -- Advanced Debug Toggles
    printStartup        = true,   -- Print startup banner
    printFramework      = true,   -- Print detected framework
    printEvents         = false,  -- Print event triggers
    printDatabase       = false,  -- Print database queries
    printPermissions    = false,  -- Print permission checks
    printCache          = false,  -- Print cache operations
    printSecurity       = false,  -- Print security validations
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Startup boot banner (printed after framework detection)
if Config.Debug.printStartup then
    Citizen.CreateThread(function()
        Wait(1000) -- Delay to ensure other resources have loaded
        print([[
            
        ╔═══════════════════════════════════════════════════════════════════════════╗
        ║                                                                           ║
        ║   🐺 LXR-MDT - MEDICAL & LAW DATABASE TERMINAL                            ║
        ║                                                                           ║
        ║   Version:        1.0.0                                                   ║
        ║   Language:       ]] .. Config.Lang .. [[                                                       ║
        ║   Framework:      [Detecting...]                                          ║
        ║                                                                           ║
        ║   Medical MDT:    ]] .. (Config.General.enableMedicalMDT and '✓ ENABLED' or '✗ DISABLED') .. [[                                              ║
        ║   Law MDT:        ]] .. (Config.General.enableLawMDT and '✓ ENABLED' or '✗ DISABLED') .. [[                                              ║
        ║   Prescriptions:  ]] .. (Config.General.enablePrescriptions and '✓ ENABLED' or '✗ DISABLED') .. [[                                              ║
        ║   Warrants:       ]] .. (Config.General.enableWarrants and '✓ ENABLED' or '✗ DISABLED') .. [[                                              ║
        ║   Bounties:       ]] .. (Config.General.enableBounties and '✓ ENABLED' or '✗ DISABLED') .. [[                                              ║
        ║                                                                           ║
        ║   Medical Jobs:   ]] .. #Config.Jobs.medical .. [[ configured                                         ║
        ║   Law Jobs:       ]] .. #Config.Jobs.law .. [[ configured                                         ║
        ║                                                                           ║
        ║   Performance:    <0.03ms idle | Zero-tick architecture                  ║
        ║                                                                           ║
        ║   🐺 wolves.land | The Land of Wolves | Georgian RP Excellence           ║
        ║   Developer: iBoss21 / The Lux Empire                                     ║
        ║                                                                           ║
        ╚═══════════════════════════════════════════════════════════════════════════╝
            
        ]])
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- END OF CONFIGURATION
-- ════════════════════════════════════════════════════════════════════════════════
-- 🐺 wolves.land | The Land of Wolves | iBoss21
-- ════════════════════════════════════════════════════════════════════════════════
