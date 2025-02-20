return {
    "akinsho/toggleterm.nvim",
    version = '*',
    config = function()
        require("toggleterm").setup({
            size = 8,
            open_mapping = [[<C-\>]],
            shade_terminals = true,
            direction = "horizontal",
            close_on_exit = true,
            shell = vim.o.shell,
        })

        vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
    end
}
