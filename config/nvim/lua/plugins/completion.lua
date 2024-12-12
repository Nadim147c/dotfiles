return {
    "saghen/blink.cmp",
    lazy = false,
    version = "v0.*",
    dependencies = "L3MON4D3/LuaSnip",
    opts = {
        keymap = {
            ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<CR>"] = { "select_and_accept", "fallback" },

            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },

            ["<Tab>"] = { "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },
        snippets = {
            expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
            active = function(filter)
                if filter and filter.direction then return require("luasnip").jumpable(filter.direction) end
                return require("luasnip").in_snippet()
            end,
            jump = function(direction) require("luasnip").jump(direction) end,
        },

        completion = {
            menu = {
                border = "rounded",
            },
        },

        sources = {
            completion = {
                enabled_providers = { "lsp", "path", "snippets", "buffer" },
            },
            providers = {
                buffer = { min_keyword_length = 1 },
            },
        },
    },
}
