local conform = {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  -- Everything in opts will be passed to setup()
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      hcl = { "hcl" },
      go = { "gofmt" },
      yaml = { "yamlfmt" },
    },
    -- Set up format-on-save
    -- format_on_save = { timeout_ms = 500, lsp_fallback = false },
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        if vim.g.disable_format_on_save then
          return
        end
        if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].buftype ~= "" then
          return
        end
        require("conform").format({ lsp_fallback = true })
        if vim.g.post_format_hook ~= nil then
          vim.g.post_format_hook(args)
        end
      end,
    })
  end,
}

return { conform }
