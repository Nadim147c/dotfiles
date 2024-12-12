vim.cmd.colorscheme "catppuccin"

if vim.g.transparent_enabled == nil then vim.g.transparent_enabled = true end

vim.opt.grepprg = "rg --vimgrep -uv"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.opt.fileformat = "unix"

vim.opt.fillchars:append { eob = " " }

vim.o.cursorlineopt = "number"
vim.o.cursorline = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.spelllang = "en_us"
vim.opt.spell = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.colorcolumn = "100"

vim.opt.termguicolors = true
