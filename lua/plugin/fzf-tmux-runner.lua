---@module 'lazy'

---@type LazySpec
return {
    'stephansama/fzf-tmux-runner.nvim',
    keys = {
        { '<leader>fm', '<CMD>FzfTmuxMake<CR>', { desc = 'launch makefile target' } },
        { '<leader>fj', '<CMD>FzfTmuxPackageJson<CR>', { desc = 'launch package json script' } },
    },
    config = true,
    ---@module "fzf-tmux-runner"
    ---@type FzfTmuxRunnerOpts
    opts = {
        package_manager = 'nr',
        direction = 'vertical',
    },
}
