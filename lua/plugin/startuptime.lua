local User = require('user_api')

local desc = User.maps.desc
local hi = User.highlight.hl
local Keymaps = require('user_api.config.keymaps')

if not vim.g.installed_startuptime or vim.g.installed_startuptime ~= 1 then
    User.deregister_plugin('plugin.startuptime')
    return
end

local Flags = {
    colorize = true,
    event_width = 0,
    fine_blocks = not is_windows,
    more_info_key_seq = 'K',
    other_events = true,
    plot_width = 30,
    sort = true,
    sourced = true,
    sourcing_events = true,
    split_edit_key_seq = 'gf',
    startup_indent = 8,
    time_width = 8,
    tries = 10,
    use_blocks = vim.o.encoding == 'utf-8',
    zero_progress_msg = true,
    zero_progress_time = 2500,
}

for flag, val in next, Flags do
    vim.g['startuptime_' .. flag] = val
end

---@type AllMaps
local Keys = {
    ['<leader>vS'] = {
        vim.cmd.StartupTime,
        desc('Run StartupTime'),
    },
}

Keymaps({ n = Keys })

hi('StartupTimeSourcingEvent', { link = 'Title' })

User.register_plugin('plugin.startuptime')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
