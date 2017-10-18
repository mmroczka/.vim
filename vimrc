set nocompatible              " be iMproved, required
so ~/.vim/plugins.vim
" --------------------------------------------------------------------------------
" configure editor with tabs and nice stuff...
" --------------------------------------------------------------------------------
set number
set expandtab           " enter spaces when tab is pressed
set textwidth=120       " break lines when line length increases
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set autoindent          " copy indent from current line when starting a new line
syntax on               " syntax highlighting
set showcmd             " show (partial) command in status line
set shiftwidth=4
" set number                     " Show current line number
" set relativenumber             " Show relative line numbers
set background=dark
colorscheme solarized
let mapleader = "\<space>"

"-----mappings-----"
nmap <leader>ev :tabedit $MYVIMRC<cr>
nmap <leader>ep :tabedit ~/.vim/plugins.vim<cr>
nmap <leader>rt :%retab<CR>
nmap <leader>pi :PluginInstall<CR>
" more natural windows mappings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

let g:multi_cursor_use_default_mapping=0
" Default mapping
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<C-c>'
nnoremap <C-c> :call multiple_cursors#quit()<CR>
let NERDTreeShowHidden=1

"-----auto-commands-----"
augroup autosourcing
    autocmd!
    autocmd BufWritePost ~/.vim/vimrc source %
augroup END

" Set location for swapfiles
set directory=$HOME/.vim/swap//
set backupdir=$HOME/.vim/backup//
set undodir=$HOME/.vim/undo//

" ##################
" ### COPY-PASTE ###
" ##################

" System clipboard integration
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "_d"+p
vnoremap <leader>P "_d"+P
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$
nnoremap <leader>yy "+yy

" `Y` should behave like the rest of the capitals
nnoremap Y y$
" Pasting text should never update your buffers
vnoremap p "_dp
" Reselect pasted text
nnoremap <leader>v V`]


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
