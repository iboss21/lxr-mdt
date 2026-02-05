# 🐺 LXR-MDT - Framework Support

```
  ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
  ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
  █████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
  ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
  ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
```

**🐺 wolves.land Production Resource**  
© 2026 iBoss21 / The Lux Empire

---

## 📋 Multi-Framework Architecture

LXR-MDT uses a **unified bridge/adapter pattern** to support multiple frameworks seamlessly.

### Supported Frameworks

| Framework | Support Level | Status |
|-----------|---------------|--------|
| **LXR-Core** | Primary | ✅ Full Support |
| **RSG-Core** | Primary | ✅ Full Support |
| **VORP Core** | Supported | ✅ Legacy Compatible |
| **Standalone** | Fallback | ✅ Basic Functionality |

---

## 🏗️ Architecture Overview

### Bridge Layer (`shared/bridge.lua`)

The bridge abstracts framework-specific calls into unified functions:

```lua
-- Unified API
Bridge.GetPlayerData()
Bridge.GetJob()
Bridge.Notify(msg, type)
Bridge.GetIdentifier(source)
Bridge.GetPlayerJob(source)
-- ... more functions
```

### How It Works

1. **Auto-Detection**
   - Checks for running framework resources
   - Priority: LXR-Core → RSG-Core → VORP → Standalone

2. **Framework Object**
   - Gets the framework's core object
   - Maps framework functions to unified API

3. **Unified Calls**
   - Core logic uses only Bridge functions
   - Bridge handles framework-specific implementation

---

## 🎯 LXR-Core Integration

### Detection

```lua
if GetResourceState('lxr-core') == 'started' then
    Bridge.Framework = 'lxr-core'
end
```

### Core Object

```lua
Bridge.FrameworkObject = exports['lxr-core']:GetCoreObject()
```

### Player Data Structure

```lua
PlayerData = {
    citizenid = 'ABC12345',
    charinfo = {
        firstname = 'John',
        lastname = 'Doe'
    },
    job = {
        name = 'doctor',
        label = 'Doctor',
        grade = {
            level = 1,
            name = 'Physician'
        }
    }
}
```

### Events

- `LXR:Client:OnPlayerLoaded` - Player spawned
- `LXR:Client:OnPlayerUnload` - Player logout
- `LXR:Client:OnJobUpdate` - Job changed

---

## 🎯 RSG-Core Integration

### Detection

```lua
if GetResourceState('rsg-core') == 'started' then
    Bridge.Framework = 'rsg-core'
end
```

### Core Object

```lua
Bridge.FrameworkObject = exports['rsg-core']:GetCoreObject()
```

### Player Data Structure

```lua
PlayerData = {
    citizenid = 'XYZ98765',
    charinfo = {
        firstname = 'Jane',
        lastname = 'Smith'
    },
    job = {
        name = 'sheriff',
        label = 'Sheriff',
        grade = {
            level = 2,
            name = 'Sheriff'
        }
    }
}
```

### Events

- `RSGCore:Client:OnPlayerLoaded` - Player spawned
- `RSGCore:Client:OnPlayerUnload` - Player logout
- `RSGCore:Client:OnJobUpdate` - Job changed

---

## 🎯 VORP Core Integration

### Detection

```lua
if GetResourceState('vorp_core') == 'started' then
    Bridge.Framework = 'vorp'
end
```

### Core Object

```lua
Bridge.FrameworkObject = exports.vorp_core:GetCore()
```

### Player Data Structure

```lua
PlayerData = {
    charIdentifier = 123,
    firstname = 'William',
    lastname = 'Turner',
    job = 'doctor',
    jobGrade = 1
}
```

### Events

- `vorp:SelectedCharacter` - Character selected
- `vorp:PlayerForceRespawn` - Player respawn
- `vorp:updateJob` - Job update

### Notes

VORP has a different structure than LXR/RSG. The bridge normalizes:
- Character ID format
- Job structure (job/jobGrade → job.name/job.grade.level)
- Event naming patterns

---

## 🎯 Standalone Mode

### When Standalone Activates

- No framework resource detected
- Manual selection: `Config.Framework = 'standalone'`
- Framework detection failure

### Features

**Available:**
- ✅ Basic MDT functionality
- ✅ Native notifications
- ✅ Command access
- ✅ Mock job system (for testing)

**Limited:**
- ⚠️ No framework player data
- ⚠️ Basic permissions
- ⚠️ Manual job assignment

### Mock Job System

```lua
-- Standalone always returns mock job
Bridge.GetPlayerJob(source)
-- Returns: {name = 'doctor', grade = {level = 2}}
```

**Purpose:** Testing and development without full framework.

---

## 🔄 Framework Detection Process

### 1. Configuration Check

```lua
if Config.Framework ~= 'auto' then
    -- Use manual selection
    Bridge.Framework = Config.Framework
end
```

