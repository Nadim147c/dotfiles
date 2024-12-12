return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require "which-key"

        local show_key = {
            "<leader>?",
            function() require("which-key").show { global = true } end,
            desc = "Buffer Local Keymaps (which-key)",
        }

        wk.add({ show_key }, {
            mode = "n",
            prefix = "<leader>",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
            expr = false,
        })
    end,
}
