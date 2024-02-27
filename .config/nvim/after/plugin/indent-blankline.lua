vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#d79921", bg = "none"})

require("ibl").setup({
    indent = { char = " "},
    whitespace = { },
    scope = { char = "▎",
        highlight = "IndentBlanklineContextChar",
        show_start = false,
        show_end = false,
        include = { node_type = { python = { "if_statement",
                                            "for_statement",
                                            "with_statement", } } },
    },
})
