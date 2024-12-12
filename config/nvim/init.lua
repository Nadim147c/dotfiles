vim.g.config = vim.fn.stdpath "config"
vim.g.mapleader = " "
vim.o.laststatus = 3

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print "Installing lazy.nvim plugin managers"
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
local lazy_config = require "configs.lazy"

-- load plugins
---@diagnostic disable-next-line: different-requires
require("lazy").setup({ import = "plugins" }, lazy_config)

require "options"
require "custom"
require "mappings"
