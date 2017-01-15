if has("gui_running")
    set guioptions-=L
    set guioptions-=T
    set guioptions-=r

    if has('gui_macvim')
        set macmeta
        set guicursor+=a:blinkwait0
    endif

    if has('gui_win32') || has('gui_win64')
        set guifont=DejaVu_Sans_Mono:h10:cRUSSIAN
    else
	set guifont=DejaVu\ Sans\ Mono\ 9
    endif

    " Some meta mappings
    nnoremap <silent> <M-Right> :call WinMoveRight()<CR>
    nnoremap <silent> <M-l> :call WinMoveRight()<CR>
    nnoremap <silent> <M-Left> :call WinMoveLeft()<CR>
    nnoremap <silent> <M-h> :call WinMoveLeft()<CR>
    nnoremap <silent> <M-Up> :call WinMoveUp()<CR>
    nnoremap <silent> <M-k> :call WinMoveUp()<CR>
    nnoremap <silent> <M-Down> :call WinMoveDown()<CR>
    nnoremap <silent> <M-j> :call WinMoveDown()<CR>
    nnoremap <silent> <M-S-Right> :call WinSwapRight()<CR>
    nnoremap <silent> <M-S-l> :call WinSwapRight()<CR>
    nnoremap <silent> <M-S-Left> :call WinSwapLeft()<CR>
    nnoremap <silent> <M-S-h> :call WinSwapLeft()<CR>
    nnoremap <silent> <M-S-Up> :call WinSwapUp()<CR>
    nnoremap <silent> <M-S-k> :call WinSwapUp()<CR>
    nnoremap <silent> <M-S-Down> :call WinSwapDown()<CR>
    nnoremap <silent> <M-S-j> :call WinSwapDown()<CR>

    " Some window remapping
    nnoremap <C-S-Left> <C-w>5>
    nnoremap <C-S-Right> <C-w>5<
    nnoremap <C-S-Up> <C-w>-
    nnoremap <C-S-Down> <C-w>+

endif
