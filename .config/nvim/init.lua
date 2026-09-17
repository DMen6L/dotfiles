-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.transparency")

vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/molten/bin/python")
