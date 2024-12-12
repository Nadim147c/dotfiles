return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local colors = require("catppuccin.palettes").get_palette "mocha"
        require("hlchunk").setup {
            chunk = {
                enable = true,
                style = colors.sky,
                delay = 50,
                duration = 100,
            },
            indent = {
                enable = true,
                chars = { "│", "¦", "┆", "┊" },
            },
        }
    end,
}
