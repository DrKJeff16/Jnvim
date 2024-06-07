---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('galaxyline') then
    return
end

local GL = require('galaxyline')

-- source provider function
local diagnostic = require('galaxyline.provider_diagnostic')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local extension = require('galaxyline.provider_extensions')
local colors = require('galaxyline.colors')
local buffer = require('galaxyline.provider_buffer')
local whitespace = require('galaxyline.provider_whitespace')
local lspclient = require('galaxyline.provider_lsp')

local default_colors = require('galaxyline.theme').default

GL.section.left[1] = {
    FileSize = {
        provider = 'FileSize',
        condition = function()
            return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,

        icon = '   ',
        highlight = { default_colors.green, default_colors.purple },
        separator = '',
        separator_highlight = { default_colors.purple, default_colors.darkblue },
    },
}

GL.load_galaxyline()
