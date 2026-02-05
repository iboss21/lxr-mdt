# 🐺 LXR-MDT - Security Guide

```
  ███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗
  ██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝
  ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝ 
  ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝  
  ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║   
  ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   
```

**🐺 wolves.land Production Resource**  
© 2026 iBoss21 / The Lux Empire

---

## 🛡️ Security Model

LXR-MDT implements a **server-authority security model**. The fundamental principle:

> **NEVER TRUST THE CLIENT**

All critical operations, validations, and state management happen **server-side only**.

---

## 🔒 Core Security Principles

### 1. Server Authority

**All critical operations validated server-side:**
- ✅ Job verification
- ✅ Permission checks
- ✅ Data validation
- ✅ State management
- ✅ Database operations

**Client is ONLY responsible for:**
- UI rendering
- Input collection
- Event triggering

### 2. Input Validation

**Every input is sanitized and validated:**

```lua
function Utils.SanitizeInput(input)
    -- Remove SQL injection attempts
    input = input:gsub("'", "''")
    input = input:gsub('"', '""')
    -- Remove HTML/script tags
    input = input:gsub('<[^>]+>', '')
    return Utils.Trim(input)
end
```

### 3. Permission System

**Grade-based access control:**
- Permissions checked server-side
- Job grade verified from framework
- Actions logged for audit trail

### 4. Anti-Abuse Mechanisms

**Multiple layers of protection:**
- Cooldown system
- Rate limiting
- Distance validation
- Suspicious behavior logging

---

## 🚫 Anti-Abuse Systems

### Cooldown System

Prevents spam and abuse by enforcing delays between actions.

```lua
Config.Security.cooldowns = {
    openMDT         = 2,    -- 2 seconds between opens
    createReport    = 30,   -- 30 seconds between reports
    issueWarrant    = 15,   -- 15 seconds between warrants
    issueBounty     = 20,   -- 20 seconds between bounties
    prescribe       = 10,   -- 10 seconds between prescriptions
}
```

**How it works:**
1. Server tracks last action timestamp per player
2. On new action, checks if cooldown expired
3. Rejects action if still in cooldown
4. Logs suspicious repeated attempts

**Implementation:**
```lua
function CheckCooldown(source, action)
    local identifier = Bridge.GetIdentifier(source)
    local key = identifier .. ':' .. action
    local cooldown = Config.Security.cooldowns[action]
    
    if Cooldowns[key] and (os.time() - Cooldowns[key]) < cooldown then
        return false  -- Still in cooldown
    end
    
    Cooldowns[key] = os.time()
    return true  -- Cooldown expired, allow action
end
```

### Rate Limiting

Prevents flooding by limiting actions per time period.

```lua
Config.Security.rateLimits = {
    searchQueries   = 30,   -- Max 30 searches per minute
    recordCreation  = 10,   -- Max 10 records per minute
    reportCreation  = 5,    -- Max 5 reports per minute
}
```

**How it works:**
1. Track action count per player per minute
2. Increment counter on each action
3. Reset counter after 60 seconds
4. Reject if limit exceeded

### Distance Validation

Ensures players are near terminals when using them.

```lua
Config.Security.maxTerminalDistance = 3.0  -- 3 meters
```

**Server-side check:**
```lua
-- Get player coords (server-side)
local playerCoords = GetEntityCoords(GetPlayerPed(source))
-- Get terminal coords
local terminalCoords = vector3(x, y, z)
-- Calculate distance
local distance = #(playerCoords - terminalCoords)
-- Validate
if distance > Config.Security.maxTerminalDistance then
    -- REJECTED: Player too far from terminal
    LogSuspiciousBehavior(source, 'Distance check failed')
    return false
end
```

---

## 📋 Permission Validation

### Permission Checking Flow

1. **Client requests action**
   ```lua
   TriggerServerEvent('lxr-mdt:server:createReport', data)
   ```

2. **Server validates player**
   ```lua
   if not ValidatePlayer(source) then
       return  -- Invalid player
   end
   ```

