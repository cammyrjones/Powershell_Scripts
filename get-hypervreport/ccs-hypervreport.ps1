#define the script to run
$script = "\\filesvr1\Scripts\get-hypervreport\Get-HyperVReport.ps1"

#get the list of hyper-v servers to run the audit against - we're only concerned with dev/test
$hypervhosts = Get-ADGroupMember -Identity "CCCS-CG-DEV-Hyper_V_Hosts"|Select-Object -ExpandProperty name

#run the script against the list of provided servers
& $script -vmhost $hypervhosts -ReportFilePath c:\temp
