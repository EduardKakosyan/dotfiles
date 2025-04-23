return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "BufReadPost",
  opts = {
    enable = true,
    max_lines = 3, -- how many lines of context to show at most
    trim_scope = "outer", -- "inner" if you want to show most nested scope only
    mode = "cursor", -- can be "topline" if you prefer that
    separator = nil, -- You can set a line separator like "─"
  },
}
