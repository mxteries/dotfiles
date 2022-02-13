augroup vimrc
  autocmd!
augroup END
let mapleader=" "
let maplocalleader=" "

let s:configdir = stdpath('config')
let s:windows = has('win32') || has('win64')
let s:plugdir = s:configdir . '/plugged'

call plug#begin(s:plugdir)
Plug 'tpope/vim-speeddating'
Plug 'tommcdo/vim-lion'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-unimpaired'          " Useful mappings
Plug 'tpope/vim-commentary'          " for commenting
Plug 'tpope/vim-repeat'              " for repeating
Plug 'tpope/vim-surround'            " for adding surrounding characters
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

Plug 'rhysd/git-messenger.vim'  " leader gm to trigger
" todo: gitconfig make verbose default, add commit template

" nvim plugins
Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'lewis6991/gitsigns.nvim'
Plug 'numToStr/FTerm.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'mfussenegger/nvim-lint'
Plug 'folke/which-key.nvim' | set timeoutlen=350
Plug 'nvim-orgmode/orgmode'
if !s:windows
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/playground'
end

Plug 'tpope/vim-fugitive'
Plug 'morhetz/gruvbox'
  let g:gruvbox_invert_selection=0
  let g:gruvbox_sign_column='bg0'
  let g:gruvbox_hls_cursor='purple'
  let g:gruvbox_italic=1
  let g:gruvbox_bold=1

" colorscheme test
Plug 'catppuccin/nvim'
Plug 'rebelot/kanagawa.nvim'

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
        \|nnoremap <buffer> R :lcd <c-r><c-p> \| Rg<space>
        \|nnoremap <buffer> r :lcd <c-r><c-p> \| Rg<cr>
      autocmd FileType dirvish silent! unmap <buffer> /
      autocmd FileType dirvish silent! unmap <buffer> <c-p>
  augroup END

" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
  let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=.terraform'
  nnoremap <leader>K <cmd>Help<cr>
  xnoremap <leader>K y:Help<cr><c-\><c-n>pi
  nnoremap <leader>r <cmd>History:<cr>
  xnoremap <leader>rg y:Rg <c-r>"<cr>
  nnoremap <leader>fc <cmd>Commands<cr>
  nnoremap <leader>ff <cmd>Files<cr>
  nnoremap <leader>fb <cmd>Buffers<cr>
  " Rg in the current buffer's directory
  " command! -bang -nargs=* Rgb
  "   \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case "
  "   \ .shellescape(<q-args>), 1, {'dir': expand('%:p:h') }, <bang>0)
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

let g:markdown_folding = 1

Plug 'hashivim/vim-terraform'
Plug 'tommcdo/vim-fubitive'

call plug#end()

" Lua plugin configs
lua require('plugged')

" Private stuff
if !empty(expand(glob(s:configdir . '/local_settings.vim')))
    execute 'source ' . s:configdir . '/local_settings.vim'
endif

" Indent spaces
set softtabstop=4 shiftwidth=4 expandtab autoindent copyindent

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
set incsearch nohlsearch
set undofile        " keep an undo file (looks like %home%...%vimrc)
set wildmode=longest:full:lastused,full " zsh tab behavior + "lastused"
set splitbelow splitright
set updatetime=250
set cursorline
set linebreak         " more readable text wrapping
set confirm
set iskeyword+=-      " - counts as part of a word for w and C-]
set list listchars+=lead:.  " show leading spaces
" set scrolloff=5       " scroll before cursor reaches edge of screen
set foldlevelstart=1
set pumblend=20
set signcolumn=yes    " always show sign column
set termguicolors

" Enable mouse for scrolling only
set mouse=n
noremap <LeftMouse> <Nop>
noremap <RightMouse> <Nop>
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
  " gets branch or commit if detached head (see plugin/fugitive.vim)
  let fug = "%{exists('g:loaded_fugitive') ? FugitiveHead(7) : ''}"
  let org = " %{v:lua.orgmode.statusline()}"
  let sep = '%='
  let pos = '%-12(%l:%c%V%)'
  let pct = ' %P'
  return cwd.rel.'%<'.ft.mod.ro.fug.org.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()


" Mappings
nnoremap cd <cmd>lcd %:p:h<cr>
nnoremap cD <cmd>lcd ..<cr>
nnoremap <leader>cg :lcd `git rev-parse --show-toplevel`<CR>:pwd<CR>

" ':h terminal-input'
" tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap <leader>ts <cmd>botright split <bar> term<cr>
nnoremap <leader>tv <cmd>vsplit <bar> term<cr>
nnoremap <leader>tn <cmd>tabnew <bar> term<cr>

nnoremap <leader>Y "+Y
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>p "+p
xnoremap <leader>p "+p
vnoremap P "0p

nnoremap <leader>R :source $MYVIMRC<cr>

" replace every occurrence of word under cursor on this line
nnoremap <leader>ciw :s/<c-r><c-w>//g<left><left>
nnoremap <leader>ciW :s/<c-r><c-a>//g<left><left>
xnoremap <leader>c  y:s/<c-r>"//g<left><left>

nnoremap <leader>lo <cmd>lua vim.diagnostic.open_float()<cr>
nnoremap <leader>ln <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>lp <cmd>lua vim.diagnostic.goto_prev()<CR>

" Alternative C-i mapping for when tab is mapped over
nnoremap <A-i> <C-i>
nnoremap <A-o> <C-o>
nnoremap <BS> <C-^>
cnoremap <C-A> <Home>

nnoremap <left> 3<c-w><c-<>
nnoremap <right> 3<c-w><c->>
nnoremap <down> 2<c-w><c-+>
nnoremap <up> 2<c-w><c-->

" map <leader>\ to prompt for a mapping, "<" has to be escaped via <lt>
nmap <leader>\ :nmap <buffer> <lt>leader><lt>leader><space>

" testing
" remember 1k filemarks
set shada=!,'1000,<50,s10,h
nnoremap f <cmd>Files<cr>
nnoremap T <Nop>
nnoremap F <Nop>

nnoremap <F6> <cmd>lua require("FTerm").toggle()<CR>
tnoremap <F6> <c-\><c-n><cmd>lua require("FTerm").toggle()<CR>

augroup vimrc
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd BufWritePre * %s/\s\+$//e
    autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
    autocmd TermOpen * startinsert

    " Filetypes
    autocmd FileType fugitive nmap <buffer> <tab> =
    autocmd FileType gitcommit setlocal spell textwidth=72 foldmethod=syntax
    autocmd Filetype markdown
                \ nmap <buffer> <leader>md ysiW)i[]<c-o>hlink<esc>
                \| nnoremap <buffer> j gj
                \| nnoremap <buffer> k gk
                \| nnoremap <buffer> <tab> za
    autocmd BufRead,BufNewFile *.cake set filetype=cs
    autocmd FileType org nnoremap <buffer> <leader>cc <cmd>.w !zsh<cr>

    " Turn on hlsearch when searching /? (and also for :s :g)
    autocmd CmdlineEnter :,/,\? set hlsearch
    autocmd CmdlineLeave :,/,\? set nohlsearch
    " Turn off smartcase when typing commands (:)
    autocmd CmdlineEnter : set nosmartcase
    autocmd CmdlineLeave : set smartcase
augroup END

" Enable true color
" if exists('+termguicolors')
"   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"   set termguicolors
" endif

set guifont=JetBrains\ Mono:h15
