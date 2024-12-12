return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        auto_install = true,
        prefer_git = true,
        ensure_installed = { "lua" },
        indent = {
            enable = true,
            disable = { "python" },
        },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
}
