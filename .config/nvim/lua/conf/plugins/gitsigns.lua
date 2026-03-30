return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "-" },
            changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local map = vim.keymap.set
            local opts = { buffer = bufnr, silent = true }

            map("n", "]g", gs.next_hunk, opts)
            map("n", "[g", gs.prev_hunk, opts)
            map("n", "<leader>gp", gs.preview_hunk, opts)
            map("n", "<leader>gb", gs.blame_line, opts)
        end,
    },
}
