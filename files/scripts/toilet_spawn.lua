dofile_once("data/scripts/lib/utilities.lua")

function shot()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)
	
	local toilet_entity = EntityLoad("mods/noita_toilet_flush/files/entities/toilet_flush/toilet.xml", x, y)
	
	EntityKill(entity_id)
end

function collision_trigger()
	shot()
end

function death()
	shot()
end
