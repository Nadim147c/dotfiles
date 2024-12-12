return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    event = "VimEnter",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        ---@param key string
        ---@param action string|function
        ---@param desc string
        local function map(key, action, desc)
            vim.keymap.set("n", "<leader>f" .. key, action, { desc = "Telescope " .. desc })
        end

        local tb = require "telescope.builtin"

        local function find_config() tb.find_files { cwd = vim.fn.stdpath "config" } end
        local function find_all() tb.find_files { follow = true, no_ignore = true, hidden = true } end
        local command = { "rg", "--files", "--hidden", "--color=never", "--glob=!.git" }
        local function custom_find_files() tb.find_files { find_command = command } end

        --- File & Buffer Search
        map("c", find_config, "find config files")
        map("a", find_all, "find all files")
        map("f", custom_find_files, "find files")
        map("o", tb.oldfiles, "find recently opened files")
        map("b", tb.buffers, "find opened buffers")

        -- Content Search
        map("w", tb.live_grep, "live grep")
        map("z", tb.current_buffer_fuzzy_find, "find in current buffer")

        -- GIT Search
        map("gc", tb.git_commits, "git commits")
        map("gb", tb.git_branches, "git branch")
        map("gf", tb.git_files, "git files")

        -- Random
        map("h", tb.help_tags, "help page")

        require("telescope").load_extension "ui-select"
        require("telescope").load_extension "fzf"
        require("telescope").load_extension "noice"

        require("telescope").setup {
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "-L",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                file_ignore_patterns = { "node_modules" },
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                path_display = { "truncate" },
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                mappings = {
                    n = { ["q"] = require("telescope.actions").close },
                },
            },
            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown {} },
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        }
    end,
}
