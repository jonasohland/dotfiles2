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
	"williamboman/mason.nvim",
	cmd = "Mason",
	event = "VeryLazy",
	build = ":MasonUpdate",
	opts = {
		ensure_installed = {
			"gopls",
			"rust-analyzer",
			"stylua",
			"shfmt",
			"lua-language-server",
			"json-lsp",
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)
		local mr = require("mason-registry")
		mr:on("package:install:success", function()
			vim.defer_fn(function()
				-- trigger FileType event to possibly load this newly installed LSP server
				require("lazy.core.handler.event").trigger({
					event = "FileType",
					buf = vim.api.nvim_get_current_buf(),
				})
			end, 100)
		end)
		local function ensure_installed()
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end
		if mr.refresh then
			mr.refresh(ensure_installed)
		else
			ensure_installed()
		end
	end,
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

local mason_lspconfig = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { cmp, neoconf, neodev },
	config = function(_, opts)
		require("mason-lspconfig").setup(opts)
		require("mason-lspconfig").setup_handlers({
			-- The first entry (without a key) will be the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler (optional)
				require("lspconfig")[server_name].setup({
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					on_attach = function(_, bufnr)
						vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
						vim.keymap.set("n", "gq", vim.diagnostic.open_float, { buffer = bufnr })
						vim.keymap.set("n", "gh", vim.lsp.buf.hover, { buffer = bufnr })
						vim.keymap.set("n", "ge", vim.diagnostic.goto_next, { buffer = bufnr })
						vim.keymap.set("n", "gr", vim.diagnostic.goto_prev, { buffer = bufnr })
					end,
				})
			end,
		})
	end,
}

local lspconfig = {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		mason_lspconfig,
		neodev,
		neoconf,
	},
}

local code_actions_preview = {
	"aznhe21/actions-preview.nvim",
	config = function(_, _)
		vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
	end,
}

return {
	mason,
	lspconfig,
	code_actions_preview,
}
