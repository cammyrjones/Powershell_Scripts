#define the name of the license file to copy over
$licensefile = "MapXtremeDesktop.lic"
#define the flag file to set when the copy is done
$flagfile = "\\filesvr1\mdt_share$\MapXtreme\MapXtreme_desktop_deployments\$($Env:COMPUTERNAME).txt"
#define the source folder for the license file
$source = "\\filesvr1\mdt_share$\MapXtreme"

#function to check if system is 64 bit OS
function is64bit() {
    return ([IntPtr]::Size -eq 8)
}

#if is64bit evaluates to true - copy to x86 folder
if (is64bit -eq $true) {
    #define the destination folder for the license file
    $destination = "C:\Program Files (x86)\Common Files\MapInfo\MapXtreme\7.1.0"
}
#if evaluates to false - copy to main program files folder
else {
    #define the destination folder for the license file
    $destination = "C:\Program Files\Common Files\MapInfo\MapXtreme\7.1.0"
}

#copy the license file to the relevant local folder
Copy-Item $source\$licensefile -Destination $destination

#if the license file exists in the destination folder (ie has been copied properly), create the flag file to show where the license has been used
if (Test-Path $destination\$licensefile) {
    Write-Output "success"
    New-Item -ItemType File -Path $flagfile -Force
}
else {
    Write-Output "failed"
}