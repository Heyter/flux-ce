--[[
	Rework © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

netstream.Hook("ClientIncludedSchema", function(player)
	character.Load(player)
	item.SendToPlayer(player)

	hook.Run("ClientIncludedSchema", player)
	hook.Run("PlayerInitialized", player)
end)

netstream.Hook("PlayerDropItem", function(player, instanceID)
	hook.Run("PlayerDropItem", player, instanceID)
end)

netstream.Hook("InventorySync", function(player, inventory)
	local newInventory = {}

	for slot, ids in ipairs(inventory) do
		newInventory[slot] = {}

		for k, v in ipairs(ids) do
			if (player:HasItemByID(v)) then
				table.insert(newInventory[slot], v)
			end
		end
	end

	player:SetInventory(newInventory)
end)

netstream.Hook("SoftUndo", function(player)
	rw.undo:DoPlayer(player)
end)

netstream.Hook("LocalPlayerCreated", function(player)
	print(player)

	netstream.Start(player, "SharedTables", rw.sharedTable)

	player:SendConfig()
	player:SyncNetVars()
end)