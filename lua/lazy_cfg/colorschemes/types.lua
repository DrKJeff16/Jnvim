---@alias CmdVal string|string[]

---@class CscSubMod
---@field setup? fun(...)
---@field mod_pfx? string
---@field mod_cmd CmdVal

---@alias CscMod table<string, CscSubMod|nil>
