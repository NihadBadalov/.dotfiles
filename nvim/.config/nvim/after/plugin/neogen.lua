local neogen = require("neogen").setup({
  snippet_engine = "luasnip"
})

vim.keymap.set("n", "<leader>nf", function()
  require("neogen").generate({ type = "func" })
end)

vim.keymap.set("n", "<leader>nt", function()
  require("neogen").generate({ type = "type" })
end)

vim.keymap.set("n", "<leader>nd", function()
  require("neogen").generate({ type = "typedef" })
end)
