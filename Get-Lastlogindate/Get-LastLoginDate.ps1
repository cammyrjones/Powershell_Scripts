Import-Module ActiveDirectory

Get-ADComputer -Filter * -Properties *  | Sort-Object LastLogonDate | Format-Table Name, LastLogonDate -Autosize