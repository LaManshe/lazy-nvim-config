return {
    -- Главный движок отладки
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- Красивый UI для отладки
            "rcarriga/nvim-dap-ui",
            -- Иконки в статусбаре и virtual text
            "theHamsta/nvim-dap-virtual-text",
            -- Автоматическая установка адаптеров через Mason
            "jay-babu/mason-nvim-dap.nvim",
            "leoluz/nvim-dap-go",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            require("dap-go").setup({
                -- Аргументы для dlv (обычно стандартных хватает)
                delve = {
                    path = "dlv", -- если dlv в PATH, иначе полный путь из Mason
                },
            })

            -- Загружать настройки из .vscode/launch.json если они есть
            require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" }, delve = { "go" } })

            -- Автоматическое открытие/закрытие UI при старте отладки
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
}
