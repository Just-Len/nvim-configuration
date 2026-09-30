local ok, ts = pcall(require, "nvim-treesitter.configs")
if ok then
  ts.setup({
    ensure_installed = { "java", "lua", "vim", "vimdoc", "rust", "markdown", "markdown_inline" },
    highlight = { enable = true },
  })
end

