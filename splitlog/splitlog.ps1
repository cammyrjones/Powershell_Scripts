$sw = new-object System.Diagnostics.Stopwatch
$sw.Start()
Write-Host "Reading source file..."
$lines = [System.IO.File]::ReadAllLines("E:\scripttest\splitlog\debug.log")
$totalLines = $lines.Length

Write-Host "Total Lines :" $totalLines

$skip = 0
$count = 1000000; # Number of lines per file

# File counter, with sort friendly name
$fileNumber = 1
$fileNumberString = $filenumber.ToString("000")

while ($skip -le $totalLines) {
    $upper = $skip + $count - 1
    if ($upper -gt ($lines.Length - 1)) {
        $upper = $lines.Length - 1
    }

    # Write the lines
    [System.IO.File]::WriteAllLines("E:\scripttest\splitlog\debug$fileNumberString.log",$lines[($skip..$upper)])

    # Increment counters
    $skip += $count
    $fileNumber++
    $fileNumberString = $filenumber.ToString("000")
}

$sw.Stop()

Write-Host "Split complete in " $sw.Elapsed.TotalSeconds "seconds" 