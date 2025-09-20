local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('nvim-ts-autotag') then
    User.deregister_plugin('plugin.ts.autotag')
    return
end

local AutoTag = require('nvim-ts-autotag')

AutoTag.setup({
    opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing `</`
    },

    ---Also override individual filetype configs, these take priority.
    ---
    ---Empty by default, useful if one of the `opts` global settings
    ---doesn't work well in a specific filetype.
    --- ---
    per_filetype = {},
})

User.register_plugin('plugin.ts.autotag')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
