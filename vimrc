" Vim-Plug: Download if does not exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

Plug 'sainnhe/sonokai'
Plug 'sainnhe/gruvbox-material'
Plug 'airblade/vim-gitgutter'        " for showing git diff info in the gutter
Plug 'itchyny/lightline.vim'         " status bar
Plug 'tpope/vim-surround'            " for adding surrounding characters
Plug 'tpope/vim-repeat'              " for repeating
Plug 'tpope/vim-commentary'          " for commenting
Plug 'tpope/vim-fugitive'            " vim + git
Plug 'justinmk/vim-dirvish'          " :crabs: netrw is gone :crabs:
Plug 'unblevable/quick-scope'        " highlight f,t
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'tommcdo/vim-exchange'          " for swapping text
Plug 'tommcdo/vim-lion'
Plug 'hashivim/vim-terraform'

Plug 'voldikss/vim-floaterm'
Plug 'voldikss/fzf-floaterm'

" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

runtime! ftplugin/man.vim  " Read man pages

set backup     " keep a copy of the original file (vimrc~)
set undofile   " keep an undo file (%home%...%vimrc)

" Store everything in the .vim directory
if !isdirectory($HOME."/.vim/tmp")
    call mkdir($HOME."/.vim/tmp", "", 0700)
endif
set backupdir=~/.vim/tmp,.
set undodir=~/.vim/tmp,.
set directory=~/.vim/tmp,.
set viminfo+=n~/.vim/viminfo

" Set term colors to seoul256, from fzf README-VIM.md
let g:terminal_ansi_colors = [
            \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
            \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
            \ '#626262', '#d75f87', '#87af87', '#ffd787',
            \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4'
            \ ]

" Formatting indents
set softtabstop=4 shiftwidth=4 expandtab
" set softtabstop=0 shiftwidth=0 noexpandtab
set autoindent
set copyindent  " copy previous indenting when auto indenting
set backspace=indent,eol,start
set listchars=tab:>-,trail:.  " configure list
set list  " show information about spaces and tabs

" Formatting search
set path=.,**,,  " exclude /usr/include and search ** by default
autocmd FileType c,cpp      setlocal path+=/usr/include
" ignore patterns (node_modules) for :find
set wildignore+=tags,*/node_modules/*,*.o,*.class,*/__pycache__,*/tools/*
set ignorecase " ignore case when searching, unless...
set smartcase  " the search has capital letters (:h ignorecase)
set incsearch  " show search as you type
set nohlsearch   " highlight search (clear with :noh or <C-L> mapping)

" Mappings
nnoremap Y y$
nnoremap <BS> <C-^>
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
inoremap <C-A> <C-O>^
inoremap <C-E> <C-O>$
" Have Esc enter normal mode in term, except when FZF
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
" vnoremap P "0p

" Leader and plugin mappings
" nnoremap <SPACE> <Nop>
let mapleader=" "
nnoremap <Leader>cd :tcd %:p:h<CR>:pwd<CR>
nnoremap <Leader>r :History:<CR>
nnoremap <Leader>; :Commands<CR>
nnoremap <Leader>K :Help<CR>
nnoremap gb :Bu<CR>
nnoremap <silent> got :FloatermNew --cwd=<buffer><CR>
nnoremap <silent> goT :FloatermNew<CR>
let g:floaterm_keymap_toggle = '<C-h>'  " Fn keys do not work well in vim due to :set <F12>?

" misc QOL
" if exists('+clipboard')
"     set clipboard=unnamedplus
" endif
set ttimeout            " time out for key codes
set ttimeoutlen=50      " wait up to 50ms after Esc for special key
set guicursor=i:block
set autowrite
set hidden          " For allowing hiding of unsaved files in our buffer
set ruler
set laststatus=2
set wildmenu
set wildmode=longest:full:lastused,full " zsh tab behavior + "lastused"
set splitbelow
set splitright
set showcmd         " Show keypress on bottom right
set number
set updatetime=250  " for git gutter update
set cursorline
set linebreak       " more readable text wrapping
set foldmethod=indent  " Fold on indents
set foldlevel=99        " Don't fold anything by default

" Enable mouse for scrolling and clicking, but disable all selection
set mouse=nv
noremap <LeftDrag> <Nop>
noremap <LeftRelease> <Nop>

" Have cake files use c# syntax
autocmd BufRead,BufNewFile *.cake set filetype=cs
" Auto remove trailing spaces
autocmd BufWritePre * %s/\s\+$//e

" Plugin Variable Configurations:
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

let g:gitgutter_override_sign_column_highlight = 1  " set column bg color
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_close_preview_on_escape = 1

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_second_highlight = 0
let g:python_highlight_all = 1

let g:floaterm_width = 0.7
let g:floaterm_height = 0.8

let g:lightline = {'colorscheme' : 'gruvbox_material'}

" Terminal themes and colors:
" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:sonokai_style = 'maia'
let g:sonokai_disable_italic_comment = 1
let g:sonokai_diagnostic_text_highlight = 1
let g:gruvbox_material_background = 'soft'
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_diagnostic_text_highlight = 1
set background=dark

colorscheme sonokai
" colorscheme gruvbox-material  " nighttime
" Set quickscope colors (after defining colorscheme)
highlight QuickScopePrimary guifg='#ffa0a0' gui=underline ctermfg=81 cterm=underline
