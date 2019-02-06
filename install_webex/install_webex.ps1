. \\filesvr1\Scripts\install_msi\function_install-msi.ps1

#$computers = (Get-ADComputer -Filter * -SearchBase "OU=Production,OU=Computers,OU=Desktop,OU=Capita Communications and Control Solutions,OU=Business Unit,DC=ad,DC=capita,DC=co,DC=uk"|Select-Object -ExpandProperty name)
$computers = (Get-ADComputer -Filter * -SearchBase "OU=Staging,OU=Computers,OU=Desktop,OU=Capita Communications and Control Solutions,OU=Business Unit,DC=ad,DC=capita,DC=co,DC=uk"|Select-Object -ExpandProperty name)


$installersourcepath = "\\filesvr1\Software\Webex\webexmc.msi"

Start-Transcript
install-msi -computers $computers -installersourcepath $installersourcepath
Stop-Transcript