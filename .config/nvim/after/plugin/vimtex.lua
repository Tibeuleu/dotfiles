vim.g.vimtex_view_general_viewer = "zathura"
vim.g.vimtex_view_method = "zathura_simple"
vim.g.vimtex_view_automatic = 0
-- vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
-- vim.g.vimtex_view_zathura_options = "-reuse-instance file:@pdf\\#src:@line:@col@tex"

vim.g.vimtex_compiler_latexmk = {
    options = {
      "-verbose",
      "-file-line-error",
      "-synctex=1",
      "-interaction=nonstopmode",
      "-shell-escape",
    }
}

vim.g.vimtex_toc_config = {
    show_help = 0,
    layer_status = {
        content = 1,
        label = 0,
        todo = 1,
        include = 0
    }
}

vim.g.vimtex_quickfix_ignore_filters = {
    "Underfull \\\\hbox",
    "Overfull \\\\hbox",
    -- "LaTeX Warning: .\\+ float specifier changed to",
    -- "LaTeX hooks Warning",
    -- "Package hyperref Warning: Token not allowed in a PDF string",
}

vim.g.vimtex_quickfix_mode = 2

vim.g.vimtex_fold_enabled = 0
vim.g.vimtex_fold_manual = 1
