$ErrorActionPreference = "Stop"
#use connect-msolservice to connect to azure AD first - requires azure AD modules and connector packages

#prompt for credentials to connect to azure AD
$msolcredential = Get-Credential

#connect to MS online service using creds
Connect-MsolService -Credential $msolcredential

#get the list of users - select name and userPN - PN will be used to get the 365 license info
$userlist = Get-ADUser -Filter * -SearchBase ""|Select-Object name, userprincipalname|Sort-Object name

$outputfile = "c:\temp\365.csv"

#for each user in the list, check if they have E1 or E3, write results to CSV
foreach ($user in $userlist) {
    $details = $null
    $skuid = $null
    $skuid = (get-MSOLUser -UserPrincipalName ($user.userprincipalname)).Licenses.AccountSKUID

    if ($skuid -eq ":STANDARDPACK") {
        $details = [string](($user.name|Out-String) + ";" + ($user.userprincipalname|Out-String) + ";" + $skuid +";" + "E1") -replace "`r|`n", ""
        $details|Out-File -FilePath $outputfile -Append -NoClobber
    }
    elseif ($skuid -eq ":ENTERPRISEPACK") {
        $details = [string](($user.name|Out-String) + ";" + ($user.userprincipalname|Out-String) + ";" + $skuid + ";" + "E3") -replace "`r|`n", ""
        $details|Out-File -FilePath $outputfile -Append -NoClobber       
    }
}