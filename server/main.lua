--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - SERVER MAIN
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

local MDT = {}
MDT.Cache = {}
MDT.Cooldowns = {}

-- Initialize on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    Utils.SuccessPrint('Server initialized')
    Utils.SuccessPrint('Framework: ' .. (Bridge.Framework or 'Unknown'))
    
    -- Initialize database tables check
    MySQL.ready(function()
        Utils.SuccessPrint('Database connection established')
    end)
end)

-- Player joined - create MDT record if doesn't exist
AddEventHandler('playerConnecting', function()
    local src = source
    Wait(1000) -- Wait for player to fully load
    
    local identifier = Bridge.GetIdentifier(src)
    if not identifier then return end
    
    local playerName = Bridge.GetPlayerName(src)
    
    -- Check if player exists in MDT
    MySQL.scalar('SELECT id FROM mdt_players WHERE citizenid = ?', {identifier}, function(exists)
        if not exists then
            -- Create new MDT player record
            local names = Utils.SplitString(playerName, ' ')
            MySQL.insert('INSERT INTO mdt_players (citizenid, firstname, lastname) VALUES (?, ?, ?)', {
                identifier,
                names[1] or 'John',
                names[2] or 'Doe'
            }, function(insertId)
                Utils.DebugPrint('Created MDT record for ' .. playerName)
            end)
        end
    end)
end)

-- Export functions for other resources
exports('GetPlayerMedicalRecords', function(citizenid)
    return MySQL.query.await('SELECT * FROM mdt_medical_records WHERE citizenid = ? ORDER BY created_at DESC', {citizenid})
end)

exports('GetPlayerCriminalRecords', function(citizenid)
    return MySQL.query.await('SELECT * FROM mdt_criminal_records WHERE citizenid = ? ORDER BY created_at DESC', {citizenid})
end)
