local cmp = require("cmp")
local cmp_under_comparator = require("cmp-under-comparator")
local luasnip = require("luasnip")
local wk = require("which-key")
local select_choice = require("luasnip.extras.select_choice")

local function toggle_autocomplete()
    local current_setting = cmp.get_config().completion.autocomplete
    if current_setting and #current_setting > 0 then
        cmp.setup({ completion = { autocomplete = false } })
        vim.notify("cmp autocomplete disabled")
    else
        cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
        vim.notify("cmp autocomplete enabled")
    end
end

local function tab_expand(fallback)
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    elseif cmp.visible() then
        cmp.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
        })
    else
        fallback()
    end
end

local function stab_expand(fallback)
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end

local function next_choice(fallback)
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    else
        fallback()
    end
end

local function prev_choice(fallback)
    if luasnip.choice_active() then
        luasnip.change_choice(-1)
    else
        fallback()
    end
end

local function sel_choice(fallback)
    if luasnip.choice_active() then
        select_choice()
    else
        fallback()
    end
end


cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(tab_expand, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(stab_expand, { "i", "s" }),
        ["<C-u>"] = cmp.mapping(sel_choice, { "i", "s" }),
        ["<C-l>"] = cmp.mapping(next_choice, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(prev_choice, { "i", "s" }),
        ["<C-n>"] = cmp.mapping(
            cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            { "i", "c" }
        ),
        ["<C-p>"] = cmp.mapping(
            cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            { "i", "c" }
        ),
        ["<C-d>"] = cmp.mapping.scroll_docs(5),
        ["<C-f>"] = cmp.mapping.scroll_docs(-5),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
    },
    view = {
        entries = "native",
    },
    sources = {
        { name = "async_path", priority_weight = 120 },
        { name = "nvim_lsp", priority_weight = 110 },
        { name = "tags", max_item_count = 10, priority_weight = 100 },
        { name = "nvim_lua", priority_weight = 90 },
        { name = "luasnip", priority_weight = 80 },
        { name = "buffer", max_item_count = 5, priority_weight = 50 },
    },
    sorting = {
        priority_weight = 100,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp_under_comparator.under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    experimental = {
        ghost_text = true,
    },
})

local snippets_lang = {
    "c",
    "nix",
    "json",
    "gitcommit",
    "markdown",
    "make",
}

for _, lang in pairs(snippets_lang) do
    luasnip.add_snippets(lang, require("ryuki.snippets." .. lang))
end

local keys = {
    { "<leader>c", group = "Code" },
    { "<leader>cc", toggle_autocomplete, desc = "Toggle nvim-cmp" },
}

wk.add(keys)
