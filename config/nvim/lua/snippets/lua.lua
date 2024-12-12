local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require "luasnip.extras"
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "server",
        fmt(
            [[
local lsp_defaults = require "configs.lsp.defaults"
local lspconfig = require "lspconfig"

return {{
    {} = function()
        local config = {{
            {}
        }}
        lspconfig.{}.setup(vim.tbl_deep_extend("force", lsp_defaults, config))
    end,
}}
]],
            { i(1), i(2), rep(1) }
        )
    ),
    s(
        "add_server",
        fmt(
            [[
    {} = function()
        local config = {{
            {}
        }}
        lspconfig.{}.setup(vim.tbl_deep_extend("force", lsp_defaults, config))
    end,
]],
            { i(1), i(2), rep(1) }
        )
    ),
}
