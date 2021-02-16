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
		gang = cb[1].gang
		boss = cb[1].boss

		local elements = {}
			
		if gang then
			table.insert(elements, {
				["label"] = "Alla medlemmar", ["value"] = 'members'
			})
			if boss == "1" then
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
				title    = "Gäng",
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
					
				

			end, function(data, menu)
				menu.close()
		end)
	end)

end

function kickmember(member)

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
			TriggerServerEvent('advance_gangs:creategang', data.value)
			TriggerEvent('esx:showNotification', 'Du skapade gänget ' .. data.value)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function members(gang)

	ESX.TriggerServerCallback('advance_gangs:getmembers', function(cb)
		local elements = cb
		print(cb)
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'members',
			{
				title    = "Medlemmar",
				align    = "center",
				elements = elements

			},
			function(data, menu)		

			end, function(data, menu)
				menu.close()
		end)

	end, gang)

end