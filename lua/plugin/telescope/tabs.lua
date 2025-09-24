local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not (exists('telescope') and exists('telescope-tabs')) then
    return nil
end

local Tabs = require('telescope-tabs')

---@class TelescopeTabs
local TelescopeTabs = {}

function TelescopeTabs.create()
    require('telescope').load_extension('telescope-tabs')

    -- if you use the picker directly you have to provide your theme manually
    local Opts = {
        entry_formatter = function(tab_id, _, _, file_paths, is_current)
            local entry_string = table.concat(
                vim.tbl_map(function(v)
                    return vim.fn.fnamemodify(v, ':.')
                end, file_paths),
                ', '
            )
            return string.format('%d: %s%s', tab_id, entry_string, is_current and ' <' or '')
        end,

        entry_ordinal = function(_, _, file_names, _, _)
            return table.concat(file_names, ' ')
        end,
        show_preview = true,
        close_tab_shortcut_i = '<C-d>', -- if you're in insert mode
        close_tab_shortcut_n = 'D', -- if you're in normal mode
    }

    Tabs.setup(Opts)
end

function TelescopeTabs.loadkeys()
    local Keymaps = require('user_api.config.keymaps')
    local desc = require('user_api.maps').desc

    ---@type AllMaps
    local Keys = {
        ['<leader>fTet'] = { Tabs.list_tabs, desc('Tabs') },
        ['<leader>tt'] = { Tabs.list_tabs, desc('Telescope Tabs') },
    }

    Keymaps({ n = Keys })
end

return TelescopeTabs
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
