-- Configure snacks.nvim to show ignored files by default
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,  -- show hidden files (starting with .)
            ignored = true, -- show ignored files (from .gitignore)
          },
        },
      },
    },
  },
}
