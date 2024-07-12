---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_num = Check.value.is_num
local is_bool = Check.value.is_bool
local is_int = Check.value.is_int
local is_fun = Check.value.is_bool
local empty = Check.value.empty

if not exists('nvim-web-devicons') then
    return
end

local WDI = require('nvim-web-devicons')

WDI.setup({
    override = {},
    color_icons = true,
    default_icons = true,
    strict = true,
    override_by_filename = {
        ['.gitignore'] = {
            icon = '',
            color = '#f1502f',
            name = 'Gitignore',
        },
    },
    override_by_operating_system = {
        ['apple'] = {
            icon = '',
            color = '#A2AAAD',
            cterm_color = '248',
            name = 'Apple',
        },
    },
})
