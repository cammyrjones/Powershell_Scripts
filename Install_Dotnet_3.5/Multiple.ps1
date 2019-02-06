$SXS = "\\filesvr1\Software\MICROSOFT\Windows\2012R2\Windows\sources\sxs"


$Servers = @(
"EASTCVDBS01"
"EASTCVAS01"
"EASTCVAS02"
"EASTCVAS03"
"EASTCVAS04"
"EASTCVAS05"
#"EASTCVAS06"
)

foreach ($Server in $Servers){
    $Destination = "\\$Server\c$\Temp"
    if (-not(Test-Path -Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination
    }
Copy-Item -Path $SXS -Destination $Destination -Recurse
Invoke-Command -ComputerName $Server -ScriptBlock { Install-WindowsFeature net-framework-core -Source "C:\Temp\SXS" } -AsJob #Installs DotNet 3.5 from SXS folder
}