---@meta

error('(config._types): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@module 'plugin._types.lsp'

---@class Config.Util
---@field set_tgc fun(force: boolean?)
---@field flag_installed fun(name: string): fun()
---@field colorscheme_init fun(self: Config.Util, fields: string|table<string, any>, force_tgc: boolean?): fun()
---@field source fun(mod_str: string): fun()
---@field tel_fzf_build fun(): string
---@field luarocks_check fun(): boolean
---@field key_variant fun(cmd: ('ed'|'tabnew'|'split'|'vsplit')?): fun()
---@field has_tgc fun(): boolean

---@class Config.Lazy
---@field colorschemes fun(): table|CscMod|fun(color: string?, ...)
---@field lsp fun(): table|Lsp.Server|fun()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
