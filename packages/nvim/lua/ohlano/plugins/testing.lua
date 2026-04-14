local neotest = {
  "nvim-neotest/neotest",
  event = "VeryLazy",
  dependencies = {
    "vhyrro/luarocks.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "fredrikaverpil/neotest-golang",
      version = "*",
      build = function()
        vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
      end,
    },
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
        require("neotest-golang")({
          go_test_args = { "-v", "-race", "-count=1", "-timeout=25s" },
          runner = "gotestsum",
        }),
      },
    })
  end,
}

return {
  neotest,
}
