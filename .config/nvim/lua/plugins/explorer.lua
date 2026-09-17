return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {},
      picker = {
        sources = {
          explorer = {
            auto_close = true,
            jump = { close = true },
            layout = {
              preset = "vertical",
              preview = false,
              layout = {
                backdrop = false,
                width = 0.42,
                min_width = 42,
                height = 0.7,
                min_height = 18,
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Explorer (root dir)",
      },
      {
        "<leader>E",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer (cwd)",
      },
    },
  },
}
