# Recipe 2.4 - Exploring PowerShellGet
# This recipe looks at what you can get with the tools in the PowerShellGet module
# Run on SRV1
# Run as administrator

# 1. Reviewing the commands available in the PowerShellGet module
Get-Command -Module PowerShellGet

# 2. Discovering Find-* cmdlets in PowerShellGet module
Get-Command -Module PowerShellGet -Verb Find

# 3. Getting all commands, modules, DSC resources and scripts
$COM = Find-Command
$MOD = Find-Module
$DSC = Find-DscResource
$SCR = Find-Script

# 4. Reporting on results
"On Host [$(hostname)]"
"Commands found:          [{0:N0}]"  -f $COM.count
"Modules found:           [{0:N0}]"  -f $MOD.count
"DSC Resources found:     [{0:N0}]"  -f $DSC.count
"Scripts found:           [{0:N0}]"  -f $SCR.count

# 5. Discovering NTFS-related modules
$MOD |
  Where-Object Name -match NTFS

# 6. Installing the NTFSSecurity module
Install-Module -Name NTFSSecurity -Force

# 7. Reviewing module contents
Get-Command -Module NTFSSecurity

# 8. Testing the Get-NTFSAccess cmdlet
Get-NTFSAccess -Path C:\Foo

# 9. Creating a download folder
$DLFLDR = 'C:\Foo\DownloadedModules'
$NIHT = @{
  ItemType = 'Directory'
  Path     = $DLFLDR
  ErrorAction = 'SilentlyContinue'
}
New-Item @NIHT | Out-Null

# 10. Downloading the PSLogging module
Save-Module -Name PSLogging -Path $DLFLDR

# 11. Viewing the contents of the download folder
Get-ChildItem -Path $DLFLDR -Recurse -Depth 2|
  Format-Table -Property FullName

# 12.Checking commands in the module
Import-Module -name $DLFLDR\PSLogging
Get-Command -Module PSLogging
