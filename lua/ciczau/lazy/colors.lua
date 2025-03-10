function ColorMyPencils(color)
    color = color or "tokyonight-night"
    vim.cmd.colorscheme(color)
end

return {
    {
        "erikbackman/brightburn.vim",
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                styles = {
                    keywords = { italic = false }
                }
            })
            ColorMyPencils()
        end
    },
}
