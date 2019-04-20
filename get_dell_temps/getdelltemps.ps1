#get list of servers
$racknumber = '*Rack ' + (Read-Host "Enter number of rack to check") + '*'
$searchbase = ""
$computers = Get-ADComputer -Filter {description -like $racknumber} -SearchBase $searchbase |Select-Object -ExpandProperty name|sort
#loop through the list
foreach ($computer in $computers)
{
    if (Test-Connection -ComputerName "$computer" -BufferSize 16 -Count 1 -Quiet) 
    {
        #get the manufacturer property
        $manufacturer = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer | Select-Object -ExpandProperty Manufacturer
        #if manufacturer name contains dell, update the firewall rules to allow OMSA
        if ($manufacturer -like '*dell*') 
        {
            write-host "$computer is a dell server, will get temps"
            Invoke-Command -ComputerName $computer -ScriptBlock {omreport chassis temps|Select-String -SimpleMatch "probe","read"|Write-Host} -ErrorAction SilentlyContinue
        }
    }

}