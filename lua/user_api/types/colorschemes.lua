---@meta

---@alias Cpc.Variants 'frappe'|'latte'|'macchiato'|'mocha'

---@alias OD.Variant ('dark'|'darker'|'cool'|'deep'|'warm'|'warmer'|'light')
---@alias OD.Diagnostics table<'darker'|'undercurl'|'background', boolean>

---@class OD
---@field style? OD.Variant
---@field transparent? boolean
---@field term_colors? boolean
---@field ending_tildes? boolean
---@field cmp_itemkind_reverse? boolean
---@field toggle_style_key? nil|string
---@field toggle_style_list? string[]
---@field code_style? table<string, string>
---@field lualine? table
---@field colors? table
---@field highlights? table
---@field diagnostics? OD.Diagnostics

---@class TN.Variants
---@field [1] 'night'
---@field [2] 'moon'
---@field [3] 'day'

--- A loadable color schemes table
---
--- ## Fields
--- - `variants`: An optional string array displaying the variants of said colorscheme.
---             **NOTE: Need to check if it exists**
--- - `mod_cmd`: A **protected** string to pass to `vim.cmd`. It **MUST** look like `'colorscheme ...'`
--- - `setup`: If the colorscheme is found (either as a Lua module or a `vim.g` variable)
---          it becomes a function to setup and set the colorscheme.
---          Otherwise it defaults to `nil`
---
--- If the colorscheme is not a lua plugin, use `vim.g` as a check instead
---@class CscSubMod
---@field setup fun(self: CscSubMod, variant: string?, transparent: boolean?, override: table?)
---@field variants? string[]
---@field mod_cmd string
---@field new fun(O: table?): CscSubMod|table

---@see CscSubMod
--- A `CscSubMod` variant but for the `onedark.nvim` colorscheme
---@class ODSubMod: CscSubMod
---@field setup fun(self: ODSubMod, variant: OD.Variant, transparent: boolean?, override: OD?)|nil
---@field new fun(O: table?): ODSubMod|table
---@field variants OD.Variant[]

--- A `CscSubMod` variant but for the `dracula` colorscheme
---@class DraculaSubMod
---@field setup fun(self: DraculaSubMod)
---@field new fun(O: table?): DraculaSubMod|table
---@field mod_cmd string

---@see CscSubMod
--- A `CscSubMod` variant but for the `catppuccin.nvim` colorscheme
---@class CpcSubMod: CscSubMod
---@field variants Cpc.Variants
---@field setup fun(self: CpcSubMod, variant: Cpc.Variant, transparent: boolean?, override: CatppuccinOptions|table?)
---@field new fun(O: table?): CpcSubMod|table

---@see CscSubMod
--- A table for each **explicitly** configured colorscheme
---
--- ## Description
--- The colorschemes must comply with the `CscSubMod` type specifications
---
---@class CscMod
---@field catppuccin CpcSubMod
---@field dracula DraculaSubMod
---@field gloombuddy CscSubMod
---@field gruvbox CscSubMod
---@field kanagawa CscSubMod
---@field molokai CscSubMod
---@field nightfox CscSubMod
---@field oak CscSubMod
---@field onedark ODSubMod
---@field space_vim_dark CscSubMod
---@field spaceduck CscSubMod
---@field spacemacs CscSubMod
---@field tokyonight CscSubMod
---@field vscode CscSubMod
---@field new fun(O: table?): CscMod|table

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
