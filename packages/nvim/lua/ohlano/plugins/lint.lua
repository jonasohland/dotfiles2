local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

local lint = {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      sh = { "shellcheck" },
      proto = { "buf_lint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      pattern = { "*.proto" },
      callback = function()
        if file_exists("buf.yml") or file_exists("buf.yaml") then
          require("lint").try_lint()
        end
      end,
    })
  end,
}

return { lint }
