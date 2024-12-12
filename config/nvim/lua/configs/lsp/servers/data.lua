local lsp_defaults = require "configs.lsp.defaults"
local lspconfig = require "lspconfig"

return {
    yamlls = function()
        local capabilities = lsp_defaults.capabilities
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
        local config = {
            on_new_config = function(new_config)
                new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
                vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
            end,
            capabilities = capabilities,
            settings = {
                redhat = { telemetry = { enabled = false } },
                yaml = {
                    keyOrdering = false,
                    format = { enable = true },
                    validate = true,
                    schemaStore = { enable = false, url = "" },
                },
            },
        }
        lspconfig.yamlls.setup(vim.tbl_deep_extend("force", lsp_defaults, config))
    end,

    jsonls = function()
        local config = {
            on_new_config = function(new_config)
                new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            end,
            settings = {
                json = {
                    format = { enable = true },
                    validate = { enable = true },
                },
            },
        }
        lspconfig.jsonls.setup(vim.tbl_deep_extend("force", lsp_defaults, config))
    end,
}
