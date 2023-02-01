# Initial Profile File for PowerShell Host
# Created 14 Aug 2020
# tfl@psp.co.uk

# For use with PowerShell Console (and inside MS Terminal)

# 1. Write host details
Write-Host "On          [$(hostname)]"
Write-Host "Customising [$($Host.Name)]"

# 2. Set $Me
$ME = whoami
Write-Host "Logged on as $ME"

# 3. Set Format enumeration limit
$FormatEnumerationLimit = 99

# 4. Set some command defaults
$PSDefaultParameterValues = @{
  "Format-Table:autosize" = $true
  'Receive-Job:keep'      = $true
  'Format-*:Wrap'         = $true
}

# 5. Set home to C:\Foo for ~, then go there
New-Item C:\Foo -ItemType Directory -Force -EA 0 | out-null
$Provider = Get-PSProvider FileSystem
$Provider.Home = 'C:\Foo'
Set-Location -Path ~
Write-Host 'Setting home to C:\Foo'

# 6. Add a new function Get-HelpDetailed
Function Get-HelpDetailed {
    Get-Help $args[0] -Detailed
} # END Get-HelpDetailed Function

# 7. Set aliases for help
Set-Alias gh    Get-Help
Set-Alias ghd   Get-HelpDetailed

# 8. Create Reskit Credential
$Urk = 'Reskit\Administrator'
$Prk = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$Credrk = [pscredential]::New($Urk, $Prk)
Write-Host "`$Credrk created for $($credrk.username)"

Write-Host "Completed Customisations to $(hostname)"