#change the list for your needs....
$computers = "ccs-hyperv12", "ccs-hyperv13", "ccs-hyperv14", "ccs-hyperv16", "ccs-retain-svr", "CCSPRNHHYP01", "CCSPRNHHYP02"
foreach ($computer in $computers) {
    New-Item -ItemType Directory -Path "\\$computer\c$\temp"
    Copy-Item -Path "\\filesvr1\Software\Dell\OM-SrvAdmin-Dell-Web-WINX64-8.2.0-1739_A00\windows\SystemsManagementx64\SysMgmtx64.msi" -Destination "\\$computer\c$\temp\"
    Invoke-Command -ComputerName $computer -ScriptBlock {msiexec.exe /i "c:\temp\SysMgmtx64.msi" /qn} -AsJob
}