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


vim.keymap.set("n", "<leader>r", function()
  vim.cmd("ToggleTerm")
  vim.cmd("term cargo run")
end)

vim.keymap.set("n", "<leader>g", vim.lsp.buf.code_action)

-- Rename values (07/04/2026)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

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

