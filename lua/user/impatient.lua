_G.__luacache_config = {
  chunks = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/luacache_chunks',
  },
  modpaths = {
    enable = false,  -- this must be false otherwise Dash.nvim breaks
    path = vim.fn.stdpath('cache')..'/luacache_modpaths',
  }
}

local status_impatient, impatient = pcall(require, "impatient")
if not status_impatient then
  vim.notify("Couldn't load impatient " .. impatient, "error")
	return
end

-- impatient.enable_profile()
