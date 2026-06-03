local data_home = vim.env.XDG_DATA_HOME or vim.fs.joinpath(vim.env.HOME, ".local", "share")
local treesitter_dir = vim.fs.joinpath(data_home, "tree-sitter")
local parser_dir = vim.fs.joinpath(treesitter_dir, "parser")

vim.opt.runtimepath:prepend(treesitter_dir)

local filetype_aliases = {
  bash = { "sh" },
  javascript = { "javascriptreact" },
  tsx = { "typescriptreact" },
  stage_idl = { "idl" },
  vortex = { "vx" },
}

-- get languages from .so filenames
local available = {}
for name, type in vim.fs.dir(parser_dir) do
  local lang = name:match("^(.+)%.so$")
  if lang and type ~= "directory" then
    available[lang] = true
  end
end

-- register aliases
local filetypes = {}
for lang in pairs(available) do
  if filetype_aliases[lang] then
    vim.treesitter.language.register(lang, filetype_aliases[lang])
  end
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
    filetypes[ft] = true
  end
end

-- vim.treesitter.start() autocmd
if not vim.tbl_isempty(filetypes) then
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("ohlano_treesitter", { clear = true }),
    pattern = vim.tbl_keys(filetypes),
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end
