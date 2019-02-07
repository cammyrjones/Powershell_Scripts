<#
.SYNOPSIS
    VM creation function (Hyper-V)
.DESCRIPTION
    Run on Hyper-V server - will take a CSV with VM settings and create the VMs
.PARAMETER virtualmachinescsv
    This defines the location of the CSV file that contains the settings for the VMs such as no. of vcpus, hdd etc
.PARAMETER vmpath
    The folder that the VMs will be stored in
.EXAMPLE
    createvms -virtualmachinescsv c:\temp\test.csv -vmpath c:\vms
.FUNCTIONALITY
    Hyper-V VM creation from a template
#>
function createvms {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_})]
        [string]$virtualmachinescsv,

        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_})]
        [string]$vmpath,

        [Parameter(Mandatory = $False)]
        [int]$VlanPId
    )

    $vmdetails = Import-Csv $virtualmachinescsv

    #Set the ISO path
    $isopath = Read-Host "Enter path to ISO to use to boot VMs"

    # VM Path
    #$VMPath = Read-Host "Enter path to store VMs"

    # Start the foreach loop
    $vmdetails|ForEach-Object {

        # VM Name
        $VMName = $_.vmname

        # Automatic Start Action (Nothing = 0, Start =1, StartifRunning = 2)
        $AutoStartAction = 2
        # In second
        $AutoStartDelay = 0
        # Automatic Stop Action (TurnOff = 0, Save =1, Shutdown = 2)
        $AutoStopAction = 2

        ######################################################
        ###           Hardware Configuration               ###
        ######################################################


        # VM Generation (1 or 2)
        $Gen = 2

        # Processor Number
        $ProcessorCount = $_.NumVCPU

        ## Memory (Static = 0 or Dynamic = 1)
        $Memory = 1
        # StaticMemory
        $StaticMemory = 4GB

        # DynamicMemory
        $StartupMemory = ([int]($_.StartupMemoryGB) * 1GB)
        $MinMemory = ([int]($_.MinMemoryGB) * 1GB)
        $MaxMemory = ([int]($_.MaxMemoryGB) * 1GB)

        ### Additional virtual drives - will only get added if a correct value higher than 0 is added in the CSV
        # bad or empty entries are ignored
        $ExtraDrive = @()

        # Drive 1
        if ($_.Disk1SizeGB -gt 0) {
            $Drive = New-Object System.Object
            $Drive       | Add-Member -MemberType NoteProperty -Name Name -Value "$VMName-1"
            $Drive       | Add-Member -MemberType NoteProperty -Name Path -Value $($VMPath + "\" + $VMName)
            $Drive       | Add-Member -MemberType NoteProperty -Name Size -Value ([int]($_.Disk1SizeGB) * 1GB)
            $Drive       | Add-Member -MemberType NoteProperty -Name Type -Value Fixed
            $ExtraDrive += $Drive
        }

        # Drive 2
        if ($_.Disk2SizeGB -gt 0) {
            $Drive = New-Object System.Object
            $Drive       | Add-Member -MemberType NoteProperty -Name Name -Value "$VMName-2"
            $Drive       | Add-Member -MemberType NoteProperty -Name Path -Value $($VMPath + "\" + $VMName)
            $Drive       | Add-Member -MemberType NoteProperty -Name Size -Value ([int]($_.Disk2SizeGB) * 1GB)
            $Drive       | Add-Member -MemberType NoteProperty -Name Type -Value Fixed
            $ExtraDrive += $Drive
        }

        # Drive 3
        if ($_.Disk3SizeGB -gt 0) {
            $Drive = New-Object System.Object
            $Drive       | Add-Member -MemberType NoteProperty -Name Name -Value "$VMName-3"
            $Drive       | Add-Member -MemberType NoteProperty -Name Path -Value $($VMPath + "\" + $VMName)
            $Drive       | Add-Member -MemberType NoteProperty -Name Size -Value ([int]($_.Disk3SizeGB) * 1GB)
            $Drive       | Add-Member -MemberType NoteProperty -Name Type -Value Fixed
            $ExtraDrive += $Drive
        }

        # Drive 4
        if ($_.Disk4SizeGB -gt 0) {
            $Drive = New-Object System.Object
            $Drive       | Add-Member -MemberType NoteProperty -Name Name -Value "$VMName-4"
            $Drive       | Add-Member -MemberType NoteProperty -Name Path -Value $($VMPath + "\" + $VMName)
            $Drive       | Add-Member -MemberType NoteProperty -Name Size -Value ([int]($_.Disk4SizeGB) * 1GB)
            $Drive       | Add-Member -MemberType NoteProperty -Name Type -Value Fixed
            $ExtraDrive += $Drive
        }
        # You can copy/delete this below block as you wish to create (or not) and attach several VHDX

        ### Network Adapters
        # Primary Network interface: VMSwitch
        $VMSwitchName = (Get-VMSwitch | Where-Object {$_.Name -notlike "*legacy*"}).name


        ######################################################
        ###           VM Creation and Configuration        ###
        ######################################################

        ## Creation of the VM
        # Creation without VHD and with a default memory value (will be changed after)
        New-VM -Name $VMName `
            -Path $VMPath `
            -NoVHD `
            -Generation $Gen `
            -MemoryStartupBytes 1GB `
            -SwitchName $VMSwitchName


        if ($AutoStartAction -eq 0) {$StartAction = "Nothing"}
        Elseif ($AutoStartAction -eq 1) {$StartAction = "Start"}
        Else {$StartAction = "StartIfRunning"}

        if ($AutoStopAction -eq 0) {$StopAction = "TurnOff"}
        Elseif ($AutoStopAction -eq 1) {$StopAction = "Save"}
        Else {$StopAction = "Shutdown"}

        ## Changing the number of processor and the memory
        # If Static Memory
        if (!$Memory) {
            Set-VM -Name $VMName `
                -ProcessorCount $ProcessorCount `
                -StaticMemory `
                -MemoryStartupBytes $StaticMemory `
                -AutomaticStartAction $StartAction `
                -AutomaticStartDelay $AutoStartDelay `
                -AutomaticStopAction $StopAction


        }
        # If Dynamic Memory
        Else {
            Set-VM -Name $VMName `
                -ProcessorCount $ProcessorCount `
                -DynamicMemory `
                -MemoryMinimumBytes $MinMemory `
                -MemoryStartupBytes $StartupMemory `
                -MemoryMaximumBytes $MaxMemory `
                -AutomaticStartAction $StartAction `
                -AutomaticStartDelay $AutoStartDelay `
                -AutomaticStopAction $StopAction

        }


        # Attach each Disk in the collection
        Foreach ($Disk in $ExtraDrive) {
            # if it is dynamic
            if ($Disk.Type -like "Dynamic") {
                New-VHD -Path $($Disk.Path + "\" + $Disk.Name + ".vhdx") `
                    -SizeBytes $Disk.Size `
                    -Dynamic
            }
            # if it is fixed
            Elseif ($Disk.Type -like "Fixed") {
                New-VHD -Path $($Disk.Path + "\" + $Disk.Name + ".vhdx") `
                    -SizeBytes $Disk.Size `
                    -Fixed
            }

            # Attach the VHD(x) to the Vm
            Add-VMHardDiskDrive -VMName $VMName `
                -Path $($Disk.Path + "\" + $Disk.Name + ".vhdx")
        }

        # configure DVD drive to use specified ISO
        Add-VMDvdDrive -VMName $VMName -Path $isopath

        $vmNetworkAdapter = Get-VMNetworkAdapter -VMName $VMName

        # Get the configured VM DVD drive
        #$vmdvd = Get-VMDvdDrive -VMName $VMName

        #Get the first HDD in list
        $OsVirtualDrive = Get-VMHardDiskDrive -VMName $VMName -ControllerNumber 0 -ControllerLocation 0

        # Set the boot order, disable secureboot
        Set-VMFirmware -VMName $VMName -BootOrder $vmNetworkAdapter, $OsVirtualDrive -EnableSecureBoot Off

        # Set the VLAN ID
        Set-VMNetworkAdapterVlan -VMName $VMName -Access -VlanId $VlanId
    }
}