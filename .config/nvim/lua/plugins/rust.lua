return {
  {
    -- Rust LSP + tooling
    "mrcjkb/rustaceanvim",
    version = "^5", -- or "latest"
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          -- inlay hints and such
          autoSetHints = true,
        },
        server = {
          -- Extra rust-analyzer config
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      }
    end,
  },
}
