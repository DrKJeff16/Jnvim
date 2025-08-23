local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

local validate = vim.validate

---@class User.Distro
local Distro = {}

Distro.archlinux = require('user_api.distro.archlinux')
Distro.termux = require('user_api.distro.termux')

---@type User.Distro|fun(verbose?: boolean)
return setmetatable({}, {
    __index = Distro,

    __newindex = function(_, _, _)
        error('User.Distro table is Read-Only!', ERROR)
    end,

    ---@param verbose? boolean
    __call = function(_, verbose)
        validate('verbose', verbose, 'boolean', true)

        verbose = verbose ~= nil and verbose or false

        local msg = ''

        if Distro.termux.validate() then
            Distro.termux()
            msg = 'Termux distribution detected...'
        elseif Distro.archlinux.validate() then
            Distro.archlinux()
            msg = 'Arch Linux distribution detected...'
        end

        if verbose and msg ~= '' then
            vim.notify(msg, INFO)
        end
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
