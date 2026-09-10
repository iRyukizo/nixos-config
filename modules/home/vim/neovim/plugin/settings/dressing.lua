require("dressing").setup({
    input = {
        prefer_width = 0.4,

        get_config = function(opts)
            if vim.startswith(opts.prompt or "", "Rename") then
                return {
                    relative = "editor",
                    prefer_width = 0.4,
                    border = "rounded",
                    title_pos = "center",
                }
            end
        end,
    },
})
