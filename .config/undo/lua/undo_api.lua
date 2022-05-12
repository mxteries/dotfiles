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

-- diffs the current buffer's state with a previous undo state
M.undo_diff = function(buf_id, undo_seq)
    local pre_undo = vim.api.nvim_buf_get_lines(buf_id, 0, -1, true)
    local post_undo = M.buf_get_undo(buf_id, undo_seq)

    -- if the tbl is empty, assign empty str. else join the table with new lines
    local a = vim.tbl_isempty(pre_undo) and '' or table.concat(pre_undo, '\n') .. '\n'
    local b = vim.tbl_isempty(post_undo) and '' or table.concat(post_undo, '\n') .. '\n'
    return vim.diff(a, b, { algorithm = "patience", })
end


return M
