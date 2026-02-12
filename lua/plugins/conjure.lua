return {
  -- 1. The REPL Interface (Conjure)
  {
    "Olical/conjure",
    ft = { "scheme" }, -- Only load for scheme files
    init = function()
      -- Tell Conjure specifically to use the "mit-scheme" binary
      vim.g["conjure#client#scheme#stdio#command"] = "mit-scheme" 
      
      -- Optional: Map the doc look-up key
      vim.g["conjure#mapping#doc_word"] = "K"
    end,
  },

  -- 2. Parentheses Management (Non-negotiable for Lisp)
  -- If you don't use this, you will waste 50% of your time balancing parens.
  {
    "gpanders/nvim-parinfer",
    ft = { "scheme" },
  }
}
