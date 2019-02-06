$Username = Read-Host "Enter the username"

$User = Get-ADUser $Username -properties pwdlastset
$User.pwdlastset = 0
Set-ADUser -Instance $User
$user.pwdlastset = -1
Set-ADUser -instance $User