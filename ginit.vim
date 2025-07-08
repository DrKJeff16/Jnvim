set backspace=indent,eol,start
set mouse=n nomousemoveevent nomousehide nomousef mousemodel=popup nomousemev
set mousescroll=ver:3,hor:2 mousetime=400

set guifont=FiraCode\ Nerd\ Font\ Mono:h19

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    GuiFont FiraCode\ Nerd\ Font\ Mono:h19
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

if exists(':GuiClipboard')
	call GuiClipboard()
endif

if exists(':GuiAdaptiveColor')
    GuiAdaptiveColor 1
endif

if exists(':GuiAdaptiveFont')
    GuiAdaptiveFont 1
endif

if exists(':GuiRenderFontAttr')
    GuiRenderFontAttr 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
