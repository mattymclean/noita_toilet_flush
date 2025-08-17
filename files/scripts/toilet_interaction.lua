dofile_once("data/scripts/lib/utilities.lua")

local toilet_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(toilet_id)

print("TOILET DEBUG: toilet_interaction.lua executing at", x, y)

local enemies = EntityGetInRadiusWithTag(x, y, 150, "enemy")
local players = EntityGetInRadiusWithTag(x, y, 150, "player_unit")
local all_entities_broad = EntityGetInRadius(x, y, 150)

print("TOILET DEBUG: Found", #enemies, "enemies,", #players, "players,", #all_entities_broad, "total entities in 150px radius")

local all_entities = {}
for i, enemy_id in ipairs(enemies) do
    table.insert(all_entities, enemy_id)
end
for i, player_id in ipairs(players) do
    table.insert(all_entities, player_id)
end

local all_entities_fallback = EntityGetInRadius(x, y, 150)
local detected_entities = {}

for i, entity in ipairs(all_entities_fallback) do
    if EntityHasTag(entity, "enemy") or EntityHasTag(entity, "player_unit") then
        table.insert(detected_entities, entity)
        print("TOILET DEBUG: Found tagged entity", entity, "with tags:", EntityGetTags(entity))
    end
end

if #all_entities == 0 and #detected_entities > 0 then
    print("TOILET DEBUG: Using fallback detection method")
    all_entities = detected_entities
end

for i, target_entity in ipairs(all_entities) do
    if EntityGetIsAlive(target_entity) then
        local entity_x, entity_y = EntityGetTransform(target_entity)
        local distance = math.sqrt((entity_x - x)^2 + (entity_y - y)^2)
        
        print("TOILET DEBUG: Entity at distance", distance, "from toilet")
        
        if distance < 100 then
            print("TOILET DEBUG: Entity within range! Distance:", distance, "Entity ID:", target_entity)
            
            local damage_comp = EntityGetFirstComponentIncludingDisabled(target_entity, "DamageModelComponent")
            local max_hp = 100
            local is_player = EntityHasTag(target_entity, "player_unit")
            
            if damage_comp ~= nil then
                max_hp = ComponentGetValue2(damage_comp, "max_hp")
            end
            
            local is_large_enemy = (max_hp > 100 or EntityHasTag(target_entity, "boss")) and not is_player
            
            if is_large_enemy then
                print("TOILET DEBUG: Large enemy detected - applying damage and swirl")
                EntityInflictDamage(target_entity, 25, "DAMAGE_CURSE", "Toilet flush clog", "NORMAL", 0, 0, toilet_id)
                
                local swirl_comp = EntityAddComponent2(target_entity, "LuaComponent", {
                    script_source_file = "mods/noita_toilet_flush/files/scripts/toilet_swirl.lua",
                    execute_every_n_frame = 1,
                    execute_on_added = 1
                })
                ComponentSetValue2(swirl_comp, "toilet_x", x)
                ComponentSetValue2(swirl_comp, "toilet_y", y)
                ComponentSetValue2(swirl_comp, "is_large", true)
                
            else
                print("TOILET DEBUG: Small enemy/player detected - applying swirl effect")
                local swirl_comp = EntityAddComponent2(target_entity, "LuaComponent", {
                    script_source_file = "mods/noita_toilet_flush/files/scripts/toilet_swirl.lua",
                    execute_every_n_frame = 1,
                    execute_on_added = 1
                })
                ComponentSetValue2(swirl_comp, "toilet_x", x)
                ComponentSetValue2(swirl_comp, "toilet_y", y)
                ComponentSetValue2(swirl_comp, "is_large", false)
                ComponentSetValue2(swirl_comp, "is_player", is_player)
            end
            
            GamePlaySound("data/audio/Desktop/misc.bank", "misc/water_splash", x, y)
        end
    end
end
