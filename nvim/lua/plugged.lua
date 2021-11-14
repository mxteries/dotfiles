local windows = vim.fn.has('win64') == 1

--- lsp ---
local nvim_lsp = require('lspconfig')
local servers = {}  -- fill out lsps here

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

if windows then
    -- Godot LSP stuff
    -- https://www.reddit.com/r/neovim/comments/oiani5/need_help_setting_up_native_lsp_for_godot/
    nvim_lsp.gdscript.setup{
        cmd = { [[C:\Users\mxter\Documents\godot_projects\ncat.exe]], "localhost", "6008" },
        on_attach = on_attach,
        capabilities = capabilities,
    }
else
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            -- on_attach = my_custom_on_attach,
            capabilities = capabilities,
        }
    end
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
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
        },
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
        -- source all buffers in insert mode
        { name = 'buffer', keyword_length = 5,
        opts = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }},
        { name = 'nvim_lua', keyword_length = 2 },
        { name = 'nvim_lsp', keyword_length = 2 },
    },
}
-- Use buffer source for / and ?
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer', keyword_length = 2 }
    }
})
cmp.setup.cmdline('?', {
    sources = {
        { name = 'buffer', keyword_length = 2 }
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
        ensure_installed = { "lua", "vim", "python", "query" },
        highlight = {
            enable = true,
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
require('gitsigns').setup()
