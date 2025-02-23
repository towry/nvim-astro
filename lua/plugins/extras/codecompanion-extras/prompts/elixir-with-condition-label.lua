return {
  strategy = "inline",
  description = "Toggle the with statement condition label",
  opts = {
    ignore_system_prompt = true,
    placement = "replace",
    contains_code = true,
    short_name = "elixir-with-condition-label",
    auto_submit = true,
    stop_context_insertion = true,
    user_prompt = false,
  },
  prompts = {
    {
      role = "system",
      content = function(context)
        return "I want you to act as an Elixir programing expert."
          .. " I will ask you to suggest some edits to the code, you should suggest the best and only one edit at a time, so user can apply your suggestion without further modification."
      end,
    },
    {
      role = "user",
      content = function(context)
        local selected = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        local prompts = {
          "Toggle/flip the with statement condition label",
          "If the with branch statement is like this:",
          "`{true, label} <- {expr, label}`",
          "please change it to `true <- expr`",
          "otherwise, if the with branch statement is like this:",
          "`true <- expr`",
          "please change it to `{true, label} <- {expr, label}` and use random unique label",
          "be sure to keep the same indentation level",
          "be sure do not change the expr, just add or remove the label",
          "please change all branches under the with statement",
          "be sure to replace code inplace, not to add new lines",
          "#buffer",
          "the code to change is as follows:",
          selected,
        }

        return table.concat(prompts, "\n")
      end,
    },
  },
}
