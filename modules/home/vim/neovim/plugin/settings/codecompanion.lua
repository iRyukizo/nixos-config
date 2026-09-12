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
            roles = {
                llm = function(adapter)
                    local model = adapter.model
                        and (adapter.model.formatted_name or adapter.model.name)
                    return adapter.formatted_name .. (model and (" - " .. model) or "")
                end,
                user = "ryuki",
            },
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
    extensions = {
        history = {
            enabled = true,
            opts = {
                auto_save = true,
                expiration_days = 60,

                picker = "telescope",

                picker_keymaps = {
                    rename = { n = "r", i = "<C-o>" },
                    delete = { n = "d", i = "<C-e>" },
                    duplicate = { n = "<C-y>", i = "<C-y>" },
                },
            },
        },
    },
})

ccfidget:setup()

local keys = {
    { "<leader>o", group = "CodeCompanion" },
    { "<leader>oc", "<cmd>:CodeCompanionChat Toggle<CR>", desc = "Chat", mode = { "n" } },
    { "<leader>oc", ":CodeCompanionChat Add<CR>", desc = "Add to Chat", mode = { "v" } },
    { "<leader>op", ":CodeCompanion<CR>", desc = "Prompt", mode = { "n", "v" } },
    { "<leader>oe", ":CodeCompanion /explain<CR>", desc = "Explain", mode = { "v" } },
    { "<leader>of", ":CodeCompanion /fix<CR>", desc = "Fix", mode = { "v" } },
    { "<leader>ot", ":CodeCompanion /tests<CR>", desc = "Tests", mode = { "v" } },
    { "<leader>ol", ":CodeCompanion /lsp<CR>", desc = "LSP", mode = { "v" } },
    { "<leader>oa", "<cmd>:CodeCompanionActions<CR>", desc = "Actions" },
    { "<leader>oh", "<cmd>:CodeCompanionHistory<CR>", desc = "History" },
}

wk.add(keys)
