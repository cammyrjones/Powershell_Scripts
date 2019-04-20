#connects to each computer in the OU, gets a list of computers that have service name like mssql and lists them
#forgot how to properly send to a csv/txt, so using transcript instead

Start-Transcript c:\temp\sqllistyeah.txt

$servers = Get-ADComputer -Filter * -SearchBase ""|Select-Object -ExpandProperty name

 foreach ($server in $servers)
 {
     #don't want to see errors as we don't care - silently continue
     Get-WmiObject win32_Service -Computer $server -ErrorAction SilentlyContinue |
     Where-Object {$_.name -like "mssql*"} | 
     Select-Object SystemName, DisplayName, Name|
     Format-Table -AutoSize
   
 }

 Stop-Transcript