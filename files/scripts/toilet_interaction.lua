dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local enemies = EntityGetInRadiusWithTag(x, y, 150, "enemy")

for i, enemy_id in ipairs(enemies) do
    if EntityGetIsAlive(enemy_id) then
        local enemy_x, enemy_y = EntityGetTransform(enemy_id)
        local distance = math.sqrt((enemy_x - x)^2 + (enemy_y - y)^2)
        
        if distance < 30 then
            local damage_comp = EntityGetFirstComponentIncludingDisabled(enemy_id, "DamageModelComponent")
            local max_hp = 100
            
            if damage_comp ~= nil then
                max_hp = ComponentGetValue2(damage_comp, "max_hp")
            end
            
            local is_large_enemy = max_hp > 100 or EntityHasTag(enemy_id, "boss")
            
            if is_large_enemy then
                EntityInflictDamage(enemy_id, 25, "DAMAGE_CURSE", "Toilet flush clog", "NORMAL", 0, 0, entity_id)
                
                local swirl_comp = EntityAddComponent2(enemy_id, "LuaComponent", {
                    script_source_file = "mods/noita_toilet_flush/files/scripts/toilet_swirl.lua",
                    execute_every_n_frame = 1,
                    execute_on_added = 1
                })
                ComponentSetValue2(swirl_comp, "toilet_x", x)
                ComponentSetValue2(swirl_comp, "toilet_y", y)
                ComponentSetValue2(swirl_comp, "is_large", true)
                
            else
                local swirl_comp = EntityAddComponent2(enemy_id, "LuaComponent", {
                    script_source_file = "mods/noita_toilet_flush/files/scripts/toilet_swirl.lua",
                    execute_every_n_frame = 1,
                    execute_on_added = 1
                })
                ComponentSetValue2(swirl_comp, "toilet_x", x)
                ComponentSetValue2(swirl_comp, "toilet_y", y)
                ComponentSetValue2(swirl_comp, "is_large", false)
            end
            
            GamePlaySound("data/audio/Desktop/misc.bank", "misc/water_splash", x, y)
        end
    end
end
