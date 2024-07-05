return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- "folke/neodev.nvim",
		"williamboman/mason.nvim",
		"mason-org/mason-registry",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()

		local vue_typescript_plugin = require("mason-registry").get_package("vue-language-server"):get_install_path()
			.. "/node_modules/@vue/language-server"
			.. "/node_modules/@vue/typescript-plugin"

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"tsserver",
				"cssls",
				"tailwindcss",
				"pyright",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,

				["tsserver"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.tsserver.setup({
						capabilities = capabilities,
						-- settings = {
						-- },
						init_options = {
							plugins = {
								{
									name = "@vue/typescript-plugin",
									location = vue_typescript_plugin,
									languages = { "javascript", "typescript", "vue" },
								},
							},
						},
						filetypes = {
							"javascript",
							"javascriptreact",
							"javascript.jsx",
							"typescript",
							"typescriptreact",
							"typescript.tsx",
							"vue",
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		--- Select item next/prev, taking into account whether the cmp window is
		--- top-down or bottoom-up so that the movement is always in the same direction.
		local select_item_smart = function(dir, opts)
			return function(fallback)
				if cmp.visible() then
					opts = opts or { behavior = cmp.SelectBehavior.Select }
					if cmp.core.view.custom_entries_view:is_direction_top_down() then
						({ next = cmp.select_next_item, prev = cmp.select_prev_item })[dir](opts)
					else
						({ prev = cmp.select_next_item, next = cmp.select_prev_item })[dir](opts)
					end
				else
					fallback()
				end
			end
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			-- No idea what this is
			matching = {
				disallow_fuzzy_matching = false,
				disallow_fullfuzzy_matching = false,
				disallow_partial_fuzzy_matching = false,
			},
			performance = {
				max_view_entries = 20,
			},
			-- That crazy window
			-- window = {
			--   completion = cmp.config.window.bordered({
			--     border = "single",
			--     side_padding = 2,
			--     col_offset = -3,
			--     max_width = 80,
			--   }),
			--   documentation = cmp.config.window.bordered({
			--     max_width = 50,
			--   }),
			-- },
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = select_item_smart("prev", cmp_select),
				["<C-n>"] = select_item_smart("next", cmp_select),
				["<C-e>"] = cmp.mapping.close(),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-B>"] = cmp.mapping.complete(),
				["<C-u>"] = cmp.mapping.scroll_docs(-3),
				["<C-d>"] = cmp.mapping.scroll_docs(3),
				["<C-g>"] = cmp.mapping.abort(),
			}),
			sorting = {
				comparators = {
					cmp.config.compare.locality,
					cmp.config.compare.offset,
					cmp.config.compare.recently_used,
					cmp.config.compare.exact,
					cmp.config.compare.order,
					cmp.config.compare.length,
					function(entry1, entry2)
						local _, entry1_under = entry1.completion_item.label:find("^_+")
						local _, entry2_under = entry2.completion_item.label:find("^_+")
						entry1_under = entry1_under or 0
						entry2_under = entry2_under or 0
						if entry1_under > entry2_under then
							return false
						elseif entry1_under < entry2_under then
							return true
						end
					end,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
				},
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "codeium" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true, -- Update diagnostics in Insert mode
			-- ^ (if false, diagnostics are updated on InsertLeave)

			underline = true,

			virtual_text = true,

			severity_sort = true, -- high -> low

			-- float = {
			--   focusable = false,
			--   style = "minimal",
			--   border = "rounded",
			--   source = true,
			--   header = { "  Diagnostics", "String" },
			--   prefix = function(_, _, _)
			--     return "  ", "String"
			--   end,
			-- },
		})
	end,
}
