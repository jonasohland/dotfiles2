local neotest_run = function()
  require("neotest").run.run()
end

local neotest_toggle_output_panel = function()
  require("neotest").output_panel.toggle()
end

local neotest_show_output = function()
  require("neotest").output.open()
end

local neotest_show_output_enter = function()
  require("neotest").output.open({ enter = true })
end

local diag_next = function()
  vim.diagnostic.jump({ count = 1, float = true })
end
local diag_prev = function()
  vim.diagnostic.jump({ count = -1, float = true })
end

vim.keymap.set("n", "<leader>tr", neotest_run)
vim.keymap.set("n", "<leader>top", neotest_toggle_output_panel)
vim.keymap.set("n", "<leader>tos", neotest_show_output)
vim.keymap.set("n", "<leader>toe", neotest_show_output_enter)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "gq", vim.diagnostic.open_float)
vim.keymap.set("n", "gh", vim.lsp.buf.hover)
vim.keymap.set("n", "ge", diag_next)
vim.keymap.set("n", "gE", diag_prev)
vim.keymap.set("n", "gr", diag_prev)
