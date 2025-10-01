---@module 'lazy'

---@type LazySpec
return {
    'dstein64/vim-startuptime',
    lazy = false,
    priority = 1000,
    version = false,
    init = require('config.util').flag_installed('startuptime'),
    ---@type table<string, any>
    opts = {
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
    },
    config = function(_, opts) ---@param opts table<string, any>
        for flag, val in pairs(opts) do
            vim.g[('startuptime_%s'):format(flag)] = val
        end
        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader>vS'] = {
                    vim.cmd.StartupTime,
                    desc('Run StartupTime'),
                },
            },
        })
        require('user_api.highlight').hl_from_dict({
            ['StartupTimeSourcingEvent'] = { link = 'Title' },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
