dofile_once("data/scripts/lib/utilities.lua")

GamePrint("TOILET TEST: toilet_spawn.lua loaded!")

function shot()
	GamePrint("TOILET TEST: shot() function called!")
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)
	
	GamePrint("TOILET TEST: Spawning toilet at " .. x .. ", " .. y)
	local toilet_entity = EntityLoad("mods/noita_toilet_flush/files/entities/toilet_flush/toilet.xml", x, y)
	GamePrint("TOILET TEST: Toilet entity ID: " .. tostring(toilet_entity))
	
	EntityKill(entity_id)
	GamePrint("TOILET TEST: Projectile killed")
end

function collision_trigger()
	GamePrint("TOILET TEST: collision_trigger() called!")
	shot()
end

function death()
	GamePrint("TOILET TEST: death() called!")
	shot()
end
