local u_api = require('undo_api')

-- has to be this function syntax otherwise the recursive call fails
-- entries is a list of entries (see :h undotree())
local function flatten_tree(timeline, entries)
    if entries == nil then
        return
    end
    for _, entry in ipairs(entries) do
        local undo_entry = string.format('%s: %s', entry.seq, os.date('%a %B %d %H:%M', entry.time))
        table.insert(timeline, undo_entry)
        flatten_tree(timeline, entry.alt)
    end
end

local init = function()
    -- When called, initializes an undo tree and binds it to the current buffer
    local tree = vim.fn.undotree()
    local bound_buf = vim.api.nvim_get_current_buf()

    -- Flatten tree into an array that represents a timeline
    local timeline = {}
    flatten_tree(timeline, tree.entries)

    -- Create the undo buffer
    vim.cmd('topleft vnew | setlocal ft=diff nobuflisted buftype=nofile noswapfile')
    local undo_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(undo_buf, 0, -1, true, timeline)

    local tab_mapping = function()
        local this_line = vim.api.nvim_get_current_line()
        local this_line_num = vim.fn.line('.')
        diff_str = u_api.undo_diff(bound_buf, tonumber(string.match(this_line, '%d+')))
        buf_lines = vim.split(this_line .. '\n' .. diff_str, '\n')
        vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), this_line_num - 1, this_line_num, true, buf_lines)
    end
    vim.keymap.set('n', '<tab>', tab_mapping, { buffer = undo_buf })
end

init()


-- table.sort(timeline, function (a,b)
--     -- Sort by first number (the undo sequence)
--     return (tonumber(string.match(a, '%d+')) > tonumber(string.match(b, '%d+')))
-- end)


