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
-- cmp.setup.cmdline('/', {
--     mapping = cmp.mapping.preset.cmdline({
--         ['<Tab>'] = {
--             c = function()
--                 if cmp.visible() then
--                     cmp.select_next_item()
--                 else
--                     -- Trigger complete menu and select next
--                     cmp.complete()
--                     cmp.select_next_item()
--                 end
--             end,
--         },
--     }),
--     sources = {
--         { name = 'buffer', keyword_length = 4 }
--     }
-- })
-- cmp.setup.cmdline('?', {
--     mapping = cmp.mapping.preset.cmdline({
--         ['<Tab>'] = {
--             c = function()
--                 if cmp.visible() then
--                     cmp.select_next_item()
--                 else
--                     -- Trigger complete menu and select next
--                     cmp.complete()
--                     cmp.select_next_item()
--                 end
--             end,
--         },
--     }),
--     sources = {
--         { name = 'buffer', keyword_length = 4 }
--     }
-- })
--- Tree-sitter ---
if not windows then
    require'nvim-treesitter.configs'.setup {
        ensure_installed = ts_parsers,
        highlight = {
            enable = false,
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
    }
end

--- everything else ---
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
-- local presets = require("which-key.plugins.presets")
-- presets.operators = {}
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
-- require("noice").setup()
require("yanky").setup({
    ring = {
        history_length = 100,
        storage = "shada",
        sync_with_numbered_registers = true,
        cancel_event = "update",
    },
    system_clipboard = {
        sync_with_ring = true,
    },
    highlight = {
        on_put = false,
        on_yank = false,
        timer = 500,
    },
})
vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleForward)")  -- or ]y, [y?
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleBackward)")
require("yanky.picker").actions.set_register(regname)

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

vim.keymap.set('n', 'yp', function()
    vim.cmd [[
        let @+=expand("%:p:~") . ':' . line(".")
        let @"=expand("%:p:~") . ':' . line(".")
    ]]
end)
vim.keymap.set('n', '!d', '!!date<cr>')


-- markdown stuff
local strike = function()
    -- check if syntax below cursor is 'markdownStrike' or 'markdownStrikeDelimiter'
    local line, col = vim.fn.line('.'), vim.fn.col('.')
    local syn_under_cursor = vim.fn.synIDattr(vim.fn.synID(line, col, 1), 'name')
    local is_md_strike = syn_under_cursor == 'markdownStrike' or syn_under_cursor == 'markdownStrikeDelimiter'

    if not is_md_strike then
        -- strikeout, start on first "word" character
        vim.cmd [[s/\w.\+/\~\~\0\~\~/e]]
        vim.cmd [[s/TODO/DONE/e]]
    else
        -- unstrike
        vim.cmd [[s/\~\~\(.*\)\~\~/\1/e]]
        -- vimL func version:
        -- echo substitute('~~TODO: set up markdown filetype autocmd that crosses out a line on <c-s>~~', '\~\~\(.*\)\~\~', '\1', '')
    end
    vim.fn.cursor(line, col) -- restore cursor
end
local my_md_group = vim.api.nvim_create_augroup('my_markdown', { clear = true }),
vim.api.nvim_create_autocmd('FileType', {
    group = my_md_group,
    pattern = 'markdown',
    callback = function()
        vim.opt.conceallevel = 3
        vim.keymap.set({'n'}, '<space><space>', strike, {buffer=true})
        vim.keymap.set({'n'}, ',', '<cmd>Grep TODO %<cr>', {buffer=true})
        vim.cmd [[
            hi def my_markdown_strike guifg=#859289 term=strikethrough cterm=strikethrough gui=strikethrough
            hi link markdownStrike my_markdown_strike
            syn match MyTodo /\v\C<(TODO|REMIND):?/  " ignore case, optional :
            hi def link MyTodo TODO
        ]]
    end,
})

-- vim.api.nvim_create_autocmd('InsertLeave', {
--     group = my_md_group,
--     pattern = '*.md',
--     command = 'norm gygq',
-- })


-- a way of grouping related files together
-- require("tabby").setup {
--     groups = {
--         python = {
--             identifier = function(filename)
--                 -- determines which files opened will be added to this tab group
--                 return filename.endswith('.py')
--             end
--         }, -- min and max height of the columns
--         width = { min = 20, max = 100 }, -- min and max width of the columns
--     },
-- }

-- ffi = require('ffi')
-- ffi.cdef('bool is_showcmd_clear(void);')

ffi = require('ffi')
ffi.cdef[[
bool KeyTyped;
int maptick;
]]
-- -- keep timestamps down to the ms and do some calc on the (t)timeoutlen to figure out sequences
my_key_presses = {}
vim.on_key(function(key)
    -- vim.loop.sleep(200)
    -- vim.schedule(function()
    local entry = {
        vim.loop.now(),
        key,
        vim.api.nvim_get_mode()['mode'],
        ffi.C.KeyTyped,  -- whether a user (not a mapping) entered a key
        ffi.C.maptick    -- whether this key is part of a mapping
    }
    table.insert(my_key_presses, entry)
    -- end)
    -- TODO I need something here to tell me if this keystroke awaits further
    -- keystrokes (eg. d, <c-w>, etc.) or if it's just a one off (x, j, k,
    -- etc.)
end)

for _, e in ipairs(my_key_presses) do
    if e[3] ~= 'i' then
        P(e)
    end
end

-- TODO: mode changes should automatically start a new group
-- function cluster(data, maxgap)
--     -- where data is a list of entries: { {time, keystroke, mode, keyTyped, maptick}, ... }
--     groups = {{data[1]}}
--     -- for i, entry in ipairs(data) do
--     vim.notify('there are ' .. #data .. ' number of entries')
--     for i=2,#data do
--         local entry = data[i]
--         entry[2] = vim.fn.keytrans(entry[2])  -- translate the key into internal codes
--         local time, key, mode, keytyped, maptick = unpack(entry)

--         if mode ~= 'i' then
--             local last_group = groups[#groups]
--             local group_leader = last_group[1][5] -- get the maptick of this group

--             if group_leader == maptick then
--                 table.insert(last_group, entry)
--             else
--                 -- create new group
--                 table.insert(groups, {entry})
--             end
--         end
--     end
--     return groups
-- end

