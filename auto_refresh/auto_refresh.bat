cd /d %~dp0
powershell -windowstyle hidden -noexit -file ".\auto_refresh.ps1" "%CD%"
