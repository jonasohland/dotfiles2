local M = {}

function M.with_preserve_cursor(fun)
  -- local original_cursor = vim.fn.winsaveview()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  fun()
  local lastline = vim.fn.line("$")
  -- vim.fn.winrestview(original_cursor)
  if line > lastline then
    line = lastline
  end
  vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { line, col })
end

return M
