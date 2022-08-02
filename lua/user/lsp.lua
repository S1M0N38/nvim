require "user.keymaps" -- import LSP_KEYMAPS

local status_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig then
  vim.notify("Couldn't load lspconfig" .. lspconfig, "error")
  return
end

local status_mason, mason = pcall(require, "mason")
if not status_mason then
  vim.notify("Couldn't load mason" .. mason, "error")
  return
end

local status_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_mason_lspconfig then
  vim.notify("Couldn't load mason-lspconfig" .. mason_lspconfig, "error")
  return
end

local status_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_nvim_lsp then
  vim.notify("Couldn't load cmp_nvim_lsp" .. cmp_nvim_lsp, "error")
  return
end

-- diagnostic setup
local function setup()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

-- make capabilities and pass them to cmp_nvim_lsp
local capabilities
capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local opts = {
  on_attach = function(_, bufnr) LSP_KEYMAPS(bufnr) end,
  capabilities = capabilities,
}

mason.setup()
mason_lspconfig.setup()
mason_lspconfig.setup_handlers({

  function(server_name) -- default handler
    lspconfig[server_name].setup(opts)
  end,

  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup({
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,

      settings = {
        Lua = {
          -- Tells Lua that a global variable named vim exists
          -- to not have warnings when configuring neovim
          diagnostics = {
            globals = { "vim" },
          },

          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,

  ['texlab'] = function()
    lspconfig.texlab.setup({
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,

      settings = {
        texlab = {
          rootDirectory = nil,
          build = {
            executable = "tectonic",

            -- compile: compile a single .tex into a pdf
            args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },

            -- build: search for Tectonic.toml in the current or in the parents directory and
            --   compile the whole project based on toml configuration. At the moment tectonic
            --   does not produce SyncTeX data when using built (keep and eye on this issue
            --   https://github.com/tectonic-typesetting/tectonic/issues/889). I consider
            --   forward search pretty important, so I plan to use `tectonic build` only
            --   when synctex will be supported.
            -- args = { "-X", "build", "--keep-intermediates", "--keep-logs" },

            onSave = true,
          },

          -- only working with "tectonic -X compile"
          -- Keep an eye on https://github.com/tectonic-typesetting/tectonic/issues/889
          -- maybe Synctex will be added to "tectonic -X built"
          forwardSearch = {
            executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
            args = { "-g", "%l", "%p", "%f" }
          },
        },
      },
    })
  end,

  -- TODO add specific handlers for different languages
})

setup()
