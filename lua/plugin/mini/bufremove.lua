---@module 'lazy'

---@param force? boolean
---@return function
local function gen_bdel(force)
    force = force ~= nil and force or false
    return function()
        require('mini.bufremove').delete(vim.api.nvim_get_current_buf(), force)
    end
end

---@type LazySpec
return {
    'nvim-mini/mini.bufremove',
    version = false,
    opts = { silent = true },
    config = function(_, opts)
        local desc = require('user_api.maps').desc
        require('mini.bufremove').setup(opts)
        require('user_api.config').keymaps({
            n = {
                ['<leader>bd'] = { gen_bdel(false), desc('Close Buffer (Mini)') },
                ['<leader>bD'] = { gen_bdel(true), desc('Close Buffer Forcefully (Mini)') },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
