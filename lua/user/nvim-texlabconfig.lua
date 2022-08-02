-- During the installation of this plugin it's required to compile
-- an executable using go (go programming language), so you need
-- go installed on your system.
--
-- On my mac I installed go using homebrew:
--   brew install golang
--
-- Then I create a go dir in $HOME to store all go related file:
--   mkdir -p $HOME/go/{bin,src,pkg}
--
-- And finally add these variable to my .zshrc
--   export GOPATH=$HOME/go
--   export GOROOT="$(brew --prefix golang)/libexec"
--   export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
--
-- To be precise I replace $(brew --prefix golang) with its evaluation
-- because brew it's pretty slow and terminal startup time was
-- sky rocketing.
--
-- With this configuration you should have the command `nvim-texlabconfig`
-- available in your terminal.
--
-- Then you have to tell to your pdf viewer how to perform backward search
-- In Skim → Preferences → Sync → PDF-TeX Sync support
--   Preset: Custom
--   Command: nvim-texlabconfig
--   Arguments: -file '%file' -line %line

local status_texlabconfig, texlabconfig = pcall(require, "texlabconfig")
if not status_texlabconfig then
  vim.notify("Couldn't load texlabconfig" .. texlabconfig, "error")
  return
end

local config = {
  cache_activate = true,
  cache_filetypes = { 'tex', 'bib' },
  cache_root = vim.fn.stdpath('cache'),
  reverse_search_edit_cmd = 'edit',
  file_permission_mode = 438,
}

texlabconfig.setup(config)
