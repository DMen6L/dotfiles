return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          cmd = { "/usr/lib/qt6/bin/qmlls", "-E" },
        },
        clangd = {
          mason = false,
          cmd = { "/usr/bin/clangd" },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
              },
            },
          },
        },
      },
    },
  },
}
