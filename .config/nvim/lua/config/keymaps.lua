local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { silent = true })
keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { silent = true })
keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { silent = true })
keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { silent = true })
keymap.set("n", "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", { silent = true })
keymap.set("n", "<C-Space>", "<Cmd>NvimTmuxNavigateNavigateNext<CR>", { silent = true })

-- Borderless terminal
vim.keymap.set("n", "<C-/>", function()
  Util.terminal(nil, { border = "none" })
end, { desc = "Term with border" })

-- Borderless lazygit
vim.keymap.set("n", "<leader>gg", function()
  Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { desc = "Lazygit (root dir)" })

keymap.set("n", "<M-h>", '<Cmd>lua require("tmux").resize_left()<CR>', { silent = true })
keymap.set("n", "<M-j>", '<Cmd>lua require("tmux").resize_bottom()<CR>', { silent = true })
keymap.set("n", "<M-k>", '<Cmd>lua require("tmux").resize_top()<CR>', { silent = true })
keymap.set("n", "<M-l>", '<Cmd>lua require("tmux").resize_right()<CR>', { silent = true })

-- Split windows
keymap.set("n", "ss", ":vsplit<Return>", opts)
keymap.set("n", "sv", ":split<Return>", opts)

-- Move selected line up or down
keymap.set("v", "<S-j>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<S-k>", ":m '<-2<CR>gv=gv")

-- HARPOON BINDS
local harpoon = require("harpoon")
keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon: Add file" })

vim.keymap.set("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
--- Optional: quick nav
keymap.set("n", "<leader>1", function()
  harpoon:list():select(1)
end)
keymap.set("n", "<leader>2", function()
  harpoon:list():select(2)
end)
keymap.set("n", "<leader>3", function()
  harpoon:list():select(3)
end)
keymap.set("n", "<leader>4", function()
  harpoon:list():select(4)
end)

--- Optional harpoon list management
-- Removes an entry at a specific index and shifts everything else up
local function remove_harpoon_index(index)
  local list = harpoon:list()
  local items = list.items

  if index < 1 or index > #items then
    vim.notify("Invalid Harpoon index: " .. index, vim.log.levels.ERROR)
    return
  end

  -- Remove the item at the index
  table.remove(items, index)

  vim.notify("Removed Harpoon item at index " .. index, vim.log.levels.INFO)
end

-- yank to clipboard
keymap.set("v", "<leader>y", '"+y')

-- toggleterm
local Terminal = require("toggleterm.terminal").Terminal

-- Toggle a horizontal terminal
keymap.set("n", "<leader>tt", function()
  require("toggleterm").toggle()
end, { desc = "Toggle Terminal" })

-- Rust: run `cargo run` in a terminal
local cargo_term = Terminal:new({
  cmd = "cargo run; echo 'Press any key to exit'; read",
  hidden = true,
  direction = "float",
})

keymap.set("n", "<leader>rr", function()
  vim.cmd("w")
  cargo_term:toggle()
end, { desc = "Rust: cargo run" })

-- Window resize management
local map = vim.keymap.set
local window_opts = { noremap = true, silent = true, desc = "Window Resize" }
--
map("n", "<S-Up>", "<cmd>resize +5<CR>", window_opts)
map("n", "<S-Down>", "<cmd>resize -5<CR>", window_opts)
map("n", "<S-Left>", "<cmd>vertical resize +5<CR>", window_opts)
map("n", "<S-Right>", "<cmd>vertical resize -5<CR>", window_opts)
