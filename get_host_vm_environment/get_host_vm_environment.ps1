# Create a filename based on a time stamp
$logname = (get-date -Format yyyyMMdd-HHmmss).ToString() + ".txt"
$logpath = "c:\temp\$logname"

# maybe change this for get-adcomputer for our OU
#$hypervservers = Get-ADGroupMember -Identity "CCCS-CG-Hyper_V_Hosts" |Select-Object -ExpandProperty name|sort
$hypervservers = "ccs-hyperv4"

#foreach computer object found, write the name to the output file, run get-vm and copy output to file, write a separator to file
foreach ($hypervserver in $hypervservers) {
    if (Test-Connection -ComputerName "$hypervserver" -BufferSize 16 -Count 1 -Quiet) {
        $session = New-PSSession -ComputerName $hypervserver
        $hostram = ((((Get-CimInstance Win32_PhysicalMemory -ComputerName $hypervserver).Capacity|Measure-Object -Sum).Sum) / 1gb)
        $hostdisk = Invoke-Command -Session $session -ScriptBlock {Get-PSDrive -PSProvider FileSystem |Where-Object {$_.Used -ne "0"}|Select-Object -Property name, @{Name = "UsedGB"; Expression = {[math]::round($_.used / 1gb, 2)}}, @{Name = "FreeGB"; Expression = {[math]::round($_.free / 1gb, 2)}}|Format-Table -AutoSize|Out-String}
        $vmlist = Invoke-Command -Session $session -ScriptBlock {Get-VM |Select-Object * |Sort-Object -Property name}

        Add-Content -Path $logpath -Value "HOST:$hypervserver" -Encoding Ascii
        Add-Content -Path $logpath -Value "Total RAM = $hostram GB" -Encoding Ascii
        Add-Content -Path $logpath -Value "Drives:" -Encoding Ascii

        Add-Content -Path $logpath -Value $hostdisk -Encoding Ascii

        Add-Content -Path $logpath -Value "VMs:" -Encoding Ascii
        foreach ($vm in $vmlist) {
            $vmram = Invoke-Command -Session $session -ScriptBlock {Get-VM -VMName $using:vm.VMName| Get-VMMemory|Select-Object -Property @{Name = "Max RAM in GB:"; Expression = {[math]::round($_.startup / 1gb, 2)}} |Format-Table -AutoSize|Out-String}
            $vmdisk = Invoke-Command -Session $session -ScriptBlock {Get-VM –VMname $using:vm.VMName | Select-Object VMId | Get-VHD | Select-Object –Property path, vhdtype, @{label = ’Size(GB)’; expression = {$_.filesize / 1gb –as [int]}}|Format-Table -AutoSize |Out-String}
            $vmfcs = Invoke-Command -ComputerName $vm.VMName -ScriptBlock {Get-Service -Name *fcs*|Format-Table -AutoSize|Out-String}
            Add-Content -Path $logpath -Value $vm.Name, " State:", $vm.State -Encoding Ascii
            Add-Content -Path $logpath -Value $vmram -Encoding Ascii
            Add-Content -Path $logpath -Value "VHD info:" -Encoding Ascii
            Add-Content -Path $logpath -Value $vmdisk -Encoding Ascii
            Add-Content -Path $logpath -Value "List any FCS services:"
            Add-Content -Path $logpath -Value $vmfcs -Encoding Ascii
            #put this at the end of each server entry as it serves as a divider
            Add-Content -Path $logpath "------------------------------------------------------------------------------------------------------------------------------------" -Encoding Ascii

        }
        

        
        Remove-PSSession -Session $session
    }
}





#don't want to see errors as we don't care - silently continue
Get-WmiObject win32_Service -Computer $vm -ErrorAction SilentlyContinue |
    Where-Object {$_.name -like "*_FCS"} | 
    Select-Object SystemName, DisplayName, Name|Out-File $logpath -Append -Encoding ascii
#Format-Table -AutoSize