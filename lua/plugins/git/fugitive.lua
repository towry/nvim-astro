local V = require("v")
local keymap_cmd = V.keymap_cmd

return {
  "tpope/vim-fugitive",
  dependencies = {},
  keys = {
    {
      "gha",
      "<cmd>Git add %<cr>",
      noremap = true,
      desc = "Git add current buffer",
    },
    {
      "<leader>g1",
      function()
        local res = vim
          .system({
            "git",
            "log",
            "--oneline",
            "--date=relative",
            "--abbrev",
            "--no-color",
            "--pretty=format:%s (%an)",
            "-3",
          }, { text = true })
          :wait()
        if res.code == 0 then
          vim.notify("   \n" .. res.stdout, vim.log.levels.INFO)
        else
          vim.notify(res.stderr, vim.log.levels.ERROR)
        end
      end,
      desc = "Emit HEAD commit info",
    },
    { "<leader>g.", ":Git", desc = "Fugitive start :Git" },
    { "<leader>gm", ":Git merge", desc = "Fugitive start git merge" },
    {
      "<leader>gg",
      ":Git | resize +10<cr>",
      desc = "Fugitive Git",
    },
    {
      "<leader>gG",
      ":tab Git<cr>",
      desc = "Fugitive Git in tab",
    },
    {
      "<leader>ga",
      keymap_cmd([[OverDispatch! git add -- % && git diff --cached --check || echo Conflict founds || exit 1]]),
      desc = "!Git add current",
    },
    {
      "<leader>gdt",
      keymap_cmd([[tab Gdiffsplit]]),
      desc = "Git diff in tab",
    },
    {
      "<leader>gA",
      keymap_cmd([[OverDispatch! git add .]]),
      desc = "!Git add all",
    },
    {
      "<leader>gp",
      keymap_cmd([[exec "OverDispatch! git push --force-with-lease origin " .. FugitiveHead()]]),
      desc = "Git push",
    },
    {
      "<leader>gu",
      function()
        vim.g.escape_cmd = "pclose"
        vim.cmd("OverDispatch git pull --ff origin " .. vim.fn.FugitiveHead())
      end,
      desc = "Git pull",
      silent = false,
    },
    {
      "<leader>gs",
      function()
        vim.cmd([[tab Git diff HEAD]])
        -- vim.cmd([[:lua vim.bo.syntax="diff"]])
      end,
      desc = "Git status with Fugitive on HEAD",
      silent = false,
    },
    {
      "<leader>gl",
      function()
        -- https://github.com/niuiic/git-log.nvim/blob/main/lua/git-log/init.lua
        local file_name = vim.api.nvim_buf_get_name(0)
        local line_range = V.nvim_get_range()
        local cmd = string.format([[vert Git log --max-count=100 -L %s,%s:%s]], line_range[1], line_range[2], file_name)
        vim.print(cmd)
        vim.cmd(cmd)
      end,
      desc = "View log for selected chunks",
      mode = { "v", "x" },
    },
    {
      "<leader>gl",
      function()
        local vcount = vim.v.count
        local max_count_arg = ""
        if vcount ~= 0 and vcount ~= nil and vcount > 0 then max_count_arg = string.format("--max-count=%s", vcount) end
        vim.cmd(
          "vert Git log -P "
            .. max_count_arg
            .. ' --oneline --date=format:"%Y-%m-%d %H:%M" --pretty=format:"%h %ad: %s - %an" -- %'
        )
      end,
      desc = "Git show current file history",
    },
    {
      -- git log with -p for current buffer. with limits for performance.
      "<leader>gL",
      function()
        local vcount = vim.v.count
        local max_count_arg = ""
        if vcount ~= 0 and vcount ~= nil and vcount > 0 then max_count_arg = string.format("--max-count=%s", vcount) end
        vim.cmd(string.format([[Git log %s -p -m --first-parent -P -- %s]], max_count_arg, vim.fn.expand("%")))
      end,
      desc = "Git show current file history with diff",
    },
    {
      "<leader>gd",
      keymap_cmd([[Git diff -- %]]),
      desc = "Diff current file",
    },
    {
      "<leader>gD",
      keymap_cmd([[Git diff -- %]]),
      desc = "Diff current file unified",
    },
    {
      "<leader>gb",
      keymap_cmd([[Git blame -n --date=short --color-lines --show-stats %]]),
      desc = "Git blame current file",
    },
    {
      "<leader>gb",
      function()
        local file_name = vim.api.nvim_buf_get_name(0)
        local line_range = V.nvim_get_range()
        vim.cmd(
          string.format(
            [[Git blame -n --date=short --color-lines -L %s,%s %s]],
            line_range[1],
            line_range[2],
            file_name
          )
        )
      end,
      mode = "x",
      desc = "Git blame current file with range",
    },
    {
      "<leader>gx",
      "<cmd>silent OverDispatch! git add -- % && git diff --cached --check --quiet || git commit --amend --no-edit<cr>",
      desc = "Git amend all",
    },
    {
      "gj",
      function()
        require("plugins.git._git-commit").open(function(prefix)
          if not prefix then return end
          vim.ui.input({
            prompt = prefix,
          }, function(input)
            -- if input is trimmed empty
            if vim.trim(input or "") == "" then
              vim.notify("Empty commit message", vim.log.levels.ERROR)
              return
            end

            input = prefix .. " " .. input

            vim.cmd(string.format('OverDispatch! git commit -m "%s"', input))
          end)
        end)
      end,
      desc = "Git commit",
      noremap = true,
      silent = true,
    },
    {
      "<leader>gc",
      function()
        -- use vim.ui.input to write commit message and then commit with the
        -- message.
        vim.ui.input({
          prompt = "Commit message: ",
        }, function(input)
          -- if input is trimmed empty
          if vim.trim(input or "") == "" then
            vim.notify("Empty commit message", vim.log.levels.ERROR)
            return
          end

          vim.cmd(string.format('OverDispatch! git commit -m "%s"', input))
        end)
      end,
      desc = "Git commit",
    },
  },
  event = "User AstroGitFile",
  cmd = {
    "G",
    "Git",
    "Gread",
    "Gwrite",
    "Ggrep",
    "GMove",
    "GDelete",
    "GBrowse",
    "Gdiffsplit",
    "Gvdiffsplit",
    "Gedit",
    "Gsplit",
    "Grevert",
    "Grebase",
    "Gpedit",
    "Gclog",
  },
}
