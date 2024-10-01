-- nvim-cmp config

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

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
