$VMName = Read-Host "Enter the VM name"
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters"
$RegistryKey = "PhysicalHostName"

Invoke-Command $VMName { Get-ItemProperty -Path $Using:RegistryPath -Name $RegistryKey | Select-Object -Property PhysicalHostName }