How to install PowerCLI

To install the module - only needs to be done once on a PC
Save-Module -Name VMware.PowerCLI -Path C:\Windows\System32\WindowsPowerShell\v1.0\Modules - if this cmdlet doesn't work, copy the PowerCLI to the same location
Import-Module -Name VMware.PowerCLI

To test run Get-Module -ListAvailable -Name VMware*

To connect to a VMWare server using PowerCLI run 
Connect-VIServer –server “IP address or hostname”
You may get an error regarding an "Invalid server certificate". If you see this error run the command below
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

To disconnect afterward run
Disconnect-VIserver -force -confirm:$false

I have saved the PowerCLI scripts I have created \\swrnfs01\Technical\VMWARE\Powershell
