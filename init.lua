_G.MYVIMRC = vim.fn.stdpath('config') .. '/init.lua'
_G.newline = string.char(10)

_G.inspect = vim.inspect

local User = require('user_api') ---@see User User API

require('user_api.types')

local Check = User.check ---@see User.check Checking utilities
local Util = User.util ---@see User.util General utilities
local Opts = User.opts ---@see User.opts Option setting
local Commands = User.commands ---@see User.commands User command generation (WIP)
local Distro = User.distro ---@see User.distro Platform-specific optimizations (WIP)

local Keymaps = require('config.keymaps')

local is_nil = Check.value.is_nil ---@see User.Check.Value.is_nil
local is_tbl = Check.value.is_tbl ---@see User.Check.Value.is_tbl
local empty = Check.value.empty ---@see User.Check.Value.empty
local desc = User.maps.kmap.desc ---@see User.Maps.Keymap.desc
local map_dict = User.maps.map_dict ---@see User.Maps.map_dict
local wk_avail = User.maps.wk.available ---@see User.Maps.WK.available
local displace_letter = Util.displace_letter ---@see User.Util.displace_letter
local capitalize = Util.string.capitalize ---@see User.Util.String.capitalize

local curr_buf = vim.api.nvim_get_current_buf
local curr_win = vim.api.nvim_get_current_win

_G.is_windows = not is_nil((vim.uv or vim.loop).os_uname().version:match('Windows'))

---@see User.Opts.setup
---@diagnostic disable-next-line:missing-fields
Opts:setup({ ---@see User.Opts.Spec For more info
    bg = 'dark', -- `background`
    bs = { 'indent', 'eol', 'start' }, -- `backspace`
    cmdwinheight = 8,
    ci = false, -- `copyindent`
    completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' },
    confirm = true,
    equalalways = true,
    et = true, -- `expandtab`
    fo = { -- `formatoptions`
        b = true,
        c = false,
        j = true,
        l = true,
        n = true,
        o = true,
        p = true,
        q = true,
        w = true,
    },
    hlg = { 'en' }, -- `helplang`
    hls = true, -- `hlsearch`
    ignorecase = false,
    incsearch = true,
    matchtime = 30,
    menuitems = 40,
    mouse = { a = false },
    nu = true, -- `number`
    pi = false, -- `preserveindent`
    rnu = false, -- `relativenumber`
    ru = true, -- `ruler`
    so = 3, -- `scrolloff`
    sessionoptions = { 'buffers', 'tabpages', 'globals' },
    sw = 4, -- `shiftwidth`
    showmatch = true,
    showmode = false,
    stal = 2, -- `showtabline`
    signcolumn = 'yes',
    sts = 4, -- `softtabstop`
    spell = false,
    splitbelow = true,
    splitright = true,
    ts = 4, -- `tabstop`
    title = true,
    wrap = true,
})

Keymaps:set_leader('<Space>')

vim.g.markdown_minlines = 500

--- Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--- Uncomment to use system clipboard
--- vim.o.clipboard = 'unnamedplus'

--- List of manually-callable plugin
_G.Pkg = require('config.lazy')

--- Setup keymaps
Keymaps:setup({
    n = {
        ['<leader>fii'] = {
            function()
                local buf = curr_buf()

                if not vim.api.nvim_get_option_value('modifiable', { buf = buf }) then
                    return
                end

                local win = curr_win()
                local saved_pos = vim.api.nvim_win_get_cursor(win)
                vim.api.nvim_feedkeys('gg=G', 'n', false)

                -- Wait for `feedkeys` to end, then reset to position
                vim.schedule(function() vim.api.nvim_win_set_cursor(win, saved_pos) end)
            end,
            desc('Indent Whole File'),
        },
        ['<leader>vM'] = {
            function() vim.cmd('messages') end,
            desc('Run `:messages`'),
        },
        ['<leader>vN'] = {
            function()
                ---@diagnostic disable-next-line
                pcall(vim.cmd, 'Notifications')
            end,
            desc('Run `:Notifications`'),
        },
    },
})

--- A table containing various possible colorschemes
local Csc = Pkg.colorschemes

---@type KeyMapDict
local CscKeys = {}

--- Reorder to your liking
local selected = {
    'kanagawa',
    'tokyonight',
    'nightfox',
    'catppuccin',
    'vscode',
    'onedark',
    'gruvbox',
    'spacemacs',
    'molokai',
    'oak',
    'spaceduck',
    'dracula',
    'space_vim_dark',
}

---@type RegKeysNamed
local NamesCsc = {
    ['<leader>vc'] = { group = '+Colorschemes' },
}

local csc_group = 'A'
local i = 1
local found_csc = ''

-- TODO: Use `Keymaps:setup()` instead of `map_dict()`
-- TODO: Try to put the following loop inside a function
-- NOTE: This was also a pain in the ass
--
-- Generate keybinds for each colorscheme that is found
-- Try checking them by typing `<leader>vc` IN NORMAL MODE
for _, name in next, selected do
    ---@type CscSubMod|ODSubMod|table
    local TColor = Csc[name]

    if is_nil(TColor.setup) then
        goto continue
    end
    found_csc = found_csc ~= '' and found_csc or name

    NamesCsc['<leader>vc' .. csc_group] = {
        group = '+Group ' .. csc_group,
    }

    if is_tbl(TColor.variants) and not empty(TColor.variants) then
        local v = 'a'
        for _, variant in next, TColor.variants do
            NamesCsc['<leader>vc' .. csc_group .. tostring(i)] = {
                group = '+' .. capitalize(name),
            }
            CscKeys['<leader>vc' .. csc_group .. tostring(i) .. v] = {
                function() TColor.setup(variant) end,
                desc('Set Colorscheme `' .. capitalize(name) .. '` (' .. variant .. ')'),
            }

            v = displace_letter(v, 'next', false)
        end
    else
        CscKeys['<leader>vc' .. csc_group .. tostring(i)] = {
            TColor.setup,
            desc('Set Colorscheme `' .. capitalize(name) .. '`'),
        }
    end

    -- NOTE: This was TOO PAINFUL to get right (including `displace_letter`)
    if i == 9 then
        -- If last  keymap set ended on 9, reset back to 1, and go to next letter alphabetically
        i = 1
        csc_group = displace_letter(csc_group, 'next', false)
    elseif i < 9 then
        i = i + 1
    end

    ::continue::
end

if wk_avail() then
    map_dict(NamesCsc, 'wk.register', false, 'n')
end
map_dict(CscKeys, 'wk.register', false, 'n')

if not empty(found_csc) then
    Csc[found_csc].setup()
end

--- Call the User API file associations and other autocmds
Util.assoc()

vim.g.markdown_minlines = 500

--- Call runtimepath optimizations for Arch Linux (WIP)
Distro.termux:setup()

-- Define any custom commands
Commands:setup()

-- Mappings related specifically to `user_api`
User:setup_keys()

vim.cmd([[
filetype plugin indent on
syntax on
]])

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
