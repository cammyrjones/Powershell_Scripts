#prompt for sa_ account to use to join to domain
$saaccount = Read-Host "Please enter name of SA account to use to join to domain - does not require domain prefix"

#remove computer from existing domain using local admin account
#Remove-Computer -UnjoinDomaincredential localhost\administrator -PassThru -Verbose -Force
#add computer to capita domain using sa account - will automatically drop into specified OU
Add-Computer –Domain ad.capita.co.uk –Credential "ad.capita.co.uk\$saaccount" –Restart -OUPath "OU=Production,OU=Computers,OU=Desktop,OU=Capita Communications and Control Solutions,OU=Business Unit,DC=ad,DC=capita,DC=co,DC=uk"