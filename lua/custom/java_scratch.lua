local M = {}

local MAVEN_POM = [[
<project xmlns="http://maven.apache.org/POM/4.0.0">
  <modelVersion>4.0.0</modelVersion>
  <groupId>scratch</groupId>
  <artifactId>java-scratch</artifactId>
  <version>1.0</version>
  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
  </properties>
</project>
]]

local function project_dir()
  return vim.fn.stdpath("cache") .. "/java-scratch"
end

local function source_dir()
  return project_dir() .. "/src/main/java"
end

--- Crea el mini proyecto Maven una sola vez.
--- jdtls solo da autocompletado/semantica a archivos que pertenecen a un
--- proyecto; sin pom.xml el scratch seria un "non-project file" (solo errores
--- de sintaxis).
local function ensure_project()
  vim.fn.mkdir(source_dir(), "p")
  local pom = project_dir() .. "/pom.xml"
  if vim.fn.filereadable(pom) == 0 then
    vim.fn.writefile(vim.split(MAVEN_POM, "\n"), pom)
  end
end

local function valid_ident(s)
  return type(s) == "string" and s:match("^%u[%w_]*$") ~= nil
end

--- :JavaScratch            -> Scratch.java
--- :JavaScratch Perro      -> Perro.java
function M.create(opts)
  local name = type(opts) == "table" and vim.trim(opts.args or "") or tostring(opts or "")
  name = valid_ident(name) and name or "Scratch"

  ensure_project()

  local file = ("%s/%s.java"):format(source_dir(), name)
  if vim.fn.filereadable(file) == 0 then
    vim.fn.writefile({
      "public class " .. name .. " {",
      "    public static void main(String[] args) {",
      "",
      "    }",
      "}",
    }, file)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(file))

  vim.bo.filetype = "java"
  vim.bo.bufhidden = "wipe"

  -- jdtls necesita un workspace estatico: si el buffer cambia de directorio
  -- el cliente se reinicia y pierde la indexacion.
  vim.cmd("cd " .. vim.fn.fnameescape(project_dir()))

  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = 0,
    once = true,
    callback = function()
      if vim.fn.filereadable(file) == 1 then
        vim.fn.delete(file)
      end
    end,
  })
end

vim.api.nvim_create_user_command("JavaScratch", M.create, {
  nargs = "?",
  complete = function()
    local names = {}
    for _, f in ipairs(vim.fn.glob(source_dir() .. "/*.java", false, true)) do
      names[#names + 1] = vim.fn.fnamemodify(f, ":t:r")
    end
    return names
  end,
  desc = "Abre (o crea) un archivo Java scratch con LSP completo",
})

return M
