"-----Newly Learned Vim Features-----"
" <visual> o: alternates cursor position of highlighed text
"
" CTRLr + ] goes to the definition of whatever the cursor is on top of -> to
" get back to where you were before hit CTRL + T
"
" To RE-select something that was previously selected in Visual mode, press gv
"-----Test the speed of vim on startup on unix and windows, respectively-----"
" rm -f vim.log && vim --startuptime vim.log +q && tail -n 1 vim.log | cut -f1 -d' '
" rm -force -ErrorAction Ignore vim.log; vim --startuptime vim.log +q; tail -n 1 vim.log | cut -f1 -d' '

set nocompatible              " be iMproved, required
if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
elseif has('win32')
    let s:editor_root=expand("~/vimfiles")
    set shell=powershell
    set shellcmdflag=-command
elseif has('unix')
    let s:editor_root=expand("~/.vim")
endif

" Setting up plugins
if empty(glob(s:editor_root . '/plugged'))
    autocmd VimEnter * PlugInstall
endif

call plug#begin(s:editor_root . '/plugged')
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-surround'
    Plug 'itchyny/lightline.vim'
    Plug 'vimwiki/vimwiki'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-repeat'
    Plug 'mhinz/vim-startify'
    Plug 'markonm/traces.vim'
    Plug 'Quramy/tsuquyomi'
    Plug 'leafgarland/typescript-vim', { 'for': ['typescript'] }
    if ( has('python') || has('python2') || has('python3') ) && has('win32')
        Plug 'Yggdroot/LeaderF', { 'do': '.\install.bat' }
    else
        Plug 'ctrlpvim/ctrlp.vim'
        if executable('rg')
            set grepprg=rg\ --color=never
            let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
            let g:ctrlp_use_caching = 0
        endif
    endif

    if has('unix')
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'idanarye/vim-vebugger'
        Plug 'jiangmiao/auto-pairs'
        Plug 'mgee/lightline-bufferline'
    endif


    if (version >= 800 || has('nvim'))
        Plug 'w0rp/ale'
        let g:ale_fixers = {
        \   'javascript': ['eslint'],
        \   'typescript': ['tslint'],
        \   'java': [''],
        \}
        let g:ale_linters = {
        \   'java': [''],
        \}
    endif

    if version < 800 && has('unix')
        Plug 'vim-syntastic/syntastic'
    endif

call plug#end()
" Setting up plugins - end

syntax enable
set hlsearch
set shiftwidth=4
set background=dark
set ignorecase
set smartcase
set completeopt=longest,menuone
set incsearch
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces set expandtab
set number relativenumber
set infercase
set splitbelow
set splitright
set noerrorbells

" ==== COC settings ====
" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" ==== COC settings ====

let g:gutentags_file_list_command = 'rg --files'
let g:tsuquyomi_single_quote_import=1
let g:VM_no_meta_mappings=1
let mapleader = " "
let g:rainbow_active = 1
" below commands save and restore your vim folds automatically for you
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

"-----mappings-----"
nnoremap <leader>ev :silent e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>r\t :%retab<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>rp :w<CR>:!python3 %<CR>
nnoremap <leader>pt :!python3 test_%<CR>
nnoremap <leader>jt :!.\gradlew test --tests *.%:t:r<CR>
nnoremap <leader>l :bn<CR>     " Move to the next buffer
nnoremap <leader>h :bp<CR>     " Move to the previous buffer
nnoremap <leader>pc :PlugClean<CR>
nnoremap <silent> <esc><esc> :nohlsearch<CR><esc>
nnoremap <leader>s :Startify<CR>
vnoremap <leader>q :norm @q<CR>
nnoremap gb :ls<CR>:b<Space>
nnoremap <leader>s :%s/\v
nnoremap <leader>it :TsuImport<CR>
nnoremap <leader>af :ALEFix<CR>
nnoremap <silent> <C-W>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <C-W>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <C-W>l :exe "vertical resize -5"<CR>
nnoremap <silent> <C-W>h :exe "vertical resize +5"<CR>
cnoreabbrev <expr> x getcmdtype() == ":" && getcmdlinj() == 'x' ? 'bd' : 'x'
nnoremap QQ :exe "q!"<CR>
nnoremap <leader>c :exe ':silent !open -a /Applications/Google\ Chrome.app %'<CR>

