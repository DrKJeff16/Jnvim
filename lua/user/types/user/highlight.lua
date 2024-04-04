---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias HlOpts vim.api.keyset.highlight

---@class HlPair
---@field name string
---@field opts HlOpts

---@alias HlDict table<string, HlOpts>
---@alias HlRepeat table<string, HlOpts[]>

---@class HlHex
---@field black '#000000'
---@field red '#ff0000'
---@field green '#00ff00'
---@field yellow '#ffff00'
---@field blue '#0000ff'
---@field cyan '#00ffff'
---@field magenta '#f050f0'
---@field white '#ffffff'

---@class HlHexDark
---@field grey '#909090'
---@field red '#9f0000'
---@field green '#009f00'
---@field yelliw '#d0d000'
---@field blue '#00009f'
---@field cyan '#009f9f'
---@field magenta '#902090'
---@field white '#c0c0c0'

---@class HlColorsHex
---@field normal? HlHex
---@field dark? HlHexDark

---@class UserHl
---@field hl fun(name: string, opts: HlOpts)
---@field hl_from_arr fun(arr: HlPair[])
---@field hl_from_dict fun(dict: HlDict)
---@field hl_repeat fun(t: HlRepeat)
---@field colors_hex? HlColorsHex
---@field current_palette? fun()
