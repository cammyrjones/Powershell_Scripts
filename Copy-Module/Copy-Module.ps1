<#
.SYNOPSIS
    Copy module folders to target computer
.PARAMETER ComputerNames
    List of computers to copy to
.PARAMETER ModuleFolders
    List of module folders required on the targets
.EXAMPLE
    C:\PS>Copy-Module -ComputerNames "test1","test2" -ModuleFolders "C:\test\testmodule1","c:\test\testmodule2"
#>
function Copy-Module {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerNames,

        [Parameter(Mandatory = $true)]
        [string[]]$ModuleFolders
    )

    $ErrorActionPreference = "stop"
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    foreach ($ComputerName in $ComputerNames) {
        if (Test-Path "\\$ComputerName\c$") {
            Write-Verbose "$ComputerName found, attempting to copy"
            foreach ($ModuleFolder in $ModuleFolders) {
                Copy-Item $ModuleFolder -Destination "\\$ComputerName\c$\program files\windowspowershell\modules" -Recurse -Force -Verbose
            }
        }
        else {
            Write-Verbose "Couldn't find part of path, will not attempt copy"
        }
    }
}