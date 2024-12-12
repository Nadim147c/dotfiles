local lsp_defaults = require "configs.lsp.defaults"
local lspconfig = require "lspconfig"

return {
    emmet_language_server = function()
        local config = {
            filetypes = { "css", "eruby", "html", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
        }
        lspconfig.emmet_language_server.setup(vim.tbl_deep_extend("force", lsp_defaults, config))
    end,

    ts_ls = function()
        local function organize_imports()
            local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
            }
            vim.lsp.buf_request_sync(0, "workspace/executeCommand", params, 500)
        end

        local config = {
            on_attach = function(_, bufnr)
                -- vim.api.nvim_create_autocmd("BufWritePost", {
                --     group = vim.api.nvim_create_augroup("organizeImports", { clear = true }),
                --     desc = "Organize imports on save",
                --     callback = function() organize_imports() end,
                -- })
                vim.keymap.set({ "n", "v" }, "<leader>fi", organize_imports, { desc = "Organize ts/js imports" })
                lsp_defaults.on_attach(_, bufnr)
            end,
            init_options = { preferences = { disableSuggestions = false } },
            commands = {
                OrganizeImports = { organize_imports, description = "Organize Imports" },
            },
        }
        lspconfig.ts_ls.setup(vim.tbl_deep_extend("force", lsp_defaults, config))
    end,
}
