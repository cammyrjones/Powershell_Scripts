#set the variable for the date - will be used to time stamp the log file
$date = (get-date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
#set the variable defining where the log file will be stored
$logfile = "c:\mapinforlog-$date.txt"
#define the message to search for the in the log file that defines whether or not activation was successfull
$successmessage = "Your node lock license was activated successfully"
$alreadyactivatedmessage = "A license was already activated. No new license is activated."
#define the arguments to be used with the mapinfor exe
$mapinforargs = @("-activatelicense", "$logfile")
#define where the mapinfor exe will be run from
$mapinfor = "C:\Program Files (x86)\MapInfo\Professional\mapinfow.exe"
#define the file to use a flag to keep a track of where this software has been activated
$flagfile = "\\filesvr1\mdt_share$\MapInfo\Pro15_Deployments\$($Env:COMPUTERNAME).txt"

& $mapinfor $mapinforargs|Wait-Job

if (select-string -path $logfile -SimpleMatch "$successmessage") {
    Write-Output "activated successfully"
    New-Item -ItemType File -Path $flagfile
}
elseif (select-string -path $logfile -SimpleMatch "$alreadyactivatedmessage") {
    Write-Output "already activated"
}
else {
    Write-Output "failed to activate"
}