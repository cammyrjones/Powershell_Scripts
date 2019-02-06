<#
.SYNOPSIS
    Workflow for copying and running MSI installers to an array of computers
.DESCRIPTION
    Takes an array of computers, as well as the path to an MSI file - will copy the MSI file to the computer and use invoke-command to run it
.PARAMETER computers
    Specifies an array of computer names
.PARAMETER installersourcepath
    Specifies the path to the MSI installer file
.PARAMETER installswitches
    Specifies the install switches to be used with the MSI installer - if this is not specified, will default to "/qn"
.EXAMPLE
    C:\PS>
    install-msi -computers "comp1","comp2" -installersourcepath "\\path\to\file.msi"
.EXAMPLE
    C:\PS>
    install-msi -computers "comp1","comp2" -installersourcepath "\\path\to\file.msi" -installswitches "/qb /norestart"
.NOTES
    It's assumed the "/qn" switch will be sufficient for most MSI packages - hence setting this as the default
.FUNCTIONALITY
    Typically this would be used where an MSI needs pushing out to AD computers where no package management software is available
#>
function Install-Msi {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$computers,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$installersourcepath,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$installswitches = "/qn"
    )

    $installer = (Split-Path -Path $installersourcepath -Leaf)
    $localinstaller = "c:\temp\$installer"
    $installargs = "/i $localinstaller $installswitches"
    $failedInstalls = @()

    foreach ($computer in $computers) {
        $installerdestpath = "\\$computer\c$\temp\$installer"
        try {
            Write-Output "Create temp directory on $computer if it doesn't exist"
            if (!(Test-Path (Split-Path $installerdestpath -Parent))) {
                New-Item -ItemType Directory -Path (Split-Path $installerdestpath -Parent)
            }
            Write-Output "Copy installer to $computer"
            Copy-Item -Path $installersourcepath -Destination $installerdestpath
            if (Test-Path -Path $installerdestpath) {
                Write-Output "Invoke command against $computer to run the installer"
                Invoke-Command -ComputerName $computer -ScriptBlock { Start-Process -FilePath "msiexec.exe" -ArgumentList $using:installargs -Verb runas -PassThru -Wait } -AsJob | Out-Null
            }
            Write-Output "Submitted install command to $computer"
        }
        catch {
            $failedInstalls += ('"' + $computer + '"')
            Write-Output "Could not install $installer on $computer due to error: $($_.Exception.Message)"
        }
    }
    Write-Output ("Could not start installer on:" + "`n" + $($failedInstalls -join "`n"))
}
