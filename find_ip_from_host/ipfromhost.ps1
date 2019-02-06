function Get-HostToIP($hostname) {   
    $error.clear()  
    Try{$result = [system.Net.Dns]::GetHostByName($hostname)}
    catch {$hostname}
    if (!$error){
        $result.AddressList | ForEach-Object {$_.IPAddressToString } 
    }
}

$searchbase = Read-Host "Enter AD Searchbase"
$logpath = "c:\temp\devserverips.txt"

$computers = Get-ADComputer -Filter {enabled -eq $True} -SearchBase $searchbase| Select-Object -ExpandProperty name
foreach ($computer in $computers){
$ip = $null
$ip = (Get-HostToIP("$computer"))
if ($ip -eq $computer){
$ip = "Could not resolve"
}

"$computer,$ip" |Format-Table -AutoSize -Wrap | Out-File -FilePath $logpath -Append -NoClobber
}
