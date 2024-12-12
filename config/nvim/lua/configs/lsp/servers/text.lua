local lsp_defaults = require "configs.lsp.defaults"
local lspconfig = require "lspconfig"

return {
    harper_ls = function()
        local config = {
            settings = {
                ["harper-ls"] = {
                    linters = {
                        spell_check = true,
                        spelled_numbers = false,
                        an_a = true,
                        sentence_capitalization = true,
                        unclosed_quotes = true,
                        wrong_quotes = false,
                        long_sentences = true,
                        repeated_words = true,
                        spaces = true,
                        matcher = true,
                        correct_number_suffix = true,
                        number_suffix_capitalization = true,
                        multiple_sequential_pronouns = true,
                    },
                },
            },
        }

        lspconfig.harper_ls.setup(vim.tbl_deep_extend("force", lsp_defaults, config))
    end,
}
