local wezterm = require 'wezterm';

local config = {
    color_scheme = "Gruvbox Dark",
    font = wezterm.font("JetBrains Mono", {weight="Medium", stretch="Normal", style="Normal"}),
    font_size = 14,
    hide_tab_bar_if_only_one_tab = true,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    audible_bell = "Disabled",

    -- -- https://docs.rs/regex/1.3.9/regex/#syntax
    -- hyperlink_rules = {
    --     -- Linkify things that look like URLs
    --     -- This is actually the default if you don't specify any hyperlink_rules
    --     {
    --         regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
    --         format = "$0",
    --     },
    -- },

}

local has_private, private = pcall(require, 'private')
if has_private then
    for k,v in pairs(private) do config[k] = v end
end

return config
