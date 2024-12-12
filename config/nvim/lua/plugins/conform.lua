return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require "conform"
        local function file_exists_glob(pattern)
            local root_dir = vim.fn.getcwd()

            local full_pattern = root_dir .. "/" .. pattern

            local files = vim.fn.glob(full_pattern, false, true)

            return #files > 0
        end

        ---@type conform.FiletypeFormatterInternal|fun(bufnr: number):conform.FiletypeFormatterInternal
        local prettier_formatter = { "prettierd", "prettier", stop_after_first = true }

        ---@type conform.FiletypeFormatterInternal|fun(bufnr: number):conform.FiletypeFormatterInternal
        local javascript_formatter = prettier_formatter
        if file_exists_glob "biome.{json,jsonc}" then javascript_formatter = { "biome" } end

        conform.setup {
            formatters_by_ft = {
                javascript = javascript_formatter,
                typescript = javascript_formatter,
                javascriptreact = javascript_formatter,
                typescriptreact = javascript_formatter,
                json = javascript_formatter,
                jsonc = javascript_formatter,
                -- Prettier Formatter
                svelte = prettier_formatter,
                css = prettier_formatter,
                html = prettier_formatter,
                vue = prettier_formatter,
                markdown = prettier_formatter,
                graphql = prettier_formatter,
                liquid = prettier_formatter,
                yaml = prettier_formatter,
                go = { "gofumpt", "gofmt", stop_after_first = true },
                lua = { "stylua" },
                python = { "isort", "black" },
                zsh = { "shfmt" },
                bash = { "shfmt" },
                sh = { "shfmt" },
            },
            formatters = {
                shfmt = { extra_args = { "-i", "2", "-ci", "-bn" } },
                biome = {
                    args = {
                        "check",
                        "--write",
                        "--linter-enabled=false",
                        "--formatter-enabled=true",
                        "--organize-imports-enabled=true",
                        "--stdin-file-path",
                        "$FILENAME",
                    },
                },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            },
        }

        local function conform_format()
            conform.format {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            }
        end

        vim.keymap.set({ "n", "v" }, "<leader>fm", conform_format, { desc = "Format file or range (in visual mode)" })
    end,
}
