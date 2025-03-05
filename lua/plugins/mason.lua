return {
    -- Установка и настройка mason.nvim
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },

    -- mason-lspconfig для интеграции с LSP-серверами
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright","lua_ls"
                },
                automatic_installation = true,
            })
        end,
    },

    -- Конфигурация LSP через nvim-lspconfig
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            -- Настройка LSP для Lua (lua_ls)
            lspconfig.lua_ls.setup({})
            -- Настройка LSP сервера для Python (pyright)
            lspconfig.pyright.setup({})
        end,
    },

    -- Настройка mason-null-ls для установки инструментов для Python
    {
        "jayp0521/mason-null-ls.nvim",
        dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = { 
                    "black", -- Оставлен только black для форматирования Python
                },
                automatic_installation = true,
            })

            -- Конфигурация null-ls для Python форматирования
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- Python: black для форматирования
                    null_ls.builtins.formatting.black,
                },
            })
        end,
    },
}

