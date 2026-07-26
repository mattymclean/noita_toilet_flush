function OnModInit()
	print("Toilet Flush Spell mod: Init")
	ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita_toilet_flush/data/gun_actions/gun_actions.lua")
end

function OnPlayerSpawned(player_entity)
	-- TESTING convenience: drop a Toilet Flush spell card next to the player on spawn.
	-- Remove (or comment out) the CreateItemActionEntity line for a normal playthrough.
	local x, y = EntityGetTransform(player_entity)
	CreateItemActionEntity("TOILET_FLUSH", x + 12, y - 6)
	GamePrint("Toilet Flush: spell card dropped at your feet (testing mode)")
end
