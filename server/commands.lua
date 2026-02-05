--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - SERVER COMMANDS
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

-- MDT Command
RegisterCommand('mdt', function(source, args, rawCommand)
    local src = source
    local job = Bridge.GetPlayerJob(src)
    local jobType = Utils.GetJobType(job.name)
    
    if not jobType then
        TriggerClientEvent('Bridge:Notify', src, 'You do not have access to MDT', 'error')
        return
    end
    
    TriggerClientEvent('lxr-mdt:client:openMDT', src, jobType)
end, false)

-- Medical MDT Command
RegisterCommand('medmdt', function(source, args, rawCommand)
    local src = source
    local job = Bridge.GetPlayerJob(src)
    
    if not Utils.IsMedicalJob(job.name) then
        TriggerClientEvent('Bridge:Notify', src, 'You must be a medical professional', 'error')
        return
    end
    
    TriggerClientEvent('lxr-mdt:client:openMDT', src, 'medical')
end, false)

-- Law MDT Command
RegisterCommand('lawmdt', function(source, args, rawCommand)
    local src = source
    local job = Bridge.GetPlayerJob(src)
    
    if not Utils.IsLawJob(job.name) then
        TriggerClientEvent('Bridge:Notify', src, 'You must be law enforcement', 'error')
        return
    end
    
    TriggerClientEvent('lxr-mdt:client:openMDT', src, 'law')
end, false)
