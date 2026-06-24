local abbreviations = {
    ["(deg)"] = "°",
    ["micro"] = "μ",
}

for text, result in pairs(abbreviations) do
    vim.cmd.abbreviate(text, result)
end
