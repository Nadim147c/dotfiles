local M = {}

M.capabilities = require("blink.cmp").get_lsp_capabilities()
M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
    },
}

M.on_init = function(client, _)
    if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

M.on_attach = function(_, bufnr)
    local function opts(desc) return { buffer = bufnr, desc = "LSP " .. desc } end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
    vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
    vim.keymap.set("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

    vim.keymap.set(
        "n",
        "<leader>wl",
        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        opts "List workspace folders"
    )

    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

    vim.keymap.set("n", "<leader>ra", function() return ":IncRename " .. vim.fn.expand "<cword>" end, { expr = true })

    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts "Show references")
end

return M
