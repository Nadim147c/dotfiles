return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "arkav/lualine-lsp-progress",
        { "ThePrimeagen/harpoon", branch = "harpoon2" },
        "letieu/harpoon-lualine",
    },
    lazy = false,
    config = function()
        local colors = require("catppuccin.palettes").get_palette "mocha"
        local lualine = require "lualine"

        ---@param check boolean
        local function lsp_name(check)
            local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
            local clients = vim.lsp.get_clients()
            if next(clients) == nil then return end
            for _, client in ipairs(clients) do
                ---@type string[]
                ---@diagnostic disable-next-line: undefined-field
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    if check == true then return true end
                    return client.name
                end
            end
            return false
        end

        ---@param check boolean
        local function macro_recording(check)
            local reg = vim.fn.reg_recording()
            if reg == "" then return end
            if check == true then return true end
            return "Recording to [" .. reg .. "]"
        end

        lualine.setup {
            options = {
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha" } },
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    { "mode", icon = "", color = { fg = colors.blue } },
                    { "branch", icon = "󰊢", color = { fg = colors.red } },
                    "diff",
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = " ", warn = " ", info = " ", hint = "󰝶 " },
                        diagnostics_color = {},
                    },
                    { "harpoon2", color = { fg = colors.teal } },
                    {
                        macro_recording,
                        cond = function() return macro_recording(true) end,
                        color = { fg = colors.green },
                        icon = " ",
                    },
                    {
                        "lsp_progress",
                        colors = {
                            percentage = colors.green,
                            title = colors.magenta,
                            message = colors.text,
                            spinner = colors.cyan,
                            lsp_client_name = colors.magenta,
                            use = true,
                        },
                        spinner_symbols = { "◜", "◠", "◝", "◞", "◡", "◟" },
                    },
                },

                lualine_x = {},
                lualine_y = {},
                lualine_z = {
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { "filename", padding = { left = 0, right = 1 }, color = { fg = colors.text } },
                    {
                        lsp_name,
                        fmt = function(str) return "[" .. str .. "]" end,
                        cond = function() return lsp_name(true) end,
                        color = { fg = colors.yellow },
                    },
                    { "encoding", color = { fg = colors.maroon } },
                    { "fileformat", color = { fg = colors.green } },
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = { fg = colors.green },
                    },
                    { "progress", color = { fg = colors.lavender } },
                    { "location", color = { fg = colors.sky } },
                },
            },

            extensions = { "lazy", "mason", "trouble", "fugitive", "fzf", "man" },
        }
    end,
}
