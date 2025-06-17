return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      theme = "auto",
      section_separators = "",
      component_separators = "",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } }, -- 0 = just filename, 1 = relative, 2 = absolute
      lualine_x = {
        -- Add refact status to show AI assistant status
        function()
          local ok, refact = pcall(require, "refact-neovim")
          if ok and refact.status_line then
            return refact.status_line()
          end
          return ""
        end,
      },
      lualine_y = { "location" },
      lualine_z = {},
    },
  },
}
