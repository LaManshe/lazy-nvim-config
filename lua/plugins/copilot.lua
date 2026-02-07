--[[return {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    config = function()
        require("copilot").setup({
            panel = {
                enabled = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 175,
            },
            filetypes = {
                yaml = false,
                markdown = true,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
        })

        vim.keymap.set("i", "<S-Tab>", function()
            if require("copilot.suggestion").is_visible() then
                return require("copilot.suggestion").accept()
            else
                return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
            end
        end, {
            silent = true,
        })
    end,
}]]
