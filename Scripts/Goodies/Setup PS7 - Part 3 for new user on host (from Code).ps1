#requires –RunAsAdministrator
# Short cut Part 2

# Run inside Elevated VS Code

# 0. Ensure we are running as admin
$ID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$P = New-Object System.Security.Principal.WindowsPrincipal($ID)
$Role = $P.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
if ($Role) {
  Write-Host "Running in elevated console"
}  else  {
  Write-Host "Not running in elevated console"
  exit
}

# 1. Using VS Code, create a Sample Profile File for VS Code
Write-Host "Creating VS Code Default profile"
$VSCodeProfileFile = $Profile.CurrentUserCurrentHost
New-Item $VSCodeProfileFile -Force -WarningAction SilentlyContinue | Out-Null
$VSCodePS7Sample =
  'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master/' +
  'scripts/goodies/Microsoft.VSCode_profile.ps1'
Start-BitsTransfer -Source $VSCodePS7Sample -Destination $VSCodeProfileFile

Write-Host 'Creating PWSH 7 Console Profile'
$ProfilePath = Split-Path -Path $VSCodeProfileFile
$ConsoleProfile = Join-Path -Path $ProfilePath -ChildPath 'Microsoft.PowerShell_profile.ps1'
New-Item $ConsoleProfile -Force -WarningAction SilentlyContinue | Out-Null
$ConsolePS7Sample =
  'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master/' +
  'scripts/goodies/Microsoft.PowerShell_Profile.ps1'
Start-BitsTransfer -Source $ConsolePS7Sample -Destination $ConsoleProfile

# 2. Update Local User Settings for VS Code
$JSON = @'
{
  "workbench.colorTheme": "Visual Studio Light",
  "powershell.codeFormatting.useCorrectCasing": true,
  "files.autoSave": "onWindowChange",
  "files.defaultLanguage": "powershell",
  "editor.fontFamily": "'Cascadia Code',Consolas,'Courier New'",
  "workbench.editor.highlightModifiedTabs": true,
  "window.zoomLevel": 1,
  "terminal.integrated.shell.windows": "C:\\Program Files\\PowerShell\\7\\pwsh.exe",
  "powershell.powerShellAdditionalExePaths": [
    {
        "exePath": "C:\\PSDailyBuild\\pwsh.exe",
        "versionName": "PowerShell 7.1 Daily Build"
    },
    {
        "exePath": "C:\\PSPreview\\pwsh.exe",
        "versionName": "PowerSHell 7.1 Preview Latest"
    }
  ]
}
'@
$JHT = ConvertFrom-Json -InputObject $JSON -AsHashtable

$Path = $Env:APPDATA
$CP   = '\Code\User\Settings.json'
$Settings = Join-Path  $Path -ChildPath $CP
$JHT |
  ConvertTo-Json  |
    Out-File -FilePath $Settings

# 4. Create VSCode Profile for PowerShell 7
Write-Host 'Creating PowerShell 7 VS Code Profile'
$CUCHProfile   = $profile.CurrentUserCurrentHost
$ProfileFolder = Split-Path -Path $CUCHProfile
$ProfileFile   = 'Microsoft.VSCode_profile.ps1'
$VSProfile     = Join-Path -Path $ProfileFolder -ChildPath $ProfileFile
$URI = 'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master/' +
       "scripts/goodies/$ProfileFile"
New-Item $VSProfile -Force -WarningAction SilentlyContinue |
   Out-Null
Start-BitsTransfer -Source $URI  -Destination $VSProfile

# 5. Create PS 7 Console profile
Write-Host 'Creating PowerShell 7 Console Profile'
$ProfileFile2   = 'Microsoft.PowerShell_Profile.ps1'
$ConsoleProfile = Join-Path -Path $ProfileFolder -ChildPath $ProfileFile2
New-Item $ConsoleProfile -Force -WarningAction SilentlyContinue |
   Out-Null
$URI2 = 'https://raw.githubusercontent.com/doctordns/PACKT-PS7/master/' +
        "scripts/goodies/$ProfileFile2"
Start-BitsTransfer -Source $URI2 -Destination $ConsoleProfile

