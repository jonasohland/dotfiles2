local au = vim.api.nvim_create_autocmd

au({ "BufNewFile", "BufRead" }, { pattern = { "*.nomad" }, command = ":set set=hcl" })

vim.filetype.add({
  extension = {
    ["nomad"] = "hcl",
    ["vx"] = "vortex",
    ["vortex"] = "vortex",
  },
})
