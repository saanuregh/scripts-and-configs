# Import necessary functions
. ".\powershell\functions.ps1"

# Temporary folder
mkdir "temp" -Force

#region Chocolatey 
$MaxThreads = 8
$RunspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxThreads)
$RunspacePool.Open()
$Jobs = @()
mkdir -Path "C:\logs" -Force
Get-Content ".\install\choco.txt" | ForEach-Object {
    $PowerShell = [powershell]::Create()
    $PowerShell.RunspacePool = $RunspacePool
    $PowerShell.AddScript( { 
            $logfile = '$_'.Split([string]'--params')[0]
            param ($name) cup.exe --no-progress --ignoredetectedreboot $name | Out-File -Append -FilePath "C:\logs\$logfile.txt" 
        })
    $PowerShell.AddArgument("$_")
    $Jobs += $PowerShell.BeginInvoke()
}
while ($Jobs.IsCompleted -contains $false) { Start-Sleep -Milliseconds 100 }
Refresh-Environment
#endregion Chocolatey

#region Python
$pyversion = ((pyenv install -l).split('\n') | Where-Object { $_ -like "*-amd64" })[0]
pyenv install $pyversion
pyenv global $pyversion
Refresh-EnvironmentandRehash
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py" -UseBasicParsing -OutFile temp\get-poetry.py; python ".\temp\get-poetry.py"
python -m pip install -U pip
pip install -U -r .\install\pip.txt
Refresh-EnvironmentandRehash
#endregion Python

#region Node
nvm on
$nodeversion = ((Invoke-WebRequest -Uri https://nodejs.org/dist/index.json -UseBasicParsing | ConvertFrom-Json) | Where-Object { $_.lts -cne $false })[0].version.substring(1)
nvm install $nodeversion
nvm use $nodeversion
Refresh-EnvironmentandRehash
Invoke-Expression("npm install --dry-run -g " + ((Get-Content ".\install\npm.txt") -join ' '))
#endregion Node

#region Powershell
Install-Module -Name PackageManagement -Repository PSGallery -Force
Install-Module -Name PowerShellGet -Repository PSGallery -Force
Refresh-EnvironmentandRehash
Get-Content ".\install\powershell.txt" | ForEach-Object {
    Install-Module "$_" -Scope CurrentUser -AllowClobber -Force
}
Get-Content ".\install\powershell_pre.txt" | ForEach-Object {
    Install-Module "$_" -AllowPrerelease -Scope CurrentUser -AllowClobber -Force
}
$profileDir = Split-Path -parent $profile
if (-Not (Test-Path $profileDir)) { mkdir $profileDir }
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua' -Out "$profileDir\z.lua"
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/mattparkes/PoShFuck/master/Install-TheFucker.ps1'))
#endregion Powershell