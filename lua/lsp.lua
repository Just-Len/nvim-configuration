local capabilities = require("cmp_nvim_lsp").default_capabilities()
local mason_root = require("mason.settings").current.install_root_dir

require("mason-lspconfig").setup({
  ensure_installed = { "jdtls", "rust_analyzer", "clangd" }
})

local lombok_jar = vim.fs.joinpath(mason_root, "packages", "jdtls", "lombok.jar")

local jdtls_cmd = { "jdtls" }
if vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(jdtls_cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
end

vim.lsp.config("jdtls", {
  cmd = jdtls_cmd,

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
        "--jvm-arg=-javaagent:" .. lombok_jar,
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
