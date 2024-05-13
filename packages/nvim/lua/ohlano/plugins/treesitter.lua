local treesitter = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			highlight = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>ns", -- set to `false` to disable one of the mappings
					node_incremental = "<leader>ni",
					scope_incremental = "<leader>nc",
					node_decremental = "<leader>nd",
				},
			},
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["as"] = "@scope",
					},
				},
			},
			ensure_installed = {
				"vim",
				"vimdoc",
				"html",
				"markdown",
				"fish",
				"bash",
				"diff",
				"git_config",
				"git_rebase",
				"c",
				"cpp",
				"lua",
				"rust",
				"go",
				"gomod",
				"gosum",
				"hcl",
				"javascript",
				"java",
				"kotlin",
				"yaml",
				"json",
				"dockerfile",
				"cuda",
				"json",
				"http",
				"latex",
				"zig",
				"meson",
				"cmake",
				"proto",
				"sql",
				"vue",
				"jsonc",
			},
		})
	end,
}

local treesitter_context = {
	"nvim-treesitter/nvim-treesitter-context",
	event = "VeryLazy",
	dependencies = { treesitter },
	config = function()
		require("treesitter-context").setup({
			enable = true,
		})
	end,
}

local treesitter_textobjects = {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = "VeryLazy",
	dependencies = { treesitter },
}

return {
	treesitter_textobjects,
	treesitter_context,
}
