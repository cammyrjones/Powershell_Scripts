$Isopath = "\\filesvr1\Software\MICROSOFT\Windows\2012R2\SW_DVD9_Windows_Svr_Std_and_DataCtr_2012_R2_64Bit_English_-3_MLF_X19-53588.iso"

$mountResult = Mount-DiskImage $Isopath -PassThru #Mounts the ISO to the server
[string]$driveLetter = ($mountResult | Get-Volume).DriveLetter #Gets the drive letter of the ISO

Install-WindowsFeature net-framework-core -Source ("$driveLetter" + ":\sources\sxs") #Installs DotNet 3.5 using the sxs folder on the mounted ISO

Dismount-DiskImage -ImagePath $Isopath #Unmounts the ISO