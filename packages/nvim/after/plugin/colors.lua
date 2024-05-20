function ColorsFix(color)
  color = color or "rose-pine"

  vim.cmd.colorscheme(color)
end

ColorsFix()
