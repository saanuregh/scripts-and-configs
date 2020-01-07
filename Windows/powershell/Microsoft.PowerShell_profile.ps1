# Runs all .ps1 files in this module's directory
Get-ChildItem -Path $PSScriptRoot\*.ps1 | Where-Object name -NotMatch 'Microsoft.PowerShell_profile' | Foreach-Object { . $_.FullName }

Import-Module Terminal-Icons
Import-Module TabExpansionPlusPlus
Import-Module PSReadLine
Import-Module Get-ChildItemColor
Import-Module posh-with
Import-Module PoShFuck
Import-Module DockerCompletion
Invoke-Expression ($(lua53 "$env:USERPROFILE\Documents\WindowsPowershell\z.lua" --init powershell) -join "`n") 

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Invoke-Expression (&starship init powershell)