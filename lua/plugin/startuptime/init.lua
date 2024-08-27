local User = require('user_api')
local Check = User.check

local is_int = Check.value.is_int
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict
local hi = User.highlight.hl

if not is_int(vim.g.installed_startuptime) or vim.g.installed_startuptime ~= 1 then
    return
end

User:register_plugin('plugin.startuptime')

local flags = {
    more_info_key_seq = 'K',
    split_edit_key_seq = 'gf',
    sort = true,
    tries = 10,
    sourcing_events = true,
    other_events = true,
    sourced = true,
    event_width = 0,
    time_width = 8,
    plot_width = 30,
    colorize = true,
    use_blocks = vim.opt.encoding:get() == 'utf-8',
    fine_blocks = not is_windows,
    startup_indent = 8,
    zero_progress_msg = true,
    zero_progress_time = 2500,
}

for flag, val in next, flags do
    vim.g['startuptime_' .. flag] = val
end

---@type KeyMapDict
local Keys = {
    ['<leader>vS'] = {
        function() vim.cmd('StartupTime') end,
        desc('Run StartupTime'),
    },
}

map_dict(Keys, 'wk.register', false, 'n')
map_dict(Keys, 'wk.register', false, 'v')

hi('StartupTimeSourcingEvent', { link = 'Title' })

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
