execute pathogen#infect()
syntax on
filetype plugin on

" My settings
set backspace=indent,eol,start
set encoding=utf-8
set nocompatible
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set showmatch
set mat=5
set scrolloff=8
set updatetime=2000
set laststatus=2
set statusline+=%F
set showcmd
set nowrap
set hlsearch
set number
" try to speed up vim
set timeoutlen=1000
set ttimeoutlen=0
set re=1
set nocursorline
set ttyfast
" set lazyredraw " might cause weird buffer issues
set foldmethod=manual
let ruby_no_expensive=1

" Avoid git issues
" Store swp files in different dir
set dir=~/.vim/swp//

" Theme
set t_Co=256
set background=dark
colorscheme lucario
set term=xterm-256color
hi Normal guibg=NONE ctermbg=NONE

" Highlight trailing whitespace in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" One autocmd group for all
augroup vimrc_autocmd
  autocmd!
  autocmd VimEnter * redraw!
  autocmd BufWinEnter,Syntax * syn sync minlines=500 maxlines=500
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  " Highlight trailing white space
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  " Autoremove trailing white space
  autocmd BufWinLeave * call clearmatches()
  autocmd BufWritePre * %s/\s\+$//e
  " Preserve views
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent loadview
  " autocmd BufEnter * lcd %:p:h " change current dir to opened files
  " Only set these commands up for git commits
  autocmd FileType gitcommit
        \ autocmd CursorMoved,CursorMovedI *
        \ let &l:textwidth = line('.') == 1 ? 59 : 70
augroup END

" Commands
let mapleader = ';'
map <leader>ai gg=G''
nmap <CR> o<Esc>
map p ]p
noremap Y y$

" vim sessions
nnoremap <leader>gss :GitSessionSave<cr>
nnoremap <leader>gsl :GitSessionLoad<cr>:source $MYVIMRC<CR>
nnoremap <leader>gsd :GitSessionDelete<cr>
let g:gitsessions_use_cache = 0
let g:gitsessions_disable_auto_load = 1

" vim split management
noremap <leader><leader> <C-w>w
noremap <leader>= <C-w>=
noremap <leader>h <C-w>h
noremap <leader>l <C-w>l
noremap <leader>j <C-w>j
noremap <leader>k <C-w>k
noremap <leader>x <C-w>x
noremap <leader>< 25<C-w><
noremap <leader>> 25<C-w>>

" convenience
noremap :W :w
noremap :Q :q
nnoremap <tab> V><esc>
nnoremap <S-tab> V<<esc>

" toggle hide/show line numbers
nnoremap <leader>sn :set nu!<CR>

" Quickly open/reload vim
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" Change highlight color
highlight Search ctermbg=darkred
highlight Search ctermfg=white
highlight Visual ctermfg=white ctermbg=darkred gui=none
hi CursorLine cterm=none term=none

" NERDtree
map <leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1
let g:NERDTreeWinSize=38

" Tabularize
nmap <leader>a= :Tab /^[^=]*\zs=<CR>
vmap <leader>a= :Tab /^[^=]*\zs=<CR>
nmap <leader>a# :Tab /^[^#]*\zs#<CR>
vmap <leader>a# :Tab /^[^#]*\zs#<CR>
nmap <leader>a: :Tab /^[^=]*\zs:<CR>
vmap <leader>a: :Tab /^[^=]*\zs:<CR>

" Fugitive
nmap <leader>gb :Gblame<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gl :GitLog<CR>

" Airline
let g:airline_theme='vice'
let g:ttimeoutlen=10
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 0
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''


" indentLine
nnoremap <leader>i :IndentLinesToggle<CR>
let g:indentLine_enabled = 0

" fix vimdiff colors
highlight DiffAdd    cterm=none ctermfg=7   ctermbg=28  gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=none ctermfg=7   ctermbg=88  gui=none guifg=bg guibg=Red
highlight DiffChange cterm=none ctermfg=16  ctermbg=3   gui=none guifg=bg guibg=Red
highlight DiffText   cterm=none ctermfg=16  ctermbg=1   gui=none guifg=bg guibg=Red

" CtrlP
let ctrlp_max_height=20
