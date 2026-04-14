local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  config = function()
    local ts = require("nvim-treesitter")
    ts.install({
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
      "zig",
      "meson",
      "cmake",
      "proto",
      "sql",
      "vue",
      "hyprlang",
    })
    for _, lang in ipairs(ts.get_installed("parser/*")) do
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { lang },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end
  end,
}

return {
  treesitter,
}
