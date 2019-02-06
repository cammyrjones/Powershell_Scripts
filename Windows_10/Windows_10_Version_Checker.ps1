$ccsoupath = "OU=Capita Communications and Control Solutions,OU=Business Unit,DC=ad,DC=capita,DC=co,DC=uk"
Get-ADComputer -Filter {OperatingSystem -Like "*Windows 10*"} -SearchBase $ccsoupath -Property * | Select-Object -Property  Name, OperatingSystem, OperatingSystemVersion