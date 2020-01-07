# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# Navigation Shortcuts
${function:dt} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:dl} = { Set-Location ~\Downloads }
${function:pro} = { Set-Location ~\Projects }

# Missing Bash aliases
Set-Alias time Measure-Command

# Directory Listing
Remove-Item alias:ls -ErrorAction SilentlyContinue
${function:ls} = { Get-ChildItemColor  @args }
${function:la} = { Get-ChildItemColor -Force @args }
${function:lsd} = { Get-ChildItem -Directory -Force @args }
${function:lsf} = { Get-ChildItem -File -Force @args }

# Create a new directory and enter it
Set-Alias mkd CreateAndSet-Directory

# Determine size of a file or total size of a directory
Set-Alias fs Get-DiskUsage

# Empty the Recycle Bin on all drives
Set-Alias emptytrash Empty-RecycleBin

Set-Alias -Name su -Value Start-PsElevatedSession
Set-Alias sudo Elevate-Process
Set-Alias refresh -Value Update-SessionEnvironmentPYENV