local lsp_defaults = require "configs.lsp.defaults"
local lspconfig = require "lspconfig"

local config = {
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "alejandra" }, -- or nixfmt or nixpkgs-fmt
      },
    },
  },
}

lspconfig.nixd.setup(vim.tbl_deep_extend("force", lsp_defaults, config))

return {}
