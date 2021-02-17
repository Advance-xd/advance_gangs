ESX = nil

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()

end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if (IsControlJustPressed(1, 166)) then
			open()
		end
		
	end

end)

local gang = nil
local boss = false

function open()
	ESX.TriggerServerCallback('advance_gangs:getplayer', function(cb)
		local elements = {}
		local title = "Gäng"

		if cb[1] then
			title = cb[1].gang
			gang = cb[1].gang
			boss = cb[1].boss
			table.insert(elements, {
				["label"] = "Alla medlemmar", ["value"] = 'members'
			})
			table.insert(elements, {
				["label"] = "Lämna " .. gang, ["value"] = 'leave'
			})
			if cb[1].boss == "1" then
				table.insert(elements, {
					["label"] = "Bjud in nämsta spelare", ["value"] = 'invite'
				})
			end

		else
			table.insert(elements, {
				["label"] = "Skapa gäng", ["value"] = 'create'
			})
		
			
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'menu',
			{
				title    = title,
				align    = "center",
				elements = elements

			},
			function(data, menu)

				if data.current.value == 'create' then
					menu.close()
					creategang()
				end

				if data.current.value == 'members' then
					menu.close()
					members(gang)
				end
				if data.current.value == 'leave' then
					menu.close()
					leave(gang)
				end

				if data.current.value == 'invite' then
					inviteplayer(gang)
				end
					
				

			end, function(data, menu)
				menu.close()
		end)
	end)

end

function creategang()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'creategang',
		{
		title = ('Namn på ditt nya gäng')
		},
	function(data, menu)
		if data.value == "" or data.value == nil then
			
		else
			menu.close()
			createtgang(data.value)
			
		end
	end,
	function(data, menu)
		menu.close()
	end)

end

function createtgang(name)
	ESX.TriggerServerCallback('advance_gangs:creategang', function(cb)
		if cb then
			TriggerEvent('esx:showNotification', 'Du skapade gänget ' .. name)
		else
			TriggerEvent('esx:showNotification', 'Namnet är upptaget')
		end
	end, name)
end

function members(gang)

	ESX.TriggerServerCallback('advance_gangs:getmembers', function(cb)
		local elements = cb
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'members',
			{
				title    = "Medlemmar",
				align    = "center",
				elements = elements

			},
			function(data, menu)
					
				
				menu.close()
				kickplayer(data.current.value)
				

			end, function(data, menu)
				menu.close()
		end)

	end, gang)

end

function kickplayer(player)

	local elements = {}

	table.insert(elements, {
		["label"] = "Ja", ["value"] = 'yes'
	})
	table.insert(elements, {
		["label"] = "Nej", ["value"] = 'no'
	})
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'kick',
		{
			title    = "Vill du sparka " .. player,
			align    = "center",
			elements = elements

		},
		function(data, menu)		
			if data.current.value == 'yes' then
				menu.close()
				TriggerServerEvent('advance_gangs:kickplayer', player)
			end
			if data.current.value == 'no' then
				menu.close()
				
			end

		end, function(data, menu)
			menu.close()
	end)
	

end

function inviteplayer(gang)
	local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer == -1 or closestPlayerDistance > 1.0 then
		TriggerEvent('esx:showNotification', 'Ingen är nära dig')
	else
		TriggerEvent('esx:showNotification', 'Du bjöd in nämaste spelaren')
		TriggerServerEvent('advance_gangs:invite', GetPlayerServerId(closestPlayer), gang)
	end

end

RegisterNetEvent("advance_gangs:invited")
AddEventHandler("advance_gangs:invited", function(gang)
	
	local elements = {}

	table.insert(elements, {
		["label"] = "Ja", ["value"] = 'yes'
	})
	table.insert(elements, {
		["label"] = "Nej", ["value"] = 'no'
	})
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'join',
		{
			title    = "Vill du gå med i " .. gang,
			align    = "center",
			elements = elements

		},
		function(data, menu)		
			if data.current.value == 'yes' then
				menu.close()
				ESX.TriggerServerCallback('advance_gangs:join', function(cb)
					if cb then
						TriggerEvent('esx:showNotification', 'Du gick med i ' .. gang)
					else
						TriggerEvent('esx:showNotification', 'Du är redan med i ett gäng')
					end
				end, gang)
			end
			if data.current.value == 'no' then
				menu.close()
				
			end

		end, function(data, menu)
			menu.close()
	end)
	
end)

function leave(gang)

	local elements = {}

	table.insert(elements, {
		["label"] = "Ja", ["value"] = 'yes'
	})
	table.insert(elements, {
		["label"] = "Nej", ["value"] = 'no'
	})
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'leave',
		{
			title    = "Vill du lämna " .. gang,
			align    = "center",
			elements = elements

		},
		function(data, menu)		
			if data.current.value == 'yes' then
				menu.close()
				TriggerServerEvent('advance_gangs:leave')
			end
			if data.current.value == 'no' then
				menu.close()
				
			end

		end, function(data, menu)
			menu.close()
	end)
end