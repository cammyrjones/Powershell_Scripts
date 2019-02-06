Write-Host "Ctrl-C to exit" -ForegroundColor Green
#Set the location of the Notepad++ exe
$notepadPP = "C:\Program Files (x86)\Notepad++\notepad++.exe"
#Test to see if the notepad++ variable is set, otherwise don't continue
if(!(Test-Path -Path $notepadPP))
    {
    Write-Host "You must correctly set the path for the Notepad++ variable, exiting" -ForegroundColor Red
    pause ; exit
    }
#Set variable of path to search in
$logpath = Read-Host "Enter path containing logs"
#Set variable of extension to search in, wildcards apply
$format = Read-Host "Enter file extension of log files or * to search all text files"
#This defines the parselogs function in order for it to loop around indefinitely
$parselogs = {
#Set variable of string to search for
$pattern = Read-Host "Enter string to search for in log file"
#This will search for the string based upon the path and format variables you have defined, pipe into the grid view for selection, pipes into a foreach loop
select-string -path "$logpath\*.$format" -pattern $pattern -allmatches |
Out-GridView -OutputMode Multiple -Title 'Select lines to open in Notepad++' |
#This loop will take all the selections from the out-gridview and open in Notepad++ on that line (will only do one per file)
ForEach-Object {
$line = $_.LineNumber
$logfile = $_.Path
$cmdArgs = @("$logfile","-n$line")
& $notepadPP @cmdargs
}
.$parselogs
}
&$parselogs