local User = require('user_api')
local Check = User.check
local types = User.types.telescope
local WK = User.maps.wk

local exists = Check.exists.module
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

---@type TelCC|nil
local M = nil

if not exists('telescope') or not exists('telescope._extensions.conventional_commits.actions') then
    return M
end

local function create_cc()
    local Actions = require('telescope._extensions.conventional_commits.actions')
    local Themes = require('telescope.themes')

    local picker = require('telescope._extensions.conventional_commits.picker')

    -- if you use the picker directly you have to provide your theme manually
    local opts = {
        action = Actions.prompt,
        include_body_and_footer = false,
    }

    picker(vim.tbl_extend('keep', opts, Themes.get_dropdown({})))
end

M = {
    cc = {
        theme = 'dropdown', -- custom theme
        action = function(entry)
            entry = {
                display = 'feat       A new feature',
                index = 7,
                ordinal = 'feat',
                value = 'feat',
            }
            vim.print(entry)
        end,
        include_body_and_footer = true, -- Add prompts for commit body and footer
    },

    loadkeys = function()
        if WK.available() then
            map_dict({ ['<leader>Gc'] = { group = '+Commit' } }, 'wk.register', false, 'n')
        end
        map_dict({
            ['<leader>GcC'] = {
                create_cc,
                desc('Create Conventional Commit'),
            },
        }, 'wk.register', false, 'n')
    end,
}

return M
