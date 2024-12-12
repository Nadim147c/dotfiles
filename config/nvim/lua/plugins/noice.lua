return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        "smjonas/inc-rename.nvim",
    },
    config = function()
        local notify = require "notify"
        ---@diagnostic disable-next-line: missing-fields
        notify.setup { background_colour = "#000000" }
        vim.keymap.set("n", "<leader>nd", notify.dismiss, { desc = "Dismiss all notifications" })

        require("inc_rename").setup {}

        require("noice").setup {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },

            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = true,
            },
        }
    end,
}
