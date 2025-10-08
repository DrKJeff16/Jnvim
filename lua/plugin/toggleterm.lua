---@module 'lazy'

local function set_terminal_keymaps(ev) ---@param ev vim.api.keyset.create_autocmd.callback_args
    if not ev then
        return
    end
    local bufnr = ev.buf
    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
        t = {
            ['<Esc>'] = {
                [[<C-\><C-n>]],
                desc('Escape Terminal', true, bufnr),
            },
            ['<C-e>'] = {
                [[<C-\><C-n>]],
                desc('Escape Terminal', true, bufnr),
            },
            ['<C-h>'] = {
                function()
                    vim.cmd.wincmd('h')
                end,
                desc('Goto Left Window', true, bufnr),
            },
            ['<C-j>'] = {
                function()
                    vim.cmd.wincmd('j')
                end,
                desc('Goto Down Window', true, bufnr),
            },
            ['<C-k>'] = {
                function()
                    vim.cmd.wincmd('k')
                end,
                desc('Goto Up Window', true, bufnr),
            },
            ['<C-l>'] = {
                function()
                    vim.cmd.wincmd('l')
                end,
                desc('Goto Right Window', true, bufnr),
            },
            ['<C-w>'] = {
                [[<C-\><C-n><C-w>w]],
                desc('Switch Window', true, bufnr),
            },
        },
    }, bufnr)
end

---@type LazySpec
return {
    'akinsho/toggleterm.nvim',
    lazy = true,
    version = false,
    keys = {
        {
            '<C-t>',
            '<CMD>exe v:count1 . "ToggleTerm"<CR>',
            mode = { 'n', 'i', 't' },
            desc = 'ToggleTerm',
            noremap = true,
        },
    },
    enabled = not require('user_api.check').in_console(),
    opts = {
        size = function(term) ---@param term Terminal
            return term.direction == 'vertical' and math.floor(vim.o.columns * 0.65)
                or (function()
                    return math.floor(vim.o.columns * 0.85)
                end)()
        end,
        open_mapping = [[<C-t>]],
        autochdir = true,
        hide_numbers = true,
        direction = 'float', ---@type 'float'|'tab'|'horizontal'|'vertical'
        close_on_exit = true,
        opts = {
            border = 'rounded',
            title_pos = 'center',
            width = (function()
                return math.floor(vim.o.columns * 0.85)
            end)(),
        },
        highlights = {
            Normal = { guibg = '#291d3f' },
            NormalFloat = { link = 'Normal' },
            FloatBorder = { guifg = '#c5c7a1', guibg = '#21443d' },
        },
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = -30,
        shading_ratio = -3,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        shell = vim.o.shell,
        auto_scroll = true,
        persist_size = true,
        persist_mode = true,
        float_opts = {
            border = 'curved',
            title_pos = 'center',
            zindex = 100,
            winblend = 3,
        },
        winbar = {
            enabled = true,
            name_formatter = function(term) ---@param term Terminal
                return term.name
            end,
        },
    },
    config = function(_, opts)
        require('toggleterm').setup(opts)
        local aus = { ---@type AuDict
            TermOpen = {
                group = vim.api.nvim_create_augroup('ToggleTerm.Hooks', { clear = false }),
                callback = set_terminal_keymaps,
            },
        }
        for event, v in next, aus do
            vim.api.nvim_create_autocmd(event, v)
        end
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
