-- Yank code block with file path and line numbers
-- Usage: Select text in visual mode and run :YankCode

local M = {}

-- Get the file extension for syntax highlighting
local function get_file_extension(filepath)
  local ext = filepath:match("%.([^%.]+)$")
  if not ext then
    return "txt"
  end

  -- Map common extensions to their syntax highlighting names
  local ext_map = {
    js = "javascript",
    ts = "typescript",
    jsx = "javascript",
    tsx = "typescript",
    py = "python",
    rb = "ruby",
    sh = "bash",
    zsh = "bash",
    fish = "bash",
    yml = "yaml",
    md = "markdown",
    rs = "rust",
    go = "go",
    c = "c",
    cpp = "cpp",
    h = "c",
    hpp = "cpp",
    java = "java",
    kt = "kotlin",
    swift = "swift",
    php = "php",
    html = "html",
    css = "css",
    scss = "scss",
    sass = "sass",
    less = "less",
    vue = "vue",
    svelte = "svelte",
    ex = "elixir",
    exs = "elixir",
    eex = "elixir",
    heex = "elixir",
    lua = "lua",
    vim = "vim",
    json = "json",
    xml = "xml",
    sql = "sql",
    r = "r",
    R = "r",
    jl = "julia",
    scala = "scala",
    clj = "clojure",
    cljs = "clojure",
    hs = "haskell",
    elm = "elm",
    dart = "dart",
    nix = "nix",
  }

  return ext_map[ext] or ext
end

-- Get relative path from current working directory
local function get_relative_path(filepath)
  local cwd = vim.fn.getcwd()
  if filepath:sub(1, #cwd) == cwd then
    local relative = filepath:sub(#cwd + 2) -- +2 to skip the trailing slash
    return relative
  end
  return filepath
end

-- Main function to yank code block
function M.yank_code()
  -- Get visual selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Get current file path
  local filepath = vim.fn.expand("%:p")
  local relative_path = get_relative_path(filepath)

  -- Get selected text
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local selected_text = table.concat(lines, "\n")

  -- Get file extension for syntax highlighting
  local file_ext = get_file_extension(relative_path)

  -- Format the output
  local output = string.format("%s:L%d-L%d\n\n```%s\n%s\n```",
    relative_path,
    start_line,
    end_line,
    file_ext,
    selected_text
  )

  -- Copy to clipboard
  vim.fn.setreg("+", output)
  vim.fn.setreg("*", output) -- Also set the selection register for compatibility

  -- Show notification
  vim.notify(string.format("Yanked %d lines from %s (L%d-L%d)",
    end_line - start_line + 1,
    relative_path,
    start_line,
    end_line),
    vim.log.levels.INFO
  )
end

-- Create the command
vim.api.nvim_create_user_command("YankCode", function()
  M.yank_code()
end, {
  desc = "Yank selected code block with file path and line numbers",
  range = true, -- Allow range selection
})

return M
