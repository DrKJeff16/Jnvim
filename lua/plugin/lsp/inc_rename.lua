---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local WK = User.maps.wk

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_num = Check.value.is_num
local is_bool = Check.value.is_bool
local is_int = Check.value.is_int
local is_fun = Check.value.is_bool
local empty = Check.value.empty
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('inc_rename') then
    return
end

User:register_plugin('plugin.lsp.inc_rename')

local IR = require('inc_rename')

IR.setup({
    cmd_name = 'IncRename',
    hl_group = 'Substitute',
    preview_empty_name = true,
    show_message = false,
    save_in_cmdline_history = true,
    input_buffer_type = 'dressing',
    post_hook = nil,
})

---@type KeyMapDict|RegKeys|RegKeysNamed
local Keys = {
    ['<leader>r'] = { group = '+IncRename' },

    ['<leader>rn'] = {
        ':IncRename ',
        desc('Rename (IncRename)', false, nil, true, true, true),
    },
}

vim.schedule(function()
    local Keymaps = require('config.keymaps')

    Keymaps:setup({ n = Keys })
end)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
