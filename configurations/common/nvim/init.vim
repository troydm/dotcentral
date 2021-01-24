" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin')
call plug#begin(stdpath('config').'/plugged')

Plug 'jnurmine/Zenburn'
Plug 'vim-airline/vim-airline'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'yegappan/mru'
Plug 'vim-scripts/YankRing.vim'
Plug 'Yggdroot/indentLine'
Plug 'troydm/asyncfinder.vim'
Plug 'troydm/zoomwintab.vim'
Plug 'troydm/easybuffer.vim'
Plug 'troydm/easytree.vim'
Plug 'troydm/shellasync.vim'
Plug 'troydm/neasytree.nvim'

" Initialize plugin system
call plug#end()

colorscheme zenburn
let g:airline_theme='easyburn'
let g:airline_powerline_fonts=1
let g:yankring_clipboard_monitor = 0
let g:yankring_history_file = '.vim_yankring_history'
let g:asyncfinder_grep_cmd = 'ack'
let g:airline#extensions#zoomwintab#enabled=1
let g:airline#extensions#zoomwintab#status_zoomed_in=''
let g:indentLine_char = '┊'
let g:indentLine_color_term = 108

" Insert mode cursor line
set cursorline
if has("gui_running")
    au InsertEnter * hi CursorLine guibg=#121212
    au InsertLeave * hi CursorLine guibg=#303030
else
    au InsertEnter * hi CursorLine ctermbg=233 cterm=none
    au InsertLeave * hi CursorLine ctermbg=238 cterm=none
endif

" some convenient keymappings
nnoremap <silent> <C-q> :Bclose<CR>
nnoremap <silent> <leader>s :ShellTerminal<CR>
nnoremap <silent> <leader>g :Gstatus<CR>
nnoremap <silent> <leader>t :NEasyTree<CR>
nnoremap <silent> <leader>r :YRShow<CR>
nnoremap <silent> <leader>u :UndotreeToggle<CR>

