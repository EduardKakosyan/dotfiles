-- ~/.config/nvim/lua/plugins/cmp-no-snippets.lua
return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    -- Remove `luasnip` from cmp sources so snippet items stop showing up
    opts.sources = vim.tbl_filter(function(source)
      return source.name ~= "luasnip"
    end, opts.sources or {})
  end,
}
