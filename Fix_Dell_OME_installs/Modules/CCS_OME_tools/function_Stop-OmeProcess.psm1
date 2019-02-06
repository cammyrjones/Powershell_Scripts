<#
.SYNOPSIS
    Takes a list of services and stops their associated processes
.PARAMETER ServiceList
    Specifies an array of services to stop
.EXAMPLE
    C:\PS>Stop-OmeProcess -ServiceList "service1"","service2"
.EXAMPLE
    C:\PS>Stop-OmeProcess -ServiceList $ServiceList
#>
function Stop-OmeProcess {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ServiceList = @()
    )

    $ErrorActionPreference = "stop"
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    $killPaths = @()
    $killList = @()
    $processesToKill = @()

    foreach ($service in (Get-Service $ServiceList)) {
        Write-Verbose "Attempting stop-service -force against $service"
        Stop-Service $service -Force -ErrorAction "SilentlyContinue"
        Write-Verbose "Done"
        if ($service.status -ne "Stopped") {
            Write-Verbose "$($service.name) is not stopped yet, will add to list to kill"
            $killPaths += (Get-WmiObject win32_service | Where-Object { $_.Name -like $service.name } | Select-Object PathName)
            Write-Verbose "Done"
        }
    }
    foreach ($killPath in $killPaths) { $killList += ($killPath.PathName.Replace('"', '').Replace('}', '')) }

    foreach ($process in (Get-Process)) {
        if ($process.path -in $killList) {
            Write-Verbose "Adding $process to list of those to kill"
            $processesToKill += $process
            Write-Verbose "Done"
        }
    }
    if (($processesToKill).count -gt 0){
    Write-Verbose "Stopping list of services"
    Stop-Process -Id $processesToKill.Id -Force
    Write-Verbose "Done"
    }
}