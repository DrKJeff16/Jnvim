local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.kmap.desc

if not exists('inc_rename') then
    return
end

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
        desc('Rename (IncRename)', false),
    },
}

Keymaps({ n = Keys })

User.register_plugin('plugin.lsp.inc_rename')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
