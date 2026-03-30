return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        delay = 300,
        spec = {
            {
                mode = { "n", "x" },
                { "<leader>a", group = "ai/harpoon" },
                { "<leader>c", group = "code" },
                { "<leader>f", group = "file/find" },
                { "<leader>g", group = "git" },
                { "<leader>x", group = "diagnostics/quickfix" },
                { "<leader>b", group = "buffer", expand = function() return require("which-key.extras").expand.buf() end },
                { "<leader>w", proxy = "<c-w>", group = "windows", expand = function() return require("which-key.extras").expand.win() end },
                { "[", group = "prev" },
                { "]", group = "next" },
                { "g", group = "goto" },
                { "z", group = "fold" },
            },
        },
    },
}
