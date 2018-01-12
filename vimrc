set nocompatible              " be iMproved, required
if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
else
    let s:editor_root=expand("~/.vim")
endif
" Setting up plugins
if empty(glob(s:editor_root . '/autoload/plug.vim'))
    autocmd VimEnter * echom "Downloading and installing vim-plug..."
    silent execute "!curl -fLo " . s:editor_root . "/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall
endif
call plug#begin(s:editor_root . '/plugged')
    Plug 'altercation/vim-colors-solarized'
    Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'ervandew/supertab'
    Plug 'idanarye/vim-vebugger'
    Plug 'sheerun/vim-polyglot'
    Plug 'shougo/vimproc.vim', {'do' : 'make'}
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-vinegar'
    Plug 'vim-airline/vim-airline'
    Plug 'jiangmiao/auto-pairs'
    Plug 'artur-shaik/vim-javacomplete2'
    Plug 'airblade/vim-rooter'

if version >= 800 || has('nvim')
    Plug 'w0rp/ale'
    let g:ale_fixers = {
    \   'javascript': ['eslint'],
    \   'python': ['autopep8'],
    \   'java': [''],
    \}
    let g:ale_linters = {
    \   'python': ['mypy'],
    \}
    let g:ale_fix_on_save = 1
endif

if version >= 800
    Plug 'maralla/completor.vim'
endif

if version < 800
    Plug 'vim-syntastic/syntastic'
    Plug 'davidhalter/jedi-vim'
endif

if has('nvim')
    set inccommand=nosplit
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_debug = 1
    let g:deoplete#enable_profile = 1
    Plug 'zchee/deoplete-jedi'
    Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern', 'for': 'javascript' }
    Plug 'mhartington/nvim-typescript', { 'do': 'npm install -g tern', 'for': 'typescript' }
    let g:tern_request_timeout = 1
    let g:tern_request_timeout = 6000
    let g:tern#command = ["tern"]
    let g:tern#arguments = ["--persistent"]
endif

call plug#end()
" Setting up plugins - end

syntax enable
set hlsearch
set shiftwidth=4
set background=dark
let g:vebugger_leader=','
colorscheme solarized
let mapleader = "\<space>"

"-----mappings-----"
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>rt :%retab<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>rp :!python %<CR>
nnoremap <leader>pt :!pytest<CR>
nnoremap <leader>b :b#<CR>
nnoremap <leader>l :bn<CR>     " Move to the next buffer
nnoremap <leader>h :bp<CR>     " Move to the previous buffer
nnoremap <leader>d :bd<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>in :set invnumber<CR>
nnoremap <leader>nh :noh<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
" pulls vim changes from git
nnoremap <leader>pv :!(cd ~/.vim && git reset HEAD --hard && git pull)<CR>
" Renames word selected accross the file
nnoremap <leader>rn :%s/\<<c-r><c-w>\>/
nnoremap Y y$
:imap jk <Esc>
if has('nvim')
    " maps terminal window movements to emulate normal vim keybindings
    tnoremap <C-h> <c-\><c-n><c-w>h
    tnoremap <C-j> <c-\><c-n><c-w>j
    tnoremap <C-k> <c-\><c-n><c-w>k
    tnoremap <C-l> <c-\><c-n><c-w>l
    tnoremap <M-n> <c-\><c-n>:enew<cr>  " To open a new empty buffer
    tnoremap <M-t> <c-\><c-n>:terminal<cr>  " To open a new terminal
    tnoremap <M-l> <c-\><c-n>:bn<CR>     " Move to the next buffer
    tnoremap <M-h> <c-\><c-n>:bp<CR> " Move to the previous buffer
    tnoremap <M-d> <c-\><c-n>:bd<CR>
    tnoremap <M-b> <c-\><c-n>:b#<CR>
endif

" mappings for vebugger
" ':help vebugger-keymaps' for more
nnoremap ,k :VBGkill<CR>
nnoremap ,s :VBGstartPDB %<CR>

cmap w!! w !sudo tee > /dev/null % " Allow saving of files as sudo when I forgot to start vim using sudo
set pastetoggle=<leader>pp
" more natural windows mappings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-=> <C-W><C-=>
" buffer mappings
set hidden		      " This allows buffers to be hidden if you've modified a buffer
nnoremap <M-n> :enew<cr>  " To open a new empty buffer
nnoremap <M-t> :terminal<cr>  " To open a new terminal
nnoremap <M-l> :bn<CR>     " Move to the next buffer
nnoremap <M-h> :bp<CR> " Move to the previous buffer
nnoremap <M-d> :bd<CR>
nnoremap <M-b> :b#<CR>
" unimpaired mappings
" Bubble single lines
nmap <M-k> [e
nmap <M-j> ]e
" Bubble multiple lines
vmap <M-k> [egv
vmap <M-j> ]egv

"-----auto-commands-----"
augroup autosourcing
    autocmd!
    if has('nvim')
	autocmd BufWritePost ~/.config/nvim/init.vim source %
    else
	autocmd BufWritePost ~/.vim/vimrc source %
    endif
augroup END

" Set location for swapfiles
set directory=$HOME/.vim/swap//
set backupdir=$HOME/.vim/backup//
set undodir=$HOME/.vim/undo//

let g:ctrlp_max_files=0 
" Ignore these directories
set wildignore+=*/build/**
set wildignore+=*/bin/**
set wildignore+=*/node_modules/**
" disable caching
let g:ctrlp_use_caching=0
let g:ctrlp_max_depth=40

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" put abbreviations at the end
inoremap \dlr '${:,.2f}'.format()<esc>i
:iabbrev dlr '${:,.2f}'.format(
nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
