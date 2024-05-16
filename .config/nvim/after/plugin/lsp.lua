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
	ensure_installed = {'bashls', 'clangd', 'fortls', 'julials', 'marksman', 'pylsp', 'rust_analyzer', 'texlab'},
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

local servers = {
    bashls = {},
    clangd = {},
    fortls = {},
    julials = {},
    marksman = {},
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        ignore = {},
                        maxLineLength = 160,
                    },
                    ruff = {
                        enabled = true,  -- Enable the plugin
                        executable = "<path-to-ruff-bin>",  -- Custom path to ruff
                        config = "<path_to_custom_ruff_toml>",  -- Custom config for ruff to use
                        extendSelect = { "I" },  -- Rules that are additionally used by ruff
                        extendIgnore = { "C90" },  -- Rules that are additionally ignored by ruff
                        format = { "I" },  -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
                        severities = { ["D212"] = "I" },  -- Optional table of rules where a custom severity is desired
                        unsafeFixes = false,  -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

                        -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
                        lineLength = 80,  -- Line length to pass to ruff checking and formatting
                        exclude = { "__about__.py" },  -- Files to be excluded by ruff checking
                        select = { "F" },  -- Rules to be enabled by ruff
                        ignore = { "D210" },  -- Rules to be ignored by ruff
                        perFileIgnores = { ["__init__.py"] = "CPY001" },  -- Rules that should be ignored for specific files
                        preview = false,  -- Whether to enable the preview style linting and formatting.
                        targetVersion = "py310",  -- The minimum python version to target (applies for both linting and formatting).
                    },
                },
            },
        },
    },
    rust_analyzer = {},
    texlab = {},
}

-- Default handlers for LSP
local default_handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

-- luasnip for Tab completion
local luasnip = require('luasnip')

cmp.setup({
    -- No preselection
    preselect = 'None',

    sources = {
		{name = 'nvim_lsp'},                    -- lsp
		{name = 'buffer', max_item_count = 5},  -- Text within current buffer
		{name = 'luasnip', max_item_count = 3}, -- Snippets
		{name = 'path', max_item_count = 3},    -- File system paths
	},

    formatting = {
                expandable_indicator = true,
            },

    experimental = {
        ghost_text = true,
    },

    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if #cmp.get_entries() == 1 then
                    cmp.confirm({ select = true })
                else
                    cmp.select_next_item()
                end
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                if #cmp.get_entries() == 1 then
                    cmp.confirm({ select = true })
                else
                    cmp.select_prev_item()
                end
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping.confirm({select = true }),
        ['<C-e>'] = cmp.mapping.abort(),
    },

    snippet = {
        expand = function(args)
            local ls = require("luasnip")
            if not ls then
                return
            end
            ls.lsp_expand(args.body)
        end,
    },

})

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
    })
end

vim.diagnostic.config({
    -- update_in_insert = true,
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
