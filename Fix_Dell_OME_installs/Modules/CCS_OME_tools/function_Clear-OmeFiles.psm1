<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.PARAMETER ServiceList
    Specifies the list of OME/OMSA services that need to be stopped/started
    Defaults to the 64 bit services
.PARAMETER Servers
    Specifies the list of Dell servers to run against
.EXAMPLE
    C:\PS>Example of how to use this cmdlet
    Example output of this cmdlet
#>
function Clear-OmeFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateScript( {get-service -Name $_})]
        [string[]]$ServiceList = @(
            "Server Administrator"
            "dcstor64"
            "dcevt64"
            "omsad"
        )
    )

    $ErrorActionPreference = "stop"
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    Write-Verbose "Stopping processes associated with services"
    CCS_OME_tools\Wait-OmeServices -ServiceList $ServiceList -DesiredStatus "Stopped"
    Write-Verbose "Done"

    Write-Verbose "Clearing out C:\Windows\temp"
    Get-ChildItem -Path "c:\windows\temp" -Recurse | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Verbose "Done"

    Write-Verbose "Starting services"
    Start-Service -Name $ServiceList
    Write-Verbose "Done"
}