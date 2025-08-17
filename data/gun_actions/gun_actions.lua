local actions = {
	{
		id          = "TOILET_FLUSH",
		name 		= "$action_toilet_flush",
		description = "$actiondesc_toilet_flush",
		sprite 		= "data/ui_gfx/gun_actions/personal_gravity_field.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/personal_gravity_field_unidentified.png",
		related_projectiles	= {"mods/toilet_flush_spell/files/entities/projectiles/toilet_flush.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6",
		spawn_probability                 = "0.4,0.4,0.4,0.4,0.4,0.4,0.4",
		price = 200,
		mana = 60,
		max_uses = 15,
		action 		= function()
			add_projectile("mods/toilet_flush_spell/files/entities/projectiles/toilet_flush.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			current_reload_time = current_reload_time + 30
		end,
	},
}

for i,v in ipairs(actions) do
	table.insert(actions_to_add, v)
end
