local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup({
  ensure_installed = { "jdtls", "rust_analyzer", "clangd" }
})


vim.lsp.config("jdtls", {
  cmd = {
    "jdtls",
    "--jvm-arg=-javaagent:/home/len/.local/share/nvim/mason/share/jdtls/lombok.jar",

  },

  capabilities = capabilities,

  settings = {
    java = {
      signatureHelp = {
        enabled = true,
      },
    },
  },
})

--[[
vim.lsp.config("jdtls", {
  install = {
    cmd = {
      "jdtls",
      "--jvm-arg=-javaagent:/home/len/.local/share/nvim/mason/share/jdtls/lombok.jar",
    },
  },
  options = {
    capabilities = capabilities,
    settings = {
      java = { signatureHelp = { enabled = true } }
    },
  },
})
]]
vim.lsp.config("rust_analyzer", {
  options = {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
      },
    },
  },
})

vim.lsp.config("clangd", {
capabilities = capabilities,
})

vim.lsp.enable("jdtls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")
