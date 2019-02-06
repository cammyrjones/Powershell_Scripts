$Isopath = "\\filesvr1\Software\MICROSOFT\Windows\10\en-gb_windows_10_multi-edition_vl_version_1709_updated_sept_2017_x64_dvd_100090748.iso"

$mountResult = Mount-DiskImage $Isopath -PassThru #Mounts the ISO to the server
[string]$driveLetter = ($mountResult | Get-Volume).DriveLetter #Gets the drive letter of the ISO

Enable-WindowsOptionalFeature -online -featurename netfx3 -Source ("$driveLetter" + ":\sources\sxs") #Installs DotNet 3.5 using the sxs folder on the mounted ISO

Dismount-DiskImage -ImagePath $Isopath #Unmounts the ISO