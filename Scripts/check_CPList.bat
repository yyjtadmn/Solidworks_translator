@echo off
set productVersion=%1
set logfile="P:\Data_Exchange\from_Roma\jenkins\CP_list.txt"
call C:\\apps\\devop_tools\\perl.d\\bin\\perl.exe C:\\apps\\devop_tools\\bin\\dtcmd.pl cp qry -e %productVersion%>%logfile%
rem find /v /c "" P:\Data_Exchange\from_Roma\jenkins\CP_list.txt
for /F "usebackq tokens=3 delims=:" %%L in (`find /v /c "" %logfile%`) do set lines=%%L
SET /A totalCP=%lines%-1
if %totalCP% lss 1 (echo 1) else (echo %totalCP%)

