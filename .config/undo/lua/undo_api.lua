local M = {}

-- Get the contents of a buffer at a specific undo state
-- Does so by changing to the target buffer and undoing to the desired state,
-- then redos back and changes back to the original buffer
-- Ideally this func would be provided by the official API
M.buf_get_undo = function(buf_id, undo_seq)
    if undo_seq < 0 then
        vim.notify('undo_seq cannot be less than 0', vim.log.levels.ERROR)
    end
    local prev_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_buf(buf_id)
    local prev_undo = vim.fn.undotree().seq_cur
    vim.cmd(string.format('silent undo %s', undo_seq))
    local undo_contents = vim.api.nvim_buf_get_lines(buf_id, 0, -1, true)

    -- restore to before this func was called
    vim.cmd(string.format('silent undo %s', prev_undo))
    vim.api.nvim_set_current_buf(prev_buf)
    return undo_contents
end

return M
