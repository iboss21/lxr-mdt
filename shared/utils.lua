--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - SHARED UTILITIES
  ═══════════════════════════════════════════════════════════════════════════════════
  
  PURPOSE:
  Shared utility functions used across client and server.
  Helper functions for common operations, formatting, validation, and data manipulation.
  
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

Utils = {}

-- ════════════════════════════════════════════════════════════════════════════════
-- STRING UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.Trim(str)
    if not str then return '' end
    return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

function Utils.Capitalize(str)
    if not str then return '' end
    return (str:gsub("^%l", string.upper))
end

function Utils.TitleCase(str)
    if not str then return '' end
    return str:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper()..rest:lower()
    end)
end

function Utils.SplitString(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-- ════════════════════════════════════════════════════════════════════════════════
-- TABLE UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.TableContains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

function Utils.TableMerge(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

function Utils.TableCopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[Utils.TableCopy(k, s)] = Utils.TableCopy(v, s) end
    return res
end

function Utils.TableCount(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

-- ════════════════════════════════════════════════════════════════════════════════
-- DATE/TIME UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.GetTimestamp()
    return os.time()
end

function Utils.FormatDate(timestamp)
    if not timestamp then timestamp = os.time() end
    return os.date('%Y-%m-%d %H:%M:%S', timestamp)
end

function Utils.FormatDateShort(timestamp)
    if not timestamp then timestamp = os.time() end
    return os.date('%Y-%m-%d', timestamp)
end

function Utils.FormatTime(timestamp)
    if not timestamp then timestamp = os.time() end
    return os.date('%H:%M:%S', timestamp)
end

function Utils.GetTimeDifference(timestamp)
    local diff = os.time() - timestamp
    local days = math.floor(diff / 86400)
    local hours = math.floor((diff % 86400) / 3600)
    local minutes = math.floor((diff % 3600) / 60)
    
    if days > 0 then
        return days .. ' day' .. (days > 1 and 's' or '') .. ' ago'
    elseif hours > 0 then
        return hours .. ' hour' .. (hours > 1 and 's' or '') .. ' ago'
    elseif minutes > 0 then
        return minutes .. ' minute' .. (minutes > 1 and 's' or '') .. ' ago'
    else
        return 'Just now'
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- NUMBER UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.Round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

function Utils.FormatNumber(num)
    local formatted = tostring(num)
    local k
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function Utils.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- ════════════════════════════════════════════════════════════════════════════════
-- VALIDATION UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.IsValidString(str, minLength, maxLength)
    if type(str) ~= 'string' then return false end
    local len = string.len(str)
    if minLength and len < minLength then return false end
    if maxLength and len > maxLength then return false end
    return true
end

function Utils.IsValidNumber(num, min, max)
    if type(num) ~= 'number' then return false end
    if min and num < min then return false end
    if max and num > max then return false end
    return true
end

function Utils.IsValidTable(tbl)
    return type(tbl) == 'table' and next(tbl) ~= nil
end

function Utils.SanitizeInput(input)
    if type(input) ~= 'string' then return '' end
    -- Remove HTML/script tags and dangerous characters
    -- Note: This is a secondary defense layer. Primary protection is parameterized queries.
    input = input:gsub('<[^>]+>', '')  -- Remove HTML tags
    input = input:gsub('[<>]', '')     -- Remove angle brackets
    return Utils.Trim(input)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- DISTANCE UTILITIES (Client-side)
-- ════════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 0 then
    function Utils.GetDistance(coords1, coords2)
        if type(coords1) == 'table' then
            coords1 = vector3(coords1.x, coords1.y, coords1.z)
        end
        if type(coords2) == 'table' then
            coords2 = vector3(coords2.x, coords2.y, coords2.z)
        end
        return #(coords1 - coords2)
    end
    
    function Utils.GetPlayerCoords()
        return GetEntityCoords(PlayerPedId())
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- JOB UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.IsMedicalJob(jobName)
    return Utils.TableContains(Config.Jobs.medical, jobName)
end

function Utils.IsLawJob(jobName)
    return Utils.TableContains(Config.Jobs.law, jobName)
end

function Utils.HasMinimumGrade(jobName, grade)
    local minGrade = Config.Jobs.minGrades[jobName] or 0
    return grade >= minGrade
end

function Utils.GetJobType(jobName)
    if Utils.IsMedicalJob(jobName) then
        return 'medical'
    elseif Utils.IsLawJob(jobName) then
        return 'law'
    end
    return nil
end

-- ════════════════════════════════════════════════════════════════════════════════
-- PERMISSION UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.HasPermission(jobType, grade, permission)
    if not jobType or not grade or not permission then return false end
    
    local permissions = Config.Permissions[jobType]
    if not permissions then return false end
    
    local gradePerms = permissions[grade]
    if not gradePerms then
        -- Try to find closest lower grade
        for i = grade, 0, -1 do
            if permissions[i] then
                gradePerms = permissions[i]
                break
            end
        end
    end
    
    if not gradePerms then return false end
    return gradePerms[permission] == true
end

-- ════════════════════════════════════════════════════════════════════════════════
-- SEARCH UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.SearchTable(tbl, searchTerm, fields)
    if not searchTerm or searchTerm == '' then return tbl end
    
    searchTerm = string.lower(searchTerm)
    local results = {}
    
    for _, item in pairs(tbl) do
        for _, field in pairs(fields) do
            local value = item[field]
            if value and string.find(string.lower(tostring(value)), searchTerm, 1, true) then
                table.insert(results, item)
                break
            end
        end
    end
    
    return results
end

-- ════════════════════════════════════════════════════════════════════════════════
-- RANDOM UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.GenerateID(length)
    length = length or 10
    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = ''
    for i = 1, length do
        local rand = math.random(1, #charset)
        result = result .. charset:sub(rand, rand)
    end
    return result
end

function Utils.GenerateUUID()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- DEBUG UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.DebugPrint(...)
    if Config.General.debug then
        print('^3[LXR-MDT DEBUG]^7', ...)
    end
end

function Utils.ErrorPrint(...)
    print('^1[LXR-MDT ERROR]^7', ...)
end

function Utils.SuccessPrint(...)
    print('^2[LXR-MDT SUCCESS]^7', ...)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- COLOR UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════

function Utils.HexToRGB(hex)
    hex = hex:gsub("#","")
    return {
        r = tonumber("0x"..hex:sub(1,2)),
        g = tonumber("0x"..hex:sub(3,4)),
        b = tonumber("0x"..hex:sub(5,6))
    }
end

function Utils.RGBToHex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- END OF UTILITIES
-- ════════════════════════════════════════════════════════════════════════════════
-- 🐺 wolves.land | Shared Utility Functions | iBoss21
-- ════════════════════════════════════════════════════════════════════════════════
