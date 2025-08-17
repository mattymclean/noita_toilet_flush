dofile_once("data/scripts/lib/utilities.lua")

print("TOILET DEBUG: toilet_interaction.lua executing")

local toilet_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(toilet_id)

print("TOILET DEBUG: Toilet at position", x, y)

local entities = EntityGetInRadius(x, y, 150)
print("TOILET DEBUG: Found", #entities, "entities in radius")

for i, entity_id in ipairs(entities) do
    if entity_id ~= toilet_id and EntityGetIsAlive(entity_id) then
        local entity_x, entity_y = EntityGetTransform(entity_id)
        local distance = math.sqrt((entity_x - x)^2 + (entity_y - y)^2)
        
        print("TOILET DEBUG: Entity", entity_id, "at distance", distance)
        
        if distance < 100 then
            print("TOILET DEBUG: Entity within range! Distance:", distance, "Entity ID:", entity_id)
            
            local is_enemy = EntityHasTag(entity_id, "enemy")
            local is_player = EntityHasTag(entity_id, "player_unit")
            
            print("TOILET DEBUG: Is enemy:", is_enemy, "Is player:", is_player)
            
            if is_enemy or is_player then
                local damage_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
                local max_hp = 100
                
                if damage_comp ~= nil then
                    max_hp = ComponentGetValue2(damage_comp, "max_hp")
                end
                
                local is_large_enemy = (max_hp > 100 or EntityHasTag(entity_id, "boss")) and not is_player
                
                if is_large_enemy then
                    print("TOILET DEBUG: Large enemy detected - applying damage and swirl")
                    EntityInflictDamage(entity_id, 25, "DAMAGE_CURSE", "Toilet flush clog", "NORMAL", 0, 0, toilet_id)
                    
                    local swirl_comp = EntityAddComponent2(entity_id, "LuaComponent", {
                        script_source_file = "mods/noita_toilet_flush/files/scripts/toilet_swirl.lua",
                        execute_every_n_frame = 1,
                        execute_on_added = 1,
                        remove_after_executed = 0
                    })
                    ComponentSetValue2(swirl_comp, "mCustomDataString", tostring(x) .. "," .. tostring(y) .. ",true")
                    
                else
                    print("TOILET DEBUG: Small enemy/player detected - applying swirl effect")
                    local swirl_comp = EntityAddComponent2(entity_id, "LuaComponent", {
                        script_source_file = "mods/noita_toilet_flush/files/scripts/toilet_swirl.lua",
                        execute_every_n_frame = 1,
                        execute_on_added = 1,
                        remove_after_executed = 0
                    })
                    ComponentSetValue2(swirl_comp, "mCustomDataString", tostring(x) .. "," .. tostring(y) .. ",false," .. tostring(is_player))
                end
                
                GamePlaySound("data/audio/Desktop/misc.bank", "misc/water_splash", x, y)
            end
        end
    end
end
