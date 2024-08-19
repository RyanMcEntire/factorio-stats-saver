local production_stats = {}
local consumption_stats = {}

local function initialize()
  if not global.production_stats then
    global.production_stats = {}
  end
  if not global.consumption_stats then
    global.consumption_stats = {}
  end
end

script.on_event(defines.events.on_tick, function(event)
  if event.tick % (60 * 60) == 0 then -- Every minute
    local force = game.forces["player"]
    local current_tick = event.tick

    local new_production_stats = force.item_production_statistics.input_counts
    local new_consumption_stats = force.item_production_statistics.output_counts

    local production_data = {}
    local consumption_data = {}

    for item, count in pairs(new_production_stats) do
      if global.production_stats[item] ~= count then
        global.production_stats[item] = count
        table.insert(production_data, { tick = current_tick, item = item, count = count })
      end
    end

    for item, count in pairs(new_consumption_stats) do
      if global.consumption_stats[item] ~= count then
        global.consumption_stats[item] = count
        table.insert(consumption_data, { tick = current_tick, item = item, count = count })
      end
    end

    if #production_data > 0 then
      game.write_file("production_stats.json", game.table_to_json(production_data), false)
    end

    if #consumption_data > 0 then
      game.write_file("consumption_stats.json", game.table_to_json(consumption_data), false)
    end
  end
end)

script.on_init(initialize)
script.on_configuration_changed(initialize)
