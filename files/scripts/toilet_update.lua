-- Toilet Flush - main update loop.
-- Runs on the landed toilet every 2 frames (LuaComponent script_source_file).
-- Patterns borrowed from vanilla: data/scripts/buildings/gravity_field.lua (pull),
-- data/scripts/projectiles/vacuum_entities.lua (capture), wallmouth_yawn.lua (velocity zeroing).

dofile_once("data/scripts/lib/utilities.lua")

local SUCK_RADIUS    = 96    -- pixels: enemies inside this get pulled in
local CAPTURE_RADIUS = 14    -- pixels: enemies inside this start swirling
local SWIRL_FRAMES   = 110   -- ~1.8s of swirling before the flush resolves
local PULL_COEFF     = 30    -- velocity added per tick at point-blank range
local SMALL_MAX_HP   = 6.0   -- internal hp units (x25 shown in game); <= this gets flushed for good
local KILL_GROWTH    = 2.0   -- each successful flush raises the kill line by this much (+50 shown HP)
local CLOG_DAMAGE    = 2.0   -- 50 shown damage dealt to big enemies that clog the toilet

local toilet_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(toilet_id)
local frame = GameGetFrameNum()

-- Per-entity int storage helpers (VariableStorageComponent - the proper way to keep
-- state between LuaComponent executions; component fields can't be invented).
local function get_int(entity, name, default)
	local comp = get_variable_storage_component(entity, name)
	if comp == nil then return default end
	return ComponentGetValue2(comp, "value_int")
end

local function set_int(entity, name, value)
	local comp = get_variable_storage_component(entity, name)
	if comp == nil then
		EntityAddComponent2(entity, "VariableStorageComponent", { name = name, value_int = value })
	else
		ComponentSetValue2(comp, "value_int", value)
	end
end

local function set_creature_velocity(entity, fn)
	edit_component(entity, "VelocityComponent", function(comp, vars)
		local vx, vy = ComponentGetValue2(comp, "mVelocity")
		local nx, ny = fn(vx, vy)
		ComponentSetValue2(comp, "mVelocity", nx, ny)
	end)
	edit_component(entity, "CharacterDataComponent", function(comp, vars)
		local vx, vy = ComponentGetValue2(comp, "mVelocity")
		local nx, ny = fn(vx, vy)
		ComponentSetValue2(comp, "mVelocity", nx, ny)
	end)
end

-- Let the toilet fly and land before it starts flushing
local age = get_int(toilet_id, "toilet_age", 0) + 2
set_int(toilet_id, "toilet_age", age)
if age < 40 then return end

if not is_in_camera_bounds(x, y, 300) then return end

-- Idle "running water": a dribble of visual-only droplets into the bowl
if frame % 10 == 0 then
	local jitter = ProceduralRandomf(x + frame, y, -4, 4)
	GameCreateParticle("water", x + jitter, y - 8, 1, 0, -20, true, false)
end

local victims = EntityGetInRadiusWithTag(x, y, SUCK_RADIUS, "hittable")
for _, v in ipairs(victims) do
	repeat
		if v == toilet_id then break end
		if EntityHasTag(v, "mod_toilet") then break end
		if EntityHasTag(v, "player_unit") or EntityHasTag(v, "polymorphed_player") then break end
		local dm = EntityGetFirstComponentIncludingDisabled(v, "DamageModelComponent")
		if dm == nil then break end
		if get_int(v, "toilet_immune_until", 0) > frame then break end

		local vx, vy = EntityGetTransform(v)
		local dist = get_distance(x, y, vx, vy)

		if dist > CAPTURE_RADIUS then
			-- Suction: stronger the closer they are, plus a small anti-gravity assist
			local pull = PULL_COEFF * (1.0 - dist / SUCK_RADIUS) + 5
			local dir_x = (x - vx) / dist
			local dir_y = (y - vy) / dist
			set_creature_velocity(v, function(mvx, mvy)
				return mvx + dir_x * pull, mvy + dir_y * pull - 1.5
			end)
		else
			-- Captured: swirl around the bowl in a shrinking ellipse
			local st = get_int(v, "toilet_swirl", 0) + 2
			set_int(v, "toilet_swirl", st)

			if st <= 2 then
				GamePlaySound("data/audio/Desktop/misc.bank", "misc/root_grow", x, y)
			end

			local progress = st / SWIRL_FRAMES
			local angle = st * 0.22
			local radius = math.max(2, CAPTURE_RADIUS * (1.0 - progress))
			local sx = x + math.cos(angle) * radius
			local sy = y - 4 + math.sin(angle) * radius * 0.5
			EntitySetTransform(v, sx, sy)
			EntityApplyTransform(v, sx, sy)
			set_creature_velocity(v, function() return 0, 0 end)

			if st % 8 == 0 then
				GameCreateParticle("water", sx, sy, 2, 0, -30, true, false)
			end

			if st >= SWIRL_FRAMES then
				-- FLUSH!
				GamePlaySound("data/audio/Desktop/misc.bank", "misc/teleport_use", x, y)
				GameCreateParticle("water", x, y - 6, 14, 0, -60, false, false)
				GameScreenshake(4, x, y)

				-- The pipes warm up: every successful flush raises this toilet's kill line
				local kills = get_int(toilet_id, "toilet_kills", 0)
				local kill_line = SMALL_MAX_HP + kills * KILL_GROWTH

				local max_hp = ComponentGetValue2(dm, "max_hp") or 0
				if max_hp <= kill_line then
					-- Small enough to fit down the pipes: proper death (drops gold), disintegrate fx
					EntityInflictDamage(v, max_hp * 4 + 10, "DAMAGE_CURSE", "flushed down the toilet", "DISINTEGRATED", 0, 0, toilet_id)
					kills = kills + 1
					set_int(toilet_id, "toilet_kills", kills)
					if kills == 3 then
						GamePrint("The toilet gurgles ominously. The pipes are warming up...")
					elseif kills == 6 then
						GamePrint("The toilet's suction grows unnatural. Larger prey beware.")
					elseif kills == 10 then
						GamePrint("THE PORCELAIN THRONE HUNGERS.")
						GameScreenshake(8, x, y)
					end
				else
					-- Too big: the toilet clogs, chews on them and spits them back out
					set_int(v, "toilet_swirl", 0)
					set_int(v, "toilet_immune_until", frame + 150)
					EntityInflictDamage(v, CLOG_DAMAGE, "DAMAGE_PROJECTILE", "clogged the toilet", "NONE", 0, -200, toilet_id)
					local kick_x = ProceduralRandomf(x + v, y, -140, 140)
					set_creature_velocity(v, function() return kick_x, -260 end)
				end
			end
		end
	until true
end

-- Also tug loose physics bodies (ragdolls, props) toward the bowl, like vanilla gravity fields do
function _toilet_force_for_body(entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular)
	local dist = get_distance(x, y, body_x, body_y)
	if dist < 6 or dist > SUCK_RADIUS then
		return body_x, body_y, 0, 0, 0
	end
	local strength = 120 * (1.0 - dist / SUCK_RADIUS) * body_mass
	local fx = (x - body_x) / dist * strength
	local fy = (y - body_y) / dist * strength
	return body_x, body_y, fx, fy, 0
end
local half = SUCK_RADIUS * 0.5
PhysicsApplyForceOnArea(_toilet_force_for_body, toilet_id, x - half, y - half, x + half, y + half)
