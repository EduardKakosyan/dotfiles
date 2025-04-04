return {
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  config = true,
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        -- Optional configurations
        disable_filetype = { "TelescopePrompt", "vim" },
        check_ts = true, -- Enable treesitter integration
      })
    end,
  },
}
