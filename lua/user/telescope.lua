local status_telescope, telescope = pcall(require, "telescope")
if not status_telescope then
  return
end

-- if available use fzy_native: this improve sorting performance 
local status_fzy_native, _ = pcall(require, "telescope-fzy-native")
if status_fzy_native then
  telescope.load_extension('fzy_native')
end
