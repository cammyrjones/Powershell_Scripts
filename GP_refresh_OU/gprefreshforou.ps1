$searchbase = Read-Host -Prompt "enter searchbase"
$computers = (Get-ADComputer -Filter * -SearchBase $searchbase |Select-Object -ExpandProperty name)
foreach ($computer in $computers){Invoke-Command -ComputerName $computer -ScriptBlock {gpupdate /force} -AsJob}