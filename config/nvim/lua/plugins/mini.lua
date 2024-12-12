return {
    {
        "echasnovski/mini.align",
        event = "VeryLazy",
        version = "*",
        config = function() require("mini.align").setup() end,
    },
    {
        "echasnovski/mini.hipatterns",
        event = "VeryLazy",
        desc = "Highlight colors in your code. Also includes Tailwind CSS support.",
        config = function()
            local hipatterns = require "mini.hipatterns"
            hipatterns.setup {
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            }
        end,
    },
}
