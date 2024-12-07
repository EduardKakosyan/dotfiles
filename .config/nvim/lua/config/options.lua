vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.encoding = "utf-8"

vim.opt.title = true
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append("**")
vim.opt.wildignore:append({ "*/node_modules/*", "*/target/*", "*/.git/*", "*/.DS_Store/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""
vim.opt.formatoptions:append({ "r" })

local opt = vim.opt

opt.conceallevel = 0
opt.cmdheight = 0

vim.g.root_spec = { "cwd" }
vim.g.omni_sql_no_default_maps = 1
vim.g.python3_host_prog = "/usr/bin/python3"