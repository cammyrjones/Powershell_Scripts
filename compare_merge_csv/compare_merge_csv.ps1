$oldcsv=Import-Csv -Path "C:\temp\asset_db\output.csv"
$newxlsx = Get-Content "C:\temp\asset_db\Asset Database Lakeside.xlsx"
ForEach($Record in $oldcsv){
    $MatchedValue = (Compare-Object $threat $Record -Property "Computer Name","Creation time" -IncludeEqual -ExcludeDifferent -PassThru).value
    $Record = Add-Member -InputObject $Record -Type NoteProperty -Name "Value" -Value $MatchedValue
}
$alert|Export-Csv ".\Combined.csv" -NoTypeInformation
