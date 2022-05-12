-- Use https://github.com/AckslD/nvim-neoclip.lua/blob/main/tests/plenary/neoclip_spec.lua as test guides

-- TODO: better pathing...
package.path = './lua/?.lua;' .. package.path
local undo_api = require('undo_api')

local feed = function(input_keys)
    local keys = vim.api.nvim_replace_termcodes(input_keys, true, false, true)
    vim.api.nvim_feedkeys(keys, 'xnt', true)
end

local assert_equal_tables = function(tbl1, tbl2)
    assert(vim.deep_equal(tbl1, tbl2), string.format("%s ~= %s", vim.inspect(tbl1), vim.inspect(tbl2)))
end

describe('get_undo function', function()
  -- before_each(function() end)
  it('works', function()
    feed('i1 little bug in the code<Esc>')
    feed('o2 little bugs in the code<Esc>')

    undo_seqs = vim.api.nvim_exec('echo undotree().seq_last', true)
    assert.equals('2', undo_seqs)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    assert.equals(2, #lines)

    post_undo_lines = undo_api.buf_get_undo(0, 1)
    -- Assert that the buffer hasn't changed
    assert_equal_tables(lines, vim.api.nvim_buf_get_lines(0, 0, -1, true))
    -- Assert that post_undo_lines is correct (indices start at 1)
    assert_equal_tables({ lines[1] }, post_undo_lines)

    -- for i, l in ipairs(post_undo_lines) do
    --     io.stdout:write(i, ': ', l, '\n')
    -- end

    -- feed('<C-r>')
  end)
end)
