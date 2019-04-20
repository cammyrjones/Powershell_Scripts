$Computers = @(
"win10test"
)
$EmailAddresses = @(
""
)

$Usernames = @()

foreach($EmailAddress in $EmailAddresses){
$Usernames += (Get-ADUser -Filter { EmailAddress -eq $EmailAddress } | Select-Object -ExpandProperty samaccountname)
} 


foreach ($Computer in $Computers)
{
Foreach ($Username in $Usernames){
Invoke-Command -ComputerName $Computer -ScriptBlock { NET LOCALGROUP "Remote Desktop Users" /add "$Using:Username" } -AsJob
#Write-Output "Will add user $Username to group on $Computer"
}
}