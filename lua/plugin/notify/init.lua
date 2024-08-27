local User = require('user_api')
local Check = User.check
local hl_t = User.types.user.highlight

local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local empty = Check.value.empty
local hl_from_dict = User.highlight.hl_from_dict

if not exists('notify') then
    return
end

User.register_plugin('plugin.notify')

local notify = require('notify')

---@diagnostic disable-next-line:missing-fields
notify.setup({
    background_colour = 'NotifyBackground',
    fps = 60,
    icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '✎',
        WARN = '',
    },
    level = vim.log.levels.DEBUG,
    minimum_width = 12,
    render = 'default',
    stages = 'fade_in_slide_out',
    time_formats = {
        notification = '%T',
        notification_history = '%FT%T',
    },
    timeout = 1000,
    top_down = true,
})
vim.notify = notify

---@type HlDict
local NotifyHl = {
    ['NotifyDEBUGBody'] = { link = 'Normal' },
    ['NotifyDEBUGBorder'] = { fg = '#CBCB42' },
    ['NotifyDEBUGIcon'] = { fg = '#909042' },
    ['NotifyDEBUGTitle'] = { fg = '#CBCB42' },

    ['NotifyERRORBody'] = { link = 'ErrorMsg' },
    ['NotifyERRORBorder'] = { fg = '#8A1F1F' },
    ['NotifyERRORIcon'] = { fg = '#F70067' },
    ['NotifyERRORTitle'] = { fg = '#F70067' },

    ['NotifyINFOBody'] = { link = 'Normal' },
    ['NotifyINFOBorder'] = { fg = '#4F6752' },
    ['NotifyINFOIcon'] = { fg = '#A9FF68' },
    ['NotifyINFOTitle'] = { fg = '#A9FF68' },

    ['NotifyLOGBody'] = { link = 'Normal' },
    ['NotifyLOGBorder'] = { fg = '#3F6072' },
    ['NotifyLOGIcon'] = { fg = '#59BFAB' },
    ['NotifyLOGTitle'] = { fg = '#59BFAB' },

    ['NotifyTRACEBody'] = { link = 'Normal' },
    ['NotifyTRACEBorder'] = { fg = '#4F3552' },
    ['NotifyTRACEIcon'] = { fg = '#D484FF' },
    ['NotifyTRACETitle'] = { fg = '#D484FF' },

    ['NotifyWARNBody'] = { link = 'WarningMsg' },
    ['NotifyWARNBorder'] = { fg = '#79491D' },
    ['NotifyWARNIcon'] = { fg = '#F79000' },
    ['NotifyWARNTitle'] = { fg = '#F79000' },
}

vim.schedule(function() hl_from_dict(NotifyHl) end)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
