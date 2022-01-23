local windows = vim.fn.has('win64') == 1
local mac = vim.fn.has('mac') == 1
local linux = vim.fn.has('unix') == 1

local servers = {}    -- lsp servers
local ts_parsers = {} -- treesitter
if mac then
    -- servers = { 'pyright' }
    servers = {}
    ts_parsers = { "go", "bash", "hcl", "lua", "vim", "python", "ruby", "query", "org" }
elseif linux then
    ts_parsers = { "lua", "vim", "python", "query", "org" }
end

--- lsp ---
local nvim_lsp = require('lspconfig')


-- LSP Keybindings
local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ltD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lso', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

if mac then
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end
elseif linux then
    -- sumneko lua
    local sumneko_root_path = vim.fn.stdpath('cache')..'/lua-language-server'
    local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'

    -- Make runtime files discoverable to the server
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    require('lspconfig').sumneko_lua.setup {
        cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Love2d
                    library = {
                        [sumneko_root_path .. '/meta/3rd/love2d/library'] = true
                    },
                    checkThirdParty = false
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }
end

--- nvim.cmp ---
local cmp = require'cmp'
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'
cmp.setup {
    mapping = {
        ['<S-Up>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<S-Down>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace
            },
            { 'i', 'c' }
        ),
        ['<Tab>'] = cmp.mapping({
            -- Tab trigger completion in insert mode
            -- Tab only navigates in cmd mode
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end,
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end,
        }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 'c'}),
    },
    sources = {
        { name = 'buffer', keyword_length = 5,
            options = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }},
        { name = 'nvim_lua', keyword_length = 5 },
        { name = 'nvim_lsp', keyword_length = 3 },
        { name = 'orgmode', keyword_length = 2 },
    },
}
-- Use buffer source for / and ?
-- trigger with <c-space>
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer', keyword_length = 10 }
    }
})
cmp.setup.cmdline('?', {
    sources = {
        { name = 'buffer', keyword_length = 10 }
    }
})
-- Use path source for ':'
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    })
})

--- Tree-sitter ---
if not windows then
    require'nvim-treesitter.configs'.setup {
        ensure_installed = ts_parsers,
        highlight = {
            enable = true,
            disable = {'org', 'ruby'},
            additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
        },
        textobjects = {
            select = {
                enable = true,
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@conditional.outer",
                    ["ic"] = "@conditional.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    -- Or you can define your own textobjects like this
                    ["iF"] = {
                        python = "(function_definition) @function",
                        cpp = "(function_definition) @function",
                        c = "(function_definition) @function",
                        java = "(method_declaration) @function",
                    },
                },
            },
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                node_incremental = '<TAB>',
                node_decremental = '<S-TAB>',
            }
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
            },
        }
    }
end

--- everything else ---
require('telescope').load_extension('fzf')
require('gitsigns').setup()
local presets = require("which-key.plugins.presets")
presets.operators = {}
require("which-key").setup {
    presets = {
        operators = false,
        motions = false, -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
    },
    window = {
        border = "single", -- none, single, double, shadow
        margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
        winblend = 20
    },
    layout = {
        width = { min = 20, max = 100 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
}
require('lint').linters_by_ft = {
    python = {'pylint'},
    sh = {'shellcheck'},
    zsh = {'shellcheck'},
    yaml = {'yamllint',},
    rb = {'ruby',},
}

vim.api.nvim_command([[
    autocmd! BufWritePost * lua require('lint').try_lint()
]])

require('orgmode').setup({
    -- treesitter parser must be installed, easiest to just
    -- compile it and drop in the parser dir imo unless you have npm installed
    -- https://github.com/milisims/tree-sitter-org
    -- gcc -o org.so -I./src src/parser.c src/scanner.cc -shared -Os -lstdc++
    org_agenda_files = {'~/me/org/*'},
    org_default_notes_file = '~/me/org/notes.org',
})
