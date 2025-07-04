---@meta

error('(config._types): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@module 'user_api.types.user.maps'
---@module 'user_api.types.lsp'

---@class Keymaps.PreExec
---@field ft string[]
---@field bt string[]

---@class Config.Keymaps
---@field NOP string[] Table of keys to no-op after `<leader>` is pressed
---@field no_oped? boolean
---@field Keys AllModeMaps
---@field set_leader fun(self: Config.Keymaps, leader: string, local_leader: string?, force: boolean?)
---@field setup fun(self: Config.Keymaps, keys: AllModeMaps, bufnr: integer?, load_defaults: boolean?)
---@field new fun(O: table?): table|Config.Keymaps|fun(keys: AllModeMaps, bufnr: integer?, load_defaults: boolean?)

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
