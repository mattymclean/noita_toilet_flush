dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local this_comp = GetUpdatedComponentID()
local toilet_x = ComponentGetValue2(this_comp, "toilet_x") or x
local toilet_y = ComponentGetValue2(this_comp, "toilet_y") or y
local is_large = ComponentGetValue2(this_comp, "is_large") or false

local swirl_time = ComponentGetValue2(this_comp, "swirl_time") or 0
local swirl_angle = ComponentGetValue2(this_comp, "swirl_angle") or 0
local swirl_radius = ComponentGetValue2(this_comp, "swirl_radius") or 40

swirl_time = swirl_time + 1
swirl_angle = swirl_angle + 0.2
swirl_radius = math.max(5, swirl_radius - 0.5)

local new_x = toilet_x + math.cos(swirl_angle) * swirl_radius
local new_y = toilet_y + math.sin(swirl_angle) * swirl_radius

EntitySetTransform(entity_id, new_x, new_y)

if swirl_time % 10 == 0 then
    local particle_id = EntityLoad("data/entities/particles/image_emitters/dirt_02.xml", new_x, new_y)
    local particle_comp = EntityGetFirstComponentIncludingDisabled(particle_id, "ParticleEmitterComponent")
    if particle_comp ~= nil then
        ComponentSetValue2(particle_comp, "emitted_material_name", "mud")
        ComponentSetValue2(particle_comp, "count_min", 3)
        ComponentSetValue2(particle_comp, "count_max", 8)
    end
end

if not is_large and swirl_time > 120 then -- 2 seconds at 60fps
    local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
    if sprite_comp ~= nil then
        local current_scale = ComponentGetValue2(sprite_comp, "scale_x") or 1.0
        local new_scale = math.max(0.1, current_scale - 0.05)
        ComponentSetValue2(sprite_comp, "scale_x", new_scale)
        ComponentSetValue2(sprite_comp, "scale_y", new_scale)
        
        if new_scale <= 0.1 then
            GamePlaySound("data/audio/Desktop/misc.bank", "misc/water_splash_big", toilet_x, toilet_y)
            EntityKill(entity_id)
        end
    end
elseif is_large and swirl_time > 180 then -- 3 seconds for large enemies
    EntityRemoveComponent(entity_id, this_comp)
end

ComponentSetValue2(this_comp, "swirl_time", swirl_time)
ComponentSetValue2(this_comp, "swirl_angle", swirl_angle)
ComponentSetValue2(this_comp, "swirl_radius", swirl_radius)
