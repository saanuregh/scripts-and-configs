# Import necessary functions
. ".\powershell\functions.ps1"

#region Chocolatey 
choco feature enable -n=allowGlobalConfirmation
Get-Content ".\install\choco.txt" | ForEach-Object { cup.exe --ignoredetectedreboot "$_" }
Refresh-Environment
#endregion Chocolatey

#region Python
$pyversion = ((pyenv install -l).split('\n') | Where-Object { $_ -like "*-amd64" })[0]
pyenv install $pyversion
pyenv global $pyversion
Refresh-EnvironmentandRehash
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py" -UseBasicParsing -OutFile temp\get-poetry.py; python ".\temp\get-poetry.py"
pip install -U -r .\install\pip.txt
Refresh-EnvironmentandRehash
#endregion Python

#region Node
nvm on
$nodeversion = ((Invoke-WebRequest -Uri https://nodejs.org/dist/index.json -UseBasicParsing | ConvertFrom-Json) | Where-Object { $_.lts -cne $false })[0].version.substring(1)
nvm install $nodeversion
nvm use $nodeversion
npm -v
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
if (-Not (Test-Path $profileDir)) {
	mkdir $profileDir
}
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua' -Out "$profileDir\z.lua"
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/mattparkes/PoShFuck/master/Install-TheFucker.ps1'))
#endregion Powershell