vim.g.vimtex_context_pdf_viewer = "zathura"
vim.g.vimtex_view_general_viewer = "zathura"
vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"

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

vim.g.vimtex_log_ignore = {
    "Underfull \\\\hbox",
    "Overfull \\\\hbox",
    -- "LaTeX Warning: .\\+ float specifier changed to",
    -- "LaTeX hooks Warning",
    -- 'Package siunitx Warning: Detected the "physics" package:',
    -- "Package hyperref Warning: Token not allowed in a PDF string",
    -- "Compilation completed",
}

vim.g.vimtex_quickfix_mode = 0

-- vim.g.vimtex_fold_enabled = 1
-- vim.g.vimtex_fold_manual = 1
