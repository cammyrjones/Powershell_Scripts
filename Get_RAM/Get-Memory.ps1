$computername = Read-Host "enter name of computer"

#Measure

((((Get-CimInstance Win32_PhysicalMemory -ComputerName $computername).Capacity|measure -Sum).Sum)/1gb)

Pause