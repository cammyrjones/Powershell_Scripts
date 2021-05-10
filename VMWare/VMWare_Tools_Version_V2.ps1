Write-Output "Note: You will need VMware PowerCLI module"

$VMHost = Read-host "What is the name/ip of the host"


Connect-VIServer -server $VMHost

Get-VM | Get-View | Select-Object @{N=”VM Name”;E={$_.Name}},@{Name=”VMware Tools”;E={$_.Guest.ToolsStatus}},@{Name='ToolsVersion';E={$_.Guest.ToolsVersion}} | Export-CSV c:\Temp\VMwareToolsStatus.csv

Disconnect-VIserver -force -confirm:$false