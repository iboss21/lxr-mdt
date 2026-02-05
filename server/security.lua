--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - SERVER SECURITY
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

local Cooldowns = {}
local RateLimits = {}

function ValidatePlayer(source)
    if not source or source == 0 then return false end
    local identifier = Bridge.GetIdentifier(source)
    return identifier ~= nil
end

function CheckCooldown(source, action)
    if not Config.Security.enableCooldowns then return true end
    
    local identifier = Bridge.GetIdentifier(source)
    if not identifier then return false end
    
    local key = identifier .. ':' .. action
    local cooldown = Config.Security.cooldowns[action]
    
    if not cooldown then return true end
    
    if Cooldowns[key] and (os.time() - Cooldowns[key]) < cooldown then
        return false
    end
    
    Cooldowns[key] = os.time()
    return true
end

exports('ValidatePlayer', ValidatePlayer)
exports('CheckCooldown', CheckCooldown)
