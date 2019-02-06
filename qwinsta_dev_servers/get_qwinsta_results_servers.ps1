#$computers = "echvas1","echvas2"
$computers = (Get-ADComputer -Filter * -SearchBase "OU=Development,OU=Server,OU=Capita Communications and Control Solutions,OU=Business Unit,DC=ad,DC=capita,DC=co,DC=uk"|Select-Object -ExpandProperty name|Sort-Object)
foreach ($computer in $computers) 
{
 if (Test-Connection -ComputerName "$computer" -BufferSize 16 -Count 1 -Quiet)
    {
        Add-Content -Path C:\temp\ROqwinsta.txt -Value $computer
        Invoke-Command -ComputerName $computer -ScriptBlock {qwinsta}|Out-File C:\temp\ROqwinsta.txt -Append -NoClobber
    }
}