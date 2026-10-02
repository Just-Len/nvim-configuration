vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.lsp.log.set_level("error")

require("bootstrap")
require("options")
require("plugins")
require("colors")
require("keymaps")
require("autocmds")
require("lsp")
require("mycmp")
require("treesitter")
require("custom.java_scratch")
require("custom.files")
require("custom.session")
require("custom.run")
