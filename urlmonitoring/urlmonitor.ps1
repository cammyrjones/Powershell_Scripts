# Set the date variable to use a proper date format for proper people
$date = Get-Date -format d.M.yyyy
# Set the variable for the path to the log file
$logpath = "E:\scripttest\testsite.log"
# Set the variable for the site to be tested for availability
$testsite = "http://google.co.ck"
# Sets the test-site function and trap in case it errors out, what to do with errror info etc
function Test-Site {
    param($URL)
    trap{
        "$date"| Add-Content $logpath
        "Failed. Details: $($_.Exception)"| Add-Content $logpath
         exit 1
    }
    $webclient = New-Object Net.WebClient
    # This is the main call
    $webclient.DownloadString($URL) | Out-Null
} 

Test-Site $testsite