3. **Server checks cooldown**
   ```lua
   if not CheckCooldown(source, 'createReport') then
       Notify(source, 'Please wait before creating another report', 'error')
       return
   end
   ```

4. **Server gets job**
   ```lua
   local job = Bridge.GetPlayerJob(source)
   local jobType = Utils.GetJobType(job.name)
   ```

5. **Server checks permission**
   ```lua
   if not Utils.HasPermission(jobType, job.grade.level, 'createReports') then
       Notify(source, 'You do not have permission', 'error')
       LogSuspiciousBehavior(source, 'Attempted unauthorized action')
       return
   end
   ```

6. **Server processes action**
   ```lua
   -- Safe to proceed
   DBOperations.CreateReport(data)
   ```

---

## 🔍 Suspicious Behavior Detection

### What's Logged as Suspicious

- Failed permission checks
- Cooldown violations (repeated attempts)
- Distance check failures
- Invalid data submissions
- SQL injection attempts
- Unusual access patterns

### Logging Implementation

```lua
function LogSuspiciousBehavior(source, reason, details)
    if not Config.Security.enableSuspicionLog then return end
    
    local identifier = Bridge.GetIdentifier(source)
    local playerName = Bridge.GetPlayerName(source)
    
    -- Log to database
    MySQL.insert('INSERT INTO mdt_logs (log_type, action, actor_name, actor_citizenid, details) VALUES (?, ?, ?, ?, ?)', {
        'security',
        reason,
        playerName,
        identifier,
        json.encode(details or {})
    })
    
    -- Optional: Discord webhook
    if Config.Security.logToDiscord and Config.Security.discordWebhook ~= '' then
        SendDiscordLog(source, reason, details)
    end
    
    -- Console warning
    Utils.ErrorPrint('Suspicious behavior from ' .. playerName .. ': ' .. reason)
end
```

---

## 🔗 SQL Injection Prevention

### Parameterized Queries

**NEVER concatenate user input into SQL:**

❌ **BAD:**
```lua
MySQL.query('SELECT * FROM mdt_players WHERE firstname = "' .. input .. '"')
```

✅ **GOOD:**
```lua
MySQL.query('SELECT * FROM mdt_players WHERE firstname = ?', {input})
```

### Input Sanitization

All user input sanitized before database operations:

```lua
local sanitized = Utils.SanitizeInput(userInput)
MySQL.query('SELECT * FROM mdt_players WHERE firstname = ?', {sanitized})
```

### oxmysql Protection

oxmysql provides built-in protection:
- Prepared statements
- Parameterized queries
- Automatic escaping

---

## 🚨 Discord Webhook Integration

### Setup

1. **Create Discord Webhook**
   - Go to Discord channel settings
   - Webhooks → Create Webhook
   - Copy webhook URL

2. **Configure in config.lua**
   ```lua
   Config.Security.discordWebhook = 'https://discord.com/api/webhooks/...'
   Config.Security.discordLogActions = {
       warrants        = true,
       bounties        = true,
       arrests         = true,
       deathCerts      = true,
       suspiciousBehavior = true,
   }
   ```

### What Gets Logged

- **Warrants** - Warrant issued, by whom, for whom
- **Bounties** - Bounty placed, amount, target
- **Arrests** - Arrest made, charges, officer
- **Death Certificates** - Death recorded, cause
- **Suspicious Behavior** - Security violations

### Example Webhook

```lua
function SendDiscordLog(source, action, details)
    local webhook = Config.Security.discordWebhook
    if webhook == '' then return end
    
    local identifier = Bridge.GetIdentifier(source)
    local playerName = Bridge.GetPlayerName(source)
    
    local embed = {
        {
            ['title'] = '🚨 MDT Security Alert',
            ['description'] = action,
            ['color'] = 16711680,  -- Red
            ['fields'] = {
                {name = 'Player', value = playerName, inline = true},
                {name = 'Citizen ID', value = identifier, inline = true},
                {name = 'Timestamp', value = os.date('%Y-%m-%d %H:%M:%S'), inline = true},
            },
            ['footer'] = {text = 'LXR-MDT Security | wolves.land'},
        }
    }
    
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({
        embeds = embed
    }), {['Content-Type'] = 'application/json'})
end
```

