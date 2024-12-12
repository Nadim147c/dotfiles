return {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    cmd = "Markview",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        vim.keymap.set("n", "m", "<CMD> Markview toggle <CR>", { desc = "Toggle markview" })
        require("markview").setup()
    end,
}
