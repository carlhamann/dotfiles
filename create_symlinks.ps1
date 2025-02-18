# Starting directory (can be changed as needed)
$baseDir = Get-Location

# Find all config files in subfolders (change the file name if desired)
$configFiles = Get-ChildItem -Path $baseDir -Filter "config.txt" -Recurse

foreach ($configFile in $configFiles) {
    Write-Host "Processing config file: $($configFile.FullName)"
    # Use the folder that contains the config file as the base for relative file paths.
    $configDir = $configFile.DirectoryName

    # Read non-empty lines from the config file, ignoring comment lines (lines starting with #)
    $lines = Get-Content -Path $configFile.FullName | Where-Object { $_.Trim() -ne "" -and $_ -notmatch "^\s*#" }

    foreach ($line in $lines) {
        # Expecting each line to be in the format: fileName,targetFolder
        $parts = $line -split ","
        if ($parts.Count -ge 2) {
            $relativeFileName = $parts[0].Trim()
            $targetFolderRaw  = $parts[1].Trim()
            # Expand any environment variables in the target folder path
            $targetFolder = [Environment]::ExpandEnvironmentVariables($targetFolderRaw)

            # Build the absolute path for the source file (located in the same folder as the config file)
            $sourceFile = Join-Path -Path $configDir -ChildPath $relativeFileName

            # Use just the file name (or you can preserve any subfolder structure if needed)
            $fileName = Split-Path -Path $relativeFileName -Leaf

            # Construct the full path for the symlink that will be created in the target folder
            $linkPath = Join-Path -Path $targetFolder -ChildPath $fileName

            # Warn if the source file doesn't exist and skip creating a symlink
            if (-not (Test-Path $sourceFile)) {
                Write-Host "WARNING: Source file does not exist: $sourceFile"
                continue
            }

            # If a file or link already exists at the target location, remove it first
            if (Test-Path $linkPath) {
                Write-Host "Deleting existing symlink: $linkPath"
                Remove-Item -Path $linkPath -Force
            }

            # Print before creating the new symlink
            Write-Host "Creating symlink: $linkPath -> $sourceFile"
            New-Item -ItemType SymbolicLink -Path $linkPath -Target $sourceFile
        }
        else {
            Write-Host "Skipping invalid config line: $line"
        }
    }
}
