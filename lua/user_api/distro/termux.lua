--- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Termux packages)

local is_dir = require('user_api.check.exists').vim_isdir

local environ = vim.fn.environ

---@class User.Distro.Termux
local Termux = {}

---@type string|''
Termux.PREFIX = vim.fn.has_key(environ(), 'PREFIX') and environ()['PREFIX'] or ''

_G.PREFIX = Termux.PREFIX

Termux.rtpaths = {
    string.format('%s/share/vim/vimfiles/after', PREFIX),
    string.format('%s/share/vim/vimfiles', PREFIX),
    string.format('%s/share/nvim/runtime', PREFIX),
    string.format('%s/local/share/vim/vimfiles/after', PREFIX),
    string.format('%s/local/share/vim/vimfiles', PREFIX),
    string.format('%s/local/share/nvim/runtime', PREFIX),
}

---@return boolean
function Termux.validate()
    local empty = require('user_api.check.value').empty

    if Termux.PREFIX == '' or not is_dir(Termux.PREFIX) then
        return false
    end

    ---@type string[]|table
    local new_rtpaths = {}

    for _, path in next, Termux.rtpaths do
        if is_dir(path) then
            table.insert(new_rtpaths, path)
        end
    end

    if empty(new_rtpaths) then
        return false
    end

    Termux.rtpaths = vim.deepcopy(new_rtpaths)
    return true
end

---@return table|User.Distro.Termux|fun()
function Termux.new()
    return setmetatable({}, {
        __index = Termux,

        ---@param self User.Distro.Termux
        __call = function(self)
            if not self.validate() then
                return
            end

            if not is_dir(PREFIX) then
                return
            end

            for _, path in next, vim.deepcopy(self.rtpaths) do
                ---@diagnostic disable-next-line:param-type-mismatch
                if is_dir(path) and not vim.tbl_contains(vim.opt.rtp:get(), path) then
                    vim.opt.rtp:append(path)
                end
            end

            vim.schedule(function()
                vim.api.nvim_set_option_value('wrap', true, { scope = 'global' })
            end)
        end,
    })
end

return Termux.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
