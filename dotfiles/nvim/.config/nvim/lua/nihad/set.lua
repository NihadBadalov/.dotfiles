vim.opt.guicursor = "n-v-c-i:block"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- https://www.reddit.com/r/vim/comments/3ql651/what_do_you_set_your_updatetime_to/
vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- a "C" appears when editing sql files and pressing <C-c> (sql omni completion)
-- reddit post explaining: https://www.reddit.com/r/neovim/comments/17mcomx/deleted_by_user/
vim.g.ftplugin_sql_omni_key = nil
