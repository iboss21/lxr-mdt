# 🐺 LXR-MDT - Events & API Reference

```
  ███████╗██╗  ██╗███╗   ███╗ █████╗ ███╗   ██╗██╗███████╗███████╗███████╗████████╗
  ██╔════╝╚██╗██╔╝████╗ ████║██╔══██╗████╗  ██║██║██╔════╝██╔════╝██╔════╝╚══██╔══╝
  █████╗   ╚███╔╝ ██╔████╔██║███████║██╔██╗ ██║██║█████╗  █████╗  ███████╗   ██║   
  ██╔══╝   ██╔██╗ ██║╚██╔╝██║██╔══██║██║╚██╗██║██║██╔══╝  ██╔══╝  ╚════██║   ██║   
  ██║     ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║██║ ╚████║██║██║     ███████╗███████║   ██║   
  ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   
```

**🐺 wolves.land Production Resource**  
**Developer API & Event Reference**  
© 2026 iBoss21 / The Lux Empire

---

## 📋 Table of Contents

1. [Bridge API](#-bridge-api-unified-functions)
2. [Client Events](#-client-events)
3. [Server Events](#-server-events)
4. [Callbacks](#-callbacks)
5. [Framework-Specific Events](#-framework-specific-events)
6. [Integration Examples](#-integration-examples)

---

## 🌉 Bridge API (Unified Functions)

The Bridge layer provides a **unified API** that works across all supported frameworks. Core gameplay logic should **ONLY** use these functions, never framework-specific calls directly.

### Client-Side Bridge Functions

#### `Bridge.GetPlayerData()`
Get complete player data from the framework.

```lua
local playerData = Bridge.GetPlayerData()
print(playerData.citizenid)
print(playerData.charinfo.firstname)
```

**Returns:**
- `table` - Player data structure (varies by framework)

---

#### `Bridge.GetJob()`
Get player's current job information.

```lua
local job = Bridge.GetJob()
print(job.name)        -- Job name (e.g., "doctor", "sheriff")
print(job.grade.level) -- Job grade level (0-10)
```

**Returns:**
- `table` - Job data
  - `name` (string) - Job name
  - `grade` (table)
    - `level` (number) - Grade level

---

#### `Bridge.Notify(msg, type, duration)`
Show a notification to the player.

```lua
Bridge.Notify('Record saved successfully', 'success', 5000)
Bridge.Notify('Access denied', 'error')
```

**Parameters:**
- `msg` (string) - Notification message
- `type` (string, optional) - Type: 'success', 'error', 'info', 'warning' (default: 'info')
- `duration` (number, optional) - Duration in milliseconds (default: 5000)

---

#### `Bridge.IsPlayerLoaded()`
Check if the player is fully loaded in the framework.

```lua
if Bridge.IsPlayerLoaded() then
    -- Player is ready
    OpenMDT()
end
```

**Returns:**
- `boolean` - True if player is loaded and ready

---

### Server-Side Bridge Functions

#### `Bridge.GetIdentifier(source)`
Get player's unique identifier (citizenid/charIdentifier).

```lua
RegisterNetEvent('lxr-mdt:server:example', function()
    local src = source
    local identifier = Bridge.GetIdentifier(src)
    print('Player ID: ' .. identifier)
end)
```

**Parameters:**
- `source` (number) - Player server ID

**Returns:**
- `string` - Unique player identifier
- `nil` - If player not found or invalid

---

#### `Bridge.GetPlayerJob(source)`
Get player's job information (server-side).

```lua
local job = Bridge.GetPlayerJob(source)
if job.name == 'doctor' and job.grade.level >= 2 then
    -- Senior doctor
end
```

**Parameters:**
- `source` (number) - Player server ID

**Returns:**
- `table` - Job data
  - `name` (string) - Job name
  - `grade` (table)
    - `level` (number) - Grade level

---

#### `Bridge.GetPlayerName(source)`
Get player's full character name.

```lua
local name = Bridge.GetPlayerName(source)
print('Player name: ' .. name)
```

**Parameters:**
- `source` (number) - Player server ID

**Returns:**
- `string` - Full character name (e.g., "John Smith")

---

#### `Bridge.AddMoney(source, account, amount)`
Add money to player's account.

```lua
Bridge.AddMoney(source, 'cash', 100)
Bridge.AddMoney(source, 'bank', 500)
```

**Parameters:**
- `source` (number) - Player server ID
- `account` (string) - Account type: 'cash', 'bank'
- `amount` (number) - Amount to add

**Returns:**
- `boolean` - True if successful

---

#### `Bridge.RemoveMoney(source, account, amount)`
Remove money from player's account.

```lua
Bridge.RemoveMoney(source, 'cash', 50)
```

**Parameters:**
- `source` (number) - Player server ID
- `account` (string) - Account type: 'cash', 'bank'
- `amount` (number) - Amount to remove

**Returns:**
- `boolean` - True if successful

---

#### `Bridge.HasItem(source, item, amount)`
Check if player has a specific item.

```lua
if Bridge.HasItem(source, 'doctor_book', 1) then
    -- Player has medical journal
end
```

**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number, optional) - Required amount (default: 1)

**Returns:**
- `boolean` - True if player has the item

---

#### `Bridge.RegisterCallback(name, callback)`
Register a server-side callback.

```lua
Bridge.RegisterCallback('lxr-mdt:server:getRecords', function(source, citizenid)
    local records = GetRecordsFromDB(citizenid)
    return records
end)
```

**Parameters:**
- `name` (string) - Callback name
- `callback` (function) - Callback function
  - Receives: `source`, ...args
  - Returns: Any data

---

## 📡 Client Events

### Core Client Events

#### `lxr-mdt:client:openMDT`
Open the MDT interface.

**Trigger:**
```lua
TriggerEvent('lxr-mdt:client:openMDT', mdtType)
```

**Parameters:**
- `mdtType` (string, optional) - Type: 'medical', 'law', or nil (auto-detect)

**Example:**
```lua
-- Open auto-detected MDT
TriggerEvent('lxr-mdt:client:openMDT')

-- Force medical MDT
TriggerEvent('lxr-mdt:client:openMDT', 'medical')
```

---

#### `lxr-mdt:client:closeMDT`
Close the MDT interface.

**Trigger:**
```lua
TriggerEvent('lxr-mdt:client:closeMDT')
```

---

#### `lxr-mdt:client:receiveMedicalRecords`
Receive medical records from server.

**Triggered By Server:**
```lua
TriggerClientEvent('lxr-mdt:client:receiveMedicalRecords', source, records)
```

**Parameters:**
- `records` (table) - Array of medical record objects

---

#### `lxr-mdt:client:receiveCriminalRecords`
Receive criminal records from server.

**Triggered By Server:**
```lua
TriggerClientEvent('lxr-mdt:client:receiveCriminalRecords', source, records)
```

**Parameters:**
- `records` (table) - Array of criminal record objects

---

#### `lxr-mdt:client:refreshUI`
Refresh the MDT UI with new data.

**Trigger:**
```lua
TriggerEvent('lxr-mdt:client:refreshUI', data)
```

**Parameters:**
- `data` (table) - New data to display

---

## 🖥️ Server Events

### Core Server Events

#### `lxr-mdt:server:getMedicalRecords`
Request medical records for a citizen.

**Trigger:**
```lua
TriggerServerEvent('lxr-mdt:server:getMedicalRecords', citizenid)
```

**Parameters:**
- `citizenid` (string) - Citizen identifier

**Server Handler:**
```lua
RegisterNetEvent('lxr-mdt:server:getMedicalRecords', function(citizenid)
    local src = source
    if not ValidatePlayer(src) then return end
    
    local records = MySQL.query.await(
        'SELECT * FROM mdt_medical_records WHERE citizenid = ? ORDER BY created_at DESC',
        {citizenid}
    )
    
    TriggerClientEvent('lxr-mdt:client:receiveMedicalRecords', src, records)
end)
```

---

#### `lxr-mdt:server:createMedicalRecord`
Create a new medical record.

**Trigger:**
```lua
TriggerServerEvent('lxr-mdt:server:createMedicalRecord', data)
```

**Parameters:**
- `data` (table) - Record data
  - `citizenid` (string) - Patient ID
  - `doctorId` (string) - Doctor ID
  - `diagnosis` (string) - Medical diagnosis
  - `treatment` (string) - Treatment provided
  - `notes` (string, optional) - Additional notes

**Example:**
```lua
local recordData = {
    citizenid = 'ABC123',
    doctorId = 'DEF456',
    diagnosis = 'Gunshot wound',
    treatment = 'Surgery performed',
    notes = 'Patient stable'
}

TriggerServerEvent('lxr-mdt:server:createMedicalRecord', recordData)
```

---

#### `lxr-mdt:server:getCriminalRecords`
Request criminal records for a citizen.

**Trigger:**
```lua
TriggerServerEvent('lxr-mdt:server:getCriminalRecords', citizenid)
```

**Parameters:**
- `citizenid` (string) - Citizen identifier

---

#### `lxr-mdt:server:createArrestReport`
Create a new arrest report.

**Trigger:**
```lua
TriggerServerEvent('lxr-mdt:server:createArrestReport', data)
```

**Parameters:**
- `data` (table) - Arrest data
  - `citizenid` (string) - Suspect ID
  - `officerId` (string) - Arresting officer ID
  - `charges` (table) - Array of charge objects
  - `evidence` (string, optional) - Evidence description
  - `notes` (string, optional) - Additional notes

**Example:**
```lua
local arrestData = {
    citizenid = 'ABC123',
    officerId = 'OFF789',
    charges = {
        {charge = 'Murder', fine = 0, jailtime = 120},
        {charge = 'Assault', fine = 50, jailtime = 30}
    },
    evidence = 'Witness testimony, blood on clothes',
    notes = 'Suspect was armed'
}

TriggerServerEvent('lxr-mdt:server:createArrestReport', arrestData)
```

---

#### `lxr-mdt:server:issueWarrant`
Issue a warrant.

**Trigger:**
```lua
TriggerServerEvent('lxr-mdt:server:issueWarrant', data)
```

**Parameters:**
- `data` (table) - Warrant data
  - `citizenid` (string) - Target citizen ID
  - `type` (string) - Warrant type: 'arrest', 'search', 'execution', 'bounty'
  - `reason` (string) - Reason for warrant
  - `amount` (number, optional) - Bounty amount (if type = 'bounty')
  - `expiresAt` (string, optional) - Expiration date (ISO format)

---

#### `lxr-mdt:server:searchPlayers`
Search for players by name or ID.

**Trigger:**
```lua
TriggerServerEvent('lxr-mdt:server:searchPlayers', searchTerm, callback)
```

**Parameters:**
- `searchTerm` (string) - Search query
- `callback` (function) - Callback to receive results

**Example:**
```lua
local function OnSearchComplete(results)
    for _, player in ipairs(results) do
        print(player.firstname .. ' ' .. player.lastname)
    end
end

TriggerServerEvent('lxr-mdt:server:searchPlayers', 'John', OnSearchComplete)
```

---

## 🔄 Callbacks

### Server Callbacks

#### `lxr-mdt:server:getPlayerInfo`
Get complete player information.

**Client Usage:**
```lua
-- Using framework callback system
TriggerCallback('lxr-mdt:server:getPlayerInfo', function(info)
    print('Player: ' .. info.firstname .. ' ' .. info.lastname)
    print('Job: ' .. info.job)
end, citizenid)
```

**Server Registration:**
```lua
Bridge.RegisterCallback('lxr-mdt:server:getPlayerInfo', function(source, citizenid)
    local info = MySQL.query.await(
        'SELECT * FROM mdt_players WHERE citizenid = ?',
        {citizenid}
    )
    return info[1]
end)
```

---

#### `lxr-mdt:server:validateAccess`
Validate if player has access to specific MDT type.

**Returns:**
- `boolean` - True if player has access
- `string` - MDT type: 'medical', 'law', or 'none'

---

## 🔧 Framework-Specific Events

### LXR-Core Events

```lua
-- Player loaded
RegisterNetEvent('LXR:Client:OnPlayerLoaded', function()
    Bridge.PlayerLoaded = true
    Bridge.PlayerData = Bridge.GetPlayerData()
end)

-- Job updated
RegisterNetEvent('LXR:Client:OnJobUpdate', function(job)
    Bridge.PlayerData.job = job
end)
```

### RSG-Core Events

```lua
-- Player loaded
RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    Bridge.PlayerLoaded = true
    Bridge.PlayerData = Bridge.GetPlayerData()
end)

-- Job updated
RegisterNetEvent('RSGCore:Client:OnJobUpdate', function(job)
    Bridge.PlayerData.job = job
end)
```

### VORP Core Events

```lua
-- Character selected
RegisterNetEvent('vorp:SelectedCharacter', function(charid)
    Bridge.PlayerLoaded = true
    Bridge.PlayerData = Bridge.GetPlayerData()
end)

-- Job updated
RegisterNetEvent('vorp:updateJob', function(job)
    Bridge.PlayerData.job = job
end)
```

---

## 🔌 Integration Examples

### Example 1: Opening MDT from Custom Item

**Client-Side:**
```lua
RegisterNetEvent('inventory:client:useItem', function(itemName)
    if itemName == 'doctor_book' then
        -- Check if player has medical job
        local job = Bridge.GetJob()
        if job.name == 'doctor' or job.name == 'surgeon' then
            TriggerEvent('lxr-mdt:client:openMDT', 'medical')
        else
            Bridge.Notify('You are not a medical professional', 'error')
        end
    end
end)
```

---

### Example 2: Creating Medical Record with Reward

**Server-Side:**
```lua
RegisterNetEvent('lxr-mdt:server:createMedicalRecord', function(data)
    local src = source
    
    -- Validate player
    if not ValidatePlayer(src) then return end
    
    -- Validate job
    local job = Bridge.GetPlayerJob(src)
    if not IsJobAllowed(job.name, 'medical') then
        TriggerClientEvent('lxr-mdt:client:notify', src, 'Access denied', 'error')
        return
    end
    
    -- Insert record
    local recordId = MySQL.insert.await([[
        INSERT INTO mdt_medical_records 
        (citizenid, doctor_id, diagnosis, treatment, notes, created_at)
        VALUES (?, ?, ?, ?, ?, NOW())
    ]], {
        data.citizenid,
        Bridge.GetIdentifier(src),
        data.diagnosis,
        data.treatment,
        data.notes or ''
    })
    
    if recordId then
        -- Reward doctor for documentation
        Bridge.AddMoney(src, 'cash', Config.Rewards.medicalRecord)
        
        -- Log action
        LogAction(src, 'medical_record_created', {
            recordId = recordId,
            patient = data.citizenid
        })
        
        -- Notify success
        TriggerClientEvent('lxr-mdt:client:notify', src, 'Record saved successfully', 'success')
    else
        TriggerClientEvent('lxr-mdt:client:notify', src, 'Failed to save record', 'error')
    end
end)
```

---

### Example 3: Target Interaction for Terminal

**Client-Side:**
```lua
-- Using rsg-target or ox_target
exports['rsg-target']:AddBoxZone('mdt_terminal_hospital', vector3(x, y, z), 2.0, 2.0, {
    name = 'mdt_terminal_hospital',
    heading = 0,
    debugPoly = false,
}, {
    options = {
        {
            type = 'client',
            event = 'lxr-mdt:client:useTerminal',
            icon = 'fas fa-book-medical',
            label = 'Access Medical Terminal',
            job = Config.Jobs.medical,
        }
    },
    distance = 2.5
})

-- Terminal usage
RegisterNetEvent('lxr-mdt:client:useTerminal', function()
    if Bridge.IsPlayerLoaded() then
        TriggerEvent('lxr-mdt:client:openMDT', 'medical')
    else
        Bridge.Notify('You are not ready yet', 'error')
    end
end)
```

---

### Example 4: Discord Webhook Logging

**Server-Side:**
```lua
function LogToDiscord(action, player, data)
    if not Config.General.logToDiscord then return end
    if not Config.Discord.webhookUrl then return end
    
    local embed = {
        {
            ['title'] = '🐺 MDT Action Log',
            ['description'] = action,
            ['color'] = 3447003,
            ['fields'] = {
                {
                    ['name'] = 'Player',
                    ['value'] = player.name,
                    ['inline'] = true
                },
                {
                    ['name'] = 'Job',
                    ['value'] = player.job,
                    ['inline'] = true
                },
                {
                    ['name'] = 'Details',
                    ['value'] = json.encode(data),
                    ['inline'] = false
                }
            },
            ['footer'] = {
                ['text'] = 'wolves.land | ' .. os.date('%Y-%m-%d %H:%M:%S')
            }
        }
    }
    
    PerformHttpRequest(Config.Discord.webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = 'LXR-MDT Logger',
        embeds = embed
    }), {['Content-Type'] = 'application/json'})
end

-- Usage in event handler
RegisterNetEvent('lxr-mdt:server:createArrestReport', function(data)
    local src = source
    -- ... validation and database insert ...
    
    -- Log to Discord
    LogToDiscord('Arrest Report Created', {
        name = Bridge.GetPlayerName(src),
        job = Bridge.GetPlayerJob(src).name
    }, {
        suspect = data.citizenid,
        charges = data.charges
    })
end)
```

---

### Example 5: Cross-Resource Communication

**From Another Resource:**
```lua
-- Trigger MDT to open for a specific player
TriggerClientEvent('lxr-mdt:client:openMDT', playerId, 'law')

-- Create a medical record from another resource
TriggerServerEvent('lxr-mdt:server:createMedicalRecord', {
    citizenid = patientId,
    doctorId = doctorId,
    diagnosis = 'Animal attack',
    treatment = 'Bandages applied',
    notes = 'Auto-generated from hunting script'
})

-- Check if player has access to MDT
exports['lxr-mdt']:HasMDTAccess(playerId, function(hasAccess, mdtType)
    if hasAccess then
        print('Player can access: ' .. mdtType)
    end
end)
```

---

## 📊 Data Structures

### Medical Record Object

```lua
{
    id = 123,
    citizenid = 'ABC123',
    doctor_id = 'DEF456',
    doctor_name = 'Dr. John Smith',
    diagnosis = 'Gunshot wound to chest',
    treatment = 'Emergency surgery performed',
    prescription = 'Morphine 10mg',
    notes = 'Patient stable, recommend 2 days rest',
    created_at = '2026-01-15 14:30:00',
    updated_at = '2026-01-15 14:30:00'
}
```

### Criminal Record Object

```lua
{
    id = 456,
    citizenid = 'ABC123',
    officer_id = 'OFF789',
    officer_name = 'Sheriff Jane Doe',
    charges = {
        {charge = 'Murder', fine = 0, jailtime = 120},
        {charge = 'Robbery', fine = 500, jailtime = 60}
    },
    totalFine = 500,
    totalJailTime = 180,
    evidence = 'Eyewitness testimony, murder weapon found',
    notes = 'Suspect showed no remorse',
    arrest_location = 'Valentine Saloon',
    created_at = '2026-01-15 20:15:00'
}
```

### Warrant Object

```lua
{
    id = 789,
    citizenid = 'ABC123',
    suspect_name = 'John Marston',
    type = 'arrest', -- 'arrest', 'search', 'execution', 'bounty'
    reason = 'Murder of Sheriff Deputy',
    issued_by = 'OFF789',
    issued_by_name = 'Sheriff Jane Doe',
    amount = 1000, -- Bounty amount (if applicable)
    status = 'active', -- 'active', 'executed', 'expired', 'cancelled'
    expires_at = '2026-02-15 00:00:00',
    created_at = '2026-01-15 21:00:00'
}
```

---

## 🛠️ Utility Functions

### Client Utils

```lua
-- Show progress bar (if supported)
Utils.ShowProgress(text, duration, callback)

-- Format date/time
Utils.FormatDate(timestamp)

-- Validate input
Utils.SanitizeInput(text)

-- Debug print
Utils.DebugPrint(message)
```

### Server Utils

```lua
-- Validate player
ValidatePlayer(source)

-- Check permission
HasPermission(source, mdtType)

-- Log action
LogAction(source, action, data)

-- Rate limit check
IsRateLimited(source, action)
```

---

## 🔒 Security Notes

1. **ALWAYS validate on server-side**
   - Never trust client-provided data
   - Check permissions before executing
   - Validate distances for terminal use

2. **Use callbacks for sensitive data**
   - Don't expose raw database queries to client
   - Return only necessary data
   - Filter results based on permissions

3. **Rate limiting**
   - Implement cooldowns on expensive operations
   - Track action frequency per player
   - Log suspicious behavior

4. **SQL injection prevention**
   - Use prepared statements
   - Never concatenate user input into queries
   - Sanitize all inputs

---

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🐺 LXR-MDT API Documentation                                            ║
║                                                                           ║
║   For full integration support, visit:                                    ║
║   📖 https://github.com/iBoss21/lxr-mdt                                   ║
║   💬 https://discord.gg/CrKcWdfd3A                                        ║
║                                                                           ║
║   Built with ❤️ for wolves.land by iBoss21 / The Lux Empire              ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```
