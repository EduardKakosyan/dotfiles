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
            lualine_c = { { "filename", path = 1 } },
            lualine_x = {},
            lualine_y = { "location" },
            lualine_z = {},
        },
    },
}
