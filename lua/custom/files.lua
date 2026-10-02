local M = {}

function M.mkdir()
  local name = vim.fn.input("Nuevo directorio: ")
  if name == "" then return end
  local path = vim.fn.expand("%:p:h") .. "/" .. name
  local ok, err = pcall(vim.fn.mkdir, path, "p")
  if not ok then
    vim.notify("No se pudo crear: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  pcall(vim.cmd, "NvimTreeRefresh")
  vim.notify("Directorio creado: " .. path)
end

function M.rename()
  local old = vim.fn.expand("%:p")
  if old == "" then
    vim.notify("No hay archivo abierto", vim.log.levels.WARN)
    return
  end

  local new_name = vim.fn.input("Nuevo nombre: ", vim.fn.fnamemodify(old, ":t"))
  if new_name == "" or new_name == vim.fn.fnamemodify(old, ":t") then return end

  local new = vim.fn.fnamemodify(old, ":h") .. "/" .. new_name
  if vim.fn.filereadable(new) == 1 then
    vim.notify("Ya existe: " .. new, vim.log.levels.ERROR)
    return
  end

  local err = vim.fn.rename(old, new)
  if err ~= 0 then
    vim.notify("No se pudo renombrar: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(new))
  pcall(vim.cmd, "NvimTreeRefresh")
end

function M.duplicate()
  local old = vim.fn.expand("%:p")
  if old == "" then
    vim.notify("No hay archivo abierto", vim.log.levels.WARN)
    return
  end

  local name = vim.fn.input("Copia como: ", vim.fn.fnamemodify(old, ":t:r") .. "-copy." .. vim.fn.fnamemodify(old, ":e"))
  if name == "" then return end

  local new = vim.fn.fnamemodify(old, ":h") .. "/" .. name
  if vim.fn.filereadable(new) == 1 then
    vim.notify("Ya existe: " .. new, vim.log.levels.ERROR)
    return
  end

  vim.fn.writefile(vim.fn.readfile(old), new)
  vim.cmd("edit " .. vim.fn.fnameescape(new))
  pcall(vim.cmd, "NvimTreeRefresh")
end

function M.cd()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then return end
  vim.cmd("cd " .. vim.fn.fnameescape(dir))
  vim.notify("cwd: " .. vim.uv.cwd())
end

vim.api.nvim_create_user_command("Mkdir", M.mkdir, { desc = "Crea un directorio junto al archivo actual" })
vim.api.nvim_create_user_command("Rename", M.rename, { desc = "Renombra el archivo actual" })
vim.api.nvim_create_user_command("Duplicate", M.duplicate, { desc = "Duplica el archivo actual" })
vim.api.nvim_create_user_command("Cd", M.cd, { desc = "cd al directorio del archivo actual" })

return M
