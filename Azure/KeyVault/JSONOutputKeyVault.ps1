
# Purpose: To produce a JSON document from KeyVault
#Author: Prateek Chaudhary


#Login-AzureRmAccount
$vaultname_source = Read-Host "Which keyvault would you like to export JSON of. Press Enter after typing the name of KeyVault?"

$path= "C:\KeyVaultTemp"
if(!(Test-Path -Path $path))
{
New-Item -path c:\ -name KeyVaultTemp -itemtype directory
}

$writefile= "C:\KeyVaultTemp\$vaultname_source.txt"
$modfile = "C:\KeyVaultTemp\Mod+$vaultname_source.txt"
$secreats= "C:\KeyVaultTemp\$vaultname_source.json" 
Get-AzureKeyVaultSecret -VaultName $vaultname_source | Format-Table -Property Name -AutoSize -Wrap -HideTableHeaders | Out-File $writefile
gc $writefile | ? {$_.trim() -ne "" } | set-content $modfile
$content = Get-Content $modfile
$content | Foreach {$_.TrimEnd()} | Set-Content $modfile
foreach($line in [System.IO.File]::ReadLines($modfile))
{
 $name = $line.ToString();
 Get-AzureKeyVaultSecret -VaultName $vaultname_source -Name $name | ConvertTo-Json |% { [regex]::Unescape($_) }| Add-Content $secreats
}
Remove-Item -Path $writefile
Remove-Item -Path $modfile
Write-Host "You can find the JSON template under C:\KeyVaultTemp"