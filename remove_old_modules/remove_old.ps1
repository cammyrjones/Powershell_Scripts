foreach ($modulename in (Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules" | Select-Object -ExpandProperty name)) {
    #Write-Output $modulename
    $Latest = Get-InstalledModule $modulename
    Get-InstalledModule $modulename -AllVersions | Where-Object {$_.Version -ne $Latest.Version} | Uninstall-Module -Verbose -ErrorAction Continue
}