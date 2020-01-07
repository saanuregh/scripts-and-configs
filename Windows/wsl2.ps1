# Powershell script to install Arch Linux on WSL 2
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "Run as administrator!!!"; Pause; Exit
}

# Set WSL version as 2
wsl --set-default-version 2

# Download and install ArchWSL with certificate
mkdir "temp" -Force; Set-Location temp
$downloads = (Invoke-WebRequest "https://api.github.com/repos/yuk7/ArchWSL/releases" | ConvertFrom-Json)[0].assets
Invoke-WebRequest -Uri $downloads[1].browser_download_url -Out arch.appx
Invoke-WebRequest -Uri $downloads[2].browser_download_url -Out arch.cer
Import-Certificate arch.cer -CertStoreLocation Cert:\LocalMachine\Root; Add-AppxPackage arch.appx
RefreshEnv.cmd

# Initial Setup of Arch Linux
Arch.exe
Arch.exe run "pacman-key --init && pacman-key --populate && pacman -S pacman-contrib  --noconfirm"
Arch.exe run "curl -s 'https://www.archlinux.org/mirrorlist/?country=IN&country=SG&country=FR&country=GB&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 6 - | tee /etc/pacman.d/mirrorlist"
Arch.exe run "pacman -Syyu --noconfirm && pacman -S base-devel && pacman -S zsh --noconfirm && pacman -S git --noconfirm"
Arch.exe run "git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm"
Arch.exe run "locale-gen"
Arch.exe run "passwd"
Arch.exe run "echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo"
Arch.exe run "useradd -m -G wheel -s /bin/zsh rak"
Arch.exe run "passwd rak"
Arch.exe config --default-user rak
