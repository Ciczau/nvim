return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        -- Make sure to install prettierd, it has to be down manual for now :(
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "stylelint_lsp",
                "eslint",
                "ts_ls",
                "volar",
                "gopls",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["stylelint_lsp"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.stylelint_lsp.setup({
                        settings = {
                            stylelintplus = {
                                autoFixOnFormat = true,
                                autoFixOnSave = true,
                                validateOnSave = true,
                                validateOnType = true,
                                validateOnInsert = true,
                                validateOnDocumentOpen = true,
                                validateOnDocumentSave = true,
                                validateOnDocumentChange = true,
                            },
                        }
                    })
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["volar"] = function()
                    require("lspconfig").volar.setup({
                        init_options = {
                            vue = {
                                hybridMode = false,
                            },
                        },
                        settings = {
                            typescript = {
                                inlayHints = {
                                    enumMemberValues = {
                                        enabled = true,
                                    },
                                    functionLikeReturnTypes = {
                                        enabled = true,
                                    },
                                    propertyDeclarationTypes = {
                                        enabled = true,
                                    },
                                    parameterTypes = {
                                        enabled = true,
                                        suppressWhenArgumentMatchesName = true,
                                    },
                                    variableTypes = {
                                        enabled = true,
                                    },
                                },
                            },
                        },
                    })
                end,

                ["ts_ls"] = function()
                    local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
                    local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

                    require("lspconfig").ts_ls.setup({
                        init_options = {
                            plugins = {
                                {
                                    name = "@vue/typescript-plugin",
                                    location = volar_path,
                                    languages = { "vue" },
                                },
                            },
                        },
                        settings = {
                            typescript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                },
                            },
                        },
                    })
                end,
                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup({
                        on_attach = function(client, bufnr)
                            if client.supports_method("textDocument/formatting") then
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    buffer = bufnr,
                                    callback = function()
                                        vim.lsp.buf.format({ async = false })
                                    end,
                                })
                            end
                        end,
                        settings = {
                            gopls = {
                                gofumpt = true,
                                staticcheck = true,
                                analyses = {
                                    unusedparams = true,
                                    unusedwrite = true,
                                    shadow = true,
                                },
                            },
                        },
                    })
                end

            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({

            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
