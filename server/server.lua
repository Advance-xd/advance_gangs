ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("advance_gangs:creategang")
AddEventHandler("advance_gangs:creategang", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = xPlayer.characterId

    MySQL.Async.execute('INSERT INTO gangs2 (id, gang, boss) VALUES (@id, @gang, @boss)',
    {
        ['@id'] = player,
        ['@gang'] = name,
        ['@boss'] = 1
    }
    )
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
        i = 0
        
        while i ~= #result do
            print(i + 1)
            print(#result)
            MySQL.Async.fetchAll('SELECT * FROM characters WHERE id = @ID', {['@ID'] = result[i + 1].id}, function(result)
                --table.insert(players, {[i + 1] = result[1].firstname .. " " .. result[1].lastname})
                --table.insert(players, {[1] = "print"})
                players[i + 1] = result[1].firstname .. " " .. result[1].lastname
                if i + 1 == #result then
                    print(players[i + 1])
                    callback(players[i + 1])
                end
            end)
        
        
            i = i + 1
        end
        
        

    end)

    
    
end)