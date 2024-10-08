--- https://github.com/razak17/nvim/blob/32bb5b4df9fe5063b468324465afcf8c34b1db70/lua/user/plugins/motions.lua#L57
local fmt = string.format
local V = require("v")

local find_string = function(tab, str)
  local found = false
  for _, v in pairs(tab) do
    if v == str then
      found = true
      break
    end
  end
  return found
end

local function get_available_stacks(notify)
  local available_stacks = require("trailblazer.trails").stacks.get_sorted_stack_names()
  if notify then
    vim.notify(
      fmt("Available stacks: %s", table.concat(available_stacks, ", ")),
      vim.log.levels.INFO,
      { title = "TrailBlazer" }
    )
  end
  return available_stacks
end

local function switch_trail_mark_stack_picker()
  local stacks = get_available_stacks(false)

  if #stacks <= 0 then return end

  vim.ui.select(stacks, {
    prompt = "Select trail stack",
  }, function(selected)
    if not selected or selected == "" then return end
    require("trailblazer").switch_trail_mark_stack(selected, true)
  end)
end

local function select_trail_stack_to_delete_picker()
  local stacks = get_available_stacks(false)

  if #stacks <= 0 then return end

  vim.ui.select(stacks, {
    prompt = "!Delete trail stack",
  }, function(selected)
    if not selected or selected == "" then return end
    require("trailblazer").delete_trail_mark_stack(selected, true)
  end)
end

local function add_trail_mark_stack()
  vim.ui.input({ prompt = "stack name: " }, function(name)
    if not name then return end
    local available_stacks = get_available_stacks()
    if find_string(available_stacks, name) then
      vim.notify(fmt('"%s" stack already exists.', name), vim.log.levels.WARN, { title = "TrailBlazer" })
      return
    end
    local tb = require("trailblazer")
    tb.add_trail_mark_stack(name)
    vim.notify(fmt('"%s" stack created.', name), vim.log.levels.INFO, { title = "TrailBlazer" })
  end)
end

local function delete_trail_mark_stack()
  vim.ui.input({ prompt = "stack name: " }, function(name)
    if not name then return end
    local available_stacks = get_available_stacks()
    if not find_string(available_stacks, name) then
      vim.notify(fmt('"%s" stack does not exist.', name), vim.log.levels.INFO, { title = "TrailBlazer" })
      return
    end
    local tb = require("trailblazer")
    tb.delete_trail_mark_stack(name)
    vim.notify(fmt('"%s" stack deleted.', name), vim.log.levels.INFO, { title = "TrailBlazer" })
  end)
end

