augroup vimrc
  autocmd!
augroup END
let mapleader=" "
let maplocalleader=" "

runtime! ftplugin/man.vim  " Read man pages

let s:configdir = stdpath('config')
let s:windows = has('win32') || has('win64')
let s:plugdir = s:configdir . '/plugged'

call plug#begin(s:plugdir)
" Testing
Plug 'phaazon/hop.nvim'
nnoremap \ <cmd>HopWord<cr>
Plug 'tpope/vim-speeddating'
Plug 'tommcdo/vim-lion'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'

Plug 'tpope/vim-markdown' | let g:markdown_folding = 1
Plug 'tpope/vim-unimpaired'          " Useful mappings
Plug 'tpope/vim-commentary'          " for commenting
Plug 'tpope/vim-repeat'              " for repeating
Plug 'tpope/vim-surround'            " for adding surrounding characters
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" nvim plugins
Plug 'nvim-lua/plenary.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-telescope/telescope.nvim', { 'on': 'Telescope'}
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'lewis6991/gitsigns.nvim'
Plug 'rhysd/git-messenger.vim'  " leader gm to trigger
if !s:windows
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/playground'
end

Plug 'tpope/vim-fugitive'
Plug 'morhetz/gruvbox'
  let g:gruvbox_invert_selection=0
  let g:gruvbox_sign_column='bg0'
  let g:gruvbox_hls_cursor='purple'
  let g:gruvbox_italic=1
  let g:gruvbox_bold=1

Plug 'justinmk/vim-dirvish'
  " disable netrw plugins but keep autoloaded funcs
  let g:loaded_netrwPlugin = 1
  command! -nargs=? -complete=dir Explore Dirvish <args>
  command! -nargs=? -complete=dir Sexplore split | silent Dirvish <args>
  command! -nargs=? -complete=dir Vexplore vsplit | silent Dirvish <args>
  augroup vimrc
      " Map t to open in new tab
      " map f to lcd then start searching for files
      " map r to lcd then start :Rg
      autocmd FileType dirvish
        \  nnoremap <buffer> t :tabedit <c-r><c-p><CR>
        \|nnoremap <buffer> f :lcd <c-r><c-p>\|Files<cr>
        \|nnoremap <buffer> r :lcd <c-r><c-p> \| Rg<space>
        \|nnoremap <buffer> R :lcd <c-r><c-p> \| Rg<cr>
      autocmd FileType dirvish silent! unmap <buffer> /
  augroup END

" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
  let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=.terraform'
  nnoremap <leader>K <cmd>Help<cr>
  nnoremap <leader>r <cmd>History:<cr>
  xnoremap <leader>rg y:Rg <c-r>"<cr>
  nnoremap <leader>fc <cmd>Commands<cr>
  nnoremap <leader>ff <cmd>Files<cr>
  nnoremap <leader>fb <cmd>Buffers<cr>
  " Rg in the current buffer's directory
  command! -bang -nargs=* Rgb
    \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case "
    \ .shellescape(<q-args>), 1, {'dir': expand('%:p:h') }, <bang>0)
  " Overwrite <c-t> to not use :tab
  let g:fzf_action = {
    \ 'ctrl-t': 'tabedit',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }


" Windows specific plugin settings
if s:windows
    let g:fzf_preview_window=''
    nnoremap <leader>K <cmd>Telescope help_tags<cr>
end
call plug#end()

" Lua plugin configs
lua require('plugged')

" Private stuff
if !empty(expand(glob(s:configdir . '/local_settings.vim')))
    execute 'source ' . s:configdir . '/local_settings.vim'
endif

" Indent spaces
set softtabstop=4 shiftwidth=4 expandtab autoindent " copyindent

" Formatting search
set path=.,**,,  " exclude /usr/include and search ** by default
augroup vimrc
    autocmd FileType c,cpp      setlocal path+=/usr/include
augroup END
" ignore patterns for :find
set wildignore+=.git,.hg,.svn
set wildignore+=*__pycache__
set wildignore+=*/node_modules/*
set wildignore+=*/tools/*
set ignorecase smartcase
set incsearch hlsearch
set undofile        " keep an undo file (looks like %home%...%vimrc)
set wildmode=longest:full:lastused,full " zsh tab behavior + "lastused"
set splitbelow splitright
set updatetime=250
set cursorline
set linebreak       " more readable text wrapping
set confirm
set iskeyword+=-      " - counts as part of a word for w and C-]
set list listchars+=lead:.  " show leading spaces
set showtabline=0     " Turn off tabline
set scrolloff=5       " scroll before cursor reaches edge of screen
set foldlevelstart=1

" Enable mouse for scrolling only
set mouse=n
noremap <LeftMouse> <Nop>
noremap <2-LeftMouse> <Nop>
noremap <LeftDrag> <Nop>
noremap <LeftRelease> <Nop>

if s:windows
    set completeslash="slash"
    let &shell = has('win32') ? 'powershell' : 'pwsh'
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
end

function! s:statusline_expr()
  let cwd = "[%{fnamemodify(getcwd(),':p:~')}]"
  " Filename relative to cwd
  let rel = " %{expand('%:~:.')} "
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let mod = "%{&modified ? '│ + ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#head() : ''}"
  let sep = '%='
  let pos = '%-12(%l:%c%V%)'
  let pct = ' %P'
  return cwd.rel.'%<'.ft.mod.ro.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

" Mappings
nnoremap <BS> <C-^>
nnoremap gt :tabs<CR>:tabnext<Space>
vnoremap P "0p
" map <leader><leader> to prompt for a mapping, "<" has to be escaped via <lt>
nmap <leader><leader> :nmap <buffer> <lt>localleader><lt>localleader><space>

nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>p "+p
xnoremap <leader>p "+p
nnoremap <leader>R :source $MYVIMRC<cr>
nnoremap cd <cmd>lcd %:p:h<cr>
nnoremap <Leader>cg :tcd `git rev-parse --show-toplevel`<CR>:pwd<CR>
nnoremap <silent> <leader>l :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
cnoremap <C-A> <Home>
tnoremap <c-\><c-\> <c-\><c-n>

" testing
" remember 1k filemarks
set shada=!,'1000,<50,s10,h
nnoremap f <Nop>
nnoremap t <Nop>
nnoremap T <Nop>
nnoremap F <Nop>
onoremap f <Nop>
onoremap t <Nop>
onoremap T <Nop>
onoremap F <Nop>

augroup vimrc
    autocmd BufRead,BufNewFile *.cake set filetype=cs
    " Auto remove trailing spaces
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
    autocmd FileType gitcommit setlocal spell

    " Markdown Link
    autocmd Filetype markdown nmap <buffer> <leader>md ysiW)i[]<c-o>hlink<esc>
    autocmd Filetype markdown setlocal textwidth=80

    " Turn on hlsearch only when searching (/?). (ps: Use 'yoh' from unimpaired)
    autocmd CmdlineEnter /,\? set hlsearch
    autocmd CmdlineLeave /,\? set nohlsearch
    " Turn off smartcase when typing commands (:)
    autocmd CmdlineEnter : set nosmartcase
    autocmd CmdlineLeave : set smartcase
augroup END

" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme gruvbox
highlight CursorLine ctermfg=white
set guifont=JetBrains\ Mono:h15
