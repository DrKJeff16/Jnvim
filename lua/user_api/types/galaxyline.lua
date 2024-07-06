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

---@class CtpColors.Spec
---@field base? string
---@field blue? string
---@field crust? string
---@field flamingo? string
---@field green? string
---@field lavender? string
---@field mantle? string
---@field maroon? string
---@field mauve? string
---@field overlay0? string
---@field overlay1? string
---@field overlay2? string
---@field peach? string
---@field pink? string
---@field red? string
---@field rosewater? string
---@field sapphire? string
---@field sky? string
---@field subtext0? string
---@field subtext1? string
---@field surface0? string
---@field surface1? string
---@field surface2? string
---@field teal? string
---@field text? string
---@field yellow? string

---@alias JLine.Ctp.Spec
---|CtpColors<string>
---|CtpColors.Spec

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
