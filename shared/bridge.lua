--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - FRAMEWORK BRIDGE / ADAPTER LAYER
  ═══════════════════════════════════════════════════════════════════════════════════
  
  PURPOSE:
  Unified framework adapter that abstracts framework-specific calls.
  Core gameplay logic calls only unified Bridge functions.
  This layer maps those calls to the correct framework exports/events/callbacks.
  
  SUPPORTED FRAMEWORKS:
  ✓ LXR-Core (Primary)
  ✓ RSG-Core (Primary)
  ✓ VORP Core (Supported)
  ○ Standalone (Fallback)
  
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

-- ════════════════════════════════════════════════════════════════════════════════
-- GLOBAL BRIDGE TABLE
-- ════════════════════════════════════════════════════════════════════════════════

Bridge = {}
Bridge.Framework = nil
Bridge.FrameworkObject = nil
Bridge.PlayerData = {}
Bridge.PlayerLoaded = false

-- ════════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK AUTO-DETECTION
-- ════════════════════════════════════════════════════════════════════════════════

function Bridge.DetectFramework()
    if Config.Framework ~= 'auto' then
        -- Manual framework selection
        Bridge.Framework = Config.Framework
        if Config.Debug.printFramework then
            print('^3[LXR-MDT]^7 Manual framework mode: ' .. Bridge.Framework)
        end
        return Bridge.Framework
    end
    
    -- Auto-detect framework (priority order: LXR > RSG > VORP > Standalone)
    local frameworks = {
        {name = 'lxr-core', resource = 'lxr-core'},
        {name = 'rsg-core', resource = 'rsg-core'},
        {name = 'vorp', resource = 'vorp_core'},
    }
    
    for _, fw in ipairs(frameworks) do
        if GetResourceState(fw.resource) == 'started' then
            Bridge.Framework = fw.name
            if Config.Debug.printFramework then
                print('^2[LXR-MDT]^7 Framework detected: ' .. Bridge.Framework)
            end
            return Bridge.Framework
        end
    end
    
    -- Fallback to standalone
    Bridge.Framework = 'standalone'
    if Config.Debug.printFramework then
        print('^3[LXR-MDT]^7 No framework detected. Running in standalone mode.')
    end
    return Bridge.Framework
end

-- ════════════════════════════════════════════════════════════════════════════════
-- INITIALIZE FRAMEWORK OBJECT
-- ════════════════════════════════════════════════════════════════════════════════

