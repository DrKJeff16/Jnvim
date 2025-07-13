---@meta

error('(plugin._types.diffview): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@alias DiffView.Views
---|'diff1_plain'
---|'diff2_horizontal'
---|'diff2_vertical'
---|'diff3_horizontal'
---|'diff3_vertical'
---|'diff3_mixed'
---|'diff4_mixed'
---|-1

---@alias DiffView.ListStyle 'list'|'tree'
---@alias DiffView.WinConfig.Type 'float'|'split'
---@alias DiffView.WinConfig.Positon 'left'|'top'|'right'|'bottom'
---@alias DiffView.WinConfig.Relative 'editor'|'win'

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
