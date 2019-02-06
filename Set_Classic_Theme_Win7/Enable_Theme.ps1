New-Item -path $RegKey -name System
 $RegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
  ##Enabled
  New-ItemProperty -path $RegKey -name SetVisualStyle -value C:\Windows\Resources\"Ease of Access Themes"\classic.theme -PropertyType String