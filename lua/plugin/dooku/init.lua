local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('dooku') then
    return
end
User:register_plugin('plugin.dooku')

local Dooku = require('dooku')

Dooku.setup({
    project_root = {
        '.git',
        '.github',
        '.hg',
        '.svn',
        '.bzr',
        '_darcs',
        '_FOSSIL_',
        '.fslckout',
        'Pipfile',
    }, -- when one of these files is found, consider that directory the project root. Search starts upwards from the current buffer.
    browser_cmd = 'firefox', -- write your internet browser here. If unset, it will attempt to detect it automatically.

    -- automations
    on_bufwrite_generate = false, -- auto run :DookuGenerate when a buffer is written.
    on_generate_open = true, -- auto open when running :DookuGenerate. This options is not triggered by on_bufwrite_generate.
    auto_setup = true, -- auto download a config for the generator if it doesn't exist in the project.

    -- notifications
    on_generate_notification = true,
    on_open_notification = true,
})
