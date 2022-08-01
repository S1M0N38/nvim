require "user.keymaps" -- import TS_KEYMAPS

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify("Couldn't load nvim-treesitter.configs" .. configs, "error")
  return
end

configs.setup({

  ensure_installed = { "lua", "python" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    -- keymaps = TS_KEYMAPS,
  },

  indent = {
    enable = true
  },

  -- autopairs = {
  --   enable = true,
  -- },

})

-- Bug for packer.nvim users https://github.com/nvim-treesitter/nvim-treesitter/issues/1469
-- workaround: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  end
})
