local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local desc = User.maps.kmap.desc

if not exists('nvim-possession') then
    return
end

local PSSN = require('nvim-possession')
local Sorting = require('nvim-possession.sorting')

PSSN.setup({
    sessions = {
        -- sessions_path = ... -- folder to look for sessions, must be a valid existing path
        -- sessions_variable = ... -- defines vim.g[sessions_variable] when a session is loaded
        -- sessions_icon = ...-- string: shows icon both in the prompt and in the statusline
        sessions_prompt = 'Possession Prompt: ', -- fzf prompt string
    },

    autoload = true, -- whether to autoload sessions in the cwd at startup
    autosave = true, -- whether to autosave loaded sessions before quitting
    autoprompt = true,
    autoswitch = {
        enable = true, -- whether to enable autoswitch
        exclude_ft = { 'text', 'markdown' }, -- list of filetypes to exclude from autoswitch
    },

    save_hook = function()
        if exists('scope') then
            vim.cmd('ScopeSaveState') -- Scope.nvim saving
        end

        -- Get visible buffers
        local visible_buffers = {}

        for _, win in next, vim.api.nvim_list_wins() do
            visible_buffers[vim.api.nvim_win_get_buf(win)] = true
        end

        for _, bufnr in next, vim.api.nvim_list_bufs() do
            if is_nil(visible_buffers[bufnr]) then -- Delete buffer if not visible
                pcall(vim.cmd.bdel, bufnr)
            end
        end
    end,

    -- useful to update or cleanup global variables for example
    -- useful to restore file trees, file managers or terminals
    post_hook = function()
        if exists('scope') then
            vim.cmd('ScopeLoadState') -- Scope.nvim saving
        end

        -- require('FTerm').open()
        vim.lsp.buf.format()
        require('nvim-tree.api').tree.toggle()
    end,

    ---@type possession.Hls
    fzf_hls = { -- highlight groups for the sessions and preview windows
        normal = 'Normal',
        preview_normal = 'Normal',
        border = 'Todo',
        preview_border = 'Constant',
    },
    ---@type possession.Winopts
    fzf_winopts = {
        -- any valid fzf-lua winopts options, for instance
        width = 0.5,
        preview = {
            vertical = 'right:30%',
        },
    },
    sort = Sorting.time_sort,
    -- sort = Sorting.alpha_sort, -- callback, sorting function to list sessions
    -- to sort by last updated instead
})

---@type AllMaps
local Keys = {
    ['<leader>s'] = { group = '+Session' },

    ['<leader>sl'] = {
        PSSN.list,
        desc('📌list sessions'),
    },
    ['<leader>sn'] = {
        PSSN.new,
        desc('📌create new session'),
    },
    ['<leader>su'] = {
        PSSN.update,
        desc('📌update current session'),
    },
    ['<leader>sd'] = {
        PSSN.delete,
        desc('📌delete selected session'),
    },
}

Keymaps:setup({ n = Keys })

User:register_plugin('plugin.possession')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
