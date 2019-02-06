$path = read-host "enter path to log"
$computer = read-host "enter target of ping"
write-host "now logging to file, ctrl-c to stop"
& $PSScriptRoot\pinglogging_new.ps1 -logpath $path -computer $computer