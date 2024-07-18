---@diagnostic disable: param-type-mismatch

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        i = {
          ["jj"] = { "<ESC>", nowait = true, noremap = true },
          ["<C-s>"] = { "<cmd>update!<cr>", desc = "Save File", noremap = true, nowait = true },
        },

        -- first key is the mode
        n = {
          ["<Leader>/"] = false,
          ["<Leader>q"] = false,
          ["<Leader>w"] = false,
          ["<c-w><space>"] = {
            function() require("which-key").show({ keys = "<c-w>", loop = true }) end,
            desc = "Window Hydra mode (which-key)",
          },
          ["<Leader>c"] = false,
          ["<Leader>C"] = false,
          ["<Leader>n"] = false,
          ["<Leader>e"] = "󱏒 Explore",
          ["<Leader>o"] = false,
          ["<Leader>ee"] = { "<Cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
          ["<Leader>e."] = {
            function()
              if vim.bo.filetype == "neo-tree" then
                vim.cmd.wincmd("p")
              else
                vim.cmd.Neotree("focus")
              end
            end,
            desc = "Toggle Explorer Focus",
          },
          ["<Leader>nf"] = {
            ":new<cr>",
            desc = "New file",
          },
          [";"] = { ":" },
          -- navigate buffer tabs
          ["<C-n>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["<C-p>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
          ["';"] = { "<cmd>b#<cr>", desc = "Previous buffer" },
          -- second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },
          -- tables with the `name` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          ["<Leader>b"] = { name = "Buffers" },
          -- quick save
          ["<C-s>"] = { ":update!<cr>", desc = "Save File" }, -- change description but the same command
          ["<C-c><C-k>"] = {
            function()
              local tabs_count = vim.fn.tabpagenr("$")
              if tabs_count <= 1 then
                V.nvim_smart_close(0, 0)
                vim.cmd('echo "hide current window"')
                return
              end
              --- get current tab's window count
              local win_count = require("v").tab_win_count()
              if win_count <= 1 then
                local choice = vim.fn.confirm("Close last window in tab?", "&Yes\n&No", 2)
                if choice == 2 then return end
              end
              V.nvim_smart_close(0, 0)
              vim.cmd('echo "hide current window"')
            end,
            desc = "Kill current window",
          },
          ["<C-c><C-f>"] = {
            function()
              local current_buf = vim.api.nvim_get_current_buf()
              vim.cmd("tabnew")
              vim.cmd("b" .. current_buf)
            end,
            desc = "Drop float win to new tab",
          },
          ["<C-c><C-d>"] = {
            function()
              if vim.fn.exists("&winfixbuf") == 1 and vim.api.nvim_get_option_value("winfixbuf", { win = 0 }) then
                vim.cmd("hide")
                return
              end
              require("astrocore.buffer").close(0)
            end,
            desc = "Delete current buffer",
          },
          ["<A-q>"] = {
            function()
              local current_win_is_qf = vim.bo.filetype == "qf"
              if current_win_is_qf then
                vim.cmd("wincmd p")
              else
                -- focus on qf window
                vim.cmd("copen")
              end
            end,
            desc = "Switch between quickfix window and previous window",
          },
          ["<leader>np"] = {
            function()
              local reg = vim.v.register or '"'
              vim.cmd(":put " .. reg)
              vim.cmd([[normal! `[v`]=]])
            end,
            expr = false,
            noremap = true,
            silent = false,
            desc = "Paste in next line and format",
          },
          ["<leader>nP"] = {
            function()
              local reg = vim.v.register or '"'
              vim.cmd(":put! " .. reg)
              vim.cmd([[normal! `[v`]=]])
            end,
            expr = false,
            noremap = true,
            silent = false,
            desc = "Paste in above line and format",
          },

          ---- git
          ["<localleader>w"] = V.git_start_nvim() and {
            ":w|cq",
            nowait = true,
            noremap = true,
            desc = "Git mergetool: prepare write and exit safe",
          } or nil,
          ["<localleader>c"] = V.git_start_nvim() and {
            ":cq 1",
            desc = "Git mergetool: Prepare to abort",
            nowait = true,
            noremap = true,
          } or nil,

          ["H"] = {
            function()
              local has_folded = vim.fn.foldclosed(".") > -1
              local is_at_first_non_whitespace_char_of_line = (vim.fn.col(".") - 1)
                == vim.fn.match(vim.fn.getline("."), "\\S")

              if is_at_first_non_whitespace_char_of_line and not has_folded then return "za" end
              if vim.fn.foldclosed(".") == -1 then return "^" end
            end,
            desc = "Move to first non-blank char of the line or fold the line",
            expr = true,
            remap = false,
            nowait = true,
          },
          ["L"] = {
            function()
              if vim.fn.foldclosed(".") > -1 then
                return "zo"
              else
                return "$"
              end
            end,
            desc = "Move to the last non-blank char of the line or open the fold",
            expr = true,
            remap = false,
            nowait = true,
          },
        },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
        v = {
          ["dp"] = {
            [[:<C-u>'<,'>diffput<cr>]],
            desc = "Diffput in visual",
            silent = true,
          },
          ["do"] = {
            [[:<C-u>'<,'>diffget<cr>]],
            desc = "Diffget in visual",
            silent = true,
          },
          J = {
            ":move '>+1<CR>gv-gv",
            desc = "Move selected line / block of text in visual mode down",
          },
          K = {
            ":move '<-2<CR>gv-gv",
            desc = "Move selected line / block of text in visual mode up",
          },
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          -- this mapping will only be set in buffers with an LSP attached
          K = {
            function() vim.lsp.buf.hover() end,
            desc = "Hover symbol details",
          },
          -- condition for only server with declaration capabilities
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
        },
      },
    },
  },
}
