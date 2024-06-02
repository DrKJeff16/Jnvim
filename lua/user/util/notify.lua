---@diagnostic disable:unused-function
---@diagnostic disable:unused-local
---@diagnostic disable:missing-fields

require('user.types.user.util')

--- Can't use `check.exists.module()` here as its module might require this module,
--- so let's avoid an import loop, shall we?
---@type fun(mod: string): boolean
local function exists(mod)
	local ok, _ = pcall(require, mod)

	return ok
end

---@type UserUtils.Notify
local M = {}

function M.notify(msg, lvl, opts)
	if type(msg) ~= 'string' then
		error('(user.util.notify.notify): Empty message', vim.log.levels.WARN)
	end

	opts = (type(opts) == 'table') and opts or {}

	local vim_lvl = vim.log.levels

	local DEFAULT_LVLS = {
		[vim_lvl.TRACE + 1] = 'trace',
		[vim_lvl.DEBUG + 1] = 'debug',
		[vim_lvl.INFO + 1] = 'info',
		[vim_lvl.WARN + 1] = 'warn',
		[vim_lvl.ERROR + 1] = 'error',
		[vim_lvl.OFF + 1] = 'off',
	}

	---@type notify.Options
	local DEFAULT_OPTS = {
		animate = true,
		hide_from_history = false,
		title = 'Message',
		timeout = 1500,
	}

	if exists('notify') then
		local notify = require('notify')

		if type(lvl) == 'number' and (lvl >= vim_lvl.TRACE and lvl <= vim_lvl.OFF) then
			lvl = DEFAULT_LVLS[math.floor(lvl) + 1]
		else
			lvl = DEFAULT_LVLS[vim_lvl.INFO + 1]
		end

		if opts ~= nil and type(opts) == 'table' and not vim.tbl_isempty(opts) then
			for key, v in next, DEFAULT_OPTS do
				opts[key] = (opts[key] ~= nil and type(v) == type(opts[key])) and opts[key] or v
			end
		else
			for key, v in next, DEFAULT_OPTS do
				opts[key] = v
			end
		end

		notify(msg, lvl, opts)
	else
		if type(lvl) == 'string' then
			for k, v in next, DEFAULT_LVLS do
				if lvl == v then
					lvl = k - 1
					break
				end
			end

			if type(lvl) == 'string' then
				lvl = vim_lvl.INFO
			end
		end

		if opts ~= nil and type(opts) == 'table' and not vim.tbl_isempty(opts) then
			vim.notify(msg, lvl, opts)
		else
			vim.notify(msg, lvl)
		end
	end
end

return M