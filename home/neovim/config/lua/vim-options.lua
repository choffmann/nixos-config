vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
-- vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 8

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<A-Space>", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim.cmd("nmap <Up>    <Nop>")
-- vim.cmd("nmap <Down>  <Nop>")
-- vim.cmd("nmap <Left>  <Nop>")
-- vim.cmd("nmap <Right> <Nop>")
-- vim.cmd("map $ <Nop>")
-- vim.cmd("map ^ <Nop>")
-- vim.cmd("map { <Nop>")
-- vim.cmd("map } <Nop>")
vim.cmd("noremap K     {")
vim.cmd("noremap J     }")
vim.cmd("noremap H     ^")
vim.cmd("noremap L     $")
vim.cmd("noremap <C-x> :bp<Bar>bd #<Cr>")

vim.cmd("inoremap <C-k> <Up>")
vim.cmd("inoremap <C-j> <Down>")
vim.cmd("inoremap <C-h> <Left>")
vim.cmd("inoremap <C-l> <Right>")

vim.cmd("nmap >> <Nop>")
vim.cmd("nmap << <Nop>")
vim.cmd("vmap >> <Nop>")
vim.cmd("vmap << <Nop>")
vim.cmd("nnoremap <Tab>   >>")
vim.cmd("nnoremap <S-Tab> <<")
vim.cmd("vnoremap <Tab>   >><Esc>gv")
vim.cmd("vnoremap <S-Tab> <<<Esc>gv")

-- vim.cmd("nnoremap <A-j> :m .+1<CR>==")
-- vim.cmd("nnoremap <A-k> :m .-2<CR>==")
-- vim.cmd("vnoremap <A-j> :m '>+1<CR>gv=gv")
-- vim.cmd("vnoremap <A-k> :m '<-2<CR>gv=gv")

vim.cmd("command! W w")
vim.cmd("command! Wa wa")
vim.cmd("command! Wqa wqa")

vim.keymap.set({ "n", "v" }, "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set({ "n", "v" }, "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<A-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set(
    "n",
    "<leader>ee",
    "<cmd>GoIfErr<CR>"
)


vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "[B]uffer [P]revious" })

