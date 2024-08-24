script.on_event(defines.events.on_tick, function(event)
  if event.tick % (60 * 60) == 0 then -- Every minute
    local force = game.forces["player"]
    local current_tick = event.tick

    local new_production_stats = force.item_production_statistics.input_counts
    local new_consumption_stats = force.item_production_statistics.output_counts

    local combined_data = {
      tick = current_tick,
      production = new_production_stats,
      consumption = new_consumption_stats
    }

    game.write_file("stats.json", game.table_to_json(combined_data), false)
  end
end)

script.on_init(initialize)
script.on_configuration_changed(initialize)
