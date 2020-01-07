If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Write-Host "Run as administrator!!!"; Pause; Exit
}

Set-ExecutionPolicy Unrestricted -Force
mkdir "temp" -Force

#debloat
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/debloat'))

#https://github.com/farag2/Windows-10-Setup-Script
#region UI & Personalization
# Show "This PC" on Desktop
# Отобразить "Этот компьютер" на рабочем столе
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWord -Value 0 -Force
# Set File Explorer to open to This PC by default
# Открывать "Этот компьютер" в Проводнике
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 1 -Force
# Show Hidden Files, Folders, and Drives
# Показывать скрытые файлы, папки и диски
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 1 -Force
# Turn off check boxes to select items
# Отключить флажки для выбора элементов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -PropertyType DWord -Value 0 -Force
# Show File Name Extensions
# Показывать расширения для зарегистрированных типов файлов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force
# Show folder merge conflicts
# Не скрывать конфликт слияния папок
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force
# Do not show all folders in the navigation pane
# Не отображать все папки в области навигации
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -PropertyType DWord -Value 0 -Force
# Do not show Cortana button on taskbar
# Не показывать кнопку Cortana на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 0 -Force
# Do not show Task View button on taskbar
# Не показывать кнопку Просмотра задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force
# Do not show People button on the taskbar
# Не показывать панель "Люди" на панели задач
IF (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 0 -Force
# Show seconds on taskbar clock
# Отображать секунды в системных часах на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 1 -Force
# Turn on acrylic taskbar transparency
# Включить прозрачную панель задач
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name UseOLEDTaskbarTransparency -PropertyType DWord -Value 1 -Force
# Do not show when snapping a window, what can be attached next to it
# Не показывать при прикреплении окна, что можно прикрепить рядом с ним
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 0 -Force
# Show more details in file transfer dialog
# Развернуть диалог переноса файлов
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 1 -Force
# Turn on ribbon in File Explorer
# Включить отображение ленты проводника в развернутом виде
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force
# Turn on recycle bin files delete confirmation
# Запрашивать подтверждение на удалении файлов из корзины
# IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer))
# {
# 	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Force
# }
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name ConfirmFileDelete -PropertyType DWord -Value 1 -Force
# Remove 3D Objects folder in "This PC" and in the navigation pane
# Скрыть папку "Объемные объекты" из "Этот компьютер" и на панели быстрого доступа
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -PropertyType String -Value Hide -Force
# Do not show "Frequent folders" in Quick access
# Не показывать недавно используемые папки на панели быстрого доступа
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -PropertyType DWord -Value 0 -Force
# Do not show "Recent files" in Quick access
# Не показывать недавно использовавшиеся файлы на панели быстрого доступа
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -PropertyType DWord -Value 0 -Force
# Remove the "Previous Versions" tab from properties context menu
# Отключить отображение вкладки "Предыдущие версии" в свойствах файлов и папок
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name NoPreviousVersionsPage -PropertyType DWord -Value 1 -Force
# Hide search box or search icon on taskbar
# Скрыть поле или значок поиска на Панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force
# Do not show "Windows Ink Workspace" button in taskbar
# Не показывать кнопку Windows Ink Workspace на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force
# Always show all icons in the notification area
# Всегда отображать все значки в области уведомлений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force
# Unpin Microsoft Edge and Microsoft Store from taskbar
# Открепить Microsoft Edge и Microsoft Store от панели задач
$Signature = @{
	Namespace        = "WinAPI"
	Name             = "GetStr"
	Language         = "CSharp"
	MemberDefinition = @"
		[DllImport("kernel32.dll", CharSet = CharSet.Auto)]
		public static extern IntPtr GetModuleHandle(string lpModuleName);
		[DllImport("user32.dll", CharSet = CharSet.Auto)]
		internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);
		public static string GetString(uint strId)
		{
			IntPtr intPtr = GetModuleHandle("shell32.dll");
			StringBuilder sb = new StringBuilder(255);
			LoadString(intPtr, strId, sb, sb.Capacity);
			return sb.ToString();
		}
"@
}
IF (-not ("WinAPI.GetStr" -as [type])) {
	Add-Type @Signature -Using System.Text
}
$unpin = [WinAPI.GetStr]::GetString(5387)
$apps = (New-Object -ComObject Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
$apps | Where-Object -FilterScript { $_.Path -like "Microsoft.MicrosoftEdge*" } | ForEach-Object -Process { $_.Verbs() | Where-Object -FilterScript { $_.Name -eq $unpin } | ForEach-Object -Process { $_.DoIt() } }
$apps | Where-Object -FilterScript { $_.Path -like "Microsoft.WindowsStore*" } | ForEach-Object -Process { $_.Verbs() | Where-Object -FilterScript { $_.Name -eq $unpin } | ForEach-Object -Process { $_.DoIt() } }
# Set the Control Panel view by large icons
# Установить крупные значки в панели управления
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force
# Turn on the display of color on Start menu, taskbar, and action center
# Отображать цвет элементов в меню "Пуск", на панели задач и в центре уведомлений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -PropertyType DWord -Value 1 -Force
# Dark Theme Color for Default Windows Mode
# Режим Windows по умолчанию темный
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force
# Dark theme color for default app mode
# Режим приложений по умолчанию темный
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
# Do not show "New App Installed" notification
# Не показывать уведомление "Установлено новое приложение"
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoNewAppAlert -PropertyType DWord -Value 1 -Force
# Do not show user first sign-in animation
# Не показывать анимацию при первом входе в систему
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableFirstLogonAnimation -PropertyType DWord -Value 0 -Force
# Turn off JPEG desktop wallpaper import quality reduction
# Отключить снижение качества фона рабочего стола в формате JPEG
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -PropertyType DWord -Value 100 -Force
# Show Task Manager details
# Раскрыть окно Диспетчера задач
$taskmgr = Get-Process -Name Taskmgr -ErrorAction SilentlyContinue
IF ($taskmgr) {
	$taskmgr.CloseMainWindow()
}
Start-Process -FilePath Taskmgr.exe -WindowStyle Hidden -PassThru
Do {
	Start-Sleep -Milliseconds 100
	$preferences = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -ErrorAction SilentlyContinue
}
Until ($preferences)
Stop-Process -Name Taskmgr
$preferences.Preferences[28] = 0
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $preferences.Preferences -Force
$Error.RemoveRange(0, $Error.Count)
# Remove Microsoft Edge shortcut from the Desktop
# Удалить ярлык Microsoft Edge с рабочего стола
$value = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
Remove-Item -Path "$value\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue
# Show accent color on the title bars and window borders
# Отображать цвет элементов в заголовках окон и границ окон
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\DWM -Name ColorPrevalence -PropertyType DWord -Value 1 -Force
# Turn off automatically hiding scroll bars
# Отключить автоматическое скрытие полос прокрутки в Windows
# New-ItemProperty -Path "HKCU:\Control Panel\Accessibility" -Name DynamicScrollbars -PropertyType DWord -Value 0 -Force
# Show more Windows Update restart notifications about restarting
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force
# Turn off the "- Shortcut" name extension for new shortcuts
# Нe дoбaвлять "- яpлык" для coздaвaeмыx яpлыкoв
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name link -PropertyType Binary -Value ([byte[]](00, 00, 00, 00)) -Force
# Use the PrtScn button to open screen snipping
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана
# New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 1 -Force
# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
# New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 1 -Force
#endregion UI & Personalization

#region Set folder
# Set location of the "Desktop", "Documents", "Downloads", "Music", "Pictures", and "Videos"
# Переопределить расположение папок "Рабочий стол", "Документы", "Загрузки", "Музыка", "Изображения", "Видео"
Function KnownFolderPath {
	Param (
		[Parameter(Mandatory = $true)]
		[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
		[string]$KnownFolder,

		[Parameter(Mandatory = $true)]
		[string]$Path
	)
	$KnownFolders = @{
		"Desktop"   = @("B4BFCC3A-DB2C-424C-B029-7FE99A87C641");
		"Documents"	= @("FDD39AD0-238F-46AF-ADB4-6C85480369C7", "f42ee2d3-909f-4907-8871-4c22fc0bf756");
		"Downloads"	= @("374DE290-123F-4565-9164-39C4925E467B", "7d83ee9b-2244-4e70-b1f5-5393042af1e4");
		"Music"     = @("4BD8D571-6D19-48D3-BE97-422220080E43", "a0c69a99-21c8-4671-8703-7934162fcf1d");
		"Pictures"  = @("33E28130-4E1E-4676-835A-98395C3BC3BB", "0ddd015d-b06c-45d5-8c4c-f59713854639");
		"Videos"    = @("18989B1D-99B5-455B-841C-AB7C74E4DDFC", "35286a68-3c57-41a1-bbb1-0eae73d76c95");
	}
	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "KnownFolders"
		Language         = "CSharp"
		MemberDefinition = @"
			[DllImport("shell32.dll")]
			public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
"@
	}
	IF (-not ("WinAPI.KnownFolders" -as [type])) {
		Add-Type @Signature
	}
	foreach ($guid in $KnownFolders[$KnownFolder]) {
		[WinAPI.KnownFolders]::SHSetKnownFolderPath([ref]$guid, 0, 0, $Path)
	}
	(Get-Item -Path $Path -Force).Attributes = "ReadOnly"
}
[hashtable] $DesktopINI = @{
	"Desktop"   =	"",
	"[.ShellClassInfo]",
	"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21769",
	"IconResource=%SystemRoot%\system32\imageres.dll,-183"
	"Documents"	=	"",
	"[.ShellClassInfo]",
	"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21770",
	"IconResource=%SystemRoot%\system32\imageres.dll,-112",
	"IconFile=%SystemRoot%\system32\shell32.dll",
	"IconIndex=-235"
	"Downloads"	=	"",
	"[.ShellClassInfo]", "LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21798",
	"IconResource=%SystemRoot%\system32\imageres.dll,-184"
	"Music"     =	"",
	"[.ShellClassInfo]", "LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21790",
	"InfoTip=@%SystemRoot%\system32\shell32.dll,-12689",
	"IconResource=%SystemRoot%\system32\imageres.dll,-108",
	"IconFile=%SystemRoot%\system32\shell32.dll", "IconIndex=-237"
	"Pictures"  =	"",
	"[.ShellClassInfo]",
	"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21779",
	"InfoTip=@%SystemRoot%\system32\shell32.dll,-12688",
	"IconResource=%SystemRoot%\system32\imageres.dll,-113",
	"IconFile=%SystemRoot%\system32\shell32.dll",
	"IconIndex=-236"
	"Videos"    =	"",
	"[.ShellClassInfo]",
	"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21791",
	"InfoTip=@%SystemRoot%\system32\shell32.dll,-12690",
	"IconResource=%SystemRoot%\system32\imageres.dll,-189",
	"IconFile=%SystemRoot%\system32\shell32.dll", "IconIndex=-238"
}
$drives = (Get-Disk | Where-Object -FilterScript { $_.BusType -ne "USB" } | Get-Partition | Get-Volume).DriveLetter
$OFS = ", "
Write-Host "`nYour drives: " -NoNewline
Write-Host "$($drives | Sort-Object -Unique)" -ForegroundColor Yellow
$OFS = " "
# Documents
# Документы
# Write-Host "`nType the drive letter in the root of which the " -NoNewline
# Write-Host "`"Documents`" " -ForegroundColor Yellow -NoNewline
# Write-Host "folder will be created."
# Write-Host "Files will not be moved. Do it manually"
# Write-Host "`nPress Enter to skip" -NoNewline
# Do {
# 	$drive = Read-Host -Prompt " "
# 	IF ($drives -eq $drive) {
# 		$drive = $(${drive}.ToUpper())
# 		$DocumentsFolder = "${drive}:\Documents"
# 		$DocumentsReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Personal
# 		IF ($DocumentsReg -ne $DocumentsFolder) {
# 			IF (-not (Test-Path -Path $DocumentsFolder)) {
# 				New-Item -Path $DocumentsFolder -ItemType Directory -Force
# 			}
# 			KnownFolderPath -KnownFolder Documents -Path $DocumentsFolder
# 			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{F42EE2D3-909F-4907-8871-4C22FC0BF756}" -PropertyType ExpandString -Value $DocumentsFolder -Force
# 			Set-Content -Path "$DocumentsFolder\desktop.ini" -Value $DesktopINI["Documents"] -Encoding Unicode -Force
# 			(Get-Item -Path "$DocumentsFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
# 			(Get-Item -Path "$DocumentsFolder\desktop.ini" -Force).Refresh()
# 		}
# 	}
# 	elseif ([string]::IsNullOrEmpty($drive)) {
# 		break
# 	}
# 	else {
# 		Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
# 		Write-Host "Type the drive letter."
# 		Write-Host "`nPress Enter to skip" -NoNewline
# 	}
# }
# Until ($drives -eq $drive)
# Downloads
# Загрузки
Write-Host "`nType the drive letter in the root of which the " -NoNewline
Write-Host "`"Downloads`" " -ForegroundColor Yellow -NoNewline
Write-Host "folder will be created."
Write-Host "Files will not be moved. Do it manually"
Write-Host "`nPress Enter to skip" -NoNewline
Do {
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive) {
		$drive = $(${drive}.ToUpper())
		$DownloadsFolder = "${drive}:\Downloads"
		$DownloadsReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
		IF ($DownloadsReg -ne $DownloadsFolder) {
			IF (-not (Test-Path -Path $DownloadsFolder)) {
				New-Item -Path $DownloadsFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Downloads -Path $DownloadsFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" -PropertyType ExpandString -Value $DownloadsFolder -Force
			Set-Content -Path "$DownloadsFolder\desktop.ini" -Value $DesktopINI["Downloads"] -Encoding Unicode -Force
			(Get-Item -Path "$DownloadsFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$DownloadsFolder\desktop.ini" -Force).Refresh()
			# Microsoft Edge downloads folder
			# Папка загрузок Microsoft Edge
			$edge = (Get-AppxPackage "Microsoft.MicrosoftEdge").PackageFamilyName
			New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\Main" -Name "Default Download Directory" -PropertyType String -Value $DownloadsFolder -Force
		}
	}
	elseif ([string]::IsNullOrEmpty($drive)) {
		break
	}
	else {
		Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
		Write-Host "Type the drive letter."
		Write-Host "`nPress Enter to skip" -NoNewline
	}
}
Until ($drives -eq $drive)
# Music
# Музыка
Write-Host "`nType the drive letter in the root of which the " -NoNewline
Write-Host "`"Music`" " -ForegroundColor Yellow -NoNewline
Write-Host "folder will be created."
Write-Host "Files will not be moved. Do it manually"
Write-Host "`nPress Enter to skip" -NoNewline
Do {
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive) {
		$drive = $(${drive}.ToUpper())
		$MusicFolder = "${drive}:\Music"
		$MusicReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music"
		IF ($MusicReg -ne $MusicFolder) {
			IF (-not (Test-Path -Path $MusicFolder)) {
				New-Item -Path $MusicFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Music -Path $MusicFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{A0C69A99-21C8-4671-8703-7934162FCF1D}" -PropertyType ExpandString -Value $MusicFolder -Force
			Set-Content -Path "$MusicFolder\desktop.ini" -Value $DesktopINI["Music"] -Encoding Unicode -Force
			(Get-Item -Path "$MusicFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$MusicFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive)) {
		break
	}
	else {
		Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
		Write-Host "Type the drive letter."
		Write-Host "`nPress Enter to skip" -NoNewline
	}
}
Until ($drives -eq $drive)
# Pictures
# Изображения
Write-Host "`nType the drive letter in the root of which the " -NoNewline
Write-Host "`"Pictures`" " -ForegroundColor Yellow -NoNewline
Write-Host "folder will be created."
Write-Host "Files will not be moved. Do it manually"
Write-Host "`nPress Enter to skip" -NoNewline
Do {
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive) {
		$drive = $(${drive}.ToUpper())
		$PicturesFolder = "${drive}:\Pictures"
		$PicturesReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures"
		IF ($PicturesReg -ne $PicturesFolder) {
			IF (-not (Test-Path -Path $PicturesFolder)) {
				New-Item -Path $PicturesFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Pictures -Path $PicturesFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{0DDD015D-B06C-45D5-8C4C-F59713854639}" -PropertyType ExpandString -Value $PicturesFolder -Force
			Set-Content -Path "$PicturesFolder\desktop.ini" -Value $DesktopINI["Pictures"] -Encoding Unicode -Force
			(Get-Item -Path "$PicturesFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$PicturesFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive)) {
		break
	}
	else {
		Write-Host "`nThe disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
		Write-Host "Type the drive letter."
		Write-Host "`nPress Enter to skip" -NoNewline
	}
}
Until ($drives -eq $drive)
# Videos
# Видео
Write-Host "`nType the drive letter in the root of which the " -NoNewline
Write-Host "`"Videos`" " -ForegroundColor Yellow -NoNewline
Write-Host "folder will be created."
Write-Host "Files will not be moved. Do it manually"
Write-Host "`nPress Enter to skip" -NoNewline
Do {
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive) {
		$drive = $(${drive}.ToUpper())
		$VideosFolder = "${drive}:\Videos"
		$VideosReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video"
		IF ($VideosReg -ne $VideosFolder) {
			IF (-not (Test-Path -Path $VideosFolder)) {
				New-Item -Path $VideosFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Videos -Path $VideosFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" -PropertyType ExpandString -Value $VideosFolder -Force
			Set-Content -Path "$VideosFolder\desktop.ini" -Value $DesktopINI["Videos"] -Encoding Unicode -Force
			(Get-Item -Path "$VideosFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$VideosFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive)) {
		break
	}
	else {
		Write-Host "`nThe disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
		Write-Host "Type the drive letter."
		Write-Host "`nPress Enter to skip" -NoNewline
	}
}
Until ($drives -eq $drive)
#endregion Set folder

#region System
# Disable mouse acceleration
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSensitivity -PropertyType String -Value 10 -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -PropertyType String -Value 0 -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseThreshold1 -PropertyType String -Value 0 -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseThreshold2 -PropertyType String -Value 0 -Force
$Xcurve = "00,00,00,00,00,00,00,00,C0,CC,0C,00,00,00,00,00,80,99,19,00,00,00,00,00,40,66,26,00,00,00,00,00,00,33,33,00,00,00,00,00".Split(',') | ForEach-Object { "0x$_"}
$Ycurve = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00".Split(',') | ForEach-Object { "0x$_"}
New-ItemProperty -path "HKCU:\Control Panel\Mouse" -name SmoothMouseXCurve -propertytype Binary -value ([byte[]] $Xcurve) -Force
New-ItemProperty -path "HKCU:\Control Panel\Mouse" -name SmoothMouseYCurve -propertytype Binary -value ([byte[]] $Ycurve) -Force
New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Mouse" -Name MouseSpeed -PropertyType String -Value 0 -Force
New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Mouse" -Name MouseThreshold1 -PropertyType String -Value 0 -Force
New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Mouse" -Name MouseThreshold2 -PropertyType String -Value 0 -Force
# Turn on OpenSSH
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
# Turn off Delivery Optimization
# Отключить оптимизацию доставки
Get-Service -Name DoSvc | Stop-Service -Force
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Name DODownloadMode -PropertyType DWord -Value 0 -Force
# Turn off F1 Help key
# Отключить справку по нажатию F1
IF (-not (Test-Path -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64")) {
	New-Item -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Force
}
New-ItemProperty -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Name "(default)" -PropertyType String -Value "" -Force
# Turn off sticky Shift key after pressing 5 times
# Отключить залипание клавиши Shift после 5 нажатий
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -PropertyType String -Value 506 -Force
#endregion System

#region Context menu
# Remove "Cast to Device" from context menu
# Удалить пункт "Передать на устройство" из контекстного меню
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "Play to menu" -Force
# Remove "Share" from context menu
# Удалить пункт "Отправить" (поделиться) из контекстного меню
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -PropertyType String -Value "" -Force
# Remove "Previous Versions" from file context menu
# Удалить пункт "Восстановить прежнюю версию" из контекстного меню
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{596AB062-B4D2-4215-9F74-E9109B0A8153}" -PropertyType String -Value "" -Force
# Remove "Edit with Paint 3D" from context menu
# Удалить пункт "Изменить с помощью Paint 3D" из контекстного меню
$exts = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
foreach ($ext in $exts) {
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$ext\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}
# Remove "Include in Library" from context menu
# Удалить пункт "Добавить в библиотеку" из контекстного меню
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(default)" -PropertyType String -Value "-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force
# Remove "Edit with Photos" from context menu
# Удалить пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
# Turn off "Look for an app in the Microsoft Store" in "Open with" dialog
# Отключить поиск программ в Microsoft Store при открытии диалога "Открыть с помощью"
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoUseStoreOpenWith -PropertyType DWord -Value 1 -Force
#endregion Context menu

#region DNS
Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object ServerAddresses -NE $null | Set-DnsClientServerAddress -ServerAddresses 1.1.1.1, 1.0.0.1
Get-DnsClientServerAddress -AddressFamily IPv6 | Where-Object ServerAddresses -NE $null | Set-DnsClientServerAddress -ServerAddresses 2606:4700:4700::1111, 2606:4700:4700::1001
#endregion DNS

#region WSL 
# Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -WarningAction SilentlyContinue | Out-Null
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -WarningAction SilentlyContinue | Out-Null
#endregion WSL

#region Chocolatey 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RefreshEnv.cmd
choco feature enable -n=allowGlobalConfirmation
Get-Content ".\install\choco.txt" | ForEach-Object {
	cinst.exe "$_"
}
RefreshEnv.cmd
#endregion Chocolatey

#region Python
$pyversion = ((pyenv install -l).split('\n') | Where-Object { $_ -like "*-amd64"})[0]
pyenv install $pyversion
pyenv global $pyversion
pyenv rehash
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py" -OutFile temp\get-poetry.py; python ".\temp\get-poetry.py"
Get-Content ".\install\pip.txt" | ForEach-Object {
	pip install "$_"
}
pyenv rehash
#endregion Python

#region Node
nvm on
$nodeversion = ((Invoke-WebRequest -Uri https://nodejs.org/dist/index.json | ConvertFrom-Json) | Where-Object { $_.lts  -cne $false})[0].version.substring(1)
nvm install $nodeversion
nvm use $nodeversion
Get-Content ".\install\npm.txt" | ForEach-Object {
	npm install -g "$_"
}
#endregion Node

#region Vscode-user
# Invoke-WebRequest -Uri 'https://aka.ms/win32-x64-user-stable' -Out ".\temp\vscode.exe"
# Start-Process -Wait -NoNewWindow -FilePath "vscode.exe" -ArgumentList '/verysilent /suppressmsgboxes /mergetasks="!runCode, quicklaunchicon, addcontextmenufiles, addcontextmenufolders, addtopath"' -PassThru
# code --install-extension Shan.code-settings-sync
#endregion Vscode-user

#region Aria2
# not in use..since its not fast enough
# $download = (Invoke-WebRequest "https://api.github.com/repos/mayswind/AriaNg-Native/releases" | ConvertFrom-Json)[0].assets | Where-Object browser_download_url -Match "x64.msi"
# Invoke-WebRequest -Uri $download.browser_download_url -Out ariang.msi
# Start-Process -FilePath msiexec.exe -ArgumentList '/i', 'ariang.msi', '/q' -Wait -PassThru
# # $userShellFoldersPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
# # $downDIR = (Get-ItemProperty $userShellFoldersPath).'{374DE290-123F-4565-9164-39C4925E467B}'
# $downDIR = Read-Host -Prompt 'Input your download location'
# "dir=$downDIR" >> .aria2
# nssm.exe install Aria2 powershell.exe C:\ProgramData\chocolatey\bin\aria2c.exe --conf-path=$env:USERPROFILE\.aria2 
#endregion Aria2

#region Random stuffs

[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\Program Files\mpv.net", "Machine")
git config --global core.editor "code --wait"
code --install-extension Shan.code-settings-sync
#endregion Random stuffs

#region Gdrive mount
# Replaced by cracked ExpanDrive ¯\_(ツ)_/¯
# $Rconfpara = "mount --allow-other --dir-cache-time 72h --drive-chunk-size 64M --log-level INFO --vfs-read-chunk-size 32M --vfs-read-chunk-size-limit off --vfs-cache-mode full --config $env:USERPROFILE\.config\rclone\rclone.conf"
# nssm.exe install RcloneMount1 C:\ProgramData\chocolatey\bin\rclone.exe $Rconfpara gdrive: E:
# nssm.exe install RcloneMount2 C:\ProgramData\chocolatey\bin\rclone.exe $Rconfpara gdrivecollege: F:
# nssm.exe set RcloneMount1 AppThrottle 10000
# nssm.exe set RcloneMount2 AppThrottle 10000
#endregion Gdrive mount

#region Powershell
Get-Content ".\install\powershell.txt" | ForEach-Object {
	Install-Module "$_" -Scope CurrentUser -AllowClobber -Force
}
Get-Content ".\install\powershell_pre.txt" | ForEach-Object {
	Install-Module "$_" -Scope CurrentUser -AllowClobber -AllowPrerelease -Force
}
$profileDir = Split-Path -parent $profile
if (-Not (Test-Path $profileDir)) {
	mkdir $profileDir
}
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua' -Out "$profileDir\z.lua"
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/mattparkes/PoShFuck/master/Install-TheFucker.ps1'))
Copy-Item -Path ./powershell/*.ps1 -Destination $profileDir
#endregion Powershell
