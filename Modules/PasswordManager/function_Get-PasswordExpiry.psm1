<#
.SYNOPSIS
    Gets password expiry value from AD based on SAM account name
.PARAMETER UserNames
    Specifies the SAM account name to search against
.EXAMPLE
    C:\PS>Get-PasswordExpiry -UserNames p12345678
    Samaccountname Displayname                           ExpiryDate
    -------------- -----------                           ----------
    p12345678      Bloggs, Joe (Comms & Control Solutions) 10/06/2018 17:00:00
#>
function Get-PasswordExpiry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$UserNames
    )

    $ErrorActionPreference = "stop"
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    Foreach ($Username in $Usernames) {
        Get-ADUser $Username -Properties 'DisplayName', 'msDS-UserPasswordExpiryTimeComputed' |
        Select-Object -Property 'Samaccountname', 'Displayname', @{
            Name = 'ExpiryDate'
            Expression = {
                [datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed')
            }
        }
    }
}