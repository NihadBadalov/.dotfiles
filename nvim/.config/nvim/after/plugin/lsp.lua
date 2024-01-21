local lsp = require('lsp-zero')
local luasnip = require('luasnip')

lsp.preset("recommended")

lsp.ensure_installed({
  'lua_ls',
  'tsserver',
  'rust_analyzer',
  'html',
  'cssls',
  'emmet_language_server',
  'svelte',
  'pyright',
  'clangd'
})

-- Fix undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

-- CMP Config
local cmp_config = {}

-- Selects when you write, for example, this.night
cmp_config.completion = {
  completeopt = 'menu,menuone',
}

-- No idea what this is
cmp_config.matching = {
  disallow_fuzzy_matching = false,
  disallow_fullfuzzy_matching = false,
  disallow_partial_fuzzy_matching = false,
}

cmp_config.performance = {
  max_view_entries = 50,
}

cmp_config.snippet = {
  expand = function(args)
    luasnip.lsp_expand(args.body)
  end
}

-- That crazy window
cmp_config.window = {
  completion = cmp.config.window.bordered({
    border = "single",
    side_padding = 2,
    col_offset = -3,
    max_width = 80,
  }),
  documentation = cmp.config.window.bordered({
    max_width = 50,
  }),
}

cmp_config.mapping = cmp.mapping.preset.insert({
  ['<C-p>'] = cmp.mapping.select_prev_item(),
  ['<C-n>'] = cmp.mapping.select_next_item(),
  ["<C-u>"] = cmp.mapping.scroll_docs(-3),
  ["<C-d>"] = cmp.mapping.scroll_docs(3),
  ['<C-j>'] = cmp.mapping.complete(),
  ['<C-g>'] = cmp.mapping.abort(),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<Tab>'] = nil,
  ['<S-Tab>'] = nil,
})

cmp_config.sources = cmp.config.sources({
  { name = 'nvim_lsp',   keyword_length = 1 },
  { name = 'codeium' },
  -- { name = 'cmp_tabnine' },
  { name = 'luasnip' },
}, {
  { name = 'buffer' },
})

cmp_config.sorting = {
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
}

cmp.setup(cmp_config)


-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

vim.keymap.set("i", "<C-n>", '<Nop>')
vim.keymap.set("i", "<C-p>", '<Nop>')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>cws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>cof", function() vim.lsp.buf.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_actions() end, opts)
  vim.keymap.set("n", "<leader>crf", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>crn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

for _, v in ipairs(require('lspconfig').util.available_servers()) do
  require('lspconfig')[v].setup({ capabilities = capabilities })
end

require 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'Lua5.3',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
