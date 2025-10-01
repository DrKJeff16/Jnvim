---@module 'lazy'

---@type LazySpec
return {
    'tiagovla/scope.nvim',
    version = false,
    init = function()
        vim.o.sessionoptions = 'buffers,tabpages,globals'
    end,
    config = function()
        require('scope').setup({
            hooks = {
                pre_tab_leave = function()
                    vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabLeavePre' })
                end,
                post_tab_enter = function()
                    vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabEnterPost' })
                end,
            },
        })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
