local match = vim.split(vim.fn.glob(vim.g.config .. "/lua/custom/*"), "\n", { trimempty = true })
for _, filename in ipairs(match) do
    if
        not vim.endswith(filename, "init.lua")
        and vim.endswith(filename, ".lua")
        and vim.fn.isdirectory(filename) ~= 1
    then
        local success, err = pcall(dofile, filename)
        if not success then
            print("Error loading file:", filename, err)
        end
    end
end
