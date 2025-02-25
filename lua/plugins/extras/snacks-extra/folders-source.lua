local M = {}

M.folders = function(opts)
    local snacks_files_source = require("snacks.picker.source.files")

    return snacks_files_source({
        cmd = {
            cmd = {
                "fd"
            },
            args = {
                "--color",
                "always",
                "--type",
                "directory",
                "--max-depth",
                "4",
            },
        },
        cwd = opts.cwd or vim.fn.getcwd(-1, 0),
        prompt = opts.prompt or "󰥨  Folders❯ ",
    })
end

return M
