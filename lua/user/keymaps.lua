-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",


-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows (resize also works dragging borders with mouse)
keymap("n", "<C-Up>", ":resize -1<CR>", opts)
keymap("n", "<C-Down>", ":resize +1<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -1<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +1<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)


-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)


-- Visual Block --
-- Move text up and down
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)


-- Plugins --

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- lsp
-- keymaps for lsp must be define inside a function so the can
-- be attached to a specific buffer using on_attach in user.lsp
function LSP_KEYMAPS(bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
  keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)
  keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", bufopts)
  keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", bufopts)
  keymap("n", "<leader>li", "<cmd>LspInfo<cr>", bufopts)
  keymap("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", bufopts)
  keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", bufopts)
  keymap("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", bufopts)
  keymap("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", bufopts)
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", bufopts)
  keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
  keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", bufopts)
end

-- cmp
-- keymaps for cmp must be define inside a function
-- because the mapping require cmp and luasnip
function CMP_KEYMAPS(cmp, luasnip)
  -- function used in super Tab mapping
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local mapping = {
    -- super Tab (Tab key used for multiple actions):
    -- -- cycle trought completions
    -- -- cycle trought snippets placeholders (TODO)
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    -- same as super Tab but perform actions in reverse
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- scroll inside cmp window
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping.scroll_docs(4),

    -- pop up cmp window without any typing
    ['<C-Space>'] = cmp.mapping.complete(),

    -- abort or confirm completion
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }
  return mapping
end

-- Treesitter
TS_KEYMAPS = {
  init_selection = "gnn",
  node_incremental = "grn",
  scope_incremental = "grc",
  node_decremental = "grm",
}

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

