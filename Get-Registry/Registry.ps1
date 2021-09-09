$kiosks = get-adcomputer -filter {name -like "*sskiosk8" or name -like "*assk*"} | Select-Object dnshostname

foreach ($kiosk in $kiosks) {
$REG = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $kiosk.name)
$REGKEY = $REG.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon")
$KIOSK = $REGKEY.GetValue("DefaultPassword")

# If the key is missing or not set it will be displayed in red
# If the key is set it will be displayed in green
 
if (!$KIOSK){
 
    Write-Host $kiosk "is not set"  -ForegroundColor Red
    }
     
    if ($val -ne ""){
    Write-Host $kiosk "is not set properly"  -ForegroundColor Red
    }
     
    else{
    Write-Host $kiosk "is set" -ForegroundColor Green
    }
}