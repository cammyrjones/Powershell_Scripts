$RegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies"
Remove-ItemProperty -Path($RegKey + "\System") -name SetVisualStyle
If( (Get-Item -Path($RegKey + "\System")).ValueCount -eq 0 -and (Get-Item -Path($RegKey + "\System")).SubKeyCount -eq 0)
{
 Remove-Item -Path($RegKey + "\System")   
}