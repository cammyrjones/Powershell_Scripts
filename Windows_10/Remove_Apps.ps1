# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}


# Change default Explorer view to "Computer"
#Write-Host "Changing default Explorer view to `"Computer`"..."
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1


# Show known file extensions
#Write-Host "Showing known file extensions..."
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0


# Uninstall default Microsoft applications for that user
Write-Host "Uninstalling default Microsoft applications..."
Get-AppxPackage "Microsoft.3DBuilder" | Remove-AppxPackage #3D Builder
Get-AppxPackage "Microsoft.BingFinance" | Remove-AppxPackage #Money
Get-AppxPackage "Microsoft.BingNews" | Remove-AppxPackage # News
Get-AppxPackage "Microsoft.BingSports" | Remove-AppxPackage #Sports
Get-AppxPackage "Microsoft.BingWeather" | Remove-AppxPackage #Weather
Get-AppxPackage "Microsoft.Getstarted" | Remove-AppxPackage #Get Started
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage #Get Microsoft Office
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage #Solitaire
Get-AppxPackage "Microsoft.Office.OneNote" | Remove-AppxPackage #OneNote
Get-AppxPackage "Microsoft.People" | Remove-AppxPackage ~People
Get-AppxPackage "Microsoft.SkypeApp" | Remove-AppxPackage #Not sure if it is "Get Skype" or "Skype Video" App
Get-AppxPackage "Microsoft.WindowsAlarms" | Remove-AppxPackage #Alarms
Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage #Camera
#Get-AppxPackage "microsoft.windowscommunicationsapps" | Remove-AppxPackage #Mail and Calender
Get-AppxPackage "Microsoft.WindowsMaps" | Remove-AppxPackage #Maps
Get-AppxPackage "Microsoft.WindowsPhone" | Remove-AppxPackage #Phone Companion
Get-AppxPackage "Microsoft.WindowsSoundRecorder" | Remove-AppxPackage #Voice Recorder
Get-AppxPackage "Microsoft.XboxApp" | Remove-AppxPackage #Xbox
Get-AppxPackage "Microsoft.ZuneMusic" | Remove-AppxPackage #Groove Music
Get-AppxPackage "Microsoft.ZuneVideo" | Remove-AppxPackage #Groove Music
#Get-AppxPackage "Microsoft.AppConnector" | Remove-AppxPackage #??
Get-AppxPackage "Microsoft.ConnectivityStore" | Remove-AppxPackage #Microsoft Wi-Fi
Get-AppxPackage "Microsoft.Office.Sway" | Remove-AppxPackage #Sway
Get-AppxPackage "Microsoft.Messaging" | Remove-AppxPackage #Messages
Get-AppxPackage "Microsoft.CommsPhone" | Remove-AppxPackage #Phone
Get-AppxPackage "9E2F88E3.Twitter" | Remove-AppxPackage #Twitter
Get-AppxPackage "king.com.CandyCrushSodaSaga" | Remove-AppxPackage #Candy Crush

#Remove apps for new accounts created
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*3dbuilder*"} | remove-appxprovisionedpackage –online #3D Builder
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*windowsalarms*"} | remove-appxprovisionedpackage –online #Alarms
#Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Appconnector*"} | remove-appxprovisionedpackage –online #??
#Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*windowscommunicationsapps*"} | remove-appxprovisionedpackage –online #Mail + Calender
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*windowscamera*"} | remove-appxprovisionedpackage –online #Camera
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*CandyCrushSaga*"} | remove-appxprovisionedpackage –online #Candy Crush
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*officehub*"} | remove-appxprovisionedpackage –online #Get Office
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*skypeapp*"} | remove-appxprovisionedpackage –online #Get Skype
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*getstarted*"} | remove-appxprovisionedpackage –online #Get Started
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*zunemusic*"} | remove-appxprovisionedpackage –online #Groove Music
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*windowsmaps*"} | remove-appxprovisionedpackage –online #Maps
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Messaging*"} | remove-appxprovisionedpackage –online #Messaging + Skype
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*solitairecollection*"} | remove-appxprovisionedpackage –online #Solitaire
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*ConnectivityStore*"} | remove-appxprovisionedpackage –online #Microsoft Wi-Fi
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*bingfinance*"} | remove-appxprovisionedpackage –online #Money
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*zunevideo*"} | remove-appxprovisionedpackage –online #Movies & TV
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*bingnews*"} | remove-appxprovisionedpackage –online #News
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*onenote*"} | remove-appxprovisionedpackage –online #OneNote
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*people*"} | remove-appxprovisionedpackage –online #People
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*CommsPhone*"} | remove-appxprovisionedpackage –online #Phone
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*windowsphone*"} | remove-appxprovisionedpackage –online #Phone Companian
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*WindowsScan*"} | remove-appxprovisionedpackage –online #Scan
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*bingsports*"} | remove-appxprovisionedpackage –online #Sports
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Office.Sway*"} | remove-appxprovisionedpackage –online #Sway
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*Twitter*"} | remove-appxprovisionedpackage –online #Twitter
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*soundrecorder*"} | remove-appxprovisionedpackage –online #Voice Recorder
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*bingweather*"} | remove-appxprovisionedpackage –online #Weather
Get-appxprovisionedpackage –online | where-object {$_.packagename –like "*xboxapp*"} | remove-appxprovisionedpackage –online #Xbox


# Restart
#Write-Host
#Write-Host "Press any key to restart your system..." -ForegroundColor Black -BackgroundColor White
#$key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
#Write-Host "Restarting..."
#Restart-Computer