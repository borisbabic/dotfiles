-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<Left>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<Down>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<Up>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<Right>", "<C-w>l", { desc = "Go to right window", remap = true })
map("n", "gb", ":bnext<CR>", { desc = "Go to next buffer", remap = true })
map("n", "gB", ":bprev<CR>", { desc = "Go to prev buffer", remap = true })
