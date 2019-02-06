function ExtPack_Install {
    Param(
        [Parameter(Mandatory = $True)]
        [String]
        $Version,

        [Parameter(Mandatory = $True)]
        [String]
        $LicenseID
    )
    Copy-Item "\\filesvr1\Software\VirtualBox\$Version\Oracle_VM_VirtualBox_Extension_Pack-$Version.vbox-extpack" -Destination "C:\Program Files\Oracle\VirtualBox"
    & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" extpack install "C:\Program Files\Oracle\VirtualBox\Oracle_VM_VirtualBox_Extension_Pack-$Version.vbox-extpack" --accept-license=$LicenseID
}
