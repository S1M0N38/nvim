-- Using gruvbox colorscheme :
-- -- dark and light version supported 
-- -- syntax highlighting using treesitter

local colorscheme = "gruvbox"
vim.o.background = "dark"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("Couldn't set " .. colorscheme, "error")
  return
end
