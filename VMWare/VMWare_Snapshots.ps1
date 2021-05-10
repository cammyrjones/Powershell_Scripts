Write-Output "Note: You will need VMware PowerCLI module"

$VMHost = Read-host "What is the name/ip of the host"


Connect-VIServer -server $VMHost

Get-VM | Get-Snapshot | Select VM,Description,powerstate,created,@{Label="Size";Expression={"{0:N2} GB" -f ($_.SizeGB)}},Name | Format-Table -AutoSize
Pause

Disconnect-VIserver -force -confirm:$false