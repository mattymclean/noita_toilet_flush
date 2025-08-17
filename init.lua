dofile_once("data/scripts/lib/mod_settings.lua")

function OnModPreInit()
	print("Toilet Flush Spell mod: PreInit")
end

function OnModInit()
	print("Toilet Flush Spell mod: Init")
	ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita_toilet_flush/data/gun_actions/gun_actions.lua")
end

function OnModPostInit()
	print("Toilet Flush Spell mod: PostInit")
end

function OnPlayerSpawned(player_entity)
	print("Toilet Flush Spell mod: Player spawned")
end
