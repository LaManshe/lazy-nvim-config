return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        ---@type render.md.UserConfig
        opts = {
            enabled = true,
            -- Горячая клавиша для переключения рендеринга
            keymaps = {
                toggle = "<Leader>mr",
            },
            -- Настройки рендеринга
            heading = {
                enabled = true,
                position = "overlay",
                icons = { "  ", "  ", "  ", "  ", "  ", "  " },
                signs = { "󰫎 ", "󰫎 ", "󰫎 ", "󰫎 ", "󰫎 ", "󰫎 " },
                width = "block",
            },
            code = {
                enabled = true,
                position = "overlay",
                width = "block",
                left_pad = 2,
                right_pad = 4,
                border = "thin",
            },
            bullet = {
                enabled = true,
                icons = { "●", "○", "◆", "◇" },
            },
            checkbox = {
                enabled = true,
                checked = {
                    icon = "✔ ",
                    scope_highlight = "@markup.list.checked",
                },
                unchecked = {
                    icon = " ",
                    scope_highlight = "@markup.list.unchecked",
                },
            },
            pipe_table = {
                enabled = true,
                preset = "heavy",
            },
        },
    },
}
