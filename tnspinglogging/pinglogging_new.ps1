[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline=$true)]
    [String[]]$Computer = "cccswc0452",
    
    [string]$LogPath = "E:\123.txt"
)

$Ping = @()
#Test if path exists, if not, create it
If (-not (Test-Path (Split-Path $LogPath) -PathType Container))
{   Write-Verbose "Folder doesn't exist $(Split-Path $LogPath), creating..."
    New-Item (Split-Path $LogPath) -ItemType Directory | Out-Null
}

#Test if log file exists, if not seed it with a header row
If (-not (Test-Path $LogPath))
{   Write-Verbose "Log file doesn't exist: $($LogPath), creating..."
}

#Log collection loop
Write-Verbose "Beginning Ping monitoring of $Computer"
While ($true)
{   $datetime = Get-Date
    $ping = tnsping $Computer
    $Results = "$datetime", "$Ping" 
    $Results | Add-Content -Path $LogPath
    Write-verbose ($results | Format-Table -AutoSize | Out-String)
    $Count --
    Start-Sleep -Seconds 60
}