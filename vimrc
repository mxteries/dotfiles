" Vim-Plug: Download if does not exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'        " for showing git diff info in the gutter
Plug 'itchyny/lightline.vim'         " status bar
Plug 'tpope/vim-surround'            " for adding surrounding characters
Plug 'tpope/vim-repeat'              " for repeating
Plug 'tpope/vim-commentary'          " for commenting
Plug 'tpope/vim-rsi'                 " consistent experience in vim and terminal
Plug 'tpope/vim-fugitive'            " vim + git
Plug 'ludovicchabant/vim-gutentags'  " auto tags
Plug 'sheerun/vim-polyglot'          " syntax highlighting swiss army knife
Plug 'justinmk/vim-dirvish'          " :crabs: netrw is gone :crabs:
Plug 'tommcdo/vim-exchange'          " for swapping text
Plug 'unblevable/quick-scope'        " highlight f,t

" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

if has('syntax')
  syntax enable
endif

if has("vms")
  set nobackup   " do not keep a backup file, use versions instead
else
  set backup     " keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile " keep an undo file (undo changes after closing)
  endif
endif

" Store everything in the .vim directory
set backupdir=~/.vim/tmp,.
set undodir=~/.vim/tmp,.
set directory=~/.vim/tmp,.
set viminfo+=n~/.vim/viminfo

" Formatting indents
" set softtabstop=4 shiftwidth=4 expandtab
set softtabstop=0 shiftwidth=0 noexpandtab
set autoindent
set copyindent  " copy previous indenting when auto indenting
set backspace=indent,eol,start
set listchars=tab:>-,trail:.  " configure list
set list  " show information about spaces and tabs

" Formatting search
set path=.,**,,  " exclude /usr/include and search ** by default
autocmd FileType c,cpp      setlocal path+=/usr/include
set wildignore+=tags,*/node_modules/*,*.o,*.class  " ignore patterns (node_modules) for :find

set ignorecase " ignore case when searching, unless...
set smartcase  " the search has capital letters (:h ignorecase)
set incsearch  " show search as you type
set hlsearch   " highlight search (clear with :noh or <C-L> mapping)

" in command-line-window, press enter in insert mode
nnoremap <Enter> :
" from :help Y
nnoremap Y y$

if maparg('<C-L>', 'n') ==# '' " Use <C-L> to clear search highlighting.
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" misc QOL
set hidden          " For allowing hiding of unsaved files in our buffer
set ruler
set laststatus=2
set wildmenu
set splitbelow
set splitright
set showcmd         " Show keypress on bottom right
set relativenumber
set updatetime=100  " for git gutter update
set noshowmode
set mouse=n         " allow mouse wheel scrolling in normal mode
set cursorline

" Plugin Variable Configurations:
let g:gitgutter_override_sign_column_highlight = 1  " set column bg color
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

let g:rsi_no_meta = 1

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:python_highlight_all = 1

" Terminal themes and colors:
" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'medium'
set background=dark  " gruvbox dark mode

" set theme after configuration finished
colorscheme gruvbox

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

" Set quickscope colors (after defining colorscheme)
highlight QuickScopePrimary guifg='LightGreen' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#ffa0a0' gui=underline ctermfg=81 cterm=underline
