require("ts_context_commentstring").setup({
    enable_autocmd = false,
})
require('Comment').setup({
    ignore = '^$', -- Ignore empty lines
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