function Bridge.InitializeFramework()
    local fw = Bridge.Framework
    local settings = Config.FrameworkSettings[fw]
    
    if not settings then
        if Config.Debug.printFramework then
            print('^1[LXR-MDT ERROR]^7 No settings found for framework: ' .. fw)
        end
        return false
    end
    
    if fw == 'standalone' then
        Bridge.FrameworkObject = nil
        return true
    end
    
    -- Get framework object
    if fw == 'lxr-core' then
        Bridge.FrameworkObject = exports['lxr-core']:GetCoreObject()
    elseif fw == 'rsg-core' then
        Bridge.FrameworkObject = exports['rsg-core']:GetCoreObject()
    elseif fw == 'vorp' then
        Bridge.FrameworkObject = exports.vorp_core:GetCore()
    end
    
    if Bridge.FrameworkObject then
        if Config.Debug.printFramework then
            print('^2[LXR-MDT]^7 Framework object initialized: ' .. fw)
        end
        return true
    else
        if Config.Debug.printFramework then
            print('^1[LXR-MDT ERROR]^7 Failed to get framework object for: ' .. fw)
        end
        return false
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- CLIENT-SIDE UNIFIED FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 0 then -- Client-side only
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- GET PLAYER DATA
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.GetPlayerData()
        local fw = Bridge.Framework
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            return Bridge.FrameworkObject.Functions.GetPlayerData()
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            return Bridge.FrameworkObject.Functions.GetPlayerData()
        elseif fw == 'vorp' and Bridge.FrameworkObject then
            return Bridge.FrameworkObject.User.getUser()
        elseif fw == 'standalone' then
            return Bridge.PlayerData or {}
        end
        
        return {}
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- GET PLAYER JOB
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.GetJob()
        local playerData = Bridge.GetPlayerData()
        local fw = Bridge.Framework
        
        if fw == 'lxr-core' or fw == 'rsg-core' then
            return playerData.job or {name = 'unemployed', grade = {level = 0}}
        elseif fw == 'vorp' then
            return {name = playerData.job or 'unemployed', grade = {level = playerData.jobGrade or 0}}
        elseif fw == 'standalone' then
            return Bridge.PlayerData.job or {name = 'unemployed', grade = {level = 0}}
        end
        
        return {name = 'unemployed', grade = {level = 0}}
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- SHOW NOTIFICATION
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.Notify(msg, type, duration)
        local fw = Bridge.Framework
        duration = duration or Config.Notifications.duration
        type = type or 'info'
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            Bridge.FrameworkObject.Functions.Notify(msg, type, duration)
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            Bridge.FrameworkObject.Functions.Notify(msg, type, duration)
        elseif fw == 'vorp' and Bridge.FrameworkObject then
            Bridge.FrameworkObject.NotifyTip(msg, duration)
        else
            -- Native notification fallback
            local dict = 'PLAYER_RESPAWN'
            local text = 'RESPAWN_PRESS'
            TriggerEvent('chat:addMessage', {
                color = type == 'error' and {255, 0, 0} or type == 'success' and {0, 255, 0} or {255, 255, 255},
                multiline = true,
                args = {'[LXR-MDT]', msg}
            })
        end
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- IS PLAYER LOADED
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.IsPlayerLoaded()
        return Bridge.PlayerLoaded
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- PLAYER LOADED EVENT HANDLER
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.RegisterPlayerLoadedEvent()
        local fw = Bridge.Framework
        local settings = Config.FrameworkSettings[fw]
        
        if not settings then return end
        
        RegisterNetEvent(settings.events.playerLoaded, function()
            Bridge.PlayerLoaded = true
            Bridge.PlayerData = Bridge.GetPlayerData()
            if Config.Debug.printEvents then
                print('^2[LXR-MDT]^7 Player loaded')
            end
        end)
        
        RegisterNetEvent(settings.events.playerUnload, function()
            Bridge.PlayerLoaded = false
            Bridge.PlayerData = {}
            if Config.Debug.printEvents then
                print('^3[LXR-MDT]^7 Player unloaded')
            end
        end)
        
        RegisterNetEvent(settings.events.jobUpdate, function(job)
            Bridge.PlayerData.job = job
            if Config.Debug.printEvents then
                print('^2[LXR-MDT]^7 Job updated: ' .. job.name)
            end
        end)
    end
    
end

