local lint = {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      sh = { "shellcheck" },
      proto = { "buf_lint" },
    }
  end,
}

return { lint }
