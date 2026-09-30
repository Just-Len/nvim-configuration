local M = {}

function M.create()
    local file = vim.fn.tempname() .. ".java"

    local content = {
        "public class Scratch {",
        "    public static void main(String[] args) {",
        "",
        "    }",
        "}",
    }

    vim.fn.writefile(content, file)

    vim.cmd("edit " .. vim.fn.fnameescape(file))

    vim.bo.filetype = "java"
    vim.bo.bufhidden = "wipe"

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

vim.api.nvim_create_user_command("JavaScratch", M.create, {})

return M
