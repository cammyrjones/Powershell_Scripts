$OutFile = "c:\temp\permissions.txt"
Del $OutFile
$folders = dir e:\shares | where {$_.psiscontainer -eq $true}
foreach ($folder in $folders){Get-Acl $folder.fullname | Get-AccessControlEntry |Out-File $OutFile -Append -NoClobber}