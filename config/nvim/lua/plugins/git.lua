return {
    { "tpope/vim-fugitive", event = "VeryLazy" },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "󰍵" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "│" },
            },

            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function opts(desc) return { buffer = bufnr, desc = "Gitsings " .. desc } end

                local map = vim.keymap.set

                map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")
                map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
                map("n", "<leader>gb", gs.blame_line, opts "Blame Line")
            end,
        },
    },
}
