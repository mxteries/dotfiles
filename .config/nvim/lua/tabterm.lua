local Term = require('terminal')

tabby_tabby = {}

local M = {}
local debug = false

local log = function(text)
    if debug then
        log_text = string.format('TERM TESTING: %s', text)
        vim.notify(log_text, vim.log.levels.DEBUG)
    end
end

-- Track terminals in each tab, example:
-- tabs = {
--     1 = t, -- tab_id : term instance
-- },

-- TODO uncomment
-- local tabs = {}
    -- Ok so the reason this DOESN'T work if you remove local is because this
    -- lua chunk/luafile runs in its own function scope. So what we actually
    -- end up doing is defining a global called "tabs" (as expected) but then
    -- every time we rerun the file, it overwrites "tabs" to be {}, which
    -- causes it to start from scratch each time.
    -- Instead what we actually want is to define "tabs" separately, so just
    -- run `:lua tabs = {}` in nvim. Now tabs exists in the global scope and
    -- can be referenced within this file's function scope when we luafile it

-- Only expose one function -> toggle
function M.toggle()
    -- Check if a term exists for this tab
    local tab_id = vim.api.nvim_get_current_tabpage()
    local tab_term = tabby_tabby[tab_id]
    if tab_term ~= nil then
        -- Term exists -> toggle visibility
        tab_term:toggle()
        -- if tab_term:is_open() then
        --     log("closing open terminal")
        --     tab_term:close()
        -- else
        --     log("open existing terminal")
        --     tab_term:open()
        -- end
    else
        log('creating new terminal')
        -- create a new term for this tab and open it
        local new_term = Term:new()
        log(string.format('storing %s:%s in tabby_tabby', tab_id, new_term))
        tabby_tabby[tab_id] = new_term
        new_term:open()
    end
end

function M.delete_term()
    for tab_id, _ in pairs(tabby_tabby) do
        log(string.format('%s is valid: %s', tab_id, vim.api.nvim_tabpage_is_valid(tab_id)))
        -- NB: nvim_tabpage_is_valid does not return false when called during the "TabClosed" autocmd
        if not vim.api.nvim_tabpage_is_valid(tab_id) then
            -- tab_id no longer exists (ie. the tab was closed)
            local tab_term = tabby_tabby[tab_id]
            log(string.format('terminating term %s in tab %s', tab_term, tab_id))
            tab_term:close(true)  -- stop the terminal job
            tabby_tabby[tab_id] = nil
        end
    end
end

-- local abc = {[2] = 1 , [3] = 1, [4] = nil, [9] = 1}
-- for a, b in pairs(abc) do
--     print(a)
--     print(b)
--     abc[a] = nil
-- end
-- print(abc[2] ~= nil)
return M

-- for x, y in pairs(tabby_tabby) do
--     print(x)
--     print(y)
-- end

-- M.delete_term()
-- M.toggle()
-- vim.cmd [[ autocmd! TabClose M.delete_term() ]]

---Creates a custom terminal
---@param cfg Config
---@return Term
-- function M:new(cfg)
--     return Term:new():setup(cfg)
-- end

---(Optional) Configure the default terminal
---@param cfg Config
-- function M.setup(cfg)
--     t:setup(cfg)
-- end

-----Opens the default terminal
--function M.open()
--    t:open()
--end

-----Closes the default terminal window but preserves the actual terminal session
--function M.close()
--    t:close()
--end

-----Exits the terminal session
--function M.exit()
--    t:close(true)
--end

---Run a arbitrary command inside the default terminal
---@param cmd Command
--function M.run(cmd)
--    if not cmd then
--        return vim.notify('FTerm: Please provide a command to run', vim.log.levels.ERROR)
--    end

--    t:run(cmd)
--end

-----To create a scratch (use and throw) terminal. Like those good ol' C++ build terminal.
-----@param cfg Command
--function M.scratch(cfg)
--    if not cfg then
--        return vim.notify('FTerm: Please provide configuration for scratch terminal', vim.log.levels.ERROR)
--    end

--    cfg.auto_close = false

--    M:new(cfg):open()
--end

-- return M
