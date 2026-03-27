local opt = vim.opt

-- Indentation (Go uses tabs, so defaults are fine)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = false -- Go convention: real tabs

-- Display
opt.number = true
opt.relativenumber = false
opt.wrap = false
opt.cursorline = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.scrolloff = 8

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Files
opt.encoding = "utf-8"
opt.backup = false
opt.swapfile = false
opt.undofile = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Misc
opt.mouse = ""
opt.clipboard = ""
opt.updatetime = 300
opt.timeoutlen = 1000

-- Disable auto-commenting on new lines
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})
