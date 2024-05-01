return {

  {
    "nvim-lua/plenary.nvim",
    name = "plenary"
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      -- set <leader>cpd and <leader>cpe to disable/enable copilot
      vim.keymap.set("n", "<leader>cpe", "<cmd>Copilot enable<CR>")
      vim.keymap.set("n", "<leader>cpd", "<cmd>Copilot disable<CR>")
    end,
  },
  -- {
  --   "Exafunction/codeium.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     require("codeium").setup({
  --       -- https://github.com/Exafunction/codeium.vim
  --     })
  --   end
  -- },
  {
    'ldelossa/gh.nvim',
    dependencies = {
      'ldelossa/litee.nvim'
    }
  },
  "eandrju/cellular-automaton.nvim",
  "gpanders/editorconfig.nvim",

  'nvim-tree/nvim-web-devicons',
  'Hitesh-Aggarwal/feline_one_monokai.nvim',
  'lambdalisue/nerdfont.vim',
  'junegunn/vim-easy-align',
  'rcarriga/nvim-notify',
}
