local progress = require("fidget.progress")

local M = {}

function M:setup()
    local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(request)
            local handle = M:create_progress_handle(request)
            M:store_progress_handle(request.data.id, handle)
        end,
    })

    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequestFinished",

        group = group,
        callback = function(request)
            local handle, duration = M:pop_progress_handle(request.data.id)
            if handle then
                M:report_exit_status(handle, request)
                handle.message = handle.message
                    .. string.format(" (%ds)", math.floor(duration / 1000))
                handle:finish()
            end
        end,
    })
end

M.handles = {}

function M:store_progress_handle(id, handle)
    M.handles[id] = { handle, vim.loop.now() }
end

function M:pop_progress_handle(id)
    local handle, start = M.handles[id][1], M.handles[id][2]
    M.handles[id] = nil

    return handle, vim.loop.now() - start
end

function M:create_progress_handle(request)
    return progress.handle.create({
        title = "  Code Companion (" .. request.data.interaction .. ")",
        message = "In progress...",
        lsp_client = {
            name = M:llm_role_title(request.data.adapter),
        },
    })
end

function M:llm_role_title(adapter)
    local parts = {}
    table.insert(parts, adapter.formatted_name)
    if adapter.model and adapter.model ~= "" then
        table.insert(parts, "(" .. adapter.model .. ")")
    end
    return table.concat(parts, " ")
end

function M:report_exit_status(handle, request)
    if request.data.status == "success" then
        handle.message = "Completed"
    elseif request.data.status == "error" then
        handle.message = " Error"
    else
        handle.message = "󰜺 Cancelled"
    end
end

return M
