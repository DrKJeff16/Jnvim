local User = require('user_api')
local Exists = User.check.exists

local exists = Exists.module
local executable = Exists.executable

if not (exists('telescope') and exists('telescope-makefile')) then
    return
end

if not (executable('make') and executable('mingw32-make')) then
    return
end

local TMK = require('telescope-makefile')
local Telescope = require('telescope')

TMK.setup({
    default_target = '[DEFAULT]',
    make_bin = not is_windows and 'make' or 'mingw32-make',
})

Telescope.load_extension('make')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
