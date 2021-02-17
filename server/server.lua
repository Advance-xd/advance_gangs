ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('advance_gangs:creategang', function(source, callback, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = xPlayer.characterId
    print(name)
    MySQL.Async.fetchAll('SELECT gang FROM gangs2 WHERE gang = @gang', {['@gang'] = name}, function(result)
        if result[1] == nil then
            MySQL.Async.execute('INSERT INTO gangs2 (id, gang, boss) VALUES (@id, @gang, @boss)',
            {
                ['@id'] = player,
                ['@gang'] = name,
                ['@boss'] = 1
            })
            callback(true)
        else
            callback(false)
        end
        
    end)
end)

ESX.RegisterServerCallback('advance_gangs:getplayer', function(source, callback)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = xPlayer.characterId

    MySQL.Async.fetchAll('SELECT * FROM gangs2 WHERE ID = @ID', {['@ID'] = player}, function(result)
        callback(result)
    end)
    
end)

ESX.RegisterServerCallback('advance_gangs:getmembers', function(source, callback, gang)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = xPlayer.characterId
    local players = {}
    
    MySQL.Async.fetchAll('SELECT * FROM gangs2 WHERE gang = @gang', {['@gang'] = gang}, function(result)
        i = 1
        while i - 1 ~= #result do
            MySQL.Async.fetchAll('SELECT * FROM characters WHERE id = @ID', {['@ID'] = result[i].id}, function(result2)
                
                table.insert(players, {
                    ["label"] = result2[1].firstname .. " " .. result2[1].lastname, ["value"] = result[i].id
                })
                if i == #result then
                    callback(players)
                end
                i = i + 1
            end)
            Citizen.Wait(100)
        end
    end)
end)

RegisterServerEvent("advance_gangs:kickplayer")
AddEventHandler("advance_gangs:kickplayer", function(name)
    MySQL.Async.execute('DELETE FROM gangs2 WHERE id = @id',
    {
        ['@id'] = name,
    })

end)

RegisterServerEvent("advance_gangs:leave")
AddEventHandler("advance_gangs:leave", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.characterId
    MySQL.Async.execute('DELETE FROM gangs2 WHERE id = @id',
    {
        ['@id'] = name,
    })

end)

RegisterServerEvent("advance_gangs:invite")
AddEventHandler("advance_gangs:invite", function(name, gang)
    TriggerClientEvent('advance_gangs:invited', name, gang)
    
end)

ESX.RegisterServerCallback('advance_gangs:join', function(source, callback, gang)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = xPlayer.characterId
    MySQL.Async.fetchAll('SELECT id FROM gangs2 WHERE id = @id', {['@id'] = player}, function(result)
        if result[1] == nil then
            callback(true)
            MySQL.Async.execute('INSERT INTO gangs2 (id, gang, boss) VALUES (@id, @gang, @boss)',
            {
                ['@id'] = player,
                ['@gang'] = gang,
                ['@boss'] = 0
            })
        else
            callback(false)
        end  
    end)
end)

ESX.RegisterServerCallback('advance_gangs:getgang', function(source, callback)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = xPlayer.characterId
    

    MySQL.Async.fetchAll('SELECT gang FROM gangs2 WHERE ID = @ID', {['@ID'] = player}, function(result)
        callback(result)
    end)
    
end)

