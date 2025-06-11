---@diagnostic disable:missing-fields

---@module 'user_api.types.blink_cmp'

local User = require('user_api')

local exists = User.check.exists.module

if not exists('blink.cmp') then
    return
end

local Config = require('plugin.blink_cmp.config')

local Cfg = Config.new()

User:register_plugin('plugin.blink_cmp')

local Blink = require('blink.cmp')

if exists('luasnip.loaders.from_vscode') then
    require('luasnip.loaders.from_vscode').lazy_load()
end

Blink.setup(Cfg.Config)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