--[[
{
    entries = { {
        save = 2,
        seq = 1,
        time = 1650647822
    }, {
        save = 3,
        seq = 2,
        time = 1650647873
    }, {
        seq = 3,
        time = 1650647887
    }, {
        seq = 4,
        time = 1650647902
    }, {
        seq = 5,
        time = 1650647905
    }, {
        seq = 6,
        time = 1650647908
    }, {
        seq = 7,
        time = 1650647915
    }, {
        seq = 8,
        time = 1650647923
    }, {
        seq = 9,
        time = 1650647927
    }, {
        save = 4,
        seq = 10,
        time = 1650647930
    }, {
        alt = { {
            seq = 11,
            time = 1650647941
        }, {
            save = 5,
            seq = 12,
            time = 1650647966
        } },
        save = 6,
        seq = 13,
        time = 1650647998
    }, {
        save = 7,
        seq = 14,
        time = 1650648010
    }, {
        seq = 15,
        time = 1650648276
    }, {
        seq = 16,
        time = 1650648280
    }, {
        seq = 17,
        time = 1650648281
    }, {
        save = 8,
        seq = 18,
        time = 1650648283
    }, {
        save = 9,
        seq = 19,
        time = 1650648299
    }, {
        alt = { {
            seq = 20,
            time = 1650649242
        } },
        seq = 21,
        time = 1650649243
    }, {
        seq = 22,
        time = 1650649244
    }, {
        seq = 23,
        time = 1650649244
    }, {
        seq = 24,
        time = 1650649245
    }, {
        seq = 25,
        time = 1650649245
    }, {
        seq = 26,
        time = 1650649246
    }, {
        seq = 27,
        time = 1650649247
    }, {
        seq = 28,
        time = 1650649247
    }, {
        seq = 29,
        time = 1650649248
    }, {
        seq = 30,
        time = 1650649249
    }, {
        save = 10,
        seq = 31,
        time = 1650649249
    }, {
        save = 11,
        seq = 32,
        time = 1650649278
    }, {
        seq = 33,
        time = 1650649285
    }, {
        seq = 34,
        time = 1650649332
    }, {
        seq = 35,
        time = 1650649352
    }, {
        save = 12,
        seq = 36,
        time = 1650649353
    }, {
        seq = 37,
        time = 1650649370
    }, {
        seq = 38,
        time = 1650649428
    }, {
        seq = 39,
        time = 1650649434
    }, {
        save = 13,
        seq = 40,
        time = 1650649436
    }, {
        seq = 41,
        time = 1650649451
    }, {
        seq = 42,
        time = 1650649455
    }, {
        seq = 43,
        time = 1650649455
    }, {
        seq = 44,
        time = 1650649456
    }, {
        save = 14,
        seq = 45,
        time = 1650649456
    }, {
        seq = 46,
        time = 1650649459
    }, {
        seq = 47,
        time = 1650649470
    }, {
        save = 15,
        seq = 48,
        time = 1650649471
    }, {
        save = 16,
        seq = 49,
        time = 1650649483
    }, {
        seq = 50,
        time = 1650649764
    }, {
        save = 17,
        seq = 51,
        time = 1650649765
    }, {
        seq = 52,
        time = 1650649782
    }, {
        save = 18,
        seq = 53,
        time = 1650649786
    }, {
        save = 19,
        seq = 54,
        time = 1650649799
    }, {
        save = 20,
        seq = 55,
        time = 1650649807
    }, {
        save = 24,
        seq = 56,
        time = 1650649830
    }, {
        save = 25,
        seq = 57,
        time = 1650649839
    }, {
        seq = 58,
        time = 1650649997
    }, {
        seq = 59,
        time = 1650650003
    }, {
        seq = 60,
        time = 1650650007
    }, {
        seq = 61,
        time = 1650650008
    }, {
        seq = 62,
        time = 1650650009
    }, {
        seq = 63,
        time = 1650650012
    }, {
        seq = 64,
        time = 1650650013
    }, {
        seq = 65,
        time = 1650650015
    }, {
        seq = 66,
        time = 1650650017
    }, {
        seq = 67,
        time = 1650650025
    }, {
        seq = 68,
        time = 1650650027
    }, {
        seq = 69,
        time = 1650650030
    }, {
        save = 26,
        seq = 70,
        time = 1650650033
    }, {
        seq = 71,
        time = 1650650036
    }, {
        save = 27,
        seq = 72,
        time = 1650650036
    }, {
        save = 28,
        seq = 73,
        time = 1650650090
    }, {
        seq = 74,
        time = 1650650102
    }, {
        seq = 75,
        time = 1650650103
    }, {
        seq = 76,
        time = 1650650104
    }, {
        seq = 77,
        time = 1650650107
    }, {
        save = 29,
        seq = 78,
        time = 1650650107
    }, {
        seq = 79,
        time = 1650650119
    }, {
        seq = 80,
        time = 1650650120
    }, {
        seq = 81,
        time = 1650650126
    }, {
        save = 31,
        seq = 82,
        time = 1650650130
    }, {
        seq = 83,
        time = 1650650210
    }, {
        seq = 84,
        time = 1650650233
    }, {
        seq = 85,
        time = 1650650234
    }, {
        alt = { {
            seq = 86,
            time = 1650650235
        } },
        seq = 87,
        time = 1650650366
    }, {
        save = 32,
        seq = 88,
        time = 1650650369
    }, {
        seq = 89,
        time = 1650650370
    }, {
        alt = { {
            seq = 90,
            time = 1650650374
        } },
        seq = 91,
        time = 1650650378
    }, {
        seq = 92,
        time = 1650650379
    }, {
        seq = 93,
        time = 1650650380
    }, {
        seq = 94,
        time = 1650650381
    }, {
        seq = 95,
        time = 1650650382
    }, {
        alt = { {
            seq = 96,
            time = 1650650395
        } },
        seq = 97,
        time = 1650650396
    }, {
        save = 33,
        seq = 98,
        time = 1650650399
    }, {
        alt = { {
            seq = 99,
            time = 1650650423
        }, {
            seq = 100,
            time = 1650650426
        } },
        seq = 101,
        time = 1650650440
    }, {
        seq = 102,
        time = 1650652446
    }, {
        save = 34,
        seq = 103,
        time = 1650652447
    }, {
        seq = 104,
        time = 1650652450
    }, {
        save = 35,
        seq = 105,
        time = 1650652452
    }, {
        seq = 106,
        time = 1650652460
    }, {
        save = 36,
        seq = 107,
        time = 1650652464
    }, {
        save = 37,
        seq = 108,
        time = 1650652466
    }, {
        seq = 109,
        time = 1650654507
    }, {
        seq = 110,
        time = 1650654509
    }, {
        seq = 111,
        time = 1650654512
    }, {
        alt = { {
            seq = 112,
            time = 1650654514
        }, {
            seq = 113,
            time = 1650654514
        }, {
            alt = { {
                seq = 114,
                time = 1650654516
            } },
            seq = 115,
            time = 1650654516
        } },
        seq = 116,
        time = 1650654523
    }, {
        seq = 117,
        time = 1650654523
    }, {
        seq = 118,
        time = 1650654524
    }, {
        seq = 119,
        time = 1650654525
    }, {
        seq = 120,
        time = 1650654530
    }, {
        seq = 121,
        time = 1650654534
    }, {
        seq = 122,
        time = 1650654538
    }, {
        seq = 123,
        time = 1650654557
    }, {
        save = 38,
        seq = 124,
        time = 1650654566
    }, {
        save = 39,
        seq = 125,
        time = 1650654589
    }, {
        save = 40,
        seq = 126,
        time = 1650654742
    }, {
        alt = { {
            seq = 127,
            time = 1650654745
        } },
        save = 41,
        seq = 128,
        time = 1650654784
    }, {
        seq = 129,
        time = 1650654810
    }, {
        seq = 130,
        time = 1650654811
    }, {
        seq = 131,
        time = 1650654812
    }, {
        save = 42,
        seq = 132,
        time = 1650654814
    }, {
        save = 43,
        seq = 133,
        time = 1650654817
    }, {
        seq = 134,
        time = 1650907322
    }, {
        seq = 135,
        time = 1650907326
    }, {
        seq = 136,
        time = 1650907326
    }, {
        seq = 137,
        time = 1650907327
    }, {
        seq = 138,
        time = 1650907336
    }, {
        save = 44,
        seq = 139,
        time = 1650907337
    }, {
        alt = { {
            seq = 140,
            time = 1650907376
        }, {
            alt = { {
                seq = 141,
                time = 1650907378
            } },
            seq = 142,
            time = 1650907388
        } },
        seq = 143,
        time = 1650907402
    }, {
        newhead = 1,
        seq = 144,
        time = 1650907431
    } },
    save_cur = 44,
    save_last = 44,
    seq_cur = 144,
    seq_last = 144,
    synced = 1,
    time_cur = 1650907432
}
--]]
