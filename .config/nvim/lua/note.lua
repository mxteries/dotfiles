-- local M = {}
-- return M

local namespace_id = vim.api.nvim_create_namespace('note')
--- maybe look at the virtual_text "format" option of the config
local note_config = {underline = true, float = false}
vim.diagnostic.config(note_config, namespace_id)

local test_diagnostic = {
    lnum = 33,
    -- end_lnum = 40,  -- no end lnum, only on lnum
    col = 5,  -- these col just mostly control the underline
    -- end_col = 10,
    message = 'test diagnostic',
}

vim.cmd [[
    sign define DiagnosticSignInfo text=😛 texthl=DiagnosticSignInfo linehl= numhl=
]]

local function note()
    vim.diagnostic.set(namespace_id, 0, {test_diagnostic}, nil)
end
function Note_open()
    local d_format = function(diagnostic)
        return string.format("F your message, here's mine", diagnostic.message)
    end
    local open_opts = {
        bufnr = 0,
        scope = 'buffer',
        namespace = namespace_id,
        prefix = 'L + ratio: ',
        format = d_format,
    }
    vim.diagnostic.open_float(open_opts)
end
note()

-- print(type(test.testkey))


-- print(vim.inspect(package.loaded))
-- print(vim.inspect(_G.vim.diagnostic))


-- for issue with moving lines:
-- https://github.com/neovim/neovim/issues/16127
