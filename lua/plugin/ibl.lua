---@module 'lazy'

---@param htype string
---@param func fun(...: any): any
---@param opts? ibl.hooks.options
local function reg(htype, func, opts)
    if not opts or require('user_api.check.value').empty(opts) then
        require('ibl.hooks').register(htype, func)
        return
    end
    require('ibl.hooks').register(htype, func, opts)
end

---@type HlDict
local Hilite = {
    RainbowRed = { fg = '#E06C75' },
    RainbowYellow = { fg = '#E5C07B' },
    RainbowBlue = { fg = '#61AFEF' },
    RainbowOrange = { fg = '#D19A66' },
    RainbowGreen = { fg = '#98C379' },
    RainbowViolet = { fg = '#C678DD' },
    RainbowCyan = { fg = '#56B6C2' },
}
local highlight = vim.tbl_keys(Hilite) ---@type string[]

---@type LazySpec
return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    version = false,
    dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
    opts = {
        enabled = true,
        debounce = 200,
        indent = {
            highlight = highlight,
            repeat_linebreak = (
                vim.fn.has('nvim-0.10') == 1
                and vim.o.breakindent
                and vim.o.breakindentopt ~= ''
            ),
            smart_indent_cap = false,
            char = {
                '╎',
                '╏',
                '┆',
                '┇',
                '┊',
                '┋',
            },
            tab_char = {
                '▏',
                '▎',
                '▍',
                '▌',
                '▋',
                '▊',
                '▉',
                '█',
            },
        },
        whitespace = {
            highlight = { 'Whitespace', 'NonText' },
            remove_blankline_trail = false,
        },

        scope = { highlight = highlight },
    },
    config = function(_, cfg_opts)
        reg(require('ibl.hooks').type.HIGHLIGHT_SETUP, function()
            require('user_api.highlight').hl_from_dict(Hilite)
        end)
        require('ibl').setup(cfg_opts)

        ---@type { [1]: string, [2]: (fun(...: any): any), [3]?: ibl.hooks.options }[]
        local arg_tbl = {
            {
                require('ibl.hooks').type.ACTIVE,
                ---@param bufnr integer
                ---@return boolean
                function(bufnr)
                    return vim.api.nvim_buf_line_count(bufnr) < 5000
                end,
            },
            {
                require('ibl.hooks').type.SCOPE_HIGHLIGHT,
                require('ibl.hooks').builtin.scope_highlight_from_extmark,
            },
            {
                require('ibl.hooks').type.SKIP_LINE,
                require('ibl.hooks').builtin.skip_preproc_lines,
                { bufnr = 0 },
            },
        }

        for _, t in next, arg_tbl do
            local htype, func, opts = t[1], t[2], t[3] or nil
            if opts then
                reg(htype, func, opts)
            else
                reg(htype, func)
            end
        end

        if require('user_api.check.value').type_not_empty('table', vim.g.rainbow_delimiters) then
            vim.g.rainbow_delimiters =
                vim.tbl_deep_extend('force', vim.g.rainbow_delimiters, { highlight = highlight })
        end
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