--- This enables you to quickly "bookmark" where you are right now,
--- naviagte to wherever you need to and come back by simply popping
--- the last mark off the stack using the "track back" feature. This is especially
--- useful when you need to quickly jump to a specific location in a different file or
--- window and return afterwards without the need for a permanent mark.
--- https://github.com/FelixKratz/dotfiles/blob/6a84fc7882c31a60268386da0d67c7d39fc7ff55/.config/nvim/lua/plugins/trailblazer.lua#L16
return {
  "LeonHeidelbach/trailblazer.nvim",
  submodules = false,
  cmd = {
    "TrailBlazerTrackBack",
    "TrailBlazerMoveToNearest",
    "TrailBlazerPeekMovePreviousUp",
    "TrailBlazerPeekMoveNextDown",
    "TrailBlazerLoadSession",
    "TrailBlazerSaveSession",
    "TrailBlazerToggleTrailMarkList",
    "TrailBlazerNewTrailMark",
    "TrailBlazerDeleteAllTrailMarks",
    "TrailBlazerMoveToTrailMarkCursor",
  },
  dependencies = {
    V.astro_extend_core({
      mappings = {
        n = {
          ["<leader>v"] = "⨓ Trailblazer",
          ["<localleader>v"] = "⨓ Trailblazer",
          ["<leader><space>"] = { "<cmd>TrailBlazerNewTrailMark<cr>", desc = "New trail mark" },
          ["<leader>vn"] = { "<cmd>TrailBlazerMoveToNearest<cr>", desc = "Trail nearest" },
          ["<leader>vx"] = { "<cmd>TrailBlazerDeleteAllTrailMarks<cr>", desc = "clear all marks" },
          ["<localleader>vx"] = { "<cmd>TrailBlazerDeleteAllTrailMarks 0<cr>", desc = "clear all marks in buffer" },
          ["<leader>va"] = { add_trail_mark_stack, desc = "Add stack" },
          ["<leader>vc"] = { "<cmd>TrailBlazerMoveToTrailMarkCursor<cr>", desc = "Move to cursor mark" },
          ["<leader>vd"] = { delete_trail_mark_stack, desc = "Delete stack" },
          ["<leader>vq"] = { "<cmd>TrailBlazerToggleTrailMarkList<cr>", desc = "Toggle trail mark list" },
          ["<leader>vgd"] = { select_trail_stack_to_delete_picker, desc = "Delete stack picker" },
          ["<leader>vgl"] = { get_available_stacks, desc = "Get stacks" },
          ["<leader>v-"] = { switch_trail_mark_stack_picker, desc = "Switch trail stack" },
          ["<leader>vg["] = {
            function() require("trailblazer").switch_to_previous_trail_mark_stack(nil, true) end,
            desc = "Switch stack to previous",
          },
          ["<leader>vg]"] = {
            function() require("trailblazer").switch_to_next_trail_mark_stack(nil, true) end,
            desc = "Switch stack to next",
          },

          ["<leader>vs"] = { "<Cmd>TrailBlazerSaveSession<CR>", desc = "Save session" },
          ["<leader>vl"] = { "<Cmd>TrailBlazerLoadSession<CR>", desc = "Load session" },

          ["<localleader>vb"] = { "<cmd>TrailBlazerTrackBack 0<cr>", desc = "Trace back in buffer" },
          ["<leader>vb"] = { "<cmd>TrailBlazerTrackBack<cr>", desc = "Trace back global" },

          ["<localleader>v["] = { "<cmd>TrailBlazerPeekMovePreviousUp %<cr>", desc = "Trail pre in buf" },
          ["<localleader>v]"] = { "<cmd>TrailBlazerPeekMoveNextDown %<cr>", desc = "Trail next in buf" },

          ["<leader>v["] = { "<cmd>TrailBlazerPeekMovePreviousUp<cr>", desc = "Trail pre global" },
          ["<leader>v]"] = { "<cmd>TrailBlazerPeekMoveNextDown<cr>", desc = "Trail next global" },
        },
      },
    }),
  },
  opts = {
    lang = "en",
    auto_save_trailblazer_state_on_exit = false,
    auto_load_trailblazer_state_on_enter = false,
    trail_options = {
      trail_mark_priority = 10001,
      --- Available modes to cycle through.
      available_trail_mark_modes = {
        "global_chron",
        "global_buf_line_sorted",
        "global_fpath_line_sorted",
        "global_chron_buf_line_sorted",
        "global_chron_fpath_line_sorted",
        "global_chron_buf_switch_group_chron",
        "global_chron_buf_switch_group_line_sorted",
        "buffer_local_chron",
        "buffer_local_line_sorted",
      },
      current_trail_mark_mode = "global_chron_buf_switch_group_chron",
      verbose_trail_mark_select = false,
      mark_symbol = "󰓎",
      newest_mark_symbol = "󰔟",
      cursor_mark_symbol = "",
      next_mark_symbol = "▶",
      previous_mark_symbol = "◀",
      multiple_mark_symbol_counters_enabled = false,
      trail_mark_symbol_line_indicators_enabled = true,
      trail_mark_in_text_highlights_enabled = false,
      trail_mark_list_rows = 5,
      move_to_nearest_before_peek = false,
      move_to_nearest_before_peek_motion_directive_up = "up",
      move_to_nearest_before_peek_motion_directive_down = "down",
    },
    hl_groups = {
      TrailBlazerTrailMark = {
        guifg = "blue",
      },
    },
    event_list = {
      "TrailBlazerTrailMarkStackSaved",
      "TrailBlazerCurrentTrailMarkStackChanged",
    },
    quickfix_mappings = {
      v = {
        actions = {
          qf_action_move_selected_trail_marks_down = "<C-k>",
          qf_action_move_selected_trail_marks_up = "<C-l>",
        },
      },
    },
    force_mappings = {
      nv = {
        motions = {
          -- new_trail_mark = '<leader><space>',
          -- toggle_trail_mark_list = '<leader>vt',
        },
        actions = {
          -- delete_all_trail_marks = '<A-L>',
          -- paste_at_last_trail_mark = '<A-p>',
          -- paste_at_all_trail_marks = '<A-P>',
          -- set_trail_mark_select_mode = '<A-t>',
          -- switch_to_next_trail_mark_stack = '<leader>v.',
          -- switch_to_previous_trail_mark_stack = '<leader>v,',
          -- set_trail_mark_stack_sort_mode = '<A-s>',
        },
      },
    },
  },
}
