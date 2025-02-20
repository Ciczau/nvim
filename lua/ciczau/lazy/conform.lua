return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
        local conform = require("conform")

        -- Setup "conform.nvim" to work
        conform.setup({
            formatters_by_ft = {
                json = { "prettierd" },
                typescript = { "prettierd" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            }
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.json", "*.lua", "*.ts" },
            callback = function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end,
        })
        vim.keymap.set({ "n", "v" }, "<leader>l", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
