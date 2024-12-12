vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = vim.api.nvim_create_augroup("vim_enter_telescope_or_nvim_tree", { clear = true }),
    desc = "Open telescope or nvim tree one vim enter",
    callback = function(data)
        if vim.fn.argv(0) == "" then
            local command = { "rg", "--files", "--hidden", "--color=never", "--glob=!.git" }
            require("telescope.builtin").find_files { find_command = command }
        end

        local directory = vim.fn.isdirectory(data.file) == 1

        if directory then
            vim.cmd.cd(data.file)
            require("oil").open(data.file)
            return
        end
    end,
})
