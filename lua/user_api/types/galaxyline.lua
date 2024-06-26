---@class JLine.Themes
---@field default table
---@field tokyonight? ColorScheme
---@field catppuccin_mocha? table
---@field catppuccin_macchiato? table
---@field catppuccin_frappe? table
---@field nightfox? table

---@class JLine.Util
---@field themes JLine.Themes
---@field file_readonly fun(icon: string?): ''|string
---@field dimensions fun(): { integer: integer, integer: integer }

--- TODO: Do this
---@class JLine.Highlight.Spec

---@class JLine.Section.Component
---@field highlight? JLine.Highlight.Spec
---@field separator_highlight? JLine.Highlight.Spec
---@field icon? string
---@field provider string|fun(...): string
---@field separator? string
---@field condition? boolean

---@alias JLine.Section JLine.Section.Component[]

---@class JLine
---@field left? JLine.Section
---@field mid? JLine.Section
---@field right? JLine.Section
