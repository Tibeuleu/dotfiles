-- Square cursor
vim.opt.guicursor = ""

-- Enable relative line number
vim.opt.nu = true
vim.opt.relativenumber = true

-- Set tabs to 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Enable auto indent and set it to 4 spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 4

-- Disable text wrap
vim.opt.wrap = true

-- Enable persistent undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.opt.undofile = true

-- Set better splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Better search options
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Decrease uptade time
vim.opt.updatetime = 50

-- Remove trailing white spaces
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    group = vim.api.nvim_create_augroup("remove_trailing_spaces", { clear = true }),
    pattern = "*",
    desc = "Remove trailing white spaces",
    command = [[%s/\s\+$//e]],
})

-- Restore cursor position
vim.api.nvim_create_autocmd({"BufReadPost"}, {
    group = vim.api.nvim_create_augroup("restore_cursor_pos", { clear = true}),
    pattern = "*",
    desc = "Restore cursor position",
    callback = function()
        vim.cmd('silent! normal! g`"zv')
    end,
})

-- Open help panel in a vsplit to the left
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("vertical_help", { clear = true }),
	pattern = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
})

-- Highlight yankzone
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true}),
    pattern = '*',
    desc = "Highlight selection on yank",
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 200,
            visual = true,
        })
    end,
})

