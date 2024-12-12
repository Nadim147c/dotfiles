return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require "harpoon"

        harpoon:setup()

        ---@param keys string
        ---@param func string|function
        ---@param desc string
        local function map(keys, func, desc) vim.keymap.set("n", keys, func, { desc = "Harpoon " .. desc }) end

        map("<leader>a", function() harpoon:list():add() end, "add to list")
        map("<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "show list")
        map("s", function() harpoon:list():next { ui_nav_wrap = true } end, "cycle trough harpoon list")
        map("1", function() harpoon:list():select(1) end, "jump to 1")
        map("2", function() harpoon:list():select(2) end, "jump to 2")
        map("3", function() harpoon:list():select(3) end, "jump to 3")
        map("4", function() harpoon:list():select(4) end, "jump to 4")
    end,
}
