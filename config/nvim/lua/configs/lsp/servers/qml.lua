local lsp_defaults = require "configs.lsp.defaults"
local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"

if not configs.qml6_lsp then
    configs.qml6_lsp = {
        default_config = {
            cmd = { "qmlls6" },
            filetypes = { "qml" },
            root_dir = function(fname) return lspconfig.util.find_git_ancestor(fname) end,
            settings = {},
        },
    }
end

lspconfig.qml6_lsp.setup { lsp_defaults }

return {}
