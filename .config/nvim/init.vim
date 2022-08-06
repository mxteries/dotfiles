augroup vimrc
    autocmd!
augroup END
let mapleader=" "
let maplocalleader=" "

let s:configdir = stdpath('config')
let s:windows = has('win32') || has('win64')

""" Plugins {{{1
let s:plugdir = s:configdir . '/plugged'
call plug#begin(s:plugdir)
Plug 'tommcdo/vim-lion'
Plug 'junegunn/goyo.vim' | let g:goyo_width=88 | let g:goyo_height="100%"
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary' | Plug 'tpope/vim-repeat' | Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-markdown' | let g:markdown_folding = 1
Plug 'tpope/vim-apathy'
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'rhysd/git-messenger.vim'  " leader gm to trigger
Plug 'Sangdol/mintabline.vim'
Plug 'FooSoft/vim-argwrap'
  nnoremap <leader>J <cmd>ArgWrap<cr>
Plug 'whiteinge/diffconflicts'

" nvim plugins
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-cmdline'
Plug 'mfussenegger/nvim-lint'
Plug 'folke/which-key.nvim' | set timeoutlen=450
if !s:windows
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-refactor'
end

Plug 'sainnhe/everforest' | let g:everforest_background = 'hard'
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
    augroup vimrc
        " map r to lcd then start :Rg
        autocmd FileType dirvish
                    \ nnoremap <buffer> r :lcd <c-r><c-p> \| Rg<space>
    augroup END

" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
    " let g:fzf_layout = { 'window': '-tabnew' }
Plug 'junegunn/fzf.vim'
    let g:fzf_command_prefix = 'Fzf'
    let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=.terraform'
    nnoremap <leader>K <cmd>FzfHelp<cr>
    xnoremap <leader>K y:FzfHelp<cr><c-\><c-n>pi
    nnoremap <leader>r <cmd>FzfRg<cr>
    nnoremap R <cmd>FzfRg<cr>
    xnoremap <leader>r y:FzfRg <c-r>"<cr>
    xnoremap R y:FzfRg <c-r>"<cr>
    nnoremap <leader>f; <cmd>FzfCommands<cr>
    nnoremap <leader>ff <cmd>FzfFiles<cr>
    nnoremap <leader>fb <cmd>FzfBuffers<cr>
    nnoremap <leader>fh <cmd>FzfHistory:<cr>
    nnoremap <leader>fr <cmd>FzfHistory<cr>
    nnoremap <leader>f/ <cmd>FzfHistory/<cr>
    nnoremap <leader>fl <cmd>FzfBLines<cr>
    nnoremap <leader>fw <cmd>FzfWindows<cr>
    let $BAT_THEME = 'gruvbox'

" Windows specific plugin settings
if s:windows
    let g:fzf_preview_window=''
else
endif

call plug#end()

" Lua plugin configs
lua require('plugged')
colorscheme everforest

" if !empty(expand(glob(s:configdir . '/local_settings.vim')))
"     execute 'source ' . s:configdir . '/local_settings.vim'
" endif

""" Settings {{{1
let g:do_filetype_lua = 1 | let g:did_load_filetypes = 0
" Indent spaces
set softtabstop=4 shiftwidth=4 expandtab autoindent copyindent
" Formatting search
set wildignore+=.git,.hg
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
set guifont=JetBrains\ Mono:h14
set foldlevel=1
set laststatus=3

" Enable mouse primarily for scrolling
set mouse=n
noremap <LeftMouse> <Nop>
noremap <RightMouse> <Nop>
noremap <2-LeftMouse> <3-LeftMouse>
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
nnoremap <silent> <tab> za
" Use zf for manual folding always
nnoremap zf <cmd>setl fdm&<CR>zf
xnoremap zf <cmd>setl fdm&<CR>zf

""" Mappings {{{1

"" Navigation and windows
" ':h terminal-input'
" tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
tnoremap <C-z> <C-\><C-N>
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
nnoremap <leader>lo <cmd>lua vim.diagnostic.open_float()<cr>
nnoremap <leader>ln <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>lp <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <BS> <C-^>
cnoremap <C-A> <Home>
nnoremap <left> 3<c-w><c-<>
nnoremap <right> 3<c-w><c->>
nnoremap <down> 2<c-w><c-+>
nnoremap <up> 2<c-w><c-->
nnoremap cd <cmd>lcd %:p:h<cr>
nnoremap cD <cmd>lcd ..<cr>
nnoremap <leader>t <cmd>split <bar> norm <c-w>T<cr>
nnoremap <leader>O <cmd>Goyo<cr>

"" git
" <leader>gm is git messenger
nnoremap <leader>gg <cmd>G<cr>
" Requires configuring core.worktree: `git --git-dir=.dotfiles config core.worktree "$HOME"`
nnoremap <leader>g. <cmd>call FugitiveDetect(expand('~/.dotfiles')) \| G<cr>
nnoremap <leader>gD :lcd `git rev-parse --show-toplevel`<CR>:pwd<CR>
nnoremap <leader>gf <cmd>GFiles<cr>
nnoremap <leader>gs <cmd>GFiles?<cr>
nnoremap <leader>gc <cmd>Commits<cr>
nnoremap <leader>gC <cmd>BCommits<cr>
xnoremap <leader>gc :BCommits<cr>

"" Editing
nnoremap <leader>Y "+Y
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>p "+p
xnoremap <leader>p "+p
xnoremap P "0p
xnoremap <leader>@ :norm @

"" cool mappings
" replace every occurrence of word under cursor on this line
xnoremap s "sy:s/<c-r>s//g<left><left>
nnoremap <leader>s :s/<c-r><c-w>//g<left><left>
nnoremap <leader>S :s/<c-r><c-a>//g<left><left>

" split selection to separate file
xnoremap <leader>n y:new<cr>P

" map <leader>\ to prompt for a mapping, "<" has to be escaped via <lt>
nmap <leader>\ :nmap <buffer> <lt>leader><lt>leader><leader>

" select last yanked/changed text
nnoremap gy `[v`]

" qi starts recording a macro and enters insert mode, and allows "esc" to stop the macro
" this means you can use `qi` and `Q` to do more advanced repeats
function! RecordInsert()
    inoremap <esc> <esc>q:iunmap <lt>esc><cr>
    " autocmd RecordingLeave * ++once iunmap <esc>
    " use the i register. 'nt' is crucial here
    " norm! doesn't work because it leaves insert mode
    call feedkeys('qii', 'nt')
endfunc
nnoremap qi :call RecordInsert()<cr>
nnoremap <leader>R <cmd>source $MYVIMRC<cr>
nnoremap <leader>c :Run<cr>
xnoremap <leader>c :Run<cr>
""" Misc
" remember 3k filemarks
set shada=!,'3000,<50,s10,h
" Don't store file marks for the following paths
set shada+=rterm
set shada+=rfugitive
set shada+=r/private
set shada+=r/tmp
lua require('zeal')

" highlight StatusLine guifg=#e2eac0 guibg=#8c3540

" Redirect the output of a Vim or external command into a scratch buffer
function! Redir(cmd) abort
    let output = execute(a:cmd)
    tabnew
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    call setline(1, split(output, "\n"))
endfunction
command! -nargs=1 Redir silent call Redir(<f-args>)

function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Greppin
if executable('rg')
    set grepprg=rg\ --vimgrep\ --glob\ '!*{.git,.terraform,tags}'
end
function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

""" autocmds {{{1
augroup vimrc
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd BufWritePre * %s/\s\+$//e
    autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
    autocmd TermOpen * startinsert

    " Filetypes
    " use treesitter folding, 1 fold only
    autocmd FileType lua,python,terraform setlocal foldnestmax=1 foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
    " don't continue comments in lua files (optionally -=r as well)
    autocmd FileType lua setlocal formatoptions-=o
    autocmd FileType vim setlocal foldmethod=marker
    " autocmd FileType json setlocal foldmethod=syntax
    autocmd FileType fugitive nmap <buffer> <tab> =
    autocmd FileType gitcommit setlocal spell textwidth=72 foldmethod=syntax
    autocmd FileType man setlocal scrolloff=5 | nnoremap <buffer> <space>/ /^\s\+
    autocmd BufLeave *.md update
    autocmd Filetype markdown
                \ nmap <buffer> <leader>md i[text](url)<esc>
                \| nnoremap <buffer> j gj
                \| nnoremap <buffer> k gk
                \| nnoremap <buffer> <tab> za
    autocmd BufRead,BufNewFile *.cake set filetype=cs

    " Turn on hlsearch when searching /? (and also for :s :g)
    autocmd CmdlineEnter :,/,\? set hlsearch
    autocmd CmdlineLeave :,/,\? set nohlsearch
    " Turn off smartcase when typing commands (:)
    autocmd CmdlineEnter : set nosmartcase
    autocmd CmdlineLeave : set smartcase
augroup END
