return {
    "alexghergh/nvim-tmux-navigation",
    config = function()
        local tmux_nav = require("nvim-tmux-navigation")
        tmux_nav.setup({})

        vim.keymap.set("n", "<C-h>", tmux_nav.NvimTmuxNavigateLeft, { silent = true })
        vim.keymap.set("n", "<C-j>", tmux_nav.NvimTmuxNavigateDown, { silent = true })
        vim.keymap.set("n", "<C-k>", tmux_nav.NvimTmuxNavigateUp, { silent = true })
        vim.keymap.set("n", "<C-l>", tmux_nav.NvimTmuxNavigateRight, { silent = true })
    end,
}
