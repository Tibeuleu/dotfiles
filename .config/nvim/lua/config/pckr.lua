local function bootstrap_pckr()
    local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

    if not (vim.uv or vim.loop).fs_stat(pckr_path) then
        vim.fn.system({
            'git',
            'clone',
            "--filter=blob:none",
            'https://github.com/lewis6991/pckr.nvim',
            pckr_path
        })
    end

    vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add {
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },
    "ellisonleao/gruvbox.nvim",
    {
        'nvim-treesitter/nvim-treesitter',
        branch = "main",
        build = ':TSUpdate'
    },
    {
        'ThePrimeagen/harpoon',
        requires = { { 'nvim-lua/plenary.nvim' } }
    },
    'mbbill/undotree',
    'tpope/vim-fugitive',
    'airblade/vim-gitgutter',
    'lukas-reineke/indent-blankline.nvim',
    'JoosepAlviste/nvim-ts-context-commentstring',
    {
        'nvim-mini/mini.comment',
        branch = "main",
        config = function()
            require('mini.comment').setup()
        end,
    },
    'lervag/vimtex',
    {
        'neovim/nvim-lspconfig',
        requires = {
            -- LSP Support
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            -- DAP Support
            { 'mfussenegger/nvim-dap' },
            { 'mfussenegger/nvim-dap-python' },
            { 'jay-babu/mason-nvim-dap.nvim' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            -- Snippets
            {
                'L3MON4D3/LuaSnip',
                run = "make install_jsregexp",
            },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },
            { 'onsails/lspkind.nvim' },
            -- Utils
            { 'j-hui/fidget.nvim' },
            { 'folke/neodev.nvim' }
        },
    },
}
