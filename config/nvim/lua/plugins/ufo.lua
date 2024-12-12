return {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    cmd = { "Fold", "Ufo" }, -- Only loads the plugin on these command
    config = function()
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        local ufo = require "ufo"

        ufo.setup { provider_selector = function(_, _, _) return { "treesitter", "indent" } end }
    end,
}
