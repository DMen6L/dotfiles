# Desktop themes

`catppuccin.lua` defines shared functional roles for Latte and Mocha. Change the
role-to-palette mappings there, rather than editing generated application colors.
The exact palette values live in `assets/palettes/catppuccin.lua`.

Apply a theme from `~/.config`:

```sh
lua scripts/theme.lua apply catppuccin-latte
lua scripts/theme.lua apply catppuccin-mocha
lua scripts/theme.lua apply rivendell
```

Applying regenerates application colors and updates the active state. Catppuccin
profiles require their corresponding GTK3 and GTK4 theme under
`$XDG_DATA_HOME/themes` (normally `~/.local/share/themes`). Missing themes are
reported before application files are written. `--no-reload` still writes theme
files; it skips desktop settings and live reloads.

Use functional names such as `accent`, `warning`, `network`, or `audio` in UI
styles. The complete native palette is also exported as `palette_mauve`,
`palette_peach`, etc. Rofi uses hyphens, such as `palette-mauve`, because Rasi
does not accept underscores in property names.

Layouts, wallpaper, terminal opacity, and Neovim's transparency remain separate
from palette selection. Existing terminals, shells, editors, and GTK applications
may need to reload or reopen to use their new colors.

Run the isolated generation checks with:

```sh
python3 scripts/tests/test_theme.py
```
