local map_lsp_keybinds = require('config.remap').map_lsp_keybinds -- Has to load keymaps before pluginslsp

-- Use neodev to configure lua_ls in nvim directories - must load before lspconfig
require("neodev").setup()

require("fidget").setup({
    notification = {
        redirect =  -- Conditionally redirect notifications to another backend
        function(msg, level, opts)
            if opts and opts.on_open then
                return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
            end
        end,
    },
})

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {'bashls', 'clangd', 'marksman', 'pylsp', 'ruff', 'texlab'},
})
require('mason-nvim-dap').setup({
    ensure_installed = {'bash', 'cppdbg', 'python'},
})
require('dap-python').setup("python")

local servers = {
    bashls = {},
    clangd = {},
    marksman = {},
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    -- I don't want pylsp linter/formatter
                    autopep8 = { enabled = false, },
                    flake8 = { enabled = false, },
                    mccabe = { enabled = false, },
                    pycodestyle = { enabled = false, },
                    pyflakes = { enabled = false, },
                    pylint = { enabled = false, },
                    yapf = { enabled = false, },
                },
            },
        },
    },
    ruff = {
        filetypes = { "python" },
        init_options = {
            settings = {
                -- configuration = "<path_to_custom_ruff_toml>",  -- Custom config for ruff to use
                exclude = { "__about__.py" },  -- Files to be excluded by ruff checking
                lineLength = 160,  -- Line length to pass to ruff checking and formatting
                organizeImports = true,
                preview = false,  -- Whether to enable the preview style linting and formatting.
                lint = {
                    enable = true,  -- Enable linting
                    -- select = { "F" },  -- Rules to be enabled by ruff
                    extendSelect = { "F", "I" },  -- Rules that are additionally used by ruff
                    ignore = { "D210", "E741", "E743" },  -- Rules to be ignored by ruff
                    extendIgnore = { "C90" },  -- Rules that are additionally ignored by ruff
                },
            },
        },
    },
    texlab = {},
}

-- Default handlers for LSP
local default_handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", focus = false }),
}

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local default_capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local on_attach = function(_client, buffer_number)
    -- Pass the current buffer to map lsp keybinds
    map_lsp_keybinds(buffer_number)

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(buffer_number, "Format", function(_)
        vim.lsp.buf.format({
            filter = function(format_client)
                -- Use Prettier to format TS/JS if it's available
                return format_client.name ~= "tsserver" or not null_ls.is_registered("prettier")
            end,
        })
    end, { desc = "LSP: Format current buffer with LSP" })
end

-- Iterate over our servers and set them up
for name, config in pairs(servers) do
    require("lspconfig")[name].setup({
        capabilities = default_capabilities,
        filetypes = config.filetypes,
        handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
        on_attach = on_attach,
        settings = config.settings,
        init_options = config.init_options,
    })
end

vim.diagnostic.config({
    -- update_in_insert = true,
    signs = false,
    virtual_text = true,
    underline = false,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

-- Autoformat on save
local fmt_group = vim.api.nvim_create_augroup('autoformat_cmds', {clear = true})

local function setup_autoformat(event)
  local id = vim.tbl_get(event, 'data', 'client_id')
  local client = id and vim.lsp.get_client_by_id(id)
  if client == nil then
    return
  end

  vim.api.nvim_clear_autocmds({group = fmt_group, buffer = event.buf})

  local buf_format = function(e)
    vim.lsp.buf.format({
      bufnr = e.buf,
      async = false,
      timeout_ms = 10000,
    })
  end

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = event.buf,
    group = fmt_group,
    desc = 'Format current buffer',
    callback = buf_format,
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Setup format on save',
  callback = setup_autoformat,
})

-- Enable inlay hints
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable inlay hints',
  callback = function(event)
    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)
    if client == nil or not client.supports_method('textDocument/inlayHint') then
      return
    end

    vim.lsp.inlay_hint.enable(true, {bufnr = event.buf})
  end,
})
