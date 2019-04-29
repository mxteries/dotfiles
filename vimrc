" Vundle plugin configuration start:
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Keep Plugin commands between vundle#begin/end.
Plugin 'VundleVim/Vundle.vim'       " required
Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline'    " vim status bar
Plugin 'airblade/vim-gitgutter'     " for showing git diff info in the gutter
Plugin 'tpope/vim-surround'         " for adding surrounding characters
Plugin 'tpope/vim-repeat'           " for repeating
Plugin 'tpope/vim-commentary'       " for commenting
Plugin 'terryma/vim-smooth-scroll'  " for better scrolling (see remaps)
Plugin 'sheerun/vim-polyglot'       " syntax highlighting swiss army knife
Plugin 'justinmk/vim-dirvish'       " :crabs: netrw is gone :crabs:
" Plugin 'tommcdo/vim-lion'         " you've piqued my interest
" Plugin 'tpope/vim-unimpaired'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" :PluginInstall (see :h vundle for more details or wiki for FAQ)
" Vundle setup end

if has('syntax')
  syntax enable
endif

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

" Store everything in the .vim directory
set backupdir=~/.vim/tmp,.
set undodir=~/.vim/tmp,.
set directory=~/.vim/tmp,.
set viminfo+=n~/.vim/viminfo

" Formatting indents
set tabstop=4   " default for vim-sleuth
set autoindent
set copyindent  " copy previous indenting when auto indenting
set backspace=indent,eol,start

" Formatting search
set path=.,**,,  " exclude /usr/include and search ** by default
autocmd FileType c,cpp      setlocal path+=/usr/include
set wildignore+=tags,*/node_modules/*,*.o,*.class  " ignore patterns (node_modules) for :find

set ignorecase " ignore case when searching, unless...
set smartcase  " the search has capital letters (:h ignorecase for more info)
set incsearch  " show search as you type
set hlsearch   " highlight search (clear with :noh or <C-L> mapping)


" My Mappings (I like vim quite vanilla, use with caution)

" in command-line-window, press enter in insert mode
nnoremap <Enter> :
" from :help Y
map Y y$
if maparg('<C-L>', 'n') ==# '' " Use <C-L> to clear search highlighting.
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
" smooth_scroll#up(distance, duration, speed)
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 20, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 20, 2)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 20, 2)<CR>

" misc QOL
set hidden   " For allowing hiding of unsaved files in our buffer
set noshowmode " not needed with a status line
set ruler
set laststatus=2
set wildmenu
set splitbelow
set splitright
set showcmd  " Show keypress on bottom right
set relativenumber   " Show relative line numbers
set updatetime=1000  " for git gutter update

" Terminal themes and colors:
" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Plugin Variable Configurations:
let g:gitgutter_override_sign_column_highlight = 1  " set column bg color

" First, install a font with Powerline symbols. (Be sure to install
" to the ~/.fontconfig/conf.d folder as well). Hack is a good font for this.
" After installing, configure your terminal to use that patched font
" Now turn on a theme for airline (gruvbox) and turn on powerline fonts
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Configure themes:
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'medium'
set background=dark  " gruvbox dark mode

" set theme after configuration finished
colorscheme gruvbox

" Don't really know much about these:
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" sourcing
source ~/.vim/autoload/myfunctions.vim
