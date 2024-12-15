-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Setup for nvim autoparis
require("nvim-autopairs").setup({
  fast_wrap = {},
  map_cr = true, -- Automatically add closing pair on <Enter>
  check_ts = true, -- Use Treesitter to check for conflicts
  disable_filetype = { "TelescopePrompt", "vim" }, -- Disable for specific filetypes
})
