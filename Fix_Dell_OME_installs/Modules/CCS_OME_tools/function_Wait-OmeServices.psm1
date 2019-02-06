<#
.SYNOPSIS
    Waits for the specified services to reach the specified status
.DESCRIPTION
    This will do a do/while loop to wait for a list of services to reach a desired status
.PARAMETER ServiceList
    Specifies an array of service names
.PARAMETER DesiredStatus
    Specifies the state that you want the services to be in
    Options are "Running" and "Stopped"
.PARAMETER RetryMax
    Specifies the maximum number of retries
.PARAMETER RetryDelay
    Specifies the delay in seconds between each retry
.EXAMPLE
    C:\PS>Wait-Services -ServiceList $ServiceList -DesiredStatus Running
    This command will wait for all services in $ServiceList to have status of "Running"
.FUNCTIONALITY
    This is intended to be used with the Vision_Refresh module
#>
function Wait-OmeServices {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ServiceList,

        [ValidateSet("Running", "Stopped")]
        [string]$DesiredStatus,

        [Parameter(Mandatory = $false)]
        [int]$RetryMax = "6",

        [Parameter(Mandatory = $false)]
        [int]$RetryDelay = "5"
    )

    $ErrorActionPreference = "Stop"
    if (-not $PSBoundParameters.ContainsKey('Verbose'))
    {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    $StopLoop = $false
    [int]$RetryCount = "0"

    do {
        try {
            Write-Verbose "Creating pending array"
            [System.Collections.ArrayList]$Pending = $ServiceList
            Write-Verbose "Created pending array"
            #Remove services from pending array if they are in desired state
            Get-Service -Name $ServiceList | Where-Object {$_.status -eq $DesiredStatus} | ForEach-Object { $Pending.Remove($_.Name)}
            Write-Verbose "Removed services from pending array where appropriate"
            #If the pending count is greater than 0, throw an error, else stop the loop
            if ($Pending.Count -gt 0) {
                Write-Verbose "The following services are still not in state $DesiredStatus : $Pending on $env:COMPUTERNAME"
                throw
            }
            else {
                Write-Verbose "All services have reached the desired state of $DesiredStatus on $env:COMPUTERNAME"
                $StopLoop = $true
            }
        }
        catch {
            #If the retry count is greater than the retry max, throw an error and stop the retry loop
            if ($RetryCount -gt $RetryMax) {
                Get-Service -Name $ServiceList | Where-Object {$_.status -eq $DesiredStatus} | ForEach-Object { $Pending.Remove($_.Name)}
                if ($Pending.Count -gt 0) {
                    throw "Services did not reach desired status of $DesiredStatus on $env:COMPUTERNAME within the given time, giving up. Services were: $Pending"
                }
                $StopLoop = $true
            }
            #Else, sleep for the specified number of seconds and increment the retry counter
            else {
                if ($DesiredStatus -eq "Stopped") {
                    Write-Verbose "Attempting to kill pending services"
                    CCS_OME_tools\Stop-OmeProcess -ServiceList $Pending
                    Write-Verbose "Done"
                }
                Write-Verbose "Retrying in $RetryDelay seconds"
                Start-Sleep -Seconds $RetryDelay
                Write-Verbose "Increment the retry counter"
                $RetryCount = $RetryCount + 1
            }
        }
    }
    #While the stop loop value is not false
    While ($StopLoop -eq $false)
}