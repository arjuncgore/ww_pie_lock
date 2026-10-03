-- ==== VARS ====
local waywall = require("waywall")

local cfg     = {
    hotbar_keys = {
        "1",
        "2",
        "3",
        "4",
    },
    text_look = {
        enabled = true,
        x = 2560 - 100,
        y = 1440 - 100,
        size = 5,
        color = "#F5793A",
    },
    toggle_key = "*-GRAVE",
    locked_hook = nil,
    unlocked_hook = nil,
}

local M       = {}
-- ==== PLUG ====
M.setup       = function(config, cfg)
    local text_obj = nil

    local locked_remaps = {}
    local unlocked_remaps = {}
    for key, val in pairs(config.input.remaps) do
        locked_remaps[key] = val
        unlocked_remaps[key] = val
    end

    for k, v in ipairs(cfg.hotbar_keys) do
        locked_remaps[v] = "F" .. 12 + k
        unlocked_remaps[v] = k
    end

    local lock_enabled = false
    waywall.set_remaps(locked_remaps)

    local locked = function()
        waywall.set_remaps(locked_remaps)
        lock_enabled = true
        return cfg.locked_hook
    end
    local unlocked = function()
        waywall.set_remaps(unlocked_remaps)
        lock_enabled = false
        return cfg.unlocked_hook
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
end

return M
