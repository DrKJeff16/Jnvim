set nocompatible

set backspace=indent,eol,start
set mouse=

set guifont=FiraCode\ Nerd\ Font\ Mono:h18

if exists(':GuiClipboard')
	call GuiClipboard()
endif

au VimEnter * :GuiWindowOpacity 0.86 | 
			\ GuiScrollbar 1 |
			\ GuiPopupmenu 1 |
			\GuiAdaotiveStyle Fusion |
			\ GuiAdaptiveFont 1 |
			\ GuiAdaptiveColor 1 |
			\ GuiRenderLigatures 1 |
			\ GuiTabline 0 |
			\ GuiMouseHide 0
