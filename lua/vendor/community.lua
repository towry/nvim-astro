return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.icon.mini-icons" },
  --- langs
  -- { import = "astrocommunity.neovim-lua-development.lazydev-nvim" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.nim" },
  { import = "astrocommunity.pack.nix" },
  { import = "astrocommunity.lsp.nvim-lsp-endhints" },
  { import = "astrocommunity.lsp.lsplinks-nvim" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  -- { import = "astrocommunity.completion.codeium-nvim" },
  -- edit
  -- { import = "astrocommunity.motion.tabout-nvim" },
  vim.env.TMUX and {
      import = "astrocommunity.completion.cmp-tmux",
    } or {},
}
