. \\filesvr1\Scripts\install_msi\function_install-msi.ps1

$computers = (Get-ADComputer -Filter * -SearchBase ""|Select-Object -ExpandProperty name)


$installersourcepath = ""

Start-Transcript
install-msi -computers $computers -installersourcepath $installersourcepath
Stop-Transcript