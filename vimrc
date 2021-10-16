unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
runtime! ftplugin/man.vim  " Read man pages

augroup vimrc
  autocmd!
augroup END

let mapleader=" "
let maplocalleader=" "

" Vim-Plug: Download if does not exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
  nnoremap <Leader>gd :Gdiff<CR>
Plug 'airblade/vim-gitgutter'        " for showing git diff info in the gutter
  let g:gitgutter_override_sign_column_highlight = 1  " set column bg color
  let g:gitgutter_sign_added = '│'
  let g:gitgutter_sign_modified = '│'
  let g:gitgutter_sign_removed = '_'
  let g:gitgutter_sign_removed_first_line = '‾'
  let g:gitgutter_sign_modified_removed = '~'

Plug 'tpope/vim-surround'            " for adding surrounding characters
Plug 'tpope/vim-repeat'              " for repeating
Plug 'tpope/vim-commentary'          " for commenting
Plug 'justinmk/vim-dirvish'
" disable netrw and use dirvish
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore vsplit | silent Dirvish <args>
augroup dirvish_config
    autocmd!
    " Map `t` to open in new tab.
    autocmd FileType dirvish
      \  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0) \| tcd %<CR>
      \ |xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0) \| tabdo tcd %<CR>
augroup END

Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'tommcdo/vim-exchange'          " for swapping text
Plug 'tommcdo/vim-lion'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  nnoremap U :UndotreeToggle<CR>
  let g:undotree_WindowLayout = 2

" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <Leader>r :History:<CR>
nnoremap <Leader>; :Commands<CR>
nnoremap <Leader>K :Help<CR>
nnoremap gb :Buffers<CR>
nnoremap <Leader>t :Windows<CR>
" Rg in the current buffer's directory
command! -bang -nargs=* Rgb
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case "
  \ .shellescape(<q-args>), 1, {'dir': expand('%:p:h') }, <bang>0)

" List ends here. Plugins become visible to Vim after this call.
call plug#end()


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

set softtabstop=4 shiftwidth=4 expandtab
set autoindent
set copyindent  " copy usage of spaces or tabs
set listchars=tab:>-,trail:.  " configure list
set list  " show information about spaces and tabs

" Formatting search
set path=.,**,,  " exclude /usr/include and search ** by default
augroup vimrc
    autocmd FileType c,cpp      setlocal path+=/usr/include
augroup END
" ignore patterns (node_modules) for :find
set wildignore+=tags,*/node_modules/*,*.o,*.class,*/__pycache__,*/tools/*
set ignorecase smartcase
set incsearch  " show search as you type
set hlsearch   " highlight search (clear with :noh or <C-L> mapping)
set ttimeoutlen=50      " wait up to 50ms after Esc for special key
set autowrite
set autoread
set hidden          " For allowing hiding of unsaved files in our buffer
set laststatus=2
set wildmode=longest:full:lastused,full " zsh tab behavior + "lastused"
set splitbelow
set splitright
set updatetime=250
set cursorline
set linebreak       " more readable text wrapping
set history=10000

" Enable mouse for scrolling and clicking, but disable all selection
set mouse=n
noremap <LeftRelease> <Nop>

function! s:statusline_expr()
  let mod = "%{&modified ? '│ + ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let ts  = " │ %{strftime('%H:%M')} │ "
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %F %<'.mod.ro.ft.fug.ts.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

" Mappings
nnoremap Y y$
nnoremap <BS> <C-^>
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
nnoremap gt :tabs<CR>:tabnext<Space>
" vnoremap P "0p
unmap Q
nnoremap <leader>y "+y
nnoremap <leader>cc :cclose<bar>lclose<cr>
nnoremap <Leader>cd :tcd %:p:h<CR>:pwd<CR>
nnoremap <Leader>cg :tcd `git rev-parse --show-toplevel`<CR>:pwd<CR>
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

function! CleverTab()
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    else
        return "\<C-P>"
    endif
endfunction
function! ShiftTab()
    return "\<C-N>"
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <S-Tab> <C-R>=ShiftTab()<CR>

augroup vimrc
    " Auto remove trailing spaces
    autocmd BufWritePre * %s/\s\+$//e
    " on tab creation, tcd to git root (https://stackoverflow.com/a/38082157/10634812)
    " autocmd TabNew * :tcd %:h | exe 'tcd ' . fnameescape(get(systemlist('git rev-parse --show-toplevel'), 0))
augroup END

" Terminal themes and colors:
" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme gruvbox
