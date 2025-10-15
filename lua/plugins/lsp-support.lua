return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "jdtls", "harper_ls", "pyright" },
        handlers = {
          function(server)
            require("lspconfig")[server].setup {
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }
          end,
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Global LSP keymaps
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local config = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
      }
      require("jdtls").start_or_attach(config)
    end,
  },
}

