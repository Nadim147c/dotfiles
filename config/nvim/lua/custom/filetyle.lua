vim.filetype.add {
    pattern = {
        [".*/kitty/.+%.conf"] = "bash",
        [".*/waybar/config"] = "jsonc",
        [".*/fontconfig/font.conf"] = "xml",
    },
    filename = {
        [".prettierrc"] = "yaml",
    },
}
