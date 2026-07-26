function OnModInit()
	print("Toilet Flush Spell mod: Init")
	ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita_toilet_flush/data/gun_actions/gun_actions.lua")
end

function OnPlayerSpawned(player_entity)
	-- TESTING convenience: drop a ready-to-fire toilet wand (plus a spare spell card)
	-- next to the player on spawn. Comment this out for a normal playthrough.
	local x, y = EntityGetTransform(player_entity)
	EntityLoad("mods/noita_toilet_flush/files/entities/toilet_wand.xml", x + 14, y - 4)
	CreateItemActionEntity("TOILET_FLUSH", x - 14, y - 4)
	GamePrint("Toilet Flush: the Flusher 3000 wand is at your feet - press E to grab it (testing mode)")
end