-- ════════════════════════════════════════════════════════════════════════════════
-- SERVER-SIDE UNIFIED FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 1 then -- Server-side only
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- GET PLAYER IDENTIFIER
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.GetIdentifier(source)
        local fw = Bridge.Framework
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            return player and player.PlayerData.citizenid or nil
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            return player and player.PlayerData.citizenid or nil
        elseif fw == 'vorp' and Bridge.FrameworkObject then
            local user = Bridge.FrameworkObject.getUser(source)
            return user and tostring(user.getUsedCharacter.charIdentifier) or nil
        elseif fw == 'standalone' then
            -- Fallback to license
            for _, id in ipairs(GetPlayerIdentifiers(source)) do
                if string.match(id, 'license:') then
                    return id
                end
            end
        end
        
        return nil
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- GET PLAYER JOB (SERVER)
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.GetPlayerJob(source)
        local fw = Bridge.Framework
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            return player and player.PlayerData.job or {name = 'unemployed', grade = {level = 0}}
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            return player and player.PlayerData.job or {name = 'unemployed', grade = {level = 0}}
        elseif fw == 'vorp' and Bridge.FrameworkObject then
            local user = Bridge.FrameworkObject.getUser(source)
            if user then
                local char = user.getUsedCharacter
                return {name = char.job or 'unemployed', grade = {level = char.jobGrade or 0}}
            end
        elseif fw == 'standalone' then
            -- Standalone fallback - always allow for testing
            return {name = 'doctor', grade = {level = 2}} -- Mock job for testing
        end
        
        return {name = 'unemployed', grade = {level = 0}}
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- GET PLAYER NAME
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.GetPlayerName(source)
        local fw = Bridge.Framework
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            if player then
                return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
            end
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            if player then
                return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
            end
        elseif fw == 'vorp' and Bridge.FrameworkObject then
            local user = Bridge.FrameworkObject.getUser(source)
            if user then
                local char = user.getUsedCharacter
                return char.firstname .. ' ' .. char.lastname
            end
        elseif fw == 'standalone' then
            return GetPlayerName(source)
        end
        
        return GetPlayerName(source)
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- ADD MONEY
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.AddMoney(source, account, amount)
        local fw = Bridge.Framework
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            if player then
                player.Functions.AddMoney(account, amount)
                return true
            end
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            if player then
                player.Functions.AddMoney(account, amount)
                return true
            end
        elseif fw == 'vorp' and Bridge.FrameworkObject then
            local user = Bridge.FrameworkObject.getUser(source)
            if user then
                user.addCurrency(account == 'cash' and 0 or 1, amount)
                return true
            end
        end
        
        return false
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- REMOVE MONEY
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.RemoveMoney(source, account, amount)
        local fw = Bridge.Framework
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            if player then
                player.Functions.RemoveMoney(account, amount)
                return true
            end
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            if player then
                player.Functions.RemoveMoney(account, amount)
                return true
            end
        elseif fw == 'vorp' and Bridge.FrameworkObject then
            local user = Bridge.FrameworkObject.getUser(source)
            if user then
                user.removeCurrency(account == 'cash' and 0 or 1, amount)
                return true
            end
        end
        
        return false
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- HAS ITEM
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.HasItem(source, item, amount)
        local fw = Bridge.Framework
        amount = amount or 1
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            if player then
                local playerItem = player.Functions.GetItemByName(item)
                return playerItem and playerItem.amount >= amount or false
            end
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            local player = Bridge.FrameworkObject.Functions.GetPlayer(source)
            if player then
                local playerItem = player.Functions.GetItemByName(item)
                return playerItem and playerItem.amount >= amount or false
            end
        elseif fw == 'vorp' then
            -- VORP inventory check would go here
            return true -- Placeholder
        end
        
        return false
    end
    
    -- ════════════════════════════════════════════════════════════════════════════
    -- REGISTER CALLBACK
    -- ════════════════════════════════════════════════════════════════════════════
    
    function Bridge.RegisterCallback(name, cb)
        local fw = Bridge.Framework
        
        if fw == 'lxr-core' and Bridge.FrameworkObject then
            Bridge.FrameworkObject.Functions.CreateCallback(name, cb)
        elseif fw == 'rsg-core' and Bridge.FrameworkObject then
            Bridge.FrameworkObject.Functions.CreateCallback(name, cb)
        elseif fw == 'vorp' and Bridge.FrameworkObject then
            Bridge.FrameworkObject.Callback.Register(name, cb)
        else
            -- Standalone callback system
            RegisterNetEvent('lxr-mdt:server:callback:' .. name, function(...)
                local src = source
                local result = cb(src, ...)
                TriggerClientEvent('lxr-mdt:client:callback:' .. name, src, result)
            end)
        end
    end
    
end

-- ════════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════

Citizen.CreateThread(function()
    Bridge.DetectFramework()
    Bridge.InitializeFramework()
    
    -- Client-side event registration
    if IsDuplicityVersion() == 0 then
        Bridge.RegisterPlayerLoadedEvent()
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- END OF BRIDGE
-- ════════════════════════════════════════════════════════════════════════════════
-- 🐺 wolves.land | Multi-Framework Unified Bridge | iBoss21
-- ════════════════════════════════════════════════════════════════════════════════
