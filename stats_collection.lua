/c 
script.on_event(defines.events.on_tick, function(event)
  local interval = 60 * 60
  local retry_limit = 3
  local retry_interval = 60

  global.retry_state = global.retry_state or {
    next_retry_tick = 0,
    retries = 0,
    initial_tick = nil
  }

  if (event.tick % interval) == 0 and global.retry_state.retries == 0 then
    game.print("It has been 1 min my dudes")
    global.retry_state.initial_tick = game.tick
    global.retry_state.next_retry_tick = game.tick
  end

  if global.retry_state.retries > 0 or (event.tick % interval) == 0 then
    if event.tick >= global.retry_state.next_retry_tick then
      local success = pcall(function()
        local force = game.players[1].force
        local production_stats = force.item_production_statistics
        local prod_stats_table = {}
        local con_stats_table = {}

        for name, count in pairs(production_stats.output_counts) do
            prod_stats_table[name] = count
        end
        for name, count in pairs(production_stats.input_counts) do
            con_stats_table[name] = count
        end
        local all_stats = {
          ["game-tick"] = global.retry_state.initial_tick,
          ["game-hours"] = global.retry_state.initial_tick / 60 / 60 / 60,
          ["production stats"] = prod_stats_table,
          ["consumption stats"] = con_stats_table
        }
        game.write_file("all_stats.lua", serpent.block(all_stats) .. "\n", true)
      end)

      if success then
        global.retry_state.retries = 0
      else
        global.retry_state.retries = global.retry_state.retries + 1
        global.retry_state.next_retry_tick = event.tick + retry_interval

        if global.retry_state.retries > retry_limit then
          local all_stats = {
            ["game-tick"] = global.retry_state.initial_tick,
            ["game-hours"] = global.retry_state.initial_tick / 60 / 60 / 60,
            ["production stats"] = {},
            ["consumption stats"] = {}
          }
          game.write_file("all_stats.lua", serpent.block(all_stats) .. "\n", true)
        end
      end
    end
  end
end)