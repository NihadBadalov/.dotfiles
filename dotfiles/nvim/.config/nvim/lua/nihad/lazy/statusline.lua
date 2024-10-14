return {
	"nvim-lualine/lualine.nvim",
	-- "freddiehaddad/feline.nvim",
	dependencies = {
		-- "Hitesh-Aggarwal/feline_one_monokai.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local colors = {
			red = "#ca1243",
			grey = "#a0a1a7",
			black = "#383a42",
			white = "#f3f3f3",
			light_green = "#83a598",
			orange = "#fe8019",
			green = "#8ec07c",
		}

		local theme = {
			normal = {
				a = { fg = colors.white, bg = colors.black },
				b = { fg = colors.white, bg = colors.grey },
				c = { fg = colors.black, bg = colors.white },
				z = { fg = colors.white, bg = colors.black },
			},
			insert = { a = { fg = colors.black, bg = colors.light_green } },
			visual = { a = { fg = colors.black, bg = colors.orange } },
			replace = { a = { fg = colors.black, bg = colors.green } },
		}

		local empty = require("lualine.component"):extend()
		function empty:draw(default_highlight)
			self.status = ""
			self.applied_separator = ""
			self:apply_highlights(default_highlight)
			self:apply_section_separators()
			return self.status
		end

		-- Put proper separators and gaps between components in sections
		local function process_sections(sections)
			for name, section in pairs(sections) do
				local left = name:sub(9, 10) < "x"
				for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
					table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
				end
				for id, comp in ipairs(section) do
					if type(comp) ~= "table" then
						comp = { comp }
						section[id] = comp
					end
					comp.separator = left and { right = "" } or { left = "" }
				end
			end
			return sections
		end

		local function search_result()
			if vim.v.hlsearch == 0 then
				return ""
			end
			local last_search = vim.fn.getreg("/")
			if not last_search or last_search == "" then
				return ""
			end
			local searchcount = vim.fn.searchcount({ maxcount = 9999 })
			return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
		end

		local function modified()
			if vim.bo.modified then
				return "+"
			elseif vim.bo.modifiable == false or vim.bo.readonly == true then
				return "-"
			end
			return ""
		end

		require("lualine").setup({
			options = {
				theme = theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = process_sections({
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					-- "diff",
					{
						"diagnostics",
						source = { "nvim" },
						sections = { "error" },
						diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
					},
					{
						"diagnostics",
						source = { "nvim" },
						sections = { "warn" },
						diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
					},
					{ "filename", file_status = false, path = 3 },
					{ modified, color = { bg = colors.red } },
					{
						"%w",
						cond = function()
							return vim.wo.previewwindow
						end,
					},
					{
						"%r",
						cond = function()
							return vim.bo.readonly
						end,
					},
					{
						"%q",
						cond = function()
							return vim.bo.buftype == "quickfix"
						end,
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = { search_result, "filetype" },
				lualine_z = { "%l:%c", "%p%%/%L" },
			}),
			inactive_sections = {
				lualine_c = { "%f %y %m" },
				lualine_x = {},
			},
		})
	end,
	-- config = function()
	--
	-- end
	-- config = function()
	-- 	local line_ok, feline = pcall(require, "feline")
	-- 	if not line_ok then
	-- 		return
	-- 	end
	--
	-- 	local one_monokai = {
	-- 		fg = "#abb2bf",
	-- 		bg = "#1e2024",
	-- 		green = "#98c379",
	-- 		yellow = "#e5c07b",
	-- 		purple = "#c678dd",
	-- 		orange = "#d19a66",
	-- 		peanut = "#f6d5a4",
	-- 		red = "#e06c75",
	-- 		aqua = "#61afef",
	-- 		darkblue = "#282c34",
	-- 		dark_red = "#f75f5f",
	-- 	}
	--
	-- 	local vi_mode_colors = {
	-- 		NORMAL = "green",
	-- 		OP = "green",
	-- 		INSERT = "yellow",
	-- 		VISUAL = "purple",
	-- 		LINES = "orange",
	-- 		BLOCK = "dark_red",
	-- 		REPLACE = "red",
	-- 		COMMAND = "aqua",
	-- 	}
	--
	-- 	local c = {
	-- 		vim_mode = {
	-- 			provider = {
	-- 				name = "vi_mode",
	-- 				opts = {
	-- 					show_mode_name = true,
	-- 					-- padding = "center", -- Uncomment for extra padding.
	-- 				},
	-- 			},
	-- 			hl = function()
	-- 				return {
	-- 					fg = require("feline.providers.vi_mode").get_mode_color(),
	-- 					bg = "darkblue",
	-- 					style = "bold",
	-- 					name = "NeovimModeHLColor",
	-- 				}
	-- 			end,
	-- 			left_sep = "block",
	-- 			right_sep = "block",
	-- 		},
	-- 		gitBranch = {
	-- 			provider = "git_branch",
	-- 			hl = {
	-- 				fg = "peanut",
	-- 				bg = "darkblue",
	-- 				style = "bold",
	-- 			},
	-- 			left_sep = "block",
	-- 			right_sep = "block",
	-- 		},
	-- 		gitDiffAdded = {
	-- 			provider = "git_diff_added",
	-- 			hl = {
	-- 				fg = "green",
	-- 				bg = "darkblue",
	-- 			},
	-- 			left_sep = "block",
	-- 			right_sep = "block",
	-- 		},
	-- 		gitDiffRemoved = {
	-- 			provider = "git_diff_removed",
	-- 			hl = {
	-- 				fg = "red",
	-- 				bg = "darkblue",
	-- 			},
	-- 			left_sep = "block",
	-- 			right_sep = "block",
	-- 		},
	-- 		gitDiffChanged = {
	-- 			provider = "git_diff_changed",
	-- 			hl = {
	-- 				fg = "fg",
	-- 				bg = "darkblue",
	-- 			},
	-- 			left_sep = "block",
	-- 			right_sep = "right_filled",
	-- 		},
	-- 		separator = {
	-- 			provider = "",
	-- 		},
	-- 		fileinfo = {
	-- 			provider = {
	-- 				name = "file_info",
	-- 				opts = {
	-- 					type = "relative",
	-- 				},
	-- 			},
	-- 			hl = {
	-- 				style = "bold",
	-- 			},
	-- 			left_sep = " ",
	-- 			right_sep = " ",
	-- 		},
	-- 		diagnostic_errors = {
	-- 			provider = "diagnostic_errors",
	-- 			hl = {
	-- 				fg = "red",
	-- 			},
	-- 		},
	-- 		diagnostic_warnings = {
	-- 			provider = "diagnostic_warnings",
	-- 			hl = {
	-- 				fg = "yellow",
	-- 			},
	-- 		},
	-- 		diagnostic_hints = {
	-- 			provider = "diagnostic_hints",
	-- 			hl = {
	-- 				fg = "aqua",
	-- 			},
	-- 		},
	-- 		diagnostic_info = {
	-- 			provider = "diagnostic_info",
	-- 		},
	-- 		lsp_client_names = {
	-- 			provider = "lsp_client_names",
	-- 			hl = {
	-- 				fg = "purple",
	-- 				bg = "darkblue",
	-- 				style = "bold",
	-- 			},
	-- 			left_sep = "left_filled",
	-- 			right_sep = "block",
	-- 		},
	-- 		file_type = {
	-- 			provider = {
	-- 				name = "file_type",
	-- 				opts = {
	-- 					filetype_icon = true,
	-- 					case = "titlecase",
	-- 				},
	-- 			},
	-- 			hl = {
	-- 				fg = "red",
	-- 				bg = "darkblue",
	-- 				style = "bold",
	-- 			},
	-- 			left_sep = "block",
	-- 			right_sep = "block",
	-- 		},
	-- 		file_encoding = {
	-- 			provider = "file_encoding",
	-- 			hl = {
	-- 				fg = "orange",
	-- 				bg = "darkblue",
	-- 				style = "italic",
	-- 			},
	-- 			left_sep = "block",
	-- 			right_sep = "block",
	-- 		},
	-- 		position = {
	-- 			provider = "position",
	-- 			hl = {
	-- 				fg = "green",
	-- 				bg = "darkblue",
	-- 				style = "bold",
	-- 			},
	-- 			left_sep = "block",
	-- 			right_sep = "block",
	-- 		},
	-- 		line_percentage = {
	-- 			provider = "line_percentage",
	-- 			hl = {
	-- 				fg = "aqua",
	-- 				bg = "darkblue",
	-- 				style = "bold",
	-- 			},
	-- 			left_sep = "block",
	-- 			right_sep = "block",
	-- 		},
	-- 		scroll_bar = {
	-- 			provider = "scroll_bar",
	-- 			hl = {
	-- 				fg = "yellow",
	-- 				style = "bold",
	-- 			},
	-- 		},
	-- 	}
	--
	-- 	local left = {
	-- 		c.vim_mode,
	-- 		c.gitBranch,
	-- 		c.gitDiffAdded,
	-- 		c.gitDiffRemoved,
	-- 		c.gitDiffChanged,
	-- 		c.separator,
	-- 	}
	--
	-- 	local middle = {
	-- 		c.fileinfo,
	-- 		c.diagnostic_errors,
	-- 		c.diagnostic_warnings,
	-- 		c.diagnostic_info,
	-- 		c.diagnostic_hints,
	-- 	}
	--
	-- 	local right = {
	-- 		-- c.lsp_client_names,
	-- 		c.file_type,
	-- 		c.file_encoding,
	-- 		c.position,
	-- 		-- c.line_percentage,
	-- 		-- c.scroll_bar,
	-- 	}
	--
	-- 	local components = {
	-- 		active = {
	-- 			left,
	-- 			middle,
	-- 			right,
	-- 		},
	-- 		inactive = {
	-- 			left,
	-- 			middle,
	-- 			right,
	-- 		},
	-- 	}
	--
	-- 	feline.setup({
	-- 		components = components,
	-- 		theme = one_monokai,
	-- 		vi_mode_colors = vi_mode_colors,
	-- 	})
	-- end,
}
