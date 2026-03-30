return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "go", "gomod", "gosum", "gowork",
            "typescript", "tsx", "javascript", "python",
            "html", "css",
            "lua", "vim", "vimdoc", "query",
            "json", "yaml", "toml", "markdown",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
    },
}
