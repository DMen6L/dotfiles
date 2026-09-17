local groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "SignColumn",
  "EndOfBuffer",
  "LineNr",
  "FoldColumn",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
}

local function apply_transparency()
  for _, group in ipairs(groups) do
    vim.cmd("highlight " .. group .. " guibg=NONE ctermbg=NONE")
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_transparency,
})

apply_transparency()
