return {
    {
        "catppuccin/nvim",
        dependencies = "xiyaowong/transparent.nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup {
                compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
                flavor = "mocha",
                transparent_background = vim.g.transparent_enabled or false,
                term_colors = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = true,
                    mini = { enabled = true, indentscope_color = "" },
                },
            }
        end,
    },

    {
        "xiyaowong/transparent.nvim",
        lazy = false,
        config = function()
            local transparent = require "transparent"
            transparent.setup { extra_groups = { "NormalFloat", "NvimTreeNormal" } }
            transparent.clear_prefix "lualine"
            transparent.clear_prefix "nvim-tree"
        end,
    },
}
