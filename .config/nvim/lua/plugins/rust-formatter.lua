-- ~/.config/nvim/lua/plugins/format-rust.lua
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.rust = { "rustfmt" }
      opts.format_on_save = opts.format_on_save or {}
      opts.format_on_save.timeout_ms = 3000
      return opts
    end,
  },
}
