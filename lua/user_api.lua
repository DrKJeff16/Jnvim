---@class UserAPI
---@field FAILED? string[]
---@field paths? string[]
local User = {}

User.util = require('user_api.util')
User.check = require('user_api.check')
User.distro = require('user_api.distro')
User.maps = require('user_api.maps')
User.opts = require('user_api.opts')
User.commands = require('user_api.commands')
User.update = require('user_api.update')
User.highlight = require('user_api.highlight')
User.config = require('user_api.config')

function User.setup_maps()
    local Keymaps = User.config.keymaps
    local desc = User.maps.desc
    local displace_letter = User.util.displace_letter
    User.paths = {}

    ---@type AllMaps
    local Keys = { ['<leader>Pe'] = { group = '+Edit Plugin Config' } }
    local group, i, cycle = 'a', 1, 1
    while i < #User.paths do
        local name = User.paths[i]
        Keys['<leader>Pe' .. group] = { group = '+Group ' .. group:upper() }
        Keys['<leader>Pe' .. group .. tostring(cycle)] = {
            function()
                vim.cmd.tabnew(name)
            end,
            desc(vim.fn.fnamemodify(name, ':h:t') .. '/' .. vim.fn.fnamemodify(name, ':t')),
        }
        if cycle == 9 then
            group = displace_letter(group, 'next')
            cycle = 1
        elseif cycle < 9 then
            cycle = cycle + 1
        end
        i = i + 1
    end

    Keymaps({ n = Keys })
end

---@param opts? table
function User.setup(opts)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('opts', opts, 'table', true, 'table?')
    else
        vim.validate({ opts = { opts, { 'table', 'nil' } } })
    end
    opts = opts or {}

    local Keymaps = User.config.keymaps
    Keymaps({ n = { ['<leader>U'] = { group = '+User API' } } })

    User.setup_maps()
    User.commands.setup()
    User.update.setup()
    User.opts.setup_maps()
    User.opts.setup_cmds()
    User.util.setup_autocmd()
    User.distro()
    User.config.neovide.setup()
end

return User
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