nnoremap <silent> <C-Tab> :EasyBufferToggle<CR>
if !has("gui_running")
    nnoremap <silent> <esc>[27;5;9~ :EasyBufferToggle<CR>
    nnoremap <silent> <esc>[1;5I :EasyBufferToggle<CR>
endif

" Save file on <C-s>
nnoremap <silent> <C-S> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm w<CR>endif<CR>

" FuzzyFinder keybindings
function! OpenFile(grep)
    if getbufvar('%','&filetype') == 'easytree'
        if winnr("$") == 1
           execute &columns/9 . 'vs'
        endif
        :wincmd w
    endif
    if a:grep
        :AsyncGrep
    else
        :AsyncFinder
    endif
endfunction
noremap <silent> <C-f> :call OpenFile(0)<CR>
noremap <silent> <C-g> :call OpenFile(1)<CR>

" Some emacs inspired keymappings
nnoremap <C-x>x <C-w>q
nnoremap <C-x>c :qa<CR>
nnoremap <C-x>\| <C-w>v
nnoremap <C-x>- <C-w>s

" Some window movement mappings
function! WinMoveUp()
    let w = winnr()
    :wincmd k
    if w == winnr()
        :wincmd j
    endif
endfunction

function! WinSwapUp()
    let b = bufname('%')
    let w = winnr()
    :wincmd k
    if w == winnr()
        :wincmd j
    endif
    let w2 = winnr()
    if w != w2
        let b2 = bufname('%')
        execute w . "wincmd w"
        execute "b " . b2
        execute w2 . "wincmd w"
        execute "b " . b
    endif
endfunction

function! WinMoveDown()
    let w = winnr()
    :wincmd j
    if w == winnr()
        :wincmd k
    endif
endfunction

function! WinSwapDown()
    let b = bufname('%')
    let w = winnr()
    :wincmd j
    if w == winnr()
        :wincmd k
    endif
    let w2 = winnr()
    if w != w2
        let b2 = bufname('%')
        execute w . "wincmd w"
        execute "b " . b2
        execute w2 . "wincmd w"
        execute "b " . b
    endif
endfunction

function! WinMoveRight()
    let w = winnr()
    :wincmd l
    if w == winnr()
        :wincmd h
    endif
endfunction

function! WinSwapRight()
    let b = bufname('%')
    let w = winnr()
    :wincmd l
    if w == winnr()
        :wincmd h
    endif
    let w2 = winnr()
    if w != w2
        let b2 = bufname('%')
        execute w . "wincmd w"
        execute "b " . b2
        execute w2 . "wincmd w"
        execute "b " . b
    endif
endfunction

function! WinMoveLeft()
    let w = winnr()
    :wincmd h
    if w == winnr()
        :wincmd l
    endif
endfunction

function! WinSwapLeft()
    let b = bufname('%')
    let w = winnr()
    :wincmd h
    if w == winnr()
        :wincmd l
    endif
    let w2 = winnr()
    if w != w2
        let b2 = bufname('%')
        execute w . "wincmd w"
        execute "b " . b2
        execute w2 . "wincmd w"
        execute "b " . b
    endif
endfunction

nnoremap <silent> <esc>[1;3C :silent! call WinMoveRight()<CR>
nnoremap <silent> <esc>[1;3D :silent! call WinMoveLeft()<CR>
nnoremap <silent> <esc>[1;3A :silent! call WinMoveUp()<CR>
nnoremap <silent> <esc>[1;3B :silent! call WinMoveDown()<CR>
nnoremap <silent> <esc>l :silent! call WinMoveRight()<CR>
nnoremap <silent> <esc>h :silent! call WinMoveLeft()<CR>
nnoremap <silent> <esc>k :silent! call WinMoveUp()<CR>
nnoremap <silent> <esc>j :silent! call WinMoveDown()<CR>
nnoremap <silent> <A-right> :silent! call WinMoveRight()<CR>
nnoremap <silent> <A-left> :silent! call WinMoveLeft()<CR>
nnoremap <silent> <A-up> :silent! call WinMoveUp()<CR>
nnoremap <silent> <A-down> :silent! call WinMoveDown()<CR>

nnoremap <silent> <esc>[1;10C :call WinSwapRight()<CR>
nnoremap <silent> <esc>[1;10D :call WinSwapLeft()<CR>
nnoremap <silent> <esc>[1;10A :call WinSwapUp()<CR>
nnoremap <silent> <esc>[1;10B :call WinSwapDown()<CR>
nnoremap <silent> <esc>L :call WinSwapRight()<CR>
nnoremap <silent> <esc>H :call WinSwapLeft()<CR>
nnoremap <silent> <esc>K :call WinSwapUp()<CR>
nnoremap <silent> <esc>J :call WinSwapDown()<CR>
nnoremap <silent> <S-A-right> :call WinSwapRight()<CR>
nnoremap <silent> <S-A-left> :call WinSwapLeft()<CR>
nnoremap <silent> <S-A-up> :call WinSwapUp()<CR>
nnoremap <silent> <S-A-down> :call WinSwapDown()<CR>

nnoremap <silent> <esc>[1;6C <C-w>5<
nnoremap <silent> <esc>[1;6D <C-w>5>
nnoremap <silent> <esc>[1;6A <C-w>5-
nnoremap <silent> <esc>[1;6B <C-w>5+

" shellasync terminal related hack
au FileType shellasyncterm inoremap <silent> <buffer> <Esc>h <Esc>:silent! call WinMoveLeft()<CR>|
                         \ inoremap <silent> <buffer> <Esc>j <Esc>:silent! call WinMoveDown()<CR>|
                         \ inoremap <silent> <buffer> <Esc>k <Esc>:silent! call WinMoveUp()<CR>|
                         \ inoremap <silent> <buffer> <Esc>l <Esc>:silent! call WinMoveRight()<CR>|
                         \ inoremap <silent> <buffer> <Esc>[1;3C <Esc>:silent! call WinMoveRight()<CR>|
                         \ inoremap <silent> <buffer> <Esc>[1;3D <Esc>:silent! call WinMoveLeft()<CR>|
                         \ inoremap <silent> <buffer> <Esc>[1;3B <Esc>:silent! call WinMoveDown()<CR>|
                         \ inoremap <silent> <buffer> <Esc>[1;3A <Esc>:silent! call WinMoveUp()<CR>|
                         \ inoremap <silent> <buffer> <A-Left> <Esc>:silent! call WinMoveLeft()<CR>|
                         \ inoremap <silent> <buffer> <A-Down> <Esc>:silent! call WinMoveDown()<CR>|
                         \ inoremap <silent> <buffer> <A-Up> <Esc>:silent! call WinMoveUp()<CR>|
                         \ inoremap <silent> <buffer> <A-Right> <Esc>:silent! call WinMoveRight()<CR>

" Visual tab mapping
vnoremap > >gv
vnoremap < <gv

" set configuration options
set encoding=utf-8
set backspace=indent,eol,start
set nu
set hidden
set title
set ruler
set showmatch
set expandtab
set showcmd
set whichwrap+=<,>,h,l
set hlsearch
set ignorecase
set smartcase
set incsearch
set smartindent
set softtabstop=4
set shiftwidth=4
set wildmenu
set laststatus=2
set timeoutlen=500

" Invisible characters
set fillchars=vert:│
set listchars=tab:▸\ ,eol:¬,trail:·
set list
