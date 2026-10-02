local M = {}

local SESSION_FILE = vim.fn.stdpath("state") .. "/session.vim"

local function is_restorable(bufnr)
  if vim.bo[bufnr].buftype ~= "" then return false end
  if not vim.api.nvim_buf_is_loaded(bufnr) then return false end
  if vim.bo[bufnr].buflisted == false then return false end
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then return false end
  if not vim.uv.fs_stat(name) then return false end
  return true
end

function M.save()
  local bufs = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if is_restorable(bufnr) then
      bufs[#bufs + 1] = vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufnr))
    end
  end

  local cwd = vim.fn.getcwd()
  vim.fn.mkdir(vim.fn.stdpath("state"), "p")

  local lines = {
    "let g:loaded_nvim_session = 1",
    "cd " .. vim.fn.fnameescape(cwd),
    "silent edit! " .. table.concat(bufs, " | edit! "),
  }
  if #bufs == 0 then lines[3] = "enew" end

  vim.fn.writefile(lines, SESSION_FILE)
end

function M.load()
  if vim.fn.filereadable(SESSION_FILE) == 0 then return end

  local current = vim.api.nvim_buf_get_name(0)
  if current ~= "" and not vim.g.skip_session_load then
    return
  end

  vim.cmd("source " .. vim.fn.fnameescape(SESSION_FILE))
end

function M.clear()
  if vim.fn.filereadable(SESSION_FILE) == 1 then vim.fn.delete(SESSION_FILE) end
end

vim.api.nvim_create_user_command("SessionSave", M.save, { desc = "Guarda la sesion actual" })
vim.api.nvim_create_user_command("SessionLoad", M.load, { desc = "Recupera la sesion guardada" })
vim.api.nvim_create_user_command("SessionClear", M.clear, { desc = "Borra la sesion guardada" })

vim.api.nvim_create_augroup("SessionPersistence", { clear = true })
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = "SessionPersistence",
  callback = function() pcall(M.save) end,
})

return M
