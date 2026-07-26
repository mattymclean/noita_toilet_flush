function OnModInit()
	print("Toilet Flush Spell mod: Init")
	ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita_toilet_flush/data/gun_actions/gun_actions.lua")
end

-- Secret code: open Options -> Mods -> Toilet Flush Spell (works mid-run from the
-- pause menu), type the magic word into "Secret code", and the Flusher 3000
-- appears at your feet. The code is consumed on use - type it again for another.
local CHEAT_CODE = "FLUSHME"

function OnWorldPostUpdate()
	if GameGetFrameNum() % 30 ~= 0 then return end

	local code = ModSettingGet("noita_toilet_flush.cheat_code")
	if code == nil or string.upper(code) ~= CHEAT_CODE then return end

	-- consume the code so it can be re-entered for another wand
	ModSettingSet("noita_toilet_flush.cheat_code", "")
	ModSettingSetNextValue("noita_toilet_flush.cheat_code", "", false)

	local players = EntityGetWithTag("player_unit")
	if players == nil or #players == 0 then return end
	local x, y = EntityGetTransform(players[1])

	EntityLoad("mods/noita_toilet_flush/files/entities/toilet_wand.xml", x + 8, y - 8)
	GamePlaySound("data/audio/Desktop/misc.bank", "misc/teleport_use", x, y)
	GamePrint("You hear the distant rumble of ancient plumbing. The Flusher 3000 has answered.")
end
