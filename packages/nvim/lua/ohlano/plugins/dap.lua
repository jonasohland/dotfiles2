local dap = {
  {
    "mfussenegger/nvim-dap",
    dependencies = {},
  },
}

local dap_ui = {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
}

local dap_go = {
  "leoluz/nvim-dap-go",
}

return {
  dap,
  dap_ui,
  dap_go,
}
