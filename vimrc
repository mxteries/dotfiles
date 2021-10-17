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
augroup vimrc
    " Map `t` to open in new tab.
    autocmd FileType dirvish nnoremap <silent><buffer> t :tabe <c-r><c-f><cr>
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
let g:fzf_buffers_jump = 1  " open existing windows in :Buffers
let g:fzf_action = {
  \ 'enter': 'drop',
  \ 'ctrl-t': 'tab drop',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
nnoremap <leader>fh <cmd>History:<cr>
nnoremap <leader>fc <cmd>Commands<cr>
nnoremap <leader>K  <cmd>Help<cr>
nnoremap <leader>fb <cmd>Buffers<cr>
nnoremap <leader>fw <cmd>Windows<cr>
" Rg in the current buffer's directory
command! -bang -nargs=* Rgb
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case "
  \ .shellescape(<q-args>), 1, {'dir': expand('%:p:h') }, <bang>0)

" restore original c-w functionality (my termwinkey)
autocmd! FileType fzf
autocmd  FileType fzf tnoremap <buffer> <c-w> <c-w>

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
set hlsearch
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
set showtabline=0
noremap <LeftRelease> <Nop>

function! s:statusline_expr()
  let ts  = " %{strftime('%H:%M')} │ "
  let cwd = "[%{fnamemodify(getcwd(),':p:~')}]"
  let rel = " %{expand('%:~:.')} "
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let mod = "%{&modified ? '│ + ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#head() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return ts.cwd.rel.'%<'.ft.mod.ro.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

" Mappings
nnoremap Y y$
nnoremap <BS> <C-^>
nnoremap gt :tabs<CR>:tabnext<Space>
" vnoremap P "0p
unmap Q
nnoremap <leader>y "+y
nnoremap <leader>cc :cclose<bar>lclose<cr>
nnoremap <Leader>cd :tcd %:p:h<CR>:pwd<CR>
nnoremap <Leader>cg :tcd `git rev-parse --show-toplevel`<CR>:pwd<CR>
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
nnoremap <silent> <leader>l :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Functions
function! CleverTab(direction)
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    else
        if a:direction > 0
            return "\<C-N>"
        else
            return "\<C-P>"
    endif
endfunction
inoremap <Tab> <C-R>=CleverTab(-1)<CR>
inoremap <S-Tab> <C-R>=CleverTab(1)<CR>

let t:entering_new_tab = 0
function! AutoTcd()
    " on tab creation, tcd to git root (https://stackoverflow.com/a/38082157/10634812)
    if t:entering_new_tab == 1
        let t:entering_new_tab = 0
        :tcd %:h | exe 'tcd ' . fnameescape(get(systemlist('git rev-parse --show-toplevel'), 0))
    endif
endfunction

augroup vimrc
    " Auto remove trailing spaces
    " Auto tcd on new tabs
    autocmd BufWritePre * %s/\s\+$//e
    autocmd TabNew * let t:entering_new_tab = 1
    autocmd BufEnter * call AutoTcd()
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
