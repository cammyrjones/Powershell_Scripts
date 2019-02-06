$ccsoupath = "OU=Capita Communications and Control Solutions,OU=Business Unit,DC=ad,DC=capita,DC=co,DC=uk"
$ccsoupathdesktops = "OU=Desktop,OU=Capita Communications and Control Solutions,OU=Business Unit,DC=ad,DC=capita,DC=co,DC=uk"

$unsupportedOSdesktops = "*XP*", "*vista*"
$unsupportedOSservers = "*2000*", "*2003*"
$laptopprefix = "CCCSL*"

#Counts the number of unsupported server OS in the CCS OU
Write-Output "Unsupported Server OS"
$TotalSvrOS = $null
$unsupportedOSservers | ForEach-Object {
    $TotalSvrOS += (Get-ADComputer -Filter {OperatingSystem -Like $_} -SearchBase $ccsoupath -Property * | Measure-Object|Select-Object -ExpandProperty count)
}
Write-Output "$TotalSvrOS"

#Counts the number of unsupported desktop OS in the CCS OU
Write-Output "Unsupported Desktop OS"
$TotalDesktopOS = $null
$unsupportedOSdesktops | ForEach-Object {
   $TotalDesktopOS += (Get-ADComputer -Filter {OperatingSystem -Like $_} -SearchBase $ccsoupath -Property * | Measure-Object|Select-Object -ExpandProperty count)
}
Write-Output "$TotalDesktopOS"

#Counts AD user accounts
Write-Output "AD Accounts"
Get-ADUser -Filter * -SearchBase $ccsoupath | Select-Object -ExpandProperty name |Measure-Object| Select-Object -ExpandProperty count 

#Gets a list of servers in the Hyper-V security group
Write-Output "Virtual Machines"
$computers = Get-ADGroupMember -Identity CCCS-CG-Hyper_V_Hosts | Select-Object -ExpandProperty Name | Sort-Object 
$Total = $null
#Runs Get-VM on the Hyper-V hosts and lists the number of VMs
Foreach ($computer in $computers) {
    $Total += (Invoke-Command -ComputerName $computer {get-vm | Measure-Object| Select-Object -ExpandProperty count})

}
Write-Output "$Total"
Write-Output "Add above with Capita CCS Virtual Servers file to get total VMs"

#Lists the laptops in the CCS OU
Write-Output "Number of Laptops"
Get-ADComputer -filter {Name -Like $laptopprefix} -SearchBase $ccsoupath | Select-Object -ExpandProperty name |Measure-Object| Select-Object -ExpandProperty count 

#Lists the desktops in the CCS Desktop OU
Write-Output "Number of Desktops"
Get-ADComputer -filter {Name -Notlike $laptopprefix} -SearchBase $ccsoupathdesktops | Select-Object -ExpandProperty name |Measure-Object| Select-Object -ExpandProperty count 