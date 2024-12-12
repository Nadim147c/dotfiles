return {
    { "kylechui/nvim-surround", event = "VeryLazy", config = true },
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { "<leader><F5>", "<CMD> UndotreeToggle <CR>", desc = "Toggle undo tree" },
    },
    {
        "nmac427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function() require("guess-indent").setup { auto_cmd = true } end,
    },
    {
        "rainbowhxch/accelerated-jk.nvim",
        keys = {
            { "j", "<Plug>(accelerated_jk_gj)", desc = "Accelerated down movement" },
            { "k", "<Plug>(accelerated_jk_gk)", desc = "Accelerated up movement" },
        },
    },
    {
        "danymat/neogen",
        cmd = "Neogen",
        keys = {
            { "<leader>nt", "<CMD> Neogen type <CR>", desc = "Neogen generate type" },
            { "<leader>nc", "<CMD> Neogen class <CR>", desc = "Neogen generate class" },
            { "<leader>nf", "<CMD> Neogen func <CR>", desc = "Neogen generate function" },
            { "<leader>nF", "<CMD> Neogen file <CR>", desc = "Neogen generate file" },
        },
        config = function() require("neogen").setup { snippet_engine = "luasnip" } end,
    },
    {
        "numToStr/Comment.nvim",
        init = function()
            local function comment() require("Comment.api").toggle.linewise.current() end
            vim.keymap.set("n", "<leader>/", comment, { desc = "Comment toggle" })

            local visual_comment = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>"
            vim.keymap.set("v", "<leader>/", visual_comment, { desc = "Comment toggle" })
        end,
    },
    {
        "Wansmer/treesj",
        keys = {
            { "<leader>tm", "<CMD> TSJToggle <CR>", desc = "Toggle node splitting" },
            { "<leader>ts", "<CMD> TSJSplit <CR>", desc = "split node under cursor" },
            { "<leader>tj", "<CMD> TSJJoin <CR>", desc = "Join node under cursor" },
        },
        cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
        event = { "BufReadPre", "BufNewFile" },
        config = function() require("treesj").setup { use_default_keymaps = false } end,
    },
}
