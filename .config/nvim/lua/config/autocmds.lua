-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Setup for nvim-cmp
-- Setup for nvim-cmp
require("cmp").setup({
  enabled = function()
    local disabled = false
    disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
    disabled = disabled or (vim.fn.reg_recording() ~= "")
    disabled = disabled or (vim.fn.reg_executing() ~= "")
    disabled = disabled or require("cmp.config.context").in_treesitter_capture("comment")
    disabled = disabled or (vim.bo.filetype == "copilot-chat")

    return not disabled
  end,
})
