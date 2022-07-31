local status_nvim_tree, nvim_tree = pcall(require, "nvim-tree")
if not status_nvim_tree then
  vim.notify("Couldn't load nvim-tree" .. nvim_tree, "error")
  return
end

nvim_tree.setup {

  renderer = {
    icons = {
      glyphs = {
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },

  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },

  git = {
    enable = true,
  },

}
