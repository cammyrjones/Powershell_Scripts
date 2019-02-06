$ErrorActionPreference = "stop"
$VerbosePreference = "continue"

<#
$servers = @(
    "ccs-hyperv3"
    "ccs-hyperv19"
    "ccs-hyperv21"
)
#>

$servers = (Get-ADGroupMember -Identity "CCCS-CG-Hyper_V_Hosts" | Select-Object -ExpandProperty name)

$ModuleFolders = @(
    "C:\git\IT-scripts\Fix_Dell_OME_installs\Modules\CCS_OME_tools"
)

. "C:\git\IT-scripts\Copy-Module\Copy-Module.ps1"

Copy-Module -ComputerNames $servers -ModuleFolders $ModuleFolders
Copy-Module -ComputerNames $env:COMPUTERNAME -ModuleFolders $ModuleFolders

foreach ($moduleName in $ModuleFolders) {
    Import-Module (Split-Path $moduleName -Leaf) -Force
}

foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -ScriptBlock {
        if (Get-Service -Name "omsad" -ErrorAction SilentlyContinue) {
            ccs_ome_tools\clear-omefiles -Verbose:$using:VerbosePreference
        }
    } -AsJob
}