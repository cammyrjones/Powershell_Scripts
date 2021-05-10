Write-Output "Note: You will need VMware PowerCLI module"

$VMHost = Read-host "What is the name/ip of the host" #Gets the host info

Connect-VIServer -server $VMHost #Connects to the VM host using info from above

$Location = Read-Host "What is the name of the container" #Gets the name of the resource group

$VMs = Get-VM -Location "$Location" | Sort-Object Name | Select-Object -ExpandProperty Name

Foreach ($VM in $VMlist){
$VMGuestOS = Get-VM $VM
Write-host $VMGuestOS | Format-Table
}

Disconnect-VIserver -force -confirm:$false