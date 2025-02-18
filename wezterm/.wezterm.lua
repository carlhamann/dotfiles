local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
config.keys = {
  { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
}
--
-- config.font = wezterm.font_with_fallback("Inconsolata Nerd Font")
config.font = wezterm.font("Inconsolata Nerd Font", {weight="Regular", stretch="Normal", style="Normal"})

-- https://github.com/prabirshrestha/dotfiles/blob/main/.config/wezterm/wezterm.lua

-- Populate launch menu with powershell and VS command prompts
-- https://wezterm.org/config/launch.html#__codelineno-7-1
local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })

  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  for _, vsvers in
    ipairs(
      wezterm.glob('Microsoft Visual Studio/20*', 'C:/Program Files (x86)')
    )
  do
    local year = vsvers:gsub('Microsoft Visual Studio/', '')
    table.insert(launch_menu, {
      label = 'x64 Native Tools VS ' .. year,
      args = {
        'cmd.exe',
        '/k',
        'C:/Program Files (x86)/'
          .. vsvers
          .. '/BuildTools/VC/Auxiliary/Build/vcvars64.bat',
      },
    })
  end
end

config.launch_menu = launch_menu
return config
