return {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local bufferline = require "bufferline"

        vim.keymap.set("n", "<leader>x", function() bufferline.unpin_and_close() end, { desc = "Close current buffer" })
        vim.keymap.set("n", "<s-tab>", function() bufferline.cycle(-1) end, { desc = "Cycle on buffer list" })
        vim.keymap.set("n", "<tab>", function() bufferline.cycle(1) end, { desc = "Cycle on buffer list" })

        bufferline.setup {
            options = {
                diagnostics = "nvim_lsp",
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "Nvim Tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        }
    end,
}