### 2. Auto-Detection (Priority Order)

```lua
local frameworks = {
    {name = 'lxr-core', resource = 'lxr-core'},
    {name = 'rsg-core', resource = 'rsg-core'},
    {name = 'vorp', resource = 'vorp_core'},
}

for _, fw in ipairs(frameworks) do
    if GetResourceState(fw.resource) == 'started' then
        Bridge.Framework = fw.name
        break
    end
end
```

### 3. Fallback

```lua
if not Bridge.Framework then
    Bridge.Framework = 'standalone'
end
```

### 4. Initialization

```lua
Bridge.InitializeFramework()
-- Gets framework object
-- Registers event handlers
-- Prints detection result
```

---

## 🎨 Unified API Reference

### Client-Side Functions

```lua
-- Get current player data
local playerData = Bridge.GetPlayerData()

-- Get player job
local job = Bridge.GetJob()
-- Returns: {name = 'doctor', grade = {level = 1}}

-- Show notification
Bridge.Notify('Message', 'info', 5000)
-- Types: 'info', 'success', 'error', 'warning'

-- Check if player loaded
if Bridge.IsPlayerLoaded() then
    -- Player is ready
end
```

### Server-Side Functions

```lua
-- Get player identifier
local citizenid = Bridge.GetIdentifier(source)

-- Get player job
local job = Bridge.GetPlayerJob(source)

-- Get player name
local name = Bridge.GetPlayerName(source)

-- Money operations
Bridge.AddMoney(source, 'cash', 100)
Bridge.RemoveMoney(source, 'cash', 50)

-- Item operations
local hasItem = Bridge.HasItem(source, 'doctor_book', 1)

-- Register callback
Bridge.RegisterCallback('callbackName', function(source, ...)
    -- Handle callback
end)
```

---

## ⚙️ Adding New Framework Support

Want to add support for another framework? Here's how:

### Step 1: Add Framework Config

```lua
Config.FrameworkSettings['new-framework'] = {
    resourceName = 'new-framework-resource',
    object       = 'NewFrameworkCore',
    events = {
        playerLoaded    = 'new:playerLoaded',
        playerUnload    = 'new:playerUnload',
        jobUpdate       = 'new:jobUpdate',
    },
    notifications = {
        type = 'new',
    },
}
```

### Step 2: Add Detection

```lua
{name = 'new-framework', resource = 'new-framework-resource'}
```

### Step 3: Implement Bridge Functions

In `shared/bridge.lua`, add framework-specific implementations for:
- `GetPlayerData()`
- `GetJob()`
- `Notify()`
- `GetIdentifier()`
- `GetPlayerJob()`
- etc.

### Step 4: Test Thoroughly

- Player loading
- Job detection
- Notifications
- Database operations
- Permission checks

---

## 🧪 Testing Framework Support

### Test Checklist

1. **Framework Detection**
   - [ ] Correct framework detected on startup
   - [ ] Manual selection works
   - [ ] Fallback to standalone works

2. **Player Loading**
   - [ ] Player data loads correctly
   - [ ] Job information accurate
   - [ ] Events fire properly

3. **MDT Access**
   - [ ] /mdt command works
   - [ ] Job validation works
   - [ ] Permission checks work

4. **Database Operations**
   - [ ] Player records created
   - [ ] Citizen ID correct format
   - [ ] Names properly extracted

5. **Notifications**
   - [ ] Framework notifications display
   - [ ] Fallback to native works

---

## 🚨 Common Issues

### Framework Not Detected

**Symptoms:**
- Standalone mode when framework running
- "Framework object not found" error

**Solutions:**
1. Check framework is started before lxr-mdt
2. Verify resource name matches config
3. Try manual framework selection
4. Check framework exports are available

### Wrong Player Data

**Symptoms:**
- Incorrect job
- Wrong player name
- Missing citizenid

**Solutions:**
1. Verify framework player data structure
2. Check bridge mapping functions
3. Ensure player is fully loaded
4. Review framework events

### Permission Issues

**Symptoms:**
- Can't access MDT despite correct job
- Permission denied errors

**Solutions:**
1. Check `Config.Jobs` includes your job
2. Verify job name matches framework
3. Check job grade level
4. Review `Config.Permissions`

---

## 📞 Support

### Framework-Specific Help

- **LXR-Core:** [LXR-Core Discord]
- **RSG-Core:** [RSG-Core Discord]
- **VORP:** [VORP Discord]
- **wolves.land:** [Our Discord](https://discord.gg/CrKcWdfd3A)

### Reporting Framework Issues

When reporting framework issues, include:
1. Framework name and version
2. Console output (errors)
3. Detected framework (from startup)
4. Steps to reproduce

---

**🐺 wolves.land** | The Land of Wolves  
**Developer:** iBoss21 / The Lux Empire  
**License:** Proprietary - wolves.land Exclusive
