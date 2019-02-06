$SXS = "\\filesvr1\Software\MICROSOFT\Windows\10\1803\sources\sxs"


Enable-WindowsOptionalFeature -online -featurename netfx3 -Source $SXS #Installs DotNet 3.5 using the sxs folder on the mounted ISO