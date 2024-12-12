local lsp_defaults = require "configs.lsp.defaults"
local lspconfig = require "lspconfig"

local handlers = {
    function(server_name) lspconfig[server_name].setup(lsp_defaults) end,
}

-- Auto load all the server configs
local servers = vim.split(vim.fn.glob(vim.g.config .. "/lua/configs/lsp/servers/*"), "\n", { trimempty = true })
for _, filename in ipairs(servers) do
    if vim.endswith(filename, ".lua") and vim.fn.isdirectory(filename) ~= 1 then
        local success, res = pcall(dofile, filename)
        if success then
            for server_name, server_hanlder in pairs(res) do
                handlers[server_name] = server_hanlder
            end
        end
    end
end

require("mason-lspconfig").setup {
    opts = { auto_install = true },
    handlers = handlers,
}
