local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 100000,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
      },
    },
    keys = {
      { "<leader>/", false },
      { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>ps", "<cmd>Telescope git_files<cr>", desc = "Find files in git tree" },
      { "<leader>pr", "<cmd>Telescope live_grep<cr>", desc = "Search in files with live preview" },
      { "<leader>po", "<cmd>Telescope buffers<cr>", desc = "Search in open buffers" },
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>pb", "<cmd>Telescope file_browser<cr>", desc = "Find Files" },
      { "<leader>pB", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "Find Files" },
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        },
      })
    end,
  },
  {
    "vhyrro/luarocks.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
    },
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    event = "VeryLazy",
    config = function()
      require("rest-nvim").setup()
    end,
  },
}

vim.list_extend(plugins, require("ohlano.plugins.lsp"))
vim.list_extend(plugins, require("ohlano.plugins.lint"))
vim.list_extend(plugins, require("ohlano.plugins.fmt"))
vim.list_extend(plugins, require("ohlano.plugins.testing"))
vim.list_extend(plugins, require("ohlano.plugins.treesitter"))
vim.list_extend(plugins, require("ohlano.plugins.dap"))

require("lazy").setup(plugins, {})
