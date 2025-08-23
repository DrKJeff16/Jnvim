local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('blink.cmp') then
    User.deregister_plugin('plugin.blink_cmp')
    return
end

local Blink = require('blink.cmp')
local Config = require('plugin.blink_cmp.config')

if exists('luasnip.loaders.from_vscode') then
    require('luasnip.loaders.from_vscode').lazy_load()
end

Blink.setup(Config.Config)

User.register_plugin('plugin.blink_cmp')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
