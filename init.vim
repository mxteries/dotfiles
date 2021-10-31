augroup vimrc
  autocmd!
augroup END
let mapleader=" "
let maplocalleader=" "

runtime! ftplugin/man.vim  " Read man pages

" Vim-Plug: Download if does not exist
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-surround'            " for adding surrounding characters
Plug 'tpope/vim-repeat'              " for repeating
Plug 'tpope/vim-commentary'          " for commenting
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'tommcdo/vim-exchange'          " for swapping text
Plug 'tommcdo/vim-lion'
Plug 'hashivim/vim-terraform'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'junegunn/vim-slash'

" Testing
Plug 'tpope/vim-endwise'
Plug 'wellle/targets.vim'
Plug 'nvim-telescope/telescope.nvim', { 'on': 'Telescope'}
Plug 'kristijanhusak/orgmode.nvim'
Plug 'junegunn/gv.vim'
Plug 'rhysd/git-messenger.vim'  " leader gm to trigger

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'morhetz/gruvbox'
  let g:gruvbox_invert_selection=0
  let g:gruvbox_sign_column='bg0'
  let g:gruvbox_hls_cursor='purple'
  let g:gruvbox_italic=1
  let g:gruvbox_bold=1

Plug 'tpope/vim-fugitive'
  nnoremap <Leader>gd :Gdiff<CR>
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

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  nnoremap U :UndotreeToggle<CR>
  let g:undotree_WindowLayout = 2

" fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
  let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=.terraform'
  " let g:fzf_buffers_jump = 1  " open existing windows in :Buffers
  nnoremap gb <cmd>Buffers<cr>
  nnoremap <leader>r <cmd>History:<cr>
  nnoremap <leader>ag :Rg <c-r><c-w><cr>
  xnoremap <leader>ag y:Rg <c-r>"<cr>
  nnoremap <leader>K  <cmd>Help<cr>
  nnoremap <leader>fw <cmd>Windows<cr>
  nnoremap <leader>fc <cmd>Commands<cr>
  nnoremap <leader>ff <cmd>Files<cr>
  " Rg in the current buffer's directory
  command! -bang -nargs=* Rgb
    \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case "
    \ .shellescape(<q-args>), 1, {'dir': expand('%:p:h') }, <bang>0)

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
" LSP + misc
lua <<EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local nvim_lsp = require('lspconfig')
local servers = { 'pyright', 'vimls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'
-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'buffer', keyword_length = 5,
        opts = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }},
    { name = 'nvim_lua', keyword_length = 2 },
    { name = 'nvim_lsp', keyword_length = 2 },
  },
}

require('gitsigns').setup()
EOF

" Store everything in the .nvim directory
if !isdirectory($HOME."/.config/nvim/tmp")
    call mkdir($HOME."/.config/nvim/tmp", "", 0700)
endif
set undofile   " keep an undo file (%home%...%vimrc)
set undodir=~/.config/nvim/tmp,.
set directory=~/.config/nvim/tmp,.

" Formatting indents
set softtabstop=4 shiftwidth=4 expandtab  " use spaces
set autoindent
set copyindent  " copy usage of spaces or tabs
" set listchars=tab:>-,trail:.  " configure list
" set list  " show information about spaces and tabs

" Formatting search
set path=.,**,,  " exclude /usr/include and search ** by default
augroup vimrc
    autocmd FileType c,cpp      setlocal path+=/usr/include
augroup END
" ignore patterns (node_modules) for :find
set wildignore+=tags,*/node_modules/*,*.o,*.class,*/__pycache__,*/tools/*
set ignorecase smartcase
set incsearch hlsearch

if exists('+clipboard')
    set clipboard=unnamedplus
endif
set autowrite
set hidden          " For allowing hiding of unsaved files in our buffer
set wildmode=longest:full:lastused,full " zsh tab behavior + "lastused"
set splitbelow splitright
set updatetime=250
set cursorline
set linebreak       " more readable text wrapping
set confirm
set iskeyword+=-    " - counts as part of a word for w and C-]

" Enable mouse for scrolling and clicking, but disable all selection
set mouse=nv
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

" map <leader><leader> to prompt for a mapping, "<" has to be escaped via <lt>
nmap <leader><leader> :nmap <lt>buffer> <lt>leader><lt>leader>
nnoremap <leader>cc :cclose<bar>lclose<cr>
nnoremap <Leader>cd :tcd %:p:h<CR>:pwd<CR>
nnoremap <Leader>cg :tcd `git rev-parse --show-toplevel`<CR>:pwd<CR>
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
nnoremap <silent> <leader>l :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Use ctrl v for terminal related mappings
tnoremap <c-v><c-v> <c-\><c-n>

augroup vimrc
    " Auto remove trailing spaces
    autocmd BufRead,BufNewFile *.cake set filetype=cs
    autocmd BufWritePre * %s/\s\+$//e
    autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}
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
hi CursorLine ctermfg=white
