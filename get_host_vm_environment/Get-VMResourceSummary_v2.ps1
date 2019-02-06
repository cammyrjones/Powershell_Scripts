# Create a filename based on a time stamp
$logname = (get-date -Format yyyyMMdd-HHmmss).ToString()+".txt"
$logpath = "c:\temp\$logname"


#$hypervservers = Get-ADGroupMember -Identity "CCCS-CG-Hyper_V_Hosts" |Select-Object -ExpandProperty name|sort
$hypervservers = "ccs-hyperv8"

foreach ($hypervserver in $hypervservers) 
{
 if (Test-Connection -ComputerName "$hypervserver" -BufferSize 16 -Count 1 -Quiet) 
    {
        #$VMs = (Get-VM -ComputerName $hypervserver)
        $session = New-PSSession -ComputerName $hypervserver
        $vms = (Invoke-Command -Session $session -ScriptBlock {Get-VM |Select-Object * |sort -Property name})
        $hostdisk = Invoke-Command -Session $session -ScriptBlock {Get-PSDrive -PSProvider FileSystem |where {$_.Used -ne "0"}|Select-Object -Property name,@{Name="UsedGB";Expression={[math]::round($_.used/1gb,2)}},@{Name="FreeGB";Expression={[math]::round($_.free/1gb,2)}}|Format-Table -AutoSize|Out-String}
        
        Add-Content -Path $logpath -Value "Host name: $hypervserver" -Encoding Ascii
        Add-Content -Path $logpath -Value "Drives:" -Encoding Ascii
        Add-Content -Path $logpath -Value $hostdisk -Encoding Ascii
        Add-Content -Path $logpath -Value ("Number of VMs: " + ($VMs.Count))
        
        $colVMs = @()
        foreach ($VM in $VMs)
        {
           $vmfcs = $null
           if (Test-Connection -ComputerName $vm.VMName -BufferSize 16 -Count 1 -Quiet) 
            {
                $vmfcs = [string](Invoke-Command -ComputerName $vm.VMName -ScriptBlock {Get-Service -Name *fcs*|Select-Object -ExpandProperty displayname})
            }
          
          $objVM = New-Object System.Object
          $objVM | Add-Member -MemberType NoteProperty -Name VMName -Value $VM.VMName
          $objVM | Add-Member -MemberType NoteProperty -Name VMState -Value $VM.State
          $objVM | Add-Member -MemberType NoteProperty -Name VMDynamicMemoryEnabled -Value $VM.DynamicMemoryEnabled
          $objVM | Add-Member -MemberType NoteProperty -Name VMStaticRAM -Value $VM.MemoryStartup 
          if ($vm.DynamicMemoryEnabled) {
            $objVM | Add-Member -MemberType NoteProperty -Name VMDynamicMemoryMax -Value $VM.MemoryMaximum 
          } else {
            $objVM | Add-Member -MemberType NoteProperty -Name VMDynamicMemoryMax -Value 0
          }
          $objVM | Add-Member -MemberType NoteProperty -Name VMCPUCount -Value ([int]$VM.ProcessorCount)
          $objVM | Add-Member -MemberType NoteProperty -Name FCS -Value ($vmfcs)
  
          $colVMs += $objVM
          
        }


        # display all VMs and their values, nicely formatted
        $a = @{Expression={$_.VMName};Label='VM Name'}, `
             @{Expression={$_.VMState};Label='State'}, `
             @{Expression={$_.VMDynamicMemoryEnabled};Label='DynMem enabled'}, `
             @{Expression={('{0:N1}' -f($_.VMStaticRAM/1GB))};Label='Static/startup RAM (GB)';align='right'}, `
             @{Expression={('{0:N1}' -f([Double]$_.VMDynamicMemoryMax/1GB))};Label='Dynamic Mem max (GB)';align='right'}, `
             @{Expression={$_.VMCPUCount};Label='vCPU count';align='right'}, `
             @{Expression={$_.FCS};Label='FCS Services';align='right'}

        $colVMs | Sort-Object VMName | Format-Table $a -Autosize|Out-String |Add-Content -Path $logpath -Encoding Ascii

        # display sums, max/min, and averages
        $b = @{Expression={$_.Property};Label='Property'}, `
             @{Expression={$_.Count};Label='Count'}, `
             @{Expression={('{0:N1}' -f($_.Sum/1GB))};Label='Sum';align='right'}, `
             @{Expression={('{0:N1}' -f($_.Minimum/1GB))};Label='Minimum';align='right'}, `
             @{Expression={('{0:N1}' -f($_.Maximum/1GB))};Label='Maximum';align='right'}, `
             @{Expression={('{0:N1}' -f($_.Average/1GB))};Label='Average';align='right'}

        Add-Content -Path $logpath -Value "All VMs" -Encoding Ascii
        Add-Content -Path $logpath -Value "======="

        $colVMs | Measure-Object VMStaticRAM,VMDynamicMemoryMax -Minimum -Maximum -Sum -Average | Format-Table $b -Autosize|out-string |Add-Content -Path $logpath -Encoding Ascii
        $colVMs | Measure-Object VMCPUCount -Minimum -Maximum -Sum -Average | Format-Table Property,Count,Sum,Minimum,Maximum,Average -Autosize|out-string |Add-Content -Path $logpath -Encoding Ascii

        Add-Content -Path $logpath -Value "Running VMs" -Encoding Ascii
        Add-Content -Path $logpath -Value "===========" -Encoding Ascii
        $colVMs | Where-Object {$_.VMState -eq 'Running'} | Measure-Object VMStaticRAM,VMDynamicMemoryMax -Minimum -Maximum -Sum -Average | Format-Table $b -Autosize|out-string |Add-Content -Path $logpath -Encoding Ascii
        $colVMs | Where-Object {$_.VMState -eq 'Running'} | Measure-Object VMCPUCount -Minimum -Maximum -Sum -Average | Format-Table Property,Count,Sum,Minimum,Maximum,Average -Autosize|out-string |Add-Content -Path $logpath -Encoding Ascii


        # add host hardware values
        $HostHW = Get-WmiObject Win32_ComputerSystem -ComputerName $hypervserver
        Add-Content -Path $logpath -Value ("Host $hypervserver total RAM: " + ('{0:N0}' -f($hostHW.TotalPhysicalMemory / 1GB)  + ' GB')) -Encoding Ascii
        Add-Content -Path $logpath -Value ("Host $hypervserver Logical Processors: " + $HostHW.NumberOfLogicalProcessors) -Encoding Ascii


        Remove-PSSession -Session $session
    }
}