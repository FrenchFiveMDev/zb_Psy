local ESX
local allRegister = {}
local psyInGame = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'psy', 'psy', 'society_psy', 'society_psy', 'society_psy', {type = 'private'})

ESX.RegisterServerCallback('zbPsy:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_psy', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('zbPsy:getStockItem')
AddEventHandler('zbPsy:getStockItem', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_psy', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', 'Vous avez retiré ~r~'..inventoryItem.label.." x"..count, 'CHAR_ABIGAIL', 8)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', "Quantité ~r~invalide", 'CHAR_ABIGAIL', 9)
		end
	end)
end)

ESX.RegisterServerCallback('zbPsy:getPlayerInventory', function(source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('zbPsy:putStockItems')
AddEventHandler('zbPsy:putStockItems', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_psy', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', 'Vous avez déposé ~g~'..inventoryItem.label.." x"..count, 'CHAR_ABIGAIL', 8)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', "Quantité ~r~invalide", 'CHAR_ABIGAIL', 9)
		end
	end)
end)


ESX.RegisterServerCallback('zbPsy:getAllRegister', function(source, cb)
	cb(allRegister)
end)


RegisterNetEvent('zbPsy:registerWithPsy')
AddEventHandler('zbPsy:registerWithPsy', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	
	if allRegister[_src] then
		TriggerClientEvent('esx:showNotification', _src, "~r~Probleme~s~: vous êtes déjà inscrit")
	else
		allRegister[_src] = {idPlayer = _src, namePlayer = xPlayer.getName(), numberRegister = #allRegister + 1, state = false}
		TriggerClientEvent('esx:showNotification', _src, "~g~Succès~s~: vous avez a été inscrit chez le psychologue")
	end
end)

RegisterNetEvent('zbPsy:setStateEnter')
AddEventHandler('zbPsy:setStateEnter', function(id)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local __src = id
	local xTarget = ESX.GetPlayerFromId(__src)
	if allRegister then
		if allRegister[__src] then
			allRegister[__src].state = true
			TriggerClientEvent('esx:showNotification', _src, "~g~Succès~s~: vous êtes passés au patient suivant")
			TriggerClientEvent('esx:showNotification', __src, "~g~Succès~s~: vous pouvez rentrer chez le psy")
		end
	end
end)

RegisterNetEvent('zbPsy:setStateEnd')
AddEventHandler('zbPsy:setStateEnd', function(id)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local __src = id
	local xTarget = ESX.GetPlayerFromId(__src)
	if allRegister then
		if allRegister[__src] then
			allRegister[__src] = nil
			TriggerClientEvent('esx:showNotification', _src, "~g~Succès~s~: vous avez mis fin au rendez-vous")
			TriggerClientEvent('esx:showNotification', __src, "~g~Succès~s~: votre rendez-vous a pris fin")
		end
	end
end)

RegisterNetEvent('zbPsy:setStateRefuse')
AddEventHandler('zbPsy:setStateRefuse', function(id)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local __src = id
	local xTarget = ESX.GetPlayerFromId(__src)
	if allRegister then
		if allRegister[__src] then
			allRegister[__src] = nil
			TriggerClientEvent('esx:showNotification', _src, "~g~Succès~s~: vous avez refusé le rendez-vous")
			TriggerClientEvent('esx:showNotification', __src, "~g~Succès~s~: votre rendez-vous a été refusé")
		end
	end
end)


ESX.RegisterServerCallback('zbPsy:getIfMyTurn', function(source, cb)
	local _src = source
	if allRegister then
		if allRegister[_src] then
			if allRegister[_src].state then
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)


ESX.RegisterServerCallback('zbPsy:getIfPsyState', function(source, cb)
	cb(psyInGame)
end)

RegisterNetEvent('zbPsy:setStatePsyIG')
AddEventHandler('zbPsy:setStatePsyIG', function()
	local _src = source
	local xPlayers	= ESX.GetPlayers()
	if psyInGame then
		psyInGame = false
		TriggerClientEvent('esx:showNotification', _src, "~g~Succès~s~: vous avez fermer le cabinet")
		for i=1, #xPlayers, 1 do
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Psychologue', '~r~Annonce', 'Le psychologue est désormais fermé', 'CHAR_ABIGAIL', 8)
		end
	else
		psyInGame = true
		TriggerClientEvent('esx:showNotification', _src, "~g~Succès~s~: vous avez ouvert le cabinet")
		for i=1, #xPlayers, 1 do
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Psychologue', '~g~Annonce', 'Le psychologue est désormais ouvert', 'CHAR_ABIGAIL', 8)
		end
	end
end)