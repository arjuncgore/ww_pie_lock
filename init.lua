-- ==== VARS ====
local waywall       = require("waywall")

-- local cfg     = {
--     hotbar_keys = {
--         "1",
--         "2",
--         "3",
--         "4",
--     },
--     text = {
--         enabled = true,
--         text = "change pie dir",
--         x = 2560 - 100,
--         y = 1440 - 100,
--         size = 5,
--         color = "#F5793A",
--     },
--     toggle_key = "*-GRAVE",
--     locked_hook = nil,
--     unlocked_hook = nil,
--     remaps_table = ...
-- }

local M             = {}
local locked_remaps = {}
-- ==== PLUG ====
M.setup             = function(config, cfg)
    local text_obj = nil

    local unlocked_remaps = {}
    for key, val in pairs(cfg.remaps_table) do
        locked_remaps[key] = val
        unlocked_remaps[key] = val
    end

    for k, v in ipairs(cfg.hotbar_keys) do
        locked_remaps[v] = "F" .. (12 + k)
    end

    local lock_enabled = true

    local locked = function()
        waywall.set_remaps(locked_remaps)
        lock_enabled = true
        if cfg.locked_hook then cfg.locked_hook() end
    end
    local unlocked = function()
        waywall.set_remaps(unlocked_remaps)
        lock_enabled = false
        if cfg.unlocked_hook then cfg.unlocked_hook() end
    end

    config.actions[cfg.toggle_key] = function()
        if lock_enabled then
            unlocked()
            if cfg.text.enabled then
                if text_obj then
                    text_obj:close()
                    text_obj = nil
                end
                text_obj = waywall.text(cfg.text.text, {
                    x = cfg.text.x,
                    y = cfg.text.y,
                    color = cfg.text.color,
                    size = cfg.text.size,
                })
            end
        else
            locked()
            if text_obj then
                text_obj:close()
                text_obj = nil
            end
        end
    end

    waywall.listen("state", function()
        local state = waywall.state()
        if (state.screen == "wall" or state.screen == "generating") and not lock_enabled then
            lock_enabled = true
            if text_obj then
                text_obj:close()
                text_obj = nil
            end
        end
    end)
end

M.normal_remaps     = function()
    return locked_remaps
end


return M
