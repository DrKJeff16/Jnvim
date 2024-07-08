---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.telescope
local WK = User.maps.wk

local exists = Check.exists.module
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('telescope') or not exists('telescope._extensions.conventional_commits.actions') then
    return
end

local function create_conventional_commit()
    local Actions = require('telescope._extensions.conventional_commits.actions')
    local Themes = require('telescope.themes')

    local picker = require('telescope._extensions.conventional_commits.picker')

    -- if you use the picker directly you have to provide your theme manually
    local opts = {
        action = Actions.prompt,
        include_body_and_footer = false,
    }
    opts = vim.tbl_extend('force', opts, Themes['get_ivy']())
    picker(opts)
end

---@class TelCC.Opts
---@field theme? 'ivy'|'dropdown'|'cursor'
---@field action? fun(entry: table)
---@field include_body_and_footer? boolean

---@class TelCC
---@field cc TelCC.Opts
---@field loadkeys fun()
local M = {}

M.cc = {
    theme = 'ivy', -- custom theme
    action = function(entry)
        --[[ entry = {
            display = 'feat       A new feature',
            index = 7,
            ordinal = 'feat',
            value = 'feat',
        } ]]
        vim.print(entry)
    end,
    include_body_and_footer = true, -- Add prompts for commit body and footer
}

function M.loadkeys()
    if WK.available() then
        map_dict({ ['<leader>Gc'] = { name = '+Commit' } }, 'wk.register', false, 'n')
    end
    map_dict({
        ['<leader>GcC'] = {
            create_conventional_commit,
            desc('Create conventional commit'),
        },
    }, 'wk.register', false, 'n')
end

return M
