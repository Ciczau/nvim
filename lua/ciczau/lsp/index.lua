require("ciczau.lsp.typescript")
require("ciczau.lsp.vue")
require("ciczau.lsp.lua")
require("ciczau.lsp.eslint")

-- pressing K on hovered symbol will toggle the hover window
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.keymap.set("n", "K", function()
            local base_win_id = vim.api.nvim_get_current_win()
            local windows = vim.api.nvim_tabpage_list_wins(0)
            for _, win_id in ipairs(windows) do
                if win_id ~= base_win_id then
                    local win_cfg = vim.api.nvim_win_get_config(win_id)
                    if win_cfg.relative == "win" and win_cfg.win == base_win_id then
                        vim.api.nvim_win_close(win_id, {})
                        return
                    end
                end
            end
            vim.lsp.buf.hover()
        end, { remap = false, silent = true, buffer = ev.buf, desc = "Toggle hover" })
        -- Probably lots of other keymaps...
    end
})

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

vim.diagnostic.config({
    virtual_text = true, -- it's false by default
    virtual_lines = false,
    signs = false,
    float = {
        border = "single",
        format = function(diagnostic)
            return string.format(
                "%s (%s) [%s]",
                diagnostic.message,
                diagnostic.source,
                diagnostic.code or diagnostic.user_data.lsp.code
            )
        end,
    },
})
