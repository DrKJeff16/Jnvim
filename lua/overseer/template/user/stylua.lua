local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable

if not executable('stylua') then
    return {
        name = 'Format With Stylua',
        desc = 'Format Lua file with stylua',
        builder = function()
            local file = vim.fn.expand('%:p')
            local cmd = { 'stylua' }
            return {
                cmd = cmd,
                args = { file },
                components = {
                    'default',
                },
                metadata = {
                    author = 'DrKJeff16',
                    date = '2024-08-18',
                },
            }
        end,
        condition = { filetype = { 'lua' } },
    }
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
