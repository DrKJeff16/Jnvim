---@class JLine.Theme.Spec
---@field bg string
---@field fg string
---@field darkblue string
---@field red string
---@field green string
---@field yellow string
---@field violet string
---@field cyan string
---@field blue string
---@field magenta string
---@field orange string

---@class JLine.Themes
---@field default table|JLine.Theme.Spec
---@field tokyonight? table|JLine.Theme.Spec
---@field catppuccin_mocha? table|JLine.Theme.Spec
---@field catppuccin_macchiato? table|JLine.Theme.Spec
---@field catppuccin_frappe? table|JLine.Theme.Spec
---@field nightfox? table|JLine.Theme.Spec

---@class JLine.Util
---@field curr_theme? JLine.Theme.Spec
---@field themes JLine.Themes
---@field file_readonly fun(icon: string?): ''|string
---@field dimensions fun(): { integer: integer, integer: integer }
---@field palette fun(self: JLine.Util): JLine.Theme.Spec

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
