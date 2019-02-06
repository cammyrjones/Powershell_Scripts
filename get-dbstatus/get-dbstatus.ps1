#Import SQL Module
Import-Module SQLPS -DisableNameChecking
 
function Get-DBStatus {
   [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)][string]$Servername
    )
 
  
    
    #Create SMO Object
    $SQLServer = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $ServerName
 
   
 
    foreach ($db in $SQLServer.Databases){
     
     #Change text to read Online/Offline as opposed to "True" or "False"
    Switch ($db.IsAccessible) {
    "True" {$dbstatus = "Online"}
    "False" {$dbstatus = "Offline"}
    }
        #Properties of function
        $props = @{ 'Server' = $ServerName
                    'DbName' = $db.Name
                    'Status' = $dbstatus
                    'Version' = $db.Version}
        New-Object -TypeName PSObject -Property $props
    
 
 
    }
 
}