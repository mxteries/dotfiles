augroup vimrc
    autocmd!
augroup END
let mapleader=","
let maplocalleader=","

let s:configdir = stdpath('config')
let s:windows = has('win32') || has('win64')

""" Plugins {{{1
let s:plugdir = s:configdir . '/plugged'
call plug#begin(s:plugdir)
Plug 'tpope/vim-speeddating'
Plug 'tommcdo/vim-lion'
Plug 'junegunn/goyo.vim' | let g:goyo_width=88 | let g:goyo_height="100%"
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
Plug 'tpope/vim-rhubarb'
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
                    \|nnoremap <buffer> R :lcd <c-r><c-p> \| Rg<space>
                    \|nnoremap <buffer> r :lcd <c-r><c-p> \| Rg<cr>
        autocmd FileType dirvish silent! unmap <buffer> <c-p>
    augroup END

" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
    let g:fzf_layout = { 'window': '-tabnew' }
Plug 'junegunn/fzf.vim'
    let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=.terraform'
    nnoremap <space>K <cmd>Help<cr>
    xnoremap <space>K y:Help<cr><c-\><c-n>pi
    nnoremap <space>r <cmd>History:<cr>
    xnoremap R y:Rg <c-r>"<cr>
    nnoremap <leader>fc <cmd>Commands<cr>
    nnoremap <leader>ff <cmd>Files<cr>
    nnoremap <leader>fb <cmd>Buffers<cr>
    nnoremap <leader>fo <cmd>Colors<cr>
    nnoremap <leader>fh <cmd>History<cr>
    nnoremap <leader>f/ <cmd>History/<cr>
    nnoremap <leader>fL <cmd>Lines<cr>
    nnoremap <leader>fl <cmd>BLines<cr>
    nnoremap <leader>ft <cmd>Tags<cr>
    nnoremap <leader>fT <cmd>BTags<cr>
    nnoremap <leader>fw <cmd>Windows<cr>
    nnoremap <leader>fM <cmd>Marks<cr>
    nnoremap <leader>fm <cmd>Maps<cr>
    nnoremap <leader>fp <cmd>Filetypes<cr>

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

""" Settings {{{1
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
set pumblend=20
set signcolumn=yes    " always show sign column
set termguicolors
set nowrapscan
set guifont=JetBrains\ Mono:h15

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
    let sep = '%='
    let pos = '%-12(%l:%c%V%)'
    let pct = ' %P'
    return cwd.rel.'%<'.ft.mod.ro.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

function! Myfoldtext() abort
    let line = getline(v:foldstart)
    let foldsize = (v:foldend - v:foldstart + 1)
    let linecount = '['.foldsize.' lines]'
    return line.' '.linecount
endfunction
set foldtext=Myfoldtext()
nnoremap <silent> <tab> @=(foldlevel('.')?'za':"\<tab>")<CR>
" Use zf for manual folding always
nnoremap zf <cmd>setl fdm&<CR>zf
xnoremap zf <cmd>setl fdm&<CR>zf

""" Mappings {{{1
" Idea: use <leader> for multi keystrokes with which-key, use <space> for one letter modifier
nnoremap <space>l <cmd>echo "use ,"<cr>

"" Navigation and windows
" ':h terminal-input'
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
nnoremap 8 <c-d>
nnoremap 9 <c-u>
nnoremap <PageDown> <c-d>
nnoremap <PageUp> <c-u>
nnoremap <c-w>O <cmd>Goyo<cr>
nnoremap <space>o <cmd>Goyo<cr>
" Alternative C-i mapping for when tab is mapped over
nnoremap <A-i> <C-i>
nnoremap <A-o> <C-o>
nnoremap <BS> <C-^>
cnoremap <C-A> <Home>
nnoremap <left> 3<c-w><c-<>
nnoremap <right> 3<c-w><c->>
nnoremap <down> 2<c-w><c-+>
nnoremap <up> 2<c-w><c-->
nnoremap cd <cmd>lcd %:p:h<cr>
nnoremap cD <cmd>lcd ..<cr>
nnoremap <leader>lo <cmd>lua vim.diagnostic.open_float()<cr>
nnoremap <leader>ln <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>lp <cmd>lua vim.diagnostic.goto_prev()<CR>

"" git
nnoremap <space>g <cmd>G<cr>
" <leader>gm is git messenger
nnoremap <leader>gg :lcd `git rev-parse --show-toplevel`<CR>:pwd<CR>
nnoremap <leader>gf <cmd>GFiles<cr>
nnoremap <leader>gs <cmd>GFiles?<cr>
nnoremap <leader>gc <cmd>Commits<cr>
nnoremap <leader>gC <cmd>BCommits<cr>
xnoremap <leader>gc :BCommits<cr>

"" Terminal and Tabs
" tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
nnoremap <space>t <cmd>botright split <bar> term<cr>
nnoremap <space>T <cmd>split <bar> norm <c-w>T<cr>

"" Editing
nnoremap <space>Y "+Y
nnoremap <space>y "+y
xnoremap <space>y "+y
nnoremap <space>p "+p
xnoremap <space>p "+p
xnoremap P "0p
xnoremap <space>@ :norm @
" replace every occurrence of word under cursor on this line
xnoremap s y:s/<c-r>"//g<left><left>
nnoremap <space>s :s/<c-r><c-w>//g<left><left>
nnoremap <leader>ciw :s/<c-r><c-w>//g<left><left>
nnoremap <leader>ciW :s/<c-r><c-a>//g<left><left>

" map <leader>\ to prompt for a mapping, "<" has to be escaped via <lt>
nmap <space>\ :nmap <buffer> <lt>space><lt>space><space>
nnoremap <space>R <cmd>source $MYVIMRC<cr>

""" Misc and testing {{{1
" remember 10k filemarks
set shada=!,'10000,<50,s10,h
" Don't store file marks for the following paths
set shada+=rterm
set shada+=rfugitive
set shada+=r/private
" ready for testing!
lua require('zeal')

nnoremap f <Nop>
nnoremap T <Nop>
nnoremap t <Nop>
nnoremap F <Nop>

" custom floating term
nnoremap <F6> <cmd>lua require("test").toggle()<CR>
tnoremap <F6> <c-\><c-n><cmd>lua require("test").toggle()<CR>
""" TESTING end

" Redirect the output of a Vim or external command into a scratch buffer
function! Redir(cmd) abort
    let output = execute(a:cmd)
    tabnew
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    call setline(1, split(output, "\n"))
endfunction
command! -nargs=1 Redir silent call Redir(<f-args>)

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

""" autocmds {{{1
augroup vimrc
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd BufWritePre * %s/\s\+$//e
    autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
    autocmd TermOpen * startinsert

    " Filetypes
    " use treesitter folding, 1 fold only
    autocmd FileType lua,python,terraform setlocal foldnestmax=1 foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType json setlocal foldmethod=syntax
    autocmd FileType fugitive nmap <buffer> <tab> =
    autocmd FileType git,gitcommit setlocal spell textwidth=72 foldmethod=syntax
    autocmd FileType man nnoremap <buffer> <space>/ /^\s\+
    autocmd Filetype markdown
                \ nmap <buffer> <leader>md ysiW)i[]<c-o>hlink<esc>
                \| nnoremap <buffer> j gj
                \| nnoremap <buffer> k gk
                \| nnoremap <buffer> <tab> za
    autocmd FileType org nnoremap <buffer> <space>c <cmd>.w !zsh<cr>
    autocmd BufRead,BufNewFile *.cake set filetype=cs

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
