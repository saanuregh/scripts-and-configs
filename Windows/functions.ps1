# Basic commands
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }

# Common Editing needs
function Edit-Hosts { Invoke-Expression "sudo $(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" }
function Edit-Profile { Invoke-Expression "$(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $profile" }

# Sudo
function sudo() {
    if ($args.Length -eq 1) {
        start-process $args[0] -verb "runAs"
    }
    if ($args.Length -gt 1) {
        start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
    }
}

# Empty the Recycle Bin on all drives
function Empty-RecycleBin {
    $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $RecBin.Items() | ForEach-Object { Remove-Item $_.Path -Recurse -Confirm:$false }
}

# File System functions
# Create a new directory and enter it
function CreateAndSet-Directory([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path }

# Determine size of a file or total size of a directory
function Get-DiskUsage([string] $path = (Get-Location).Path) {
    Convert-ToDiskSize `
    ( `
            Get-ChildItem .\ -recurse -ErrorAction SilentlyContinue `
        | Measure-Object -property length -sum -ErrorAction SilentlyContinue
    ).Sum `
        1
}

# Environment functions
# https://community.spiceworks.com/topic/1570654-what-s-in-your-powershell-profile?page=1#entry-5746422
function Test-Administrator {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}
function Start-PsElevatedSession { 
    # Open a new elevated powershell window
    if (!(Test-Administrator)) {
        if ($host.Name -match 'ISE') {
            Start-Process PowerShell_ISE.exe -Verb runas
        }
        else {
            Start-Process powershell -Verb runas -ArgumentList $('-noexit ' + ($args | Out-String))
        }
    }
    else {
        Write-Warning 'Session is already elevated'
    }
} 
# http://www.lavinski.me/my-powershell-profile/
function Elevate-Process {
    $file, [string]$arguments = $args
    $psi = new-object System.Diagnostics.ProcessStartInfo $file
    $psi.Arguments = $arguments
    $psi.Verb = 'runas'
  
    $psi.WorkingDirectory = Get-Location
    [System.Diagnostics.Process]::Start($psi)
}
function Update-SessionEnvironmentPYENV {
    Update-SessionEnvironment
    pyenv.bat rehash
}
function Remove-DuplicateEnvPath {
    [Environment]::SetEnvironmentVariable('Path', (([Environment]::GetEnvironmentVariable('Path', 'Machine') -split
                ';' | Sort-Object -Unique) -join ';'), 'Machine')
}

# Add a folder to $env:Path
function Prepend-EnvPath([String]$path) { [System.Environment]::SetEnvironmentVariable("PATH", $path + $Env:Path, "Machine") }
function Append-EnvPath([String]$path) { [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + $path, "Machine") }


# Utilities

