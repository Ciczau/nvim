return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                json = { "prettierd" },
                typescript = { "prettierd" },
                vue = { "prettierd" },
                css = { "prettierd" },
                go = { "goimports" },
                html = { "prettierd" },
                python = { "black", "isort" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            }
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.json", "*.lua", "*.ts", "*.vue", "*.css", "*.scss", "*.html", "*.py" },
            callback = function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end,
        })
    end,
}
