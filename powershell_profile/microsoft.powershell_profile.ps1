# -- Automate PowerShell Transcription --
# Create a filename based on a time stamp.
$Filename = (get-date -Format yyyyMMdd-HHmmss).ToString()+".txt"
# Set the storage path.
$transcriptPath = "$env:USERPROFILE\Documents\PowerShell\Transcript"
# Turn on PowerShell transcripting. 
Start-Transcript -Path "$transcriptPath\$Filename"
# ---------------------------------------

# copy-lastcommand - copies last command used to clipboard
Function Copy-LastCommand {
 (Get-History)[-1].commandline | Set-Clipboard
}