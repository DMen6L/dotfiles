#!/usr/bin/env python3
"""Theme generation checks; all writes stay in a temporary config directory."""
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import tomllib
import unittest

ROOT = Path(__file__).resolve().parents[2]
PROFILES = ("catppuccin-latte", "catppuccin-mocha", "rivendell")
EXPORTS = (
    "Quickshell/theme/Colors.qml",
    "hypr/modules/theme.lua",
    "waybar/colors/colors.css",
    "swaync/colors/active.css",
    "rofi/shared/colors.rasi",
    "starship/starship.toml",
)


class ThemeGenerationTests(unittest.TestCase):
    def setUp(self):
        self.work = tempfile.TemporaryDirectory(prefix="theme-test-")
        self.addCleanup(self.work.cleanup)
        self.config = Path(self.work.name) / "config"
        shutil.copytree(ROOT / "assets", self.config / "assets")
        shutil.copytree(ROOT / "rofi/styles", self.config / "rofi/styles")
        (self.config / "kitty").mkdir()
        shutil.copy2(ROOT / "kitty/current-theme.conf", self.config / "kitty/current-theme.conf")
        for name in ("starship/layout.toml", "fastfetch/layout.jsonc"):
            dest = self.config / name
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ROOT / name, dest)
        data = Path(self.work.name) / "data"
        for flavor in ("latte", "mocha"):
            for version in ("gtk-3.0", "gtk-4.0"):
                stylesheet = data / "themes" / f"catppuccin-{flavor}-mauve-standard+default" / version / "gtk.css"
                stylesheet.parent.mkdir(parents=True, exist_ok=True)
                stylesheet.write_text("/* Installed-theme fixture. */\n")
        self.env = dict(os.environ, XDG_CONFIG_HOME=str(self.config), XDG_DATA_HOME=str(data))

    def apply(self, profile, success=True):
        result = subprocess.run(
            ["lua", str(ROOT / "scripts/theme.lua"), "apply", profile, "--no-reload"],
            env=self.env, capture_output=True, text=True,
        )
        self.assertEqual(result.returncode == 0, success, result.stderr)
        return result

    def palette(self, profile):
        code = '''
local root = os.getenv("XDG_CONFIG_HOME")
package.path = root .. "/assets/?.lua;" .. root .. "/assets/?/init.lua;" .. package.path
local selected = require("theme").resolve(arg[1])
for name, color in pairs(selected.palette) do
    if type(color) == "table" and color.hex then print(name .. " " .. color.hex) end
end
'''
        result = subprocess.run(
            ["lua", "-", profile], input=code, env=self.env,
            capture_output=True, text=True, check=True,
        )
        return dict(line.split() for line in result.stdout.splitlines())

    def files(self):
        return {str(path.relative_to(self.config)): path.read_bytes()
                for path in self.config.rglob("*") if path.is_file()}

    def test_all_native_colors_exported_and_switching_is_repeatable(self):
        for profile in PROFILES:
            with self.subTest(profile=profile):
                self.apply(profile)
                self.assertIn(f'active = "{profile}"', (self.config / "assets/theme_state.lua").read_text())
                palette = self.palette(profile)
                for relative in EXPORTS:
                    content = (self.config / relative).read_text()
                    for name, color in palette.items():
                        exported = f"palette_{name}"
                        if relative.endswith(".rasi"):
                            exported = exported.replace("_", "-")
                        self.assertRegex(content, rf'\b{exported}\b[^\n]*{color}')
                for name in ("rosewater", "flamingo", "maroon", "sky", "sapphire", "lavender"):
                    if name in palette:
                        self.assertIn(palette[name], (self.config / "fastfetch/config.jsonc").read_text())
                before = self.files()
                self.apply(profile)
                self.assertEqual(before, self.files())
        self.apply("catppuccin-latte")
        self.assertIn('colorscheme = "catppuccin-latte"', (self.config / "nvim/lua/plugins/colorscheme.lua").read_text())
        self.assertIn("gtk-application-prefer-dark-theme=0", (self.config / "gtk-3.0/settings.ini").read_text())

    def test_latte_kitty_matches_native_ansi_and_selection(self):
        self.apply("catppuccin-latte")
        kitty = dict(line.split() for line in (self.config / "kitty/themes/active.conf").read_text().splitlines()
                     if line and not line.startswith("#"))
        ansi = ["#5c5f77", "#d20f39", "#40a02b", "#df8e1d", "#1e66f5", "#ea76cb", "#179299", "#acb0be",
                "#6c6f85", "#d20f39", "#40a02b", "#df8e1d", "#1e66f5", "#ea76cb", "#179299", "#bcc0cc"]
        self.assertEqual([kitty[f"color{i}"] for i in range(16)], ansi)
        self.assertEqual(kitty["background"], "#eff1f5")
        self.assertEqual(kitty["foreground"], "#4c4f69")
        self.assertEqual(kitty["selection_background"], "#dc8a78")
        self.assertEqual(kitty["selection_foreground"], "#eff1f5")

    def test_mocha_kitty_loads_the_official_theme(self):
        self.apply("catppuccin-mocha")
        active = self.config / "kitty/themes/active.conf"
        self.assertIn("include ../current-theme.conf", active.read_text())
        self.assertNotIn("color0 ", active.read_text())
        if shutil.which("kitty"):
            code = f'from kitty.config import load_config; opts=load_config({str(active)!r}); assert int(opts.background) == 0x1e1e2e'
            result = subprocess.run(["kitty", "+runpy", code], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_functional_colors_and_swaync_aliases(self):
        for profile in PROFILES[:2]:
            self.apply(profile)
            palette = self.palette(profile)
            colors = dict(re.findall(r"@define-color (\w+) (#[0-9a-f]{6});", (self.config / "swaync/colors/active.css").read_text()))
            for role, native in {"accent": "mauve", "date": "peach", "time": "lavender", "language": "pink",
                                 "network": "sapphire", "audio": "teal", "success": "green", "warning": "yellow",
                                 "urgent": "red", "aqua": "teal", "blue": "blue", "yellow": "yellow"}.items():
                self.assertEqual(colors[role], palette[native], (profile, role))
            prompt = tomllib.loads((self.config / "starship/starship.toml").read_text())
            for module in ("nodejs", "python", "rust", "golang", "lua"):
                references = re.findall(r"(?:fg|bg):(\w+)", prompt[module]["style"] + " " + prompt[module]["format"])
                self.assertTrue(references, module)
                for name in references:
                    self.assertIn(name, prompt["palettes"]["active"], (profile, module, name))
                    self.assertIn(prompt["palettes"]["active"][name], palette.values())
            self.assertEqual(colors["shadow"], palette["text" if profile.endswith("latte") else "crust"])

    def test_bad_profile_and_missing_gtk_leave_config_intact(self):
        self.apply("catppuccin-mocha")
        before = self.files()
        self.apply("unknown-theme", success=False)
        self.assertEqual(before, self.files())
        for version in ("gtk-3.0", "gtk-4.0"):
            stylesheet = Path(self.env["XDG_DATA_HOME"]) / "themes/catppuccin-latte-mauve-standard+default" / version / "gtk.css"
            stylesheet.rename(stylesheet.with_suffix(".missing"))
            result = self.apply("catppuccin-latte", success=False)
            self.assertIn("GTK theme is not installed", result.stderr)
            self.assertEqual(before, self.files())
            stylesheet.with_suffix(".missing").rename(stylesheet)

    @unittest.skipUnless(shutil.which("rofi"), "Rofi is not installed")
    def test_rofi_colors_and_consumers_parse_for_all_profiles(self):
        for profile in PROFILES:
            self.apply(profile)
            for relative in ("rofi/shared/colors.rasi", "rofi/styles/launcher.rasi", "rofi/styles/applets.rasi"):
                result = subprocess.run(
                    ["rofi", "-no-config", "-theme", str(self.config / relative), "-dump-theme"],
                    capture_output=True, text=True,
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                # Rofi returns zero even when it falls back after a parse error.
                self.assertNotIn("Failed to parse", result.stderr, (profile, relative))


if __name__ == "__main__":
    unittest.main()
