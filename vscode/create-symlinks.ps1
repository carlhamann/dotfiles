$files = @("settings.json", "keybindings.json")
$targetDir = $PSScriptRoot
$symlinkDir = "$env:APPDATA\Code\User"

foreach ($file in $files) {
  $linkPath = Join-Path -Path $symlinkDir -ChildPath $file
  $targetPath = Join-Path -Path $targetDir -ChildPath $file

  # Remove existing symlink if it exists
  if (Test-Path $linkPath) {
    Write-Host "Deleting existing symlink: $linkPath"
    Remove-Item -Path $linkPath -Force
  }

  # Print before creating new symlink
  Write-Host "Creating symlink: $linkPath -> $targetPath"
  New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath
}