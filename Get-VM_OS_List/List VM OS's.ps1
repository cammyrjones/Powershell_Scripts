$VMHost = Read-host "What is the name/ip of the host"


Connect-VIServer -server $VMHost

#$Location = Read-Host "What is the name of the container"

$VMs = Get-VM | Sort-Object Name | Select-Object -ExpandProperty Name  | Out-File -FilePath "C:\temp\List.txt"
$VMList = Get-Content C:\temp\List.txt

Foreach ($VM in $VMlist){
$VMGuestOS = Get-VMGuest -VM $VM
Write-host $VMGuestOS | Format-Table
}

Disconnect-VIserver -force -confirm:$false