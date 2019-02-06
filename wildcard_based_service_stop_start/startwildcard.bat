@echo off

REM this will prompt to set a variable for the service name prefix

set /p prefix=Enter service prefix:

if /i '%prefix%'=='' goto error

wmic service where "name like '%prefix%%%'" call startservice

pause
exit

:error
echo Variables missing, exiting
pause
exit
