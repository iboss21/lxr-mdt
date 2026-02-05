--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - SERVER VERSION CHECKER
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

local CURRENT_VERSION = '1.0.0'
local GITHUB_REPO = 'iboss21/lxr-mdt'

CreateThread(function()
    Wait(5000)
    Utils.SuccessPrint('Version: ' .. CURRENT_VERSION)
    Utils.SuccessPrint('Repository: github.com/' .. GITHUB_REPO)
end)
