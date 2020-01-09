#region Powershell
$profileDir = Split-Path -parent $profile
Copy-Item -Path ./powershell/*.ps1 -Destination $profileDir -Force
Get-ChildItem $profileDir/* | Unblock-File -Confirm
#endregion Powershell

#region Appdata\Roaming
Copy-Item -Path .\configs\appdata-roaming\* -Destination $env:APPDATA -Recurse -Force
#endregion Appdata\RRoaming

