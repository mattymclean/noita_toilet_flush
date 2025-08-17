dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local this_comp = GetUpdatedComponentID()
local effect_time = ComponentGetValue2(this_comp, "effect_time") or 0
local water_sound_played = ComponentGetValue2(this_comp, "water_sound_played") or false
local flush_sound_played = ComponentGetValue2(this_comp, "flush_sound_played") or false

effect_time = effect_time + 1

if not water_sound_played and effect_time > 30 then
    GamePlaySound("data/audio/Desktop/misc.bank", "misc/water_splash", x, y)
    ComponentSetValue2(this_comp, "water_sound_played", true)
    water_sound_played = true
end

if not flush_sound_played and effect_time > 180 then -- 3 seconds
    GamePlaySound("mods/noita_toilet_flush/files/audio/toilet_flush.ogg", "", x, y)
    ComponentSetValue2(this_comp, "flush_sound_played", true)
    flush_sound_played = true
end

if effect_time % 30 == 0 then
    for i = 1, 3 do
        local angle = (i / 3) * 2 * math.pi
        local particle_x = x + math.cos(angle) * 20
        local particle_y = y + math.sin(angle) * 20
        
        local particle_id = EntityLoad("data/entities/particles/image_emitters/dirt_02.xml", particle_x, particle_y)
        local particle_comp = EntityGetFirstComponentIncludingDisabled(particle_id, "ParticleEmitterComponent")
        if particle_comp ~= nil then
            ComponentSetValue2(particle_comp, "emitted_material_name", "mud")
            ComponentSetValue2(particle_comp, "count_min", 2)
            ComponentSetValue2(particle_comp, "count_max", 5)
            ComponentSetValue2(particle_comp, "lifetime_min", 30)
            ComponentSetValue2(particle_comp, "lifetime_max", 60)
        end
    end
end

ComponentSetValue2(this_comp, "effect_time", effect_time)
