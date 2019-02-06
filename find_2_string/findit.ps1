$searchpath = "C:\temp\testing\files\"
$string1 = "a321"
$string2 = "ohai"

$firstmatch = @()
$secondmatch = @()

Get-ChildItem -Path $searchpath -Recurse | ForEach-Object {
    if (Select-String -Path $_.FullName -Pattern $string1 -AllMatches) {
        $firstmatch += $_
    }
}
$firstmatch | ForEach-Object {
    if (Select-String -Path $_.FullName -Pattern $string2 -AllMatches) {
        $secondmatch += $_
    }
}
Write-Output $secondmatch