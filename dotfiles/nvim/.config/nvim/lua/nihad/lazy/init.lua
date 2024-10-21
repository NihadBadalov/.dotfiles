return {
  --[[ {
    'boganworld/crackboard.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      session_key = 'd5f3923c4832cdb75ada0b506d49be534a9943ef052e4f4877482c1fad1126d0',
    },
  }, ]]
  {
    "onsails/lspkind-nvim",
  },
  -- {
  --   "ziglang/zig.vim",
  -- },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({})

      --cpp
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "/home/nihad/.cpptools/extension/debugAdapters/bin/OpenDebugAD7",
      }
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
        {
          name = "Attach to gdbserver :1234",
          type = "cppdbg",
          request = "launch",
          MIMode = "gdb",
          miDebuggerServerAddress = "localhost:1234",
          miDebuggerPath = "/usr/bin/gdb",
          cwd = "${workspaceFolder}",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
      require("dap-python").setup("python")

      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)
      vim.keymap.set("n", "<leader>guo", ui.open)
      vim.keymap.set("n", "<leader>guc", ui.close)

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>?", function()
        ui.eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F6>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      -- 	ui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      -- 	-- ui.close()
      -- end
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    name = "plenary",
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end,
  },
  -- {
  --   -- https://github.com/zbirenbaum/copilot.lua
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       panel = {
  --         keymap = {
  --           jump_prev = "]]",
  --           jump_next = "[[",
  --           accept = "<Tab>",
  --           refresh = "gr",
  --           open = "<M-]>",
  --         },
  --       },
  --       suggestion = {
  --         auto_trigger = true,
  --         keymap = {
  --           accept = "<M-Tab>",
  --         },
  --       },
  --     })
  --     -- vim.keymap.set("n", "<leader>cpe", "<cmd>Copilot enable<CR>")
  --     -- vim.keymap.set("n", "<leader>cpd", "<cmd>Copilot disable<CR>")
  --   end,
  -- },
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
    "ldelossa/gh.nvim",
    dependencies = {
      "ldelossa/litee.nvim",
    },
  },
  "eandrju/cellular-automaton.nvim",
  "gpanders/editorconfig.nvim",

  -- Useful for getting pretty icons, but requires a Nerd Font.
  { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  "lambdalisue/nerdfont.vim",
  "junegunn/vim-easy-align",
  "rcarriga/nvim-notify",

  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
