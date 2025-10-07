---@module 'lazy'

---@type LazySpec
return {
    'comatory/gh-co.nvim',
    version = false,
    config = function()
        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = { ['<leader>Gg'] = { '<CMD>GhCoWho<CR>', desc('Print GitHub Codeowners') } },
        })
    end,
}
