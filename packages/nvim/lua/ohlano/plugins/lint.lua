local lint = {
	"mfussenegger/nvim-lint",
	config = function()
		require("lint").linters_by_ft = {
			sh = { "shellcheck" },
		}
	end,
}

return { lint }
