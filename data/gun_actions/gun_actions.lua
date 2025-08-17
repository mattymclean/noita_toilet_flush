local actions = {
	{
		id          = "TOILET_FLUSH",
		name 		= "$action_toilet_flush",
		description = "$actiondesc_toilet_flush",
		sprite 		= "mods/noita_toilet_flush/data/ui_gfx/gun_actions/toilet_flush.png",
		sprite_unidentified = "mods/noita_toilet_flush/data/ui_gfx/gun_actions/toilet_flush_unidentified.png",
		related_projectiles	= {"mods/noita_toilet_flush/files/entities/projectiles/toilet_flush.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6",
		spawn_probability                 = "0.1,0.2,0.3,0.4,0.5,0.6,0.7",
		price = 200,
		mana = 60,
		max_uses = 15,
		action 		= function()
			add_projectile("mods/noita_toilet_flush/files/entities/projectiles/toilet_flush.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			current_reload_time = current_reload_time + 30
		end,
	},
}

if actions_to_add ~= nil then
	for i,v in ipairs(actions) do
		table.insert(actions_to_add, v)
	end
end
