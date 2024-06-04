-- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Arch Linux packages)

require('user.types')
local Check = require('user.check')
local Util = require('user.util')

local is_dir = Check.exists.vim_isdir
local tbl_values = Check.value.tbl_values
local empty = Check.value.empty
local strip_values = Util.strip_values

---@type User.Distro.Archlinux
local M = {}

function M.setup()
	local rtpaths = {
		'/usr/local/share/nvim/runtime',
		'/usr/share/nvim/runtime',
		'/usr/local/share/vim/vimfiles',
		'/usr/local/share/vim/vimfiles/after',
		'/usr/share/vim/vimfiles',
		'/usr/share/vim/vimfiles/after',
	}

	for _, path in next, vim.deepcopy(rtpaths) do
		if not (is_dir(path) or tbl_values({ path }, vim.opt.rtp:get())) then
			rtpaths = strip_values(rtpaths, { path })
		end
	end

	if not empty(rtpaths) then
		vim.opt.rtp:append(rtpaths)
	end
end

return M
