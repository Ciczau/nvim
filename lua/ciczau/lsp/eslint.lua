vim.lsp.config['eslint'] = {
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue'

    },
    root_markers = {
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.json',
        'package.json',
        '.git'
    },
    settings = {
        validate = "on",
        packageManager = "npm", -- lub "yarn"/"pnpm"
        format = true
    }
}

vim.lsp.enable('eslint')

