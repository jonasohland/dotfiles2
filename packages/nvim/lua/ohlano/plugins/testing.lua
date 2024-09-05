local neotest = {
  "nvim-neotest/neotest",
  event = "VeryLazy",
  dependencies = {
    "vhyrro/luarocks.nvim",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "fredrikaverpil/neotest-golang",
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
        }),
      },
    })
  end,
}

return {
  neotest,
}
