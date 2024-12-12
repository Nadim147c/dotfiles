return {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local oil = require "oil"

        vim.keymap.set("n", "<C-n>", function()
            if vim.g.oil_dir == nil then vim.g.oil_dir = vim.fn.getcwd() end
            oil.open_float(vim.g.oil_dir)
        end, { desc = "Open parent directory" })

        local git_ignored = setmetatable({}, {
            __index = function(self, key)
                local proc = vim.system(
                    { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
                    { cwd = key, text = true }
                )
                local result = proc:wait()
                local ret = {}
                if result.code == 0 then
                    for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
                        line = line:gsub("/$", "")
                        table.insert(ret, line)
                    end
                end

                rawset(self, key, ret)
                return ret
            end,
        })

        oil.setup {
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = function()
                    vim.g.oil_dir = oil.get_current_dir()
                    oil.select { close = true }
                end,
                ["<BS>"] = "actions.parent",
                ["<C-p>"] = "actions.preview",
                ["<C-n>"] = "actions.close",
                ["<C-c>"] = "actions.close",
                ["q"] = "actions.close",
                ["<C-s>"] = { function() oil.save { confirm = true } end, desc = "Find files in the current directory" },
                ["-"] = "actions.open_cwd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            delete_to_trash = true,
            float = {
                padding = 3,
                border = "rounded",
                win_options = { winblend = 0 },
                preview_split = "right",
            },
            view_options = {
                -- Show hidden (.dot_files) files but not git_ignored files
                show_hidden = false,
                is_hidden_file = function(name, _)
                    if name == ".git" then return true end
                    local dir = oil.get_current_dir()
                    if not dir then return false end
                    return vim.list_contains(git_ignored[dir], name)
                end,
            },
        }
    end,
}
