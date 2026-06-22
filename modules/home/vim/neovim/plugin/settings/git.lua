local gitsigns = require("gitsigns")
local wk = require("which-key")
local telescope_builtin = require("telescope.builtin")

local function partial(f, ...)
    local a = { ... }
    local a_len = select("#", ...)

    return function(...)
        local tmp = { ... }
        local tmp_len = select("#", ...)

        for i = 1, tmp_len do
            a[a_len + i] = tmp[i]
        end

        return f(unpack(a, 1, a_len + tmp_len))
    end
end

local function make_visual(f)
    return function()
        local first = vim.fn.line("v")
        local last = vim.fn.line(".")
        f({ first, last })
    end
end

local function nav_hunk(dir)
    if vim.wo.diff then
        local map = {
            prev = "[c",
            next = "]c",
        }
        vim.cmd.normal({ map[dir], bang = true })
    else
        gitsigns.nav_hunk(dir)
    end
end

gitsigns.setup({
    current_line_blame_opts = {
        -- Show the blame quickly
        delay = 100,
    },
    -- Work-around for https://github.com/lewis6991/gitsigns.nvim/issues/929
    signs_staged_enable = false,
})

local keys = {
    { "<leader>g", group = "Git" },
    { "<leader>gg", gitsigns.toggle_signs, desc = "Git toggle signs" },
    { "<leader>gb", gitsigns.toggle_current_line_blame, desc = "Toggle blame virtual text" },
    { "<leader>gB", gitsigns.blame, desc = "Open blame window" },
    { "<leader>gd", gitsigns.diffthis, desc = "Diff buffer" },
    { "<leader>gD", partial(gitsigns.diffthis, "~"), desc = "Diff buffer against last commit" },
    { "<leader>gG", telescope_builtin.git_status, desc = "Git status" },
    { "<leader>gh", gitsigns.toggle_deleted, desc = "Show deleted hunks" },
    { "<leader>gL", telescope_builtin.git_bcommits, desc = "Git buffercommits" },
    { "<leader>gm", "<Plug>(git-messenger)", desc = "Current line blame" },
    { "<leader>gp", gitsigns.preview_hunk, desc = "Preview hunk" },
    { "<leader>gr", gitsigns.reset_hunk, desc = "Restore hunk" },
    { "<leader>gR", gitsigns.reset_buffer, desc = "Restore buffer" },
    { "<leader>gs", gitsigns.stage_hunk, desc = "Stage hunk" },
    { "<leader>gS", gitsigns.stage_buffer, desc = "Stage buffer" },
    { "<leader>gu", gitsigns.undo_stage_hunk, desc = "Undo stage hunk" },
    { "<leader>g[", partial(gitsigns.nav_hunk, "prev"), desc = "Previous hunk" },
    { "<leader>g]", partial(gitsigns.nav_hunk, "next"), desc = "Next hunk" },
}

local moves = {
    mode = { "n", "x", "o" },
    { "[c", partial(nav_hunk, "prev"), desc = "Previous hunk/diff" },
    { "]c", partial(nav_hunk, "next"), desc = "Next hunk/diff" },
}

local objects = {
    mode = "o",
    { "ih", gitsigns.select_hunk, desc = "git hunk" },
}

local visual = {
    mode = { "x" },
    { "ih", gitsigns.select_hunk, desc = "git hunk" },
    { "<leader>g", group = "Git" },
    { "<leader>gp", gitsigns.preview_hunk, desc = "Preview selection" },
    { "<leader>gr", make_visual(gitsigns.reset_hunk), desc = "Restore selection" },
    { "<leader>gs", make_visual(gitsigns.stage_hunk), desc = "Stage selection" },
    { "<leader>gu", gitsigns.undo_stage_hunk, desc = "Undo stage selection" },
}

wk.add(keys)
wk.add(moves)
wk.add(objects)
wk.add(visual)
