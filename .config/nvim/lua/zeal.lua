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
local log = function(text)
    log_text = string.format('ZEAL: %s', text)
    vim.notify(log_text, vim.log.levels.DEBUG)
end
-- print(vim.v.oldfiles)
-- for k, v in pairs(vim.v.oldfiles) do
--     log(string.format('%s : %s', k, v))
-- end
-- print(vim.fn.getchangelist(0))

--- use `put=execute('luafile %')` to capture output into a buffer
-- eg. put=execute('luafile zeal.lua')

--- here's a good shada setting to start with:
-- set shada=!,'1000,<50,s10,h
-- " Don't store file marks for the following paths
-- set shada+=rterm
-- set shada+=rfugitive
-- set shada+=r/private


--- observations about oldfiles list
-- most recent files are first

--- recency + changes
-- a basic algo could be:
-- 1. find all files that match substring (newest are first)
-- 2. for each file, get changelist size (+ jumplist? + marks? + others?)
-- 3. pick file with best balance of recency + changes

--- possible sources of data
-- 1. oldfiles (duh)
-- 2. changelist (likely have to parse shada to get this info)
-- 3. jumps (only really gives recency data)
-- 4. buffers
-- 5. undofiles (peek at the directory maybe :eyes:)
-- 5a. echo undofile('filename') could be useful
-- 5b. undofiles are never deleted by vim, we'll want to check if the file exists
-- 6. command history
--- Let's just stick with the oldfiles and the undofiles at the very beginning.
--- That gives us 1 source of recency and 1 source of access/changes


-- oldfiles is definitely not populated when this module is loaded lol...
-- P(vim.v.oldfiles)
-- log(string.format("what's in here %s", vim.inspect(vim.v.oldfiles)))


-- local undofiles_source = nil

-- set to results of a search (a list of files ranked)
last_search = nil

-- search_strings is a string with queries separated by a space
find_file = function(search_strings)
    local oldfiles_source = vim.v.oldfiles
    -- for query in vim.split(search_strings, ' ', {trimempty=true}) do end
    if search_strings == '' then
        -- if last_search is not nil, then open the results of the last
        -- search in vim ui select. Otherwise, open all zeal sources in vim ui select

        -- For now, just call fzf if we call 'Z' by itself lol
        vim.cmd('History')
        return
    end
    for _, filepath in ipairs(oldfiles_source) do
        if string.match(filepath, search_strings) then
            vim.cmd(string.format('edit %s', filepath))
            return filepath
        end
    end
end

vim.cmd('command! -nargs=? Z lua find_file("<args>")')
-- command! -nargs=1 Redir silent call Redir(<f-args>)

