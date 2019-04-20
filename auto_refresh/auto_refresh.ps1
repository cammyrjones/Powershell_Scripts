$ie = New-Object -com internetexplorer.application;
$ie.Navigate("")
$ie.Visible = $true

$i = 0;

# Wait for the page to load
while ($i -ge 0)
{
    Write-Host 'IE Refresh count: ' + $i
    Start-Sleep -Seconds 180
    $i = $i+1;
    $ie.Refresh()
}
