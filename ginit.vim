set nocompatible

set backspace=indent,eol,start mouse=ni nospell helplang=en
set title bg=dark ls=2 stal=2

set guifont=FiraCode\ Nerd\ Font\ Mono:h19

if exists(':GuiClipboard')
	call GuiClipboard()
endif

au VimEnter * :GuiWindowOpacity 0.80 |
			\ GuiScrollbar 1 |
			\ GuiPopupmenu 1 |
			\ GuiAdaptiveStyle Fusion |
			\ GuiAdaptiveFont 1 |
			\ GuiAdaptiveColor 1 |
			\ GuiRenderLigatures 1 |
			\ GuiTabline 0 |
			\ GuiMouseHide 0
