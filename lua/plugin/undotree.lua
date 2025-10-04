---@module 'lazy'

---@type LazySpec
return {
    'jiaoshijie/undotree',
    dev = true,
    version = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('undotree').setup({
            float_diff = true,
            layout = 'left_bottom',
            position = 'left',
            ignore_filetype = {
                'TelescopePrompt',
                'help',
                'lazy',
                'notify',
                'qf',
                'spectre_panel',
                'tsplayground',
                'undotree',
                'undotreeDiff',
            },
            window = { winblend = 10 },
            keymaps = {
                J = 'move_change_next',
                K = 'move_change_prev',
                ['<cr>'] = 'action_enter',
                gj = 'move2parent',
                j = 'move_next',
                k = 'move_prev',
                p = 'enter_diffbuf',
                q = 'quit',
            },
        })
        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader><M-u>'] = { require('undotree').toggle, desc('Toggle UndoTree') },
            },
        })
        vim.api.nvim_create_user_command('Undotree', function(ctx)
            if vim.tbl_isempty(ctx.fargs) then
                require('undotree').toggle()
                return
            end
            local cmd = ctx.fargs[1]
            if cmd == 'toggle' then
                require('undotree').toggle()
            elseif cmd == 'open' then
                require('undotree').open()
            elseif cmd == 'close' then
                require('undotree').close()
            else
                vim.notify('Invalid subcommand: ' .. (cmd or ''), vim.log.levels.ERROR)
            end
        end, {
            nargs = '?',
            desc = 'Undotree command with subcommands: toggle, open, close',
            complete = function(_, line)
                local input = vim.split(line, '%s+')
                local prefix = input[#input]
                return vim.tbl_filter(function(cmd)
                    return vim.startswith(cmd, prefix)
                end, { 'toggle', 'open', 'close' })
            end,
        })
    end,
}
