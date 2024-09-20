script.on_event(defines.events.on_tick, function(event)
	if event.tick % (30 * 60) == 0 then --
		local force = game.forces["player"]
		local current_tick = event.tick

		local surfaces = {}
		local new_production_stats = force.item_production_statistics.input_counts
		local new_consumption_stats = force.item_production_statistics.output_counts
		local active_mods = game.active_mods
		local researched_techs = {}

		for name, surface in pairs(game.surfaces) do
			table.insert(surfaces, name)
		end

		for tech_name, tech in pairs(force.technologies) do
			if tech.researched then
				table.insert(researched_techs, tech_name)
			end
		end

		local combined_data = {
			surface = surfaces[1], -- TODO: This is hardcoded to one. Needs rewrite when DLC drops.
			tick = current_tick,
			production = new_production_stats,
			consumption = new_consumption_stats,
			research = researched_techs,
			mods = active_mods,
		}

		game.write_file("stats.json", game.table_to_json(combined_data), false)
	end
end)

script.on_init(initialize)
script.on_configuration_changed(initialize)
