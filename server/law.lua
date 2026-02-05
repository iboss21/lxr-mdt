--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - SERVER LAW MDT
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

-- Placeholder for law MDT server logic
-- Full implementation would include all law operations

RegisterNetEvent('lxr-mdt:server:getCriminalRecords', function(citizenid)
    local src = source
    if not ValidatePlayer(src) then return end
    
    local records = MySQL.query.await('SELECT * FROM mdt_criminal_records WHERE citizenid = ? ORDER BY created_at DESC', {citizenid})
    TriggerClientEvent('lxr-mdt:client:receiveCriminalRecords', src, records)
end)
