$WMF51 = "\\filesvr1\Software\MICROSOFT\WMF\5.1\Win8.1AndW2K12R2-KB3191564-x64.msu"
$installargs = "/QUIET /NORESTART"

$HypervServers = (Get-ADGroupMember -Identity CCCS-CG-Hyper_V_Hosts | Select-Object -ExpandProperty name)

$Servers = @()
foreach ($HypervServer in $HypervServers) {
    $Servers += (Get-ADComputer -Identity $HypervServer -Properties * | Where-Object {$_.OperatingSystem -Like "*2012 R2*"} | Select-Object -ExpandProperty Name) 
}

$Servers = "CCS-HYPERV12"
foreach ($Server in $Servers) {
    $Destination = "\\$Server\c$\Temp"
    if (-not(Test-Path -Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination
    }
    Copy-Item -Path $WMF51 -Destination $Destination -ErrorAction SilentlyContinue
    Invoke-Command -ComputerName $Server -ScriptBlock {
        Start-Process -FilePath "wusa.exe C:\temp\Win8.1AndW2K12R2-KB3191564-x64.msu" -ArgumentList $using:installargs -Verb runas
    } -AsJob
}