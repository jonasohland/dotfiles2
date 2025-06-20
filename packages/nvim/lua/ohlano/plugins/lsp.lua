local luasnip = {
  "L3MON4D3/LuaSnip",
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  build = "make install_jsregexp",
}

local cmp = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "saadparwaiz1/cmp_luasnip",
    luasnip,
  },
  config = function(_, _)
    local cmp = require("cmp")
    local snip = require("luasnip")
    cmp.setup({
      snippet = {
        expand = function(args)
          snip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp_document_symbol" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
      }),
    })
  end,
}

local mason = {
  "mason-org/mason.nvim",
  cmd = "Mason",
  event = "VeryLazy",
  build = ":MasonUpdate",
  opts = {},
}

local neodev = {
  "folke/neodev.nvim",
  dependencies = {
    "nvim-neotest/neotest",
  },
  opts = {
    library = { plugins = { "neotest" }, types = true },
  },
}

local neoconf = {
  "folke/neoconf.nvim",
  cmd = "Neoconf",
  opts = {},
}

local lspconfig = {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    neodev,
    neoconf,
  },
}

local mason_lspconfig = {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { cmp, neoconf, neodev, lspconfig, mason },
  opts = {
    automatic_enable = true,
    ensure_installed = {
      "gopls",
      "golangci_lint_ls",
      "rust_analyzer",
      "lua_ls",
      "jsonls",
      "helm_ls",
      "clangd",
    },
  },
}
local code_actions_preview = {
  "aznhe21/actions-preview.nvim",
  config = function(_, _)
    vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
  end,
}

local vim_helm = {
  "qvalentin/helm-ls.nvim",
  ft = "helm",
}

-- local copilot = {
--   "zbirenbaum/copilot.lua",
--   event = "InsertEnter",
--   config = function()
--     require("copilot").setup({
--       panel = {
--         enabled = true,
--         auto_refresh = true,
--         layout = {
--           position = "right",
--         },
--       },
--     })
--   end,
-- }

return {
  mason,
  lspconfig,
  mason_lspconfig,
  code_actions_preview,
  vim_helm,
  --  copilot,
}
