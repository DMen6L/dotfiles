return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- rustaceanvim manages rust-analyzer itself.
        rust_analyzer = { enabled = false },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "rust" },
    },
  },
}
