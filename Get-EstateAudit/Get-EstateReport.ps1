$oupath = ""
$oupathdesktops = ""

$unsupportedOSdesktops = "*XP*", "*vista*"
$unsupportedOSservers = "*2000*", "*2003*"
$laptopprefix = ""

#Counts the number of unsupported server OS in the CCS OU
Write-Output "Unsupported Server OS"
$TotalSvrOS = $null
$unsupportedOSservers | ForEach-Object {
    $TotalSvrOS += (Get-ADComputer -Filter {OperatingSystem -Like $_} -SearchBase $oupath -Property * | Measure-Object|Select-Object -ExpandProperty count)
}
Write-Output "$TotalSvrOS"

#Counts the number of unsupported desktop OS in the CCS OU
Write-Output "Unsupported Desktop OS"
$TotalDesktopOS = $null
$unsupportedOSdesktops | ForEach-Object {
   $TotalDesktopOS += (Get-ADComputer -Filter {OperatingSystem -Like $_} -SearchBase $oupath -Property * | Measure-Object|Select-Object -ExpandProperty count)
}
Write-Output "$TotalDesktopOS"

#Counts AD user accounts
Write-Output "AD Accounts"
Get-ADUser -Filter * -SearchBase $oupath | Select-Object -ExpandProperty name |Measure-Object| Select-Object -ExpandProperty count 

#Gets a list of servers in the Hyper-V security group
Write-Output "Virtual Machines"
$computers = Get-ADGroupMember -Identity  | Select-Object -ExpandProperty Name | Sort-Object 
$Total = $null
#Runs Get-VM on the Hyper-V hosts and lists the number of VMs
Foreach ($computer in $computers) {
    $Total += (Invoke-Command -ComputerName $computer {get-vm | Measure-Object| Select-Object -ExpandProperty count})

}
Write-Output "$Total"

#Lists the laptops in the CCS OU
Write-Output "Number of Laptops"
Get-ADComputer -filter {Name -Like $laptopprefix} -SearchBase $oupath | Select-Object -ExpandProperty name |Measure-Object| Select-Object -ExpandProperty count 

#Lists the desktops in the CCS Desktop OU
Write-Output "Number of Desktops"
Get-ADComputer -filter {Name -Notlike $laptopprefix} -SearchBase $oupathdesktops | Select-Object -ExpandProperty name |Measure-Object| Select-Object -ExpandProperty count 