" Makes it so splits are never smaller than one line
set winheight=5
set winminheight=5

if exists(':tnoremap')
    if has('win32')
        nnoremap <leader>T :tab terminal<CR>Set-Theme tehrob<CR>clear<CR>
    else
        nnoremap <leader>T :tab terminal<CR>set -o vi<CR>
    endif
endif

" pulls vim changes from git
if has('unix')
    nnoremap <leader>pv :!(cd ~/.vim && git reset HEAD --hard && git pull)<CR>
elseif has ('win32')
    nnoremap <leader>pv :!cd ~/vimfiles; git reset HEAD --hard; git pull<CR>
endif

" Renames selected word accross the file
nnoremap <leader>rn :%s/\<<c-r><c-w>\>/
nnoremap Y y$

" mappings for vebugger
" ':help vebugger-keymaps' for more
"nnoremap ,k :VBGkill<CR>
"nnoremap ,s :VBGstartPDB %<CR>

" more natural windows mappings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

if exists(':tnoremap')
    tnoremap <esc><esc> <c-\><c-n>
    tnoremap <C-J> <C-W><C-J>
    tnoremap <C-K> <C-W><C-K>
    tnoremap <C-L> <C-W><C-L>
    tnoremap <C-H> <C-W><C-H>
endif

" buffer mappings
set hidden                      " This allows buffers to be hidden if you've modified a buffer

"-----Macros-----"
" Takes clipboard link of github to plugin and turns it into vim-plug syntax
let @p = 'oPlug ''''"+PF''ldf/.'

"-----auto-commands-----"
augroup autosourcing
    autocmd!
    if has('nvim')
        autocmd BufWritePost vimrc execute "source " . s:editor_root . "/init.vim"
    else
        autocmd BufWritePost vimrc execute "source " . s:editor_root . "/vimrc"
        if has('win32') && has('gui_running')
            autocmd BufWritePost vimrc simalt ~x
        endif
    endif
augroup END

augroup TrimTrailingWhitespace
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END

if has("gui_running")
    colorscheme solarized
    autocmd GUIEnter * set vb t_vb=
endif

" Ignore these directories
set wildignore+=*/build/**
set wildignore+=*/bin/**
set wildignore+=*/node_modules/**
set wildignore=*.swp,*.bak
set wildignore+=*.pyc,*.class,*.sln,*.Master,*.csproj,*.csproj.user,*.cache,*.dll,*.pdb,*.min.*
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/*
set wildignore+=tags
set wildignore+=*.tar.*

" put abbreviations at the end
inoremap \dlr '${:,.2f}'.format()<esc>i

if has('unix') && !has('gui_running')
    au VimLeave * :!clear
endif

if has('win32') && !has('gui_running') && !empty($CONEMUBUILD)
    set term=xterm
    set t_Co=256
    inoremap <Char-0x07F> <BS>
    nnoremap <Char-0x07F> <BS>
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    set encoding=utf-8
    set termencoding=utf-8
    set fileencoding=utf-8
endif

if has('unix') && has('gui_running')
    set macligatures
    set lines=999 columns=9999
    set guifont=Fira\ Code:h12
    set guioptions=ca
endif

if has('win32') && has('gui_running')
    set renderoptions=type:directx
    set encoding=utf-8
    autocmd GUIEnter * simalt ~x
    set guifont=Fira\ Code:h12
    set guioptions=ca
endif

let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline = {}
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.colorscheme = 'solarized'
set noshowmode
if has('unix')
    set showtabline=2
endif

