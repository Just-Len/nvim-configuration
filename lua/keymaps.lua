local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

vim.keymap.set("n", "<leader>j", function()
  vim.cmd("ToggleTerm")
  vim.cmd("term javac -d out $(find src -name '*.java') && java -cp out com.app.Main")
end)


--[[
--
-- Java non-usefull term
--
vim.keymap.set("n", "<leader>s", function()
    vim.cmd("ToggleTerm")
  vim.cmd("term ./mvnw spring-boot:run")
end)
]]

vim.keymap.set("n", "<leader>s", function()
  vim.fn.system('kitty bash -c "./mvnw spring-boot:run; exec bash" &')
end, { desc = "Better spring execution using kitty" })


vim.keymap.set("n", "<leader>R", function()
  vim.cmd("ToggleTerm")
  vim.cmd("term cargo run")
end)

vim.keymap.set("n", "<leader>g", vim.lsp.buf.code_action)

-- Rename values (07/04/2026)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

-- Navegacion LSP (estos si faltaban; Neovim ya pone gra/grn/grr/gri por defecto)
-- gd sin leader es la convencion de LSP y no choca con nada
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Ir a la definicion" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Ir a la definicion" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Ver referencias" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Ir a la implementacion" })

-- K: hover si hay LSP, y si no vuelve al keywordprg original
vim.keymap.set("n", "K", function()
  if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
    vim.lsp.buf.hover()
  else
    vim.cmd("normal! K")
  end
end, { desc = "Documentacion (hover)" })

-- Formatear bajo demanda (el automatico lo hace conform al guardar)
vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Formatear buffer" })

vim.keymap.set('n', '<leader>q', function()
  local winid = vim.fn.getloclist(0, { winid = 0 }).winid
  if winid ~= 0 then
    vim.cmd("lclose")
  else
    if #vim.diagnostic.get(0) > 0 then
      vim.diagnostic.setloclist({ open = true })
    else
      print("No errors here :D")
    end
  end
end)

vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
vim.keymap.set("n", "<leader>fb", telescope.buffers, {})

-- Mas telescope: busqueda por categoria
vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "Buscar atajos" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Buscar en la ayuda" })
vim.keymap.set("n", "<leader>fs", telescope.lsp_document_symbols, { desc = "Simbolos del archivo" })
vim.keymap.set("n", "<leader>fw", telescope.lsp_workspace_symbols, { desc = "Simbolos del proyecto" })
vim.keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "Todos los errores" })
vim.keymap.set("n", "<leader>fc", telescope.colorscheme, { desc = "Cambiar tema" })
vim.keymap.set("n", "<leader>fp", telescope.builtin, { desc = "Todos los pickers" })

-- Git (telescope ya traia los pickers, solo faltaban los atajos)
vim.keymap.set("n", "<leader>gs", telescope.git_status, { desc = "git status interactivo" })
vim.keymap.set("n", "<leader>gc", telescope.git_commits, { desc = "Historial de commits" })
vim.keymap.set("n", "<leader>gb", telescope.git_branches, { desc = "Ramas" })
vim.keymap.set("n", "<leader>gl", telescope.git_stash, { desc = "Stashes" })

-- Archivos
vim.keymap.set("n", "<leader>wd", function() vim.cmd("Mkdir") end, { desc = "Crear directorio" })
vim.keymap.set("n", "<leader>wr", function() vim.cmd("Rename") end, { desc = "Renombrar archivo" })
vim.keymap.set("n", "<leader>wy", function() vim.cmd("Duplicate") end, { desc = "Duplicar archivo" })
vim.keymap.set("n", "<leader>wc", function() vim.cmd("Cd") end, { desc = "cd al directorio del archivo" })

-- Ejecucion por lenguaje
-- ESPACIO R = cargo run (tecla sola, sin prefijo para que no espere)
vim.keymap.set("n", "<leader>rt", function() vim.cmd("CargoTest") end, { desc = "cargo test" })
vim.keymap.set("n", "<leader>rc", function() vim.cmd("CargoCheck") end, { desc = "cargo check" })
vim.keymap.set("n", "<leader>rl", function() vim.cmd("CargoClippy") end, { desc = "cargo clippy" })
vim.keymap.set("n", "<leader>jt", function() vim.cmd("JavaTest") end, { desc = "Tests de Java" })
vim.keymap.set("n", "<leader>jf", function() vim.cmd("JavaFormat") end, { desc = "Formatear proyecto Java" })
vim.keymap.set("n", "<leader>cb", function() vim.cmd("CBuild") end, { desc = "Compilar proyecto C/C++" })
vim.keymap.set("n", "<leader>js", function() vim.cmd("JavaScratch") end, { desc = "Java scratch" })

