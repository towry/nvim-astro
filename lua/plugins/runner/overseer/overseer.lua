local V = require("v")

return {
  ---- NOTE: If task buffer is opened and then deleted, it will not be visible in
  ---overseer output window again.
  -- https://github.com/stevearc/overseer.nvim
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerRestartLast",
    "OverseerRun",
    "OverseerOpen",
    "OverseerToggle",
    "OverseerClose",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    -- Show infos like checkhealth
    "OverseerInfo",
    "OverseerBuild",
    -- run action on last.
    "OverseerQuickAction",
    -- select running task and perf action: kill or restart etc.
    "OverseerTaskAction",
    "OverseerClearCache",
  },

  keys = {
    { "<localleader>m", ":OverMake ", desc = "OverMake" },
    { "<localleader>o", desc = "Overseer" },
    { "<localleader>o;", "<cmd>OverseerRestartLast<cr>", desc = "Restart last task" },
    { "<localleader>oo", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
    { "<localleader>or", "<cmd>OverseerRun<cr>", desc = "Run" },
    {
      "<localleader>o1",
      function()
        require("plugins.runner.overseer.utils").start_template_by_tags({
          "BUILD",
        })
      end,
      desc = "Select template to BUILD and open the output of task",
    },
    {
      "<localleader>o2",
      function()
        require("plugins.runner.overseer.utils").start_template_by_tags({
          "RUN",
        })
      end,
      desc = "Select template to RUN and open the output of task",
    },
    {
      "<localleader>o3",
      function()
        require("plugins.runner.overseer.utils").start_template_by_tags({
          "TEST",
        })
      end,
      desc = "Select template to TEST and open the output of task",
    },
    {
      "<localleader>o<space>",
      function() require("plugins.runner.overseer.utils").start_template_and_open() end,
      desc = "Start template and open",
    },
    { "<localleader>oR", "<cmd>OverseerRunCmd<cr>", desc = "Run shell cmd" },
    { "<localleader>oc", "<cmd>OverseerClose<cr>", desc = "Close" },
    { "<localleader>oS", "<cmd>OverseerSaveBundle<cr>", desc = "Save bundle" },
    { "<localleader>oL", "<cmd>OverseerLoadBundle<cr>", desc = "Load bundle" },
    { "<localleader>od", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete bundle" },
    {
      "<localleader>ov",
      '<cmd>lua require("plugins.runner.overseer.utils").open_vsplit_last()<cr>',
      desc = " Open last output window in vsplit",
    },
    {
      "<localleader>oq",
      "<cmd>OverseerQuickAction<cr>",
      desc = "Run an action on the most recent task, or the task under the cursor",
    },
    { "<localleader>oC", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
  },
  opts = function(_, opts)
    local astrocore = require("astrocore")
    return vim.tbl_deep_extend("force", {
      -- https://github.com/stevearc/overseer.nvim/blob/master/doc/reference.md#setup-options
      -- strategy = "terminal",
      strategy = {
        astrocore.is_available("toggleterm.nvim") and "toggleterm" or "terminal",
        -------- toggleterm
        open_on_start = false,
        direction = "tab",
        auto_scroll = true,
        quit_on_exit = "never",
      },
      templates = { "builtin" },
      auto_detect_success_color = true,
      dap = true,
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
          "unique",
        },
      },
      task_list = {
        default_detail = 2,
        max_width = { 100, 0.6 },
        min_width = { 50, 0.4 },
        direction = "right",
        bindings = {
          ["<C-t>"] = "<CMD>OverseerQuickAction open tab<CR>",
          ["="] = "IncreaseDetail",
          ["-"] = "DecreaseDetail",
          ["<C-y>"] = "ScrollOutputUp",
          ["<C-n>"] = "ScrollOutputDown",
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<C-l>"] = false,
          ["<C-h>"] = false,
        },
      },
      form = {
        border = "single",
      },
      confirm = {
        border = "single",
      },
      task_win = {
        border = "single",
      },
      help_win = {
        border = "single",
      },
      task_launcher = {},
    }, opts)
  end,
  config = function(_, opts)
    vim.g.plugin_overseer_loaded = 1
    local overseer = require("overseer")
    local overseer_vscode_variables = require("overseer.template.vscode.variables")
    local precalculate_vars = overseer_vscode_variables.precalculate_vars

    ---@diagnostic disable-next-line: duplicate-set-field
    overseer_vscode_variables.precalculate_vars = function()
      local tbl = precalculate_vars()
      local cwd = vim.uv.cwd()
      -- NOTE: need fix this for multiple workspaces
      tbl["workspaceFolder"] = cwd
      tbl["workspaceRoot"] = cwd
      tbl["fileWorkspaceFolder"] = cwd
      tbl["workspaceFolderBasename"] = vim.fs.basename(cwd)
      return tbl
    end

    overseer.setup(opts)

    vim.api.nvim_create_user_command("OverseerRestartLast", function()
      local tasks = overseer.list_tasks({ recent_first = true })
      if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
      else
        overseer.run_action(tasks[1], "restart")
      end
    end, {})

    --- prevent o insert line
    vim.keymap.set("n", "<localleader>o", "<NOP>", {})
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",

    V.astro_extend_core({
      commands = {
        Grep = {
          function(params)
            -- Insert args at the '$*' in the grepprg
            local cmd, num_subs = vim.o.grepprg:gsub("%$%*", params.args)
            if num_subs == 0 then cmd = cmd .. " " .. params.args end
            local overseer = require("overseer")
            local task = overseer.new_task({
              cmd = vim.fn.expandcmd(cmd),
              components = {
                {
                  "on_output_quickfix",
                  errorformat = vim.o.grepformat,
                  open = not params.bang,
                  open_height = 8,
                  items_only = true,
                },
                -- We don't care to keep this around as long as most tasks
                { "on_complete_dispose", timeout = 30 },
                "default",
              },
            })
            task:start()
          end,
          nargs = "+",
          bang = true,
          complete = "file",
          desc = "Grep with overseer",
        },
        TryMake = {
          function(opts)
            local Path = require("plenary.path")
            local cwd = vim.uv.cwd()
            local target = opts.fargs[1]
            if target == nil then
              target = ""
            else
              target = " " .. target
            end
            if vim.bo.buftype == "" then cwd = vim.fn.expand("%:p:h") end
            V.path_search_ancestors_callback(cwd, function(dir)
              if V.path_is_homedir(dir) then
                vim.notify("Makefile not found, homedir reached.")
                return true
              end
              if type(dir) ~= "string" then
                vim.notify("invalid path found, return")
                return true
              end
              local mk = Path:new(dir).joinpath("Makefile")
              if vim.fn.filereadable(mk) == 1 then
                cwd = vim.uv.cwd()
                vim.cmd.lcd(dir)
                local cmds = string.format([[OverMake%s -f %s%s]], opts.bang and "!" or "", mk, target)
                vim.cmd(cmds)
                vim.cmd.lcd(cwd)
                return true
              end
            end)
          end,
          nargs = "*",
          bang = true,
          desc = "Find makefile and run",
        },
        OverMake = {
          function(params)
            -- Insert args at the '$*' in the makeprg
            local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
            if num_subs == 0 then cmd = cmd .. " " .. params.args end
            --- expandcmd raise error about backtick like cmd: Git commit -m "some
            --- `backtick`"
            cmd = vim.fn.expandcmd(vim.fn.escape(cmd, "`"))
            local task = require("overseer").new_task({
              cmd = cmd,
              strategy = "terminal",
              components = {
                {
                  "on_output_quickfix",
                  -- items_only = true,
                  errorformat = vim.o.errorformat,
                  open = params.bang,
                  -- relative_file_root = cwd,
                  open_on_match = false,
                  -- open_on_exit = 'failure',
                  tail = false,
                  open_height = 8,
                },
                "default",
              },
            })

            task:start()
          end,
          desc = "Run your makeprg as an Overseer task",
          nargs = "*",
          bang = true,
        },
        OverDispatch = {
          function(params)
            local cmd = vim.trim(params.args or "")
            if cmd == "" and vim.b.over_dispatch then cmd = vim.b.over_dispatch end
            vim.b.over_dispatch = cmd
            local expanded_cmd = vim.fn.expandcmd(vim.fn.escape(cmd, "`"))
            local task = require("overseer").new_task({
              strategy = {
                "toggleterm",
                open_on_start = false,
              },
              cmd = expanded_cmd,
              components = {
                { "on_output_quickfix", open = not params.bang, open_height = 8 },
                "default",
              },
            })
            task:start()

            if params.smods.silent then return end

            local echo_label = params.bang and "OverDispatch[!]: " or "OverDispatch: "
            vim.schedule(
              function() vim.api.nvim_echo({ { echo_label, "InfoFloat" }, { expanded_cmd, "Comment" } }, true, {}) end
            )
          end,
          desc = "Run your cmd as an Overseer task",
          nargs = "*",
          bang = true,
        },
      },
    }),
  },
}
