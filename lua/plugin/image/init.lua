local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.kmap.desc

if not exists('image') then
    return
end

local Image = require('image')

Image.setup({
    ---@type 'kitty'|'ueberzug'
    backend = 'ueberzug',

    ---@type 'magick_cli'|'magick_rock'
    processor = 'magick_cli', -- or "magick_rock"

    integrations = {
        markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            only_render_image_at_cursor_mode = 'popup',
            floating_windows = true, -- if true, images will be rendered in floating markdown windows
            filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
            enabled = true,
            filetypes = { 'norg' },
        },
        typst = {
            enabled = true,
            filetypes = { 'typst' },
        },
        html = {
            enabled = false,
        },
        css = {
            enabled = false,
        },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = {
        'cmp_menu',
        'cmp_docs',
        'snacks_notif',
        'scrollview',
        'scrollview_sign',
    },
    editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' }, -- render image files as images when opened
})

---@type AllMaps
local Keys = {
    ['<leader>fI'] = { group = '+Image' },

    ['<leader>fIt'] = {
        function()
            if Image.is_enabled() then
                Image.disable()
            else
                Image.enable()
            end
        end,
        desc('Toggle The Image View'),
    },
    ['<leader>fIe'] = {
        Image.enable,
        desc('Enable The Image View'),
    },
    ['<leader>fId'] = {
        Image.disable,
        desc('Disable The Image View'),
    },
}

Keymaps({ n = Keys })

User:register_plugin('plugin.image')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
