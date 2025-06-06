return {
  {
    "smallcloudai/refact-neovim",
    lazy = false,
    config = function()
      require("refact-neovim").setup({
        address_url = "Refact",
        api_key = os.getenv("REFACT_API_KEY"),
      })
    end
  }
}
