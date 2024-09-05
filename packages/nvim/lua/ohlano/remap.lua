vim.g.mapleader = " "

local function numbers()
  vim.cmd.set("number")
  vim.cmd.set("norelativenumber")
end

local function relativenumbers()
  vim.cmd.set("relativenumber")
end

local function lint()
  require("lint").try_lint()
end

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>kh", vim.cmd.noh)
vim.keymap.set("n", "<leader>na", numbers)
vim.keymap.set("n", "<leader>nr", relativenumbers)
vim.keymap.set("n", "<leader>rl", lint)
