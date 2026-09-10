local wk = require("which-key")

if not pcall(require, "codecompanion") then
    return
end

local cc = require("codecompanion")
local ccfidget = require("ryuki.codecompanion-fidget")

cc.setup({
    adapters = {
        acp = {
            codex = function()
                return require("codecompanion.adapters").extend("codex", {
                    defaults = {
                        auth_method = "chat-gpt",
                    },
                })
            end,
        },
    },
    interactions = {
        chat = {
            adapter = {
                name = "codex",
            },
        },
        inline = {
            adapter = {
                name = "ollama",
            },
        },
        cli = {
            adapter = {
                name = "codex",
            },
        },
        cmd = {
            adapter = {
                name = "ollama",
            },
        },
    },
})

ccfidget:setup()

local keys = {
    { "<leader>o", group = "CodeCompanion" },
    { "<leader>oc", "<cmd>:CodeCompanionChat Toggle<CR>", desc = "Chat", mode = { "n" } },
    { "<leader>oc", "<cmd>:CodeCompanionChat Add<CR>", desc = "Add to Chat", mode = { "v" } },
    { "<leader>op", "<cmd>:CodeCompanion<CR>", desc = "Prompt", mode = { "n", "v" } },
    { "<leader>oe", "<cmd>:CodeCompanion /explain<CR>", desc = "Explain", mode = { "v" } },
    { "<leader>of", "<cmd>:CodeCompanion /fix<CR>", desc = "Fix", mode = { "v" } },
    { "<leader>ot", "<cmd>:CodeCompanion /tests<CR>", desc = "Tests", mode = { "v" } },
    { "<leader>ol", "<cmd>:CodeCompanion /lsp<CR>", desc = "LSP", mode = { "v" } },
    { "<leader>oa", "<cmd>:CodeCompanionActions<CR>", desc = "Actions" },
}

wk.add(keys)
