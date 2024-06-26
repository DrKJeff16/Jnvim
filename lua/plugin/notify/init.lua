---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local hl_t = User.types.user.highlight
local Highlight = User.highlight

local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local empty = Check.value.empty
local hl = Highlight.hl

if not exists('notify') then
    return
end

local notify = require('notify')

---@type notify.Config
local Opts = {
    background_colour = 'NotifyBackground',
    fps = 60,
    icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '✎',
        WARN = '',
    },
    level = vim.log.levels.INFO,
    minimum_width = 15,
    render = 'default',
    stages = 'fade_in_slide_out',
    time_formats = {
        notification = '%T',
        notification_history = '%FT%T',
    },
    timeout = 1500,
    top_down = true,
}

notify.setup(Opts)
vim.notify = notify

---@type HlDict
local NotifyHl = {
    ['NotifyERRORBorder'] = { fg = '#8A1F1F' },
    ['NotifyWARNBorder'] = { fg = '#79491D' },
    ['NotifyINFOBorder'] = { fg = '#4F6752' },
    ['NotifyDEBUGBorder'] = { fg = '#8B8B8B' },
    ['NotifyTRACEBorder'] = { fg = '#4F3552' },
    ['NotifyERRORIcon'] = { fg = '#F70067' },
    ['NotifyWARNIcon'] = { fg = '#F79000' },
    ['NotifyINFOIcon'] = { fg = '#A9FF68' },
    ['NotifyDEBUGIcon'] = { fg = '#8B8B8B' },
    ['NotifyTRACEIcon'] = { fg = '#D484FF' },
    ['NotifyERRORTitle'] = { fg = '#F70067' },
    ['NotifyWARNTitle'] = { fg = '#F79000' },
    ['NotifyINFOTitle'] = { fg = '#A9FF68' },
    ['NotifyDEBUGTitle'] = { fg = '#8B8B8B' },
    ['NotifyTRACETitle'] = { fg = '#D484FF' },
    ['NotifyERRORBody'] = { link = 'Normal' },
    ['NotifyWARNBody'] = { link = 'Normal' },
    ['NotifyINFOBody'] = { link = 'Normal' },
    ['NotifyDEBUGBody'] = { link = 'Normal' },
    ['NotifyTRACEBody'] = { link = 'Normal' },
}

for name, opts in next, NotifyHl do
    hl(name, opts)
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
