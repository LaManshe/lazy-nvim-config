-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local dap = require("dap")

vim.keymap.set("n", "<F5>", function()
    dap.continue()
end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F10>", function()
    dap.step_over()
end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", function()
    dap.step_into()
end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", function()
    dap.step_out()
end, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>db", function()
    dap.toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Breakpoint" })
