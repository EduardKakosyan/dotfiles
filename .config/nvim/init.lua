-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.diagnostic.enable(false) -- Disable diagnostics for the current buffer
  end,
})

vim.opt.colorcolumn = "90"

-- Customize the highlight color of the color column
vim.cmd("highlight ColorColumn ctermbg=yellow guibg=yellow")
