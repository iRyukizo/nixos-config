local oil = require('oil')
local detail = false

oil.setup {
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr) 
            return name == ".."
        end,
    },
    keymaps = {
        ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
                detail = not detail
                if detail then
                    oil.set_columns({ "icon", "permissions", "size", "mtime" })
                else
                    oil.set_columns({ "icon" })
                end
            end,
        },
    },
}

