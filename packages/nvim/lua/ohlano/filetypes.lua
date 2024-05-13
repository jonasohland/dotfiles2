local au = vim.api.nvim_create_autocmd

au({ "BufNewFile", "BufRead" }, { pattern = { "*.nomad" }, command = ":set filetype=hcl" })
