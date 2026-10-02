-- ==== VARS ====
local waywall = require("waywall")

local cfg = {
    hotbar_keys = {
        "1",
        "2",
        "3",
        "4",
        "G",
        "C",
        "T",
        "F",
        "R"
    }
    text_look = {
        enabled = true,
        x = 2560 - 100,
        y = 1440 - 100,
        size = 5,
        color = "#F5793A",
    }
    toggle_key = "GRAVE",
    locked_hook = nil,
    unlocked_hook = nil,
}

local M       = {}
-- ==== PLUG ====
M.setup       = function(config, cfg)
    local text_obj = nil

    local locked_remaps = {}
    local remaps_fast = {}
    for key, val in pairs(config.input.remaps) do
        locked_remaps[key] = val
        unlocked_remaps[key] = val
    end

    local lock_enabled = false
    local locked = function()
        waywall.set_remaps(locked_remaps)
        lock_enabled = true
        cfg.locked_hook
    end
    local unlocked = function()
        waywall.set_remaps(unlocked_remaps)
        lock_enabled = false
        cfg.unlocked_hook
    end


    waywall.listen("state", function()
        local state = waywall.state()
        if state.screen == "generating" or state.screen == "wall" and not reset_enabled then
            waywall.set_resolution(0, 0)
            reset_mode()
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
        end
    end)

    waywall.listen("resolution", function()
        local act_width, act_height = waywall.active_res()
        if act_width == cfg.thin_res.w and act_height == cfg.thin_res.h and reset_enabled then
            if text_obj then
                text_obj:close()
                text_obj = nil
            end
            normal_mode()
        end
    end)
end

return M
