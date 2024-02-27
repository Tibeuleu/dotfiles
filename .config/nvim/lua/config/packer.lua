return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        -- or branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use "ellisonleao/gruvbox.nvim"

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use 'nvim-treesitter/playground'
    use {
        'ThePrimeagen/harpoon',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    use 'lukas-reineke/indent-blankline.nvim'

    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'numToStr/Comment.nvim'

    use 'lervag/vimtex'

    use {
        'neovim/nvim-lspconfig',
        requires = {
            -- LSP Support
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-cmdline'},
            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'saadparwaiz1/cmp_luasnip'},
            {'rafamadriz/friendly-snippets'},
            {'onsails/lspkind.nvim'},
            -- Utils
            {'j-hui/fidget.nvim'},
            {'folke/neodev.nvim'}
        }
    }

end)
