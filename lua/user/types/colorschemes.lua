---@alias OD.style ('dark'|'darker'|'cool'|'deep'|'warm'|'warmer'|'light')

---@alias OD.Diagnostics table<'darker'|'undercurl'|'background', boolean>

---@class OD
---@field style? OD.style
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

--- A loadable color schemes table.
--- ---
--- Each colorscheme is a table with **three** items:
--- * `mod_pfx`: A **protected** string for internal calls
--- * `mod_cmd`: A **protected** string to pass to `vim.cmd`. It **MUST** look like `'colorscheme ...'`.
--- * `setup`: A function to setup and set the colorscheme.
---
--- If the colorscheme is not a lua plugin, use `vim.g` as a check instead.
---@class CscSubMod
---@field setup? fun(...)
---@field protected mod_pfx string
---@field mod_cmd string

--- A loadable color schemes table.
--- ---
--- Each colorscheme is a table with **three** items:
--- * `mod_pfx`: A **protected** string for internal calls
--- * `mod_cmd`: A **protected** string to pass to `vim.cmd`. It **MUST** look like `'colorscheme ...'`.
--- * `setup`: A function to setup and set the colorscheme.
---
--- If the colorscheme is not a lua plugin, use `vim.g` as a check instead.
---@class ODSubMod: CscSubMod
---@field setup? fun(style: OD.style?)

--- A table for each **explicitly** configured colorscheme.
--- ---
--- The colorschemes must comply with the `CscSubMod` type specifications.
--- ---
---@class CscMod
---@field tokyonight? CscSubMod|nil
---@field onedark? ODSubMod|nil
---@field catppuccin? CscSubMod|nil
---@field nightfox? CscSubMod|nil
---@field spaceduck? CscSubMod|nil
---@field dracula? CscSubMod|nil
---@field molokai? CscSubMod|nil
---@field gloombuddy? CscSubMod|nil
---@field oak? CscSubMod|nil
---@field new? fun(): CscMod
---@field __index? CscMod
