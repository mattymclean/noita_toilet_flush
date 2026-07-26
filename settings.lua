dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "noita_toilet_flush"
mod_settings_version = 1

mod_settings =
{
	{
		id = "_header",
		ui_name = "Whisper the secret words to summon the Flusher 3000...",
		not_setting = true,
	},
	{
		id = "cheat_code",
		ui_name = "Secret code",
		ui_description = "If you know it, type it. The wand will appear at your feet.",
		value_default = "",
		text_max_length = 20,
		allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
