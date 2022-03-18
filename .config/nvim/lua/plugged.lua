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
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lc', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ly', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
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
local luasnip = require("luasnip")
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'
cmp.setup {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
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
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
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
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 'c'}),
    },
    sources = {
        {
            name = 'buffer',
            keyword_length = 5,
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            },
        },
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
                enable = false,
                lookahead = false,
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
        refactor = {
            highlight_definitions = {
                enable = true,
                -- Set to false if you have an `updatetime` of ~100.
                clear_on_cursor_move = false,
            },
            highlight_current_scope = { enable = false },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = "<leader>lr",
                },
            },
            navigation = {
                enable = false,
                keymaps = {
                    goto_definition = "<leader>ld",
                    list_definitions = "<leader>ls",
                    goto_next_usage = "<a-*>",
                    goto_previous_usage = "<a-#>",
                },
            },
        },
    }
end

--- everything else ---
require('telescope').load_extension('fzf')
require('gitsigns').setup()
local presets = require("which-key.plugins.presets")
presets.operators = {}
require("which-key").setup {
    presets = {
        operators = true,
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
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
        height = { min = 4, max = 40 }, -- min and max height of the columns
        width = { min = 20, max = 100 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
}
require("which-key").register({
  ["<leader>f"] = { name = "+fzf" },
  ["<leader>l"] = { name = "+diag [+lsp +ts]" },
  ["<leader>o"] = { name = "+org" },
  ["<leader>g"] = { name = "+git" },
})
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

-- colorschemes
-- this will affect all the hl-groups where the redefined colors are used
-- local my_colors = {
--     fujiGray = "#8b949e",  -- more readable comment color
-- }
-- require('kanagawa').setup({
--     colors = my_colors,
--     undercurl = true,           -- enable undercurls
--     commentStyle = "italic",
--     functionStyle = "NONE",
--     keywordStyle = "NONE",
--     statementStyle = "bold",
--     typeStyle = "NONE",
--     variablebuiltinStyle = "NONE",
--     specialReturn = false,       -- special highlight for the return keyword
--     specialException = false,    -- special highlight for exception handling keywords
--     transparent = false,        -- do not set background color
--     dimInactive = true,        -- dim inactive window `:h hl-NormalNC`
-- })


-- local hour = tonumber(os.date('%H'))
-- if (hour > 8 and hour < 17) then
--     vim.cmd("set background=light")
-- end
-- vim.cmd("colorscheme gruvbox")
vim.cmd("colorscheme everforest")
