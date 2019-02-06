#you're going to need to add a timeout to get-wmiobject as the script will hang when waiting for systems that are down....

$computers = Get-ADGroupMember -Identity "CCCS-CG-Hyper_V_Hosts" |Select-Object -ExpandProperty name|Sort-Object
#loop through the list
foreach ($computer in $computers){
$manufacturer = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer | Select-Object -ExpandProperty Manufacturer
Write-Host "$computer manufacturer is $manufacturer"
}