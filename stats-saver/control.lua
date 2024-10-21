script.on_event(defines.events.on_tick, function(event)
	if event.tick % (30 * 60) == 0 then --
		local force = game.forces["player"]
		local current_tick = event.tick
		local surfaces = {}
		local new_production_stats = force.item_production_statistics.input_counts
		local new_consumption_stats = force.item_production_statistics.output_counts
		local active_mods = game.active_mods
		local researched_techs = {}

		for tech_name, tech in pairs(force.technologies) do
			if tech.researched then
				table.insert(researched_techs, tech_name)
			end
		end

		for name, id in pairs(game.surfaces) do
			surfaces[name] = {
				production = get_item_production_statistics(name).input_counts,
				consumption = get_item_production_statistics(name).output_counts,
			}
		end

		-- NOTE:
		-- Surface addition only adds for the one surface
		-- until Space Age comes out.
		-- Will need to iterate over each surface and get stats
		-- when Space Age api is released.

		local combined_data = {
			tick = current_tick,
			surfaces = surfaces,
			research = researched_techs,
			mods = active_mods,
		}

		game.write_file("stats.json", game.table_to_json(combined_data), false)
	end
end)

script.on_init(initialize)
script.on_configuration_changed(initialize)