---

## 🧪 Security Testing

### Test These Scenarios

1. **Unauthorized Access**
   - Try accessing MDT without proper job
   - Expected: Access denied, logged

2. **Permission Violations**
   - Try actions without proper grade
   - Expected: Permission denied, logged

3. **Cooldown Bypass**
   - Spam actions rapidly
   - Expected: Rejected after cooldown limit

4. **Distance Checks**
   - Use terminal from far away
   - Expected: Rejected, distance violation logged

5. **SQL Injection Attempts**
   - Input: `'; DROP TABLE mdt_players; --`
   - Expected: Sanitized, no damage

6. **Invalid Data**
   - Submit malformed data
   - Expected: Validation failure, rejected

---

## 📊 Security Monitoring

### Database Logs

Check `mdt_logs` table for security events:

```sql
SELECT * FROM mdt_logs 
WHERE log_type = 'security' 
ORDER BY created_at DESC 
LIMIT 50;
```

### Console Monitoring

Enable security debug:
```lua
Config.Debug.printSecurity = true
```

Watch for:
- Permission denials
- Cooldown violations
- Distance failures
- Invalid requests

---

## 🛠️ Security Best Practices

### For Administrators

1. **Regular Audits**
   - Review `mdt_logs` weekly
   - Check for suspicious patterns
   - Investigate repeated violations

2. **Permission Management**
   - Grant minimum necessary permissions
   - Review grade assignments regularly
   - Adjust cooldowns if abused

3. **Monitor Performance**
   - Watch for DDoS attempts
   - Check rate limit violations
   - Monitor database query times

4. **Backup Data**
   - Regular database backups
   - Test restore procedures
   - Keep audit logs

### For Developers

1. **Never Trust Client**
   - Always validate server-side
   - Use server callbacks for data
   - Verify permissions server-side

2. **Sanitize All Input**
   - Use parameterized queries
   - Sanitize before database
   - Validate data types

3. **Log Suspicious Activity**
   - Log failed permission checks
   - Log unusual patterns
   - Include context in logs

4. **Test Security**
   - Try to bypass restrictions
   - Test with malicious input
   - Verify all validations work

---

## 🚫 What NOT to Do

❌ **Don't trust client events**
```lua
-- BAD: Client can spoof this
RegisterNetEvent('lxr-mdt:server:grantAccess')
AddEventHandler('lxr-mdt:server:grantAccess', function()
    -- Anyone can trigger this!
end)
```

❌ **Don't skip validation**
```lua
-- BAD: No validation
RegisterNetEvent('lxr-mdt:server:createReport')
AddEventHandler('lxr-mdt:server:createReport', function(data)
    -- Insert directly? Dangerous!
    MySQL.insert('INSERT INTO ...', {data.value})
end)
```

❌ **Don't store sensitive data client-side**
```lua
-- BAD: Client can see/modify this
local isAdmin = true  -- Client-side variable
```

❌ **Don't rely on client calculations**
```lua
-- BAD: Client calculated this
TriggerServerEvent('giveMoney', amount)  -- Client chose amount!
```

---

## ✅ Security Checklist

Before going live, verify:

- [ ] All server events validate player
- [ ] All actions check permissions
- [ ] All inputs are sanitized
- [ ] Cooldowns are enabled
- [ ] Rate limits are configured
- [ ] Distance checks work
- [ ] Suspicious behavior logs
- [ ] Discord webhook configured
- [ ] Database has audit trail
- [ ] Tested security scenarios
- [ ] Reviewed permission config
- [ ] Backup system in place

---

**🐺 wolves.land** | The Land of Wolves  
**Developer:** iBoss21 / The Lux Empire  
**License:** Proprietary - wolves.land Exclusive

**Remember: Security is not optional. It's essential.**
