return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup({
            view = {
                width = 35,
                side = "right",
            },
            renderer = {
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                    },
                },
            },
            update_focused_file = { enable = true },
            hijack_netrw = true,
            disable_netrw = true,
        })

        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
                local bufname = vim.api.nvim_buf_get_name(0)
                local filetype = vim.bo.filetype
                if filetype ~= "NvimTree" and bufname ~= "" then
                    vim.cmd("NvimTreeToggle")
                end
            end,
        })

        vim.keymap.set("n", "<leader>pv", function()
            vim.cmd("NvimTreeToggle")
            vim.cmd("only")
        end, { noremap = true, silent = true })
    end
}
