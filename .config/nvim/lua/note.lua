-- local M = {}
-- return M
local config = {
    cmd = os.getenv('SHELL'),
    border = 'single',
    auto_close = true,
    hl = 'Normal',
    blend = 0,
    dimensions = {
        height = 0.8,
        width = 0.8,
        x = 0.5,
        y = 0.5,
    },
}

local function setup(cfg)
    vim.notify('Calling config', vim.log.levels.INFO)
    -- if not cfg then
    --     return vim.notify('setup() is optional. Please remove it!', vim.log.levels.WARN)
    -- end
    -- Config = vim.tbl_deep_extend('force', Config, cfg)
end


local namespace_id = vim.api.nvim_create_namespace('note')
--- maybe look at the virtual_text "format" option of the config
local note_config = {underline = true}
vim.diagnostic.config(note_config, namespace_id)

local test_diagnostic = {
    lnum = 33,
    -- end_lnum = 40,  -- no end lnum, only on lnum
    col = 5,  -- these col just mostly control the underline
    end_col = 10,
    severity = vim.diagnostic.severity.INFO,
    message = 'test diagnostic',
    source = 'note'
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



-- for issue with moving lines:
-- https://github.com/neovim/neovim/issues/16127
