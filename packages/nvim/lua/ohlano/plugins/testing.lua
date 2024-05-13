local neotest = {
	"nvim-neotest/neotest",
	event = "VeryLazy",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go",
		"rouge8/neotest-rust",
	},
	config = function(_, _)
		local neotest = require("neotest")
		---@diagnostic disable-next-line: missing-fields
		neotest.setup({
			adapters = {
				require("neotest-rust")({
					args = { "--no-capture" },
				}),
				require("neotest-go")({
					args = { "-count=1", "-timeout=60s" },
				}),
			},
		})
	end,
}

return {
	neotest,
}
