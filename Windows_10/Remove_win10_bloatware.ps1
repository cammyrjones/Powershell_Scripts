Get-appxprovisionedpackage –online | where-object {$_.name -like "*Skype*"} | remove-appxprovisionedpackage –online
Get-AppxPackage -AllUsers | where-object {$_.name -like "*Skype*"} | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object {$_.name -notlike "*Store"} | where-object {$_.name -notlike "*Calculator*"} | where-object {$_.name -notlike "*.Net*"} | remove-appxprovisionedpackage –online
Get-AppxPackage -AllUsers | where-object {$_.name -notlike "*Store"} | where-object {$_.name -notlike "*Calculator*"} | where-object {$_.name -notlike "*.Net*"} | Remove-AppxPackage
