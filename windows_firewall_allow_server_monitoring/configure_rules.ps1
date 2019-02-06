#get list of servers
$computers = Get-ADGroupMember -Identity "CCCS-CG-Hyper_V_Hosts" |Select-Object -ExpandProperty name|sort
#loop through the list
foreach ($computer in $computers) {
    #get the manufacturer property
    $manufacturer = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer | Select-Object -ExpandProperty Manufacturer
    #if manufacturer name contains dell, update the firewall rules to allow OMSA
    if ($manufacturer -like '*dell*') {
        write-host "$computer is a dell server, will update firewall rules to allow OMSA"
        Invoke-Command -ComputerName $computer -ScriptBlock {New-NetFirewallRule -DisplayName "Allow OMSA connection from Domain" -Direction Inbound -Protocol TCP -Profile Domain -Action Allow -LocalPort 1311} -AsJob -Verbose
    }
    else {
        write-host "$computer is not a dell server, nothing to do"
    }
}