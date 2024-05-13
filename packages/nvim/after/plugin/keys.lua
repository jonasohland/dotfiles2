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

vim.keymap.set("n", "<leader>tr", neotest_run)
vim.keymap.set("n", "<leader>top", neotest_toggle_output_panel)
vim.keymap.set("n", "<leader>tos", neotest_show_output)
vim.keymap.set("n", "<leader>toe", neotest_show_output_enter)
