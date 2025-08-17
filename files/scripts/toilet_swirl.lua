dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local comp_id = GetUpdatedComponentID()

local custom_data = ComponentGetValue2(comp_id, "mCustomDataString")
local params = {}

for param in string.gmatch(custom_data, "[^,]+") do
    table.insert(params, param)
end

local toilet_x = tonumber(params[1])
local toilet_y = tonumber(params[2])
local is_large = params[3] == "true"
local is_player = params[4] == "true"

if toilet_x == nil or toilet_y == nil then
    return
end

local x, y = EntityGetTransform(entity_id)
local angle = math.atan2(y - toilet_y, x - toilet_x)

local swirl_time = ComponentGetValue2(comp_id, "swirl_time") or 0
swirl_time = swirl_time + 1
ComponentSetValue2(comp_id, "swirl_time", swirl_time)

local max_swirl_time = is_large and 120 or 180

if swirl_time < max_swirl_time then
    local radius = 30 - (swirl_time / max_swirl_time) * 25
    local angular_speed = 0.2 + (swirl_time / max_swirl_time) * 0.3
    
    angle = angle + angular_speed
    
    local new_x = toilet_x + math.cos(angle) * radius
    local new_y = toilet_y + math.sin(angle) * radius
    
    EntitySetTransform(entity_id, new_x, new_y)
    
    local scale = 1.0 - (swirl_time / max_swirl_time) * 0.7
    local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
    if sprite_comp ~= nil then
        ComponentSetValue2(sprite_comp, "scale_x", scale)
        ComponentSetValue2(sprite_comp, "scale_y", scale)
    end
    
    if swirl_time % 10 == 0 then
        local mud_entity = EntityLoad("data/entities/particles/image_emitters/mud_stain_02.xml", x, y)
        local vel_x = (math.random() - 0.5) * 100
        local vel_y = (math.random() - 0.5) * 100
        local vel_comp = EntityGetFirstComponentIncludingDisabled(mud_entity, "VelocityComponent")
        if vel_comp ~= nil then
            ComponentSetValue2(vel_comp, "mVelocity", vel_x, vel_y)
        end
    end
else
    if is_large then
        EntityRemoveComponent(entity_id, comp_id)
    else
        EntityKill(entity_id)
    end
end
