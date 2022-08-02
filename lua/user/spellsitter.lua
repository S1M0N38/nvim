local status_spellsitter, spellsitter = pcall(require, "spellsitter")
if not status_spellsitter then
  vim.notify("Couldn't load nvim-treesitter.configs" .. spellsitter, "error")
	return
end

spellsitter.setup()
