dofile_once("data/scripts/lib/utilities.lua")

function shot()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)
	
	local toilet_entity = EntityLoad("mods/toilet_flush_spell/files/entities/toilet_flush/toilet.xml", x, y)
	
	EntityKill(entity_id)
end
