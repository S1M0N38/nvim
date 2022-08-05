local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_packer, packer = pcall(require, "packer")
if not status_packer then
  vim.notify("Couldn't load packer" .. packer, "error")
  return
end

-- My plugins here
local plugins = function(use)
  -- Linking plugins to specific commit make them resistent to breaking changes

  -- -- Have packer manage itself
  use { "wbthomason/packer.nvim", commit = "de109156cfa634ce0256ea4b6a7c32f9186e2f10" }

  -- -- Useful lua functions used by lots of plugins
  use { "nvim-lua/plenary.nvim", commit = "986ad71ae930c7d96e812734540511b4ca838aa2" }

  -- -- Optimization: improve neovim startup time
  use { "lewis6991/impatient.nvim", commit = "2aa872de40dbbebe8e2d3a0b8c5651b81fe8b235" }

  -- -- Colorschemes
  use { "ellisonleao/gruvbox.nvim", commit = "29c50f1327d9d84436e484aac362d2fa6bca590b" }

  -- -- File Navigation: tree and fuzzy finder
  use { "kyazdani42/nvim-tree.lua", commit = "665813b9e6e247c633346b861e08f03e44e3ac91" } -- tree navigation
  use { "nvim-telescope/telescope.nvim", commit = "b5833a682c511885887373aad76272ad70f7b3c2" } -- fuzzy finder
  use { "nvim-telescope/telescope-fzy-native.nvim", commit = "7b3d2528102f858036627a68821ccf5fc1d78ce4" } -- improve sorting speed
  use {
    'mrjones2014/dash.nvim',
    commit = "f7402d1d96b126f8c678bd1d1d0102213c148eac",
    run = 'make install',
  }

  -- -- Completions plugins (cmp)
  use { "hrsh7th/nvim-cmp", commit = "706371f1300e7c0acb98b346f80dad2dd9b5f679" } -- The completion plugin
  use { "hrsh7th/cmp-buffer", commit = "62fc67a2b0205136bc3e312664624ba2ab4a9323" } -- buffer completions
  use { "hrsh7th/cmp-path", commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1" } -- path completions
  use { "hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" } -- lsp completions
  use { "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" } -- neovim's Lua runtime API
  use { "saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" } -- snippet completions

  -- -- Snippets
  use { "L3MON4D3/LuaSnip", commit = "d8cacf83a214b7dd80986a8a24e4adf3fdd4f069" } -- snippet engine
  use { "rafamadriz/friendly-snippets", commit = "1db69684a27eec0b9f520a5d7d95d414fc30ba91" } -- a bunch of snippets to use

  -- -- Langauge Server Protocol (lsp)
  use { "williamboman/mason.nvim", commit = "bf2442eaf6b116321dda12ee73a37c4e733eefb8" } -- lsp and dap installer
  use { "williamboman/mason-lspconfig.nvim", commit = "05e70bc283471d27c905383a02185934a68ab496" } -- autoconfigure lspconfig using mason 
  use { "neovim/nvim-lspconfig", commit = "60f2993b9661d9844cee3bebdbd1b5860577eb3c" } -- lsp configurations

  -- -- TreeSitter (TS)
  -- Avoid fail upon the first installation: https://github.com/nvim-treesitter/nvim-treesitter/issues/3135
  -- Fix is explain here https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
  use {
    "nvim-treesitter/nvim-treesitter",
    commit = "0d7fab0c3323ed2e50ccdf14fd24fbbad664f7b1",
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use { "lewis6991/spellsitter.nvim", commit = "eb74c4b1f4240cf1a7860877423195cec6311bd5" }

  -- Latex - enable backword search
  -- take a look at lua/user/nvim-texlabconfig.lua for installation details
  use { 'f3fora/nvim-texlabconfig',
    commit = "128a4985c096c100b9889c45998487264cc53ec8",
    run = "go build -o $GOPATH/bin/"
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end

-- Install your plugins here
return packer.startup({
  plugins,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
    profile = {
      enable = false,
    },
  },
})
