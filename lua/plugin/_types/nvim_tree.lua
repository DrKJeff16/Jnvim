---@meta

error('(plugin._types.nvim_tree): DO NOT SOURCE THIS FILE DIRECTLY', vim.log.levels.ERROR)

---@module 'user_api.types.maps'
---@module 'user_api.types.highlight'
---@module 'user_api.types.autocmd'

---@alias AnyFunc fun(...)
---@alias TreeApi table<string, string|AnyFunc|table>
---@alias OptSetterFun fun(desc: string, bufn: integer?): KeyMapOpts

---@class BufData
---@field file string
---@field buf integer

---@class TreeToggleOpts
---@field focus? boolean Defaults to `true`
---@field find_file? boolean Defaults to `false`
---@field path? string|nil Defaults to `nil`
---@field current_window? boolean Defaults to `false`
---@field update_root? boolean Defaults to `false`

---@class TreeOpenOpts
---@field find_file? boolean Defaults to `false`
---@field path? string|nil Defaults to `nil`
---@field current_window? boolean Defaults to `false`
---@field update_root? boolean Defaults to `false`

---@class TreeNodeGSDir
---@field direct? string[]
---@field indirect? string[]

---@class TreeNodeGitStatus
---@field file? string
---@field dir TreeNodeGSDir

---@class TreeNode
---@field git_status TreeNodeGitStatus
---@field absolute_path string
---@field file string
---@field nodes any

---@class TreeGitConds
---@field add string[]
---@field restore string[]

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
