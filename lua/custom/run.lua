local M = {}

local MARKERS = {
  "Cargo.toml",
  "pom.xml",
  "build.gradle",
  "CMakeLists.txt",
  "Makefile",
  "makefile",
  "GNUmakefile",
}

local function cwd()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" then
    return vim.fn.fnamemodify(file, ":p:h")
  end
  return vim.fn.getcwd()
end

local function root()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return vim.fn.getcwd()
  end
  return vim.fs.root(file, MARKERS) or cwd()
end

local run_term

local function sh(cmd)
  local Terminal = require("toggleterm.terminal").Terminal
  if not run_term or (run_term.bufnr and not vim.api.nvim_buf_is_valid(run_term.bufnr)) then
    run_term = Terminal:new({ hidden = true })
  end
  if run_term:is_open() then
    run_term:send(cmd)
  else
    run_term:open()
    run_term:send(cmd)
  end
end

function M.java_main_class()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local package, class

  for _, line in ipairs(lines) do
    if not package then
      local pkg = line:match("^%s*package%s+([%w_.]+)%s*;")
      if pkg then package = pkg end
    end
    if not class then
      local name = line:match("public%s+class%s+([%w_]+)")
      if name then class = name end
    end
    if package and class then break end
  end

  if not class then
    local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
    if fname ~= "" then class = fname end
  end

  if not class then return nil end
  return package and (package .. "." .. class) or class
end
function M.java_run()
  local main = M.java_main_class()
  if not main then
    vim.notify("No encontre una clase con 'public static void main'", vim.log.levels.ERROR)
    return
  end

  local r = root()
  local dir, files
  if vim.fn.isdirectory(r .. "/src") == 1 then
    dir, files = r, "$(find src -name '*.java')"
  else
    -- proyecto sin layout Maven/Gradle: compila desde el directorio del paquete
    dir, files = cwd(), "$(find . -name '*.java')"
  end

  local cmd = ('cd %s && OUT=$(mktemp -d) && javac -d "$OUT" %s && java -cp "$OUT" %s')
    :format(vim.fn.shellescape(dir), files, main)
  sh(cmd)
  vim.notify("Ejecutando " .. main)
end

function M.java_test()
  local r = root()
  local cmd
  if vim.fn.filereadable(r .. "/mvnw") == 1 then
    cmd = "cd %s && ./mvnw test"
  elseif vim.fn.filereadable(r .. "/gradlew") == 1 then
    cmd = "cd %s && ./gradlew test"
  elseif vim.fn.filereadable(r .. "/pom.xml") == 1 then
    cmd = "cd %s && mvn test"
  else
    vim.notify("No encuentro pom.xml, build.gradle ni ./mvnw", vim.log.levels.ERROR)
    return
  end
  sh(cmd:format(vim.fn.shellescape(r)))
end

function M.java_format()
  sh("cd " .. vim.fn.shellescape(root()) .. " && ./mvnw spotless:apply 2>/dev/null || echo 'sin spotless, usa ESPACIO f'")
end

function M.cargo_run() sh("cd " .. vim.fn.shellescape(root()) .. " && cargo run") end
function M.cargo_test() sh("cd " .. vim.fn.shellescape(root()) .. " && cargo test") end
function M.cargo_check() sh("cd " .. vim.fn.shellescape(root()) .. " && cargo check") end
function M.cargo_clippy() sh("cd " .. vim.fn.shellescape(root()) .. " && cargo clippy") end

function M.c_build()
  local r = root()
  local cmd
  if vim.fn.filereadable(r .. "/compile_commands.json") == 1 then
    cmd = "cd %s && ninja 2>/dev/null || make"
  elseif vim.fn.filereadable(r .. "/CMakeLists.txt") == 1 then
    cmd = "cd %s && cmake --build build --target clean all 2>/dev/null || (mkdir -p build && cd build && cmake .. && make)"
  elseif vim.fn.filereadable(r .. "/Makefile") == 1 then
    cmd = "cd %s && make"
  else
    vim.notify("No encuentro Makefile, CMakeLists.txt ni compile_commands.json", vim.log.levels.ERROR)
    return
  end
  sh(cmd:format(vim.fn.shellescape(r)))
end

local commands = {
  { "JavaRun", M.java_run, "Compila y ejecuta el main detectado" },
  { "JavaTest", M.java_test, "Corre los tests del proyecto Java" },
  { "JavaFormat", M.java_format, "Aplica el formateador del proyecto Java" },
  { "CargoRun", M.cargo_run, "cargo run" },
  { "CargoTest", M.cargo_test, "cargo test" },
  { "CargoCheck", M.cargo_check, "cargo check" },
  { "CargoClippy", M.cargo_clippy, "cargo clippy" },
  { "CBuild", M.c_build, "Compila el proyecto C/C++" },
}

for _, spec in ipairs(commands) do
  vim.api.nvim_create_user_command(spec[1], function() spec[2]() end, {
    nargs = 0,
    desc = spec[3],
  })
end

return M
