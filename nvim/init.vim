augroup vimrc
  autocmd!
augroup END
let mapleader=" "
let maplocalleader=" "

runtime! ftplugin/man.vim  " Read man pages

let s:windows = has('win32') || has('win64')
let s:plugdir = '~/.config/nvim/plugged'
if s:windows
    let s:plugdir = '~/AppData/Local/nvim/plugged'
end

call plug#begin(s:plugdir)
" Testing
Plug 'tpope/vim-speeddating'
Plug 'habamax/vim-godot'
Plug 'rhysd/clever-f.vim'
Plug 'tommcdo/vim-lion'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'

Plug 'tpope/vim-unimpaired'          " Useful mappings
Plug 'tpope/vim-commentary'          " for commenting
Plug 'tpope/vim-repeat'              " for repeating
Plug 'tpope/vim-surround'            " for adding surrounding characters
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'tommcdo/vim-exchange'          " for swapping text
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" nvim plugins
Plug 'nvim-lua/plenary.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-telescope/telescope.nvim', { 'on': 'Telescope'}
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
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
      " Map `t` to open in new tab.
      autocmd FileType dirvish
        \  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0) \| tcd %:h<CR>
        \ |xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0) \| tabdo tcd %:h<CR>
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

" Windows specific plugin settings
if s:windows
    let g:fzf_preview_window=''
    nnoremap <leader>K <cmd>Telescope help_tags<cr>
end
call plug#end()

" Lua plugin configs
lua require('plugged')

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
" set clipboard=unnamedplus
set undofile        " keep an undo file (looks like %home%...%vimrc)
set hidden          " For allowing hiding of unsaved files in our buffer
set wildmode=longest:full:lastused,full " zsh tab behavior + "lastused"
set splitbelow splitright
set updatetime=250
set cursorline
set linebreak       " more readable text wrapping
set confirm
set iskeyword+=-    " - counts as part of a word for w and C-]
set showtabline=0   " Turn off tabline

" Enable mouse for scrolling only
set mouse=n
noremap <LeftMouse> <Nop>
noremap <LeftRelease> <Nop>
noremap <LeftDrag> <Nop>
noremap <2-LeftMouse> <Nop>

if s:windows
    set completeslash="slash"
    let &shell = has('win32') ? 'powershell' : 'pwsh'
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
end

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
vnoremap P "0p
" map <leader><leader> to prompt for a mapping, "<" has to be escaped via <lt>
nmap <leader><leader> :nmap <lt>buffer> <lt>leader><lt>leader>

nnoremap <leader>R :source $MYVIMRC<cr>
nnoremap <leader>cc :cclose<bar>lclose<cr>
nnoremap <Leader>cd :tcd %:p:h<CR>:pwd<CR>
nnoremap <Leader>cg :tcd `git rev-parse --show-toplevel`<CR>:pwd<CR>
nnoremap <silent> <leader>l :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
cnoremap <C-A> <Home>

" Use ctrl v for terminal related mappings
tnoremap <c-v><c-v> <c-\><c-n>

augroup vimrc
    autocmd BufRead,BufNewFile *.md setlocal textwidth=72
    autocmd BufRead,BufNewFile *.cake set filetype=cs
    " Auto remove trailing spaces
    autocmd BufWritePre * %s/\s\+$//e
    " Auto source init vim
    autocmd BufWritePost $MYVIMRC source $MYVIMRC | echo "Reloaded $MYVIMRC"
    autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
augroup END

" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme gruvbox
hi CursorLine ctermfg=white
