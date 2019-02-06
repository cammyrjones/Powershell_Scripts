# Create a filename based on a time stamp
$logname = (get-date -Format yyyyMMdd-HHmmss).ToString() + ".txt"
# Set the log path.
$logpath = "c:\temp\$logname"

$hypervservers = Get-ADGroupMember -Identity "CCCS-CG-DEV-Hyper_V_Hosts" |Select-Object -ExpandProperty name|Sort-Object

#$hypervservers = "ccs-hyperv4","ccs-hyperv3"

#foreach computer object found, write the name to the output file, run get-vm and copy output to file, write a separator to file
foreach ($hypervserver in $hypervservers) {
    Add-Content -Path $logpath "HOST:$hypervserver" -Encoding Ascii
    Add-Content -Path $logpath "VMs:" -Encoding Ascii
    if ((Get-ADComputer $hypervserver -Properties name, operatingsystem | Select-Object -ExpandProperty operatingsystem) | Select-String "2008") {
        $nameProperty = "elementname"
    }
    else {
        $nameProperty = "name"
    }
    Invoke-Command -ComputerName $hypervserver -ScriptBlock {Get-VM |Select-Object -ExpandProperty $using:nameProperty} |Out-File $logpath -Append -Encoding ascii
    Add-Content -Path $logpath "----------------------------" -Encoding Ascii
}