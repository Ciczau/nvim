return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup({
            actions = {
                open_file = {
                    quit_on_open = true
                }
            },
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
            local current_filetype = vim.bo.filetype
            if current_filetype ~= "NvimTree" then
                vim.cmd("bdelete")
                vim.cmd("NvimTreeToggle")
                vim.cmd("only")
            end
        end, { noremap = true, silent = true })
    end
}
