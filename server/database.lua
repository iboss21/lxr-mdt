--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - SERVER DATABASE OPERATIONS
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

DBOperations = {}

function DBOperations.GetPlayerInfo(citizenid)
    return MySQL.query.await('SELECT * FROM mdt_players WHERE citizenid = ?', {citizenid})
end

function DBOperations.SearchPlayers(searchTerm)
    local query = '%' .. searchTerm .. '%'
    return MySQL.query.await('SELECT * FROM mdt_players WHERE firstname LIKE ? OR lastname LIKE ? OR citizenid LIKE ? LIMIT 50', {query, query, query})
end

function DBOperations.CreateMedicalRecord(data)
    return MySQL.insert.await('INSERT INTO mdt_medical_records (citizenid, record_type, diagnosis, description, severity, doctor_name, doctor_citizenid) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        data.citizenid, data.record_type, data.diagnosis, data.description, data.severity, data.doctor_name, data.doctor_citizenid
    })
end

function DBOperations.CreateArrestRecord(data)
    return MySQL.insert.await('INSERT INTO mdt_arrests (citizenid, crimes, description, fine, jail_time, arresting_officer, officer_citizenid) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        data.citizenid, json.encode(data.crimes), data.description, data.fine, data.jail_time, data.officer_name, data.officer_citizenid
    })
end

exports('GetPlayerInfo', DBOperations.GetPlayerInfo)
exports('SearchPlayers', DBOperations.SearchPlayers)
