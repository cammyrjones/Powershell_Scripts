# This script will tell you the expiry date and the date a users password was set
$Firstname = Read-Host "Enter the users first name"
$Surname = Read-Host "Enter the users surname"

$Usernames =@()


$Usernames += (Get-ADUser -Filter { ( Givenname -eq $Firstname) -and ( Surname -eq $Surname ) } | Select-Object -ExpandProperty samaccountname)

Foreach ($Username in $Usernames){
$output = (Get-ADUser $Username –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed", "passwordlastset" | Select-Object -Property "Samaccountname","Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}},"passwordlastset")

Write-Host $output | Format-Table
}
Pause