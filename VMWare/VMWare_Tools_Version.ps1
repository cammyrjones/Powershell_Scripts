Write-Output "Note: You will need VMware PowerCLI module"

$VMHost = Read-host "What is the name/ip of the host"


Connect-VIServer -server $VMHost

get-vm | get-vmguest | select VMName, ToolsVersion | FT -autosize

Disconnect-VIserver -force -confirm:$false