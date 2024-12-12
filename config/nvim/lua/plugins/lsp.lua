return {
    {
        "b0o/schemastore.nvim",
        version = false,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        dependencies = "Bilal2453/luvit-meta",
        opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } },
    },

    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
        opts = {
            max_concurrent_installers = 10,
            ui = {
                icons = {
                    package_pending = " ",
                    package_installed = "󰄳 ",
                    package_uninstalled = " ",
                },
                keymaps = {
                    toggle_server_expand = "<CR>",
                    install_server = "i",
                    update_server = "u",
                    check_server_version = "c",
                    update_all_servers = "U",
                    check_outdated_servers = "C",
                    uninstall_server = "X",
                    cancel_installation = "<C-c>",
                },
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function() require "configs.lsp" end,
    },
}
