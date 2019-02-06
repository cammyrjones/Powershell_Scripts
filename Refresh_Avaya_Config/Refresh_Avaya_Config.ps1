$source = "\\filesvr1\mdt_share$\Avaya"
$destination = "$env:USERPROFILE\AppData\Roaming\Avaya\Avaya one-X Communicator"

if (Test-Path $destination) {
    Copy-Item -Path $source\$File -Destination $destination -Recurse
}
else {
    New-Item -Type Directory -Path $destination -Force
    Get-ChildItem $source -Recurse | Copy-Item -Destination $destination -Recurse
}