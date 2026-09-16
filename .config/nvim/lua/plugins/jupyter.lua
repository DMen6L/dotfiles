return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  lazy = false,
  build = ":UpdateRemotePlugins",

  init = function()
    vim.g.molten_output_win_max_height = 20
  end,
}
