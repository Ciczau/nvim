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

        vim.keymap.set("n", "<leader>pv", function()
            local buffers = vim.fn.getbufinfo({ buflisted = 1 })
            local current_filetype = vim.bo.filetype

            if #buffers == 1 and current_filetype ~= "NvimTree" then
                vim.cmd("q")
                vim.cmd("NvimTreeOpen")
            elseif current_filetype ~= "NvimTree" then
                vim.cmd("q")
            else
                vim.cmd("NvimTreeToggle")
            end
        end, { noremap = true, silent = true })
    end
}
