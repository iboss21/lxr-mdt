--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - CLIENT MAIN
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

local MDTOpen = false
local CurrentMDTType = nil

-- Initialize
CreateThread(function()
    Wait(1000)
    Utils.DebugPrint('Client initialized')
end)

-- Open MDT
function OpenMDT(mdtType)
    if not Bridge.IsPlayerLoaded() then
        Bridge.Notify('You must be fully loaded to use MDT', 'error')
        return
    end
    
    local job = Bridge.GetJob()
    local jobType = Utils.GetJobType(job.name)
    
    if not jobType then
        Bridge.Notify('You do not have access to MDT', 'error')
        return
    end
    
    -- Use mdtType if provided, otherwise use job type
    mdtType = mdtType or jobType
    
    if mdtType ~= jobType then
        Bridge.Notify('You do not have access to this MDT type', 'error')
        return
    end
    
    MDTOpen = true
    CurrentMDTType = mdtType
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openMDT',
        mdtType = mdtType,
        jobData = job
    })
end

-- Close MDT
function CloseMDT()
    MDTOpen = false
    CurrentMDTType = nil
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeMDT'
    })
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    CloseMDT()
    cb('ok')
end)

RegisterNUICallback('searchPlayer', function(data, cb)
    TriggerServerEvent('lxr-mdt:server:searchPlayer', data)
    cb('ok')
end)

-- Exports
exports('OpenMDT', OpenMDT)
exports('CloseMDT', CloseMDT)
