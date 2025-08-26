local User = require('user_api')
local Check = User.check

local Keymaps = require('user_api.config.keymaps')
local exists = Check.exists.module
local desc = User.maps.desc

if not exists('telescope._extensions.conventional_commits.actions') then
    User.deregister_plugin('plugin.telescope.cc')
    return nil
end

---@class TelCC
local CC = {}

local function create_cc()
    local Actions = require('telescope._extensions.conventional_commits.actions')
    local Themes = require('telescope.themes')

    local picker = require('telescope._extensions.conventional_commits.picker')

    -- if you use the picker directly you have to provide your theme manually
    local Opts = {
        action = Actions.prompt,
        include_body_and_footer = true,
    }

    picker(vim.tbl_extend('keep', Opts, Themes.get_dropdown({})))
end

---@class TelCC.Opts
CC.cc = {
    theme = 'dropdown', -- custom theme
    action = function(_)
        local entry = {
            display = 'feat       A new feature',
            index = 7,
            ordinal = 'feat',
            value = 'feat',
        }
        vim.print(entry)
    end,
    include_body_and_footer = true, -- Add prompts for commit body and footer
}

function CC.loadkeys()
    ---@type AllMaps
    local Keys = {
        ['<leader>Gc'] = { group = '+Commit' },

        ['<leader>GcC'] = {
            create_cc,
            desc('Create Conventional Commit'),
        },
    }

    Keymaps({ n = Keys })
end

User.register_plugin('plugin.telescope.cc')

return CC

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
