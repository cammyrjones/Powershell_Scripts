#original command line version
#& DISM /Online /Enable-Feature /FeatureName:NetFx3 /NoRestart

#start dism with specified argument list, wait to finish
Start-Process -FilePath "dism.exe" -ArgumentList "/Online","/Enable-Feature","/FeatureName:NetFx3","/NoRestart" -Wait