dofile_once("data/scripts/lib/utilities.lua")

local PULL_RADIUS = 120
local FLUSH_RADIUS = 24
local PULL_FORCE = 1500
local FLUSH_DAMAGE = 25
local SMALL_HP_THRESHOLD = 100

function attract_and_flush(entity_id)
    local x, y = EntityGetTransform(entity_id)
    
    GamePrint("TOILET DEBUG: toilet_interaction.lua executing at " .. x .. ", " .. y)
    
    local nearby = EntityGetInRadius(x, y, PULL_RADIUS) or {}
    
    GamePrint("TOILET DEBUG: Found " .. #nearby .. " entities in radius")
    
    for _, eid in ipairs(nearby) do
        if (eid ~= entity_id) then
            if EntityHasTag(eid, "mortal") or EntityHasTag(eid, "enemy") or EntityHasTag(eid, "player_unit") then
                local ex, ey = EntityGetTransform(eid)
                
                local dx = x - ex
                local dy = y - ey
                local dist_sq = dx * dx + dy * dy
                local dist = math.sqrt(dist_sq)
                
                GamePrint("TOILET DEBUG: Entity " .. eid .. " at distance " .. dist)
                
                if dist > 0 and dist < PULL_RADIUS then
                    local nx = dx / dist
                    local ny = dy / dist
                    local force_mag = PULL_FORCE * (1 - dist / PULL_RADIUS)
                    PhysicsApplyForce(eid, nx * force_mag, ny * force_mag)
                end
                
                if dist < FLUSH_RADIUS then
                    flush_entity(entity_id, eid, ex, ey)
                end
            end
        end
    end
end

function flush_entity(toilet_id, target_id, target_x, target_y)
    if EntityHasTag(target_id, "flushed") then return end
    EntityAddTag(target_id, "flushed")
    
    GamePrint("TOILET DEBUG: Flushing entity " .. target_id)
    
    local dmg_comp = EntityGetFirstComponentIncludingDisabled(target_id, "DamageModelComponent")
    if dmg_comp then
        local max_hp = ComponentGetValue2(dmg_comp, "max_hp") or 0
        local hp = ComponentGetValue2(dmg_comp, "hp") or 0
        local is_player = EntityHasTag(target_id, "player_unit")
        
        if (max_hp < SMALL_HP_THRESHOLD or hp < 1.0) and not is_player then
            GamePrint("TOILET DEBUG: Small enemy - removing")
            spawn_flush_particles(target_x, target_y)
            PhysicsApplyForce(target_id, 0, -500)
            EntityKill(target_id)
        else
            GamePrint("TOILET DEBUG: Large enemy/player - damaging")
            EntityInflictDamage(target_id, FLUSH_DAMAGE, "DAMAGE_CURSE", "Toilet flush clog", "NORMAL", 0, -200, toilet_id)
            spawn_flush_particles(target_x, target_y)
        end
    end
    
    GamePlaySound("data/audio/Desktop/misc.bank", "misc/water_splash", target_x, target_y)
end

function spawn_flush_particles(x, y)
    local mud_entity = EntityLoad("data/entities/particles/image_emitters/mud_stain_02.xml", x, y)
    local vel_x = (math.random() - 0.5) * 100
    local vel_y = (math.random() - 0.5) * 100
    local vel_comp = EntityGetFirstComponentIncludingDisabled(mud_entity, "VelocityComponent")
    if vel_comp ~= nil then
        ComponentSetValue2(vel_comp, "mVelocity", vel_x, vel_y)
    end
end

function time_step()
    local entity_id = GetUpdatedEntityID()
    attract_and_flush(entity_id)
end
