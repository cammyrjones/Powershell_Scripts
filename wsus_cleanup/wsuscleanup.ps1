# Variables
$DateFormat = Get-Date -format yyyyMMdd-HHmmss
$Logfile = "C:\wsus_cleanup\logs\wsus-cleanup-$DateFormat.log"
 
# WSUS cleanup command
Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates | Out-File $Logfile