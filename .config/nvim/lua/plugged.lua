local windows = vim.fn.has('win64') == 1
local mac = vim.fn.has('mac') == 1
local linux = vim.fn.has('unix') == 1

local ts_parsers = {} -- treesitter
if mac then
    servers = {}
    ts_parsers = { "go", "bash", "hcl", "lua", "vim", "python", "ruby", "query"}
elseif linux then
    vim.g.python3_host_prog = '/usr/bin/python3'
    ts_parsers = { "lua", "vim", "python", "query"}
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
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            print('lol no')
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<S-Up>'] = cmp.mapping.scroll_docs(-4),
        ['<S-Down>'] = cmp.mapping.scroll_docs(4),
        ['<C-c>'] = cmp.mapping.abort(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace
        },
        -- Tab trigger completion in insert mode
        -- Tab only navigates in cmd mode
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
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
    }),
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
    },
}
-- Use buffer source for / and ?
-- trigger with <c-space>
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline({
        ['<Tab>'] = {
            c = function()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    -- Trigger complete menu and select next
                    cmp.complete()
                    cmp.select_next_item()
                end
            end,
        },
    }),
    sources = {
        { name = 'buffer', keyword_length = 4 }
    }
})
cmp.setup.cmdline('?', {
    mapping = cmp.mapping.preset.cmdline({
        ['<Tab>'] = {
            c = function()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    -- Trigger complete menu and select next
                    cmp.complete()
                    cmp.select_next_item()
                end
            end,
        },
    }),
    sources = {
        { name = 'buffer', keyword_length = 4 }
    }
})
-- Use path source for ':'
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
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
            disable = {'ruby'},
            additional_vim_regex_highlighting = {}, -- Required since TS highlighter doesn't support all syntax features (conceal)
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = false,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",

                    ["x"] = "@swappable",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<c-n>"] = "@swappable",
                },
                swap_previous = {
                    ["<c-p>"] = "@swappable",
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
        playground = {
            enable = false,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false,
        }
    }
end

--- everything else ---
require('telescope').load_extension('fzf')
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>htb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>htd', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
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
  ["<leader>g"] = { name = "+git" },
  ["<leader>h"] = {
      name = "+gitsigns",
      ['S'] = "gs.stage_buffer",
      ['u'] = "gs.undo_stage_hunk",
      ['R'] = "gs.reset_buffer",
      ['p'] = "gs.preview_hunk",
      ['b'] = "budget git messenger",
      ['tb'] = "gs.toggle_current_line_blame",
      ['d'] = "gs.diffthis",
      ['D'] = "function() gs.diffthis('~') end",
      ['td'] = "gs.toggle_deleted",
  },
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

vim.cmd("colorscheme everforest")

-- custom lua funcs here
P = function(v)
    print(vim.inspect(v))
    return v
end

-- Runs something for the current buffer
-- Can overload functionality by using the 0 range in the future
Run = function(line1, line2)
    local range = line1 .. ',' .. line2
    local command = ''
    local ft = vim.bo.filetype
    -- local path = '"' .. vim.fn.expand('%') .. '"'
    if ft == 'python' then
        command = range .. 'w !python3'
    elseif ft == 'lua' then
        command = range .. 'source'
    elseif ft == 'sh' or ft == 'bash' or ft == 'zsh' then
        command = range .. 'w !bash'
    end
    vim.notify(command)
    vim.cmd(command)
end
-- Define a "Run" command that acts on the entire file by default
vim.cmd('command! -range=% Run lua Run(<line1>, <line2>)')
