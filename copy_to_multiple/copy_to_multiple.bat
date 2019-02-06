rem @echo off
setlocal enableextensions enabledelayedexpansion

rem loop to copy files from source to destination - CAUTION will automatically overwrite
for /f %%x in (E:\scripttest\copy_to_multiple\pclist.txt) do (
    xcopy "e:\scripttest\copy_to_multiple\sourcefiles\*" "\\%%x\c$\data\destination" /s /i /y
	pause
    )
    


