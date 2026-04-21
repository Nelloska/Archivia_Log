Title [zip log : Archiviazione file antecedenti a %logfileage% giorni e eliminazione log antecenti a %ArchiveAge% giorni]
Echo off
cls
REM è il tempo, in giorni, in cui conservi i log zippati sul disco
set ArchiveAge=60
REM è il tempo, in giorni, in cui i log in memoria senza zipparli
set LogfileAge=1
REM è il path dove si trova il tool "Archive_Log"
set Workpath=C:\Support\Archive_Log
REM è il path dove Archive_Log scrive il report di esecuzione
mkdir %Workpath%\Report
set APP=%%f
set ttime=%time:~0,2%_%time:~3,2%_%time:~6,2%
set today=%date:~9,4%-%date:~6,2%-%date:~3,2%
REM LogPath da valorizzare in base al path dove scrivono i logs i nostri applicativi
set LogPath=C:\APP\LOG
set APPpath=%LogPath%\%APP%
set Oldpath=%APPpath%\Old_Log

REM save old report file
ren %Workpath%\Report\Report_%today%.log %ttime%_Report_%today%.log

:STEP0
REM Check partition
	

if exist "%LogPath%" goto STEP1
	ren %Workpath%\Report\Report_%today%.log %ttime%_Report_%today%.log
	Echo ------------------------------------------------------------------------------------------------------------>>  Report_%today%.log
	Echo ###################################       %date% - %time:~0,2%:%time:~3,2%:%time:~6,2%      ###################################>> Report_%today%.log
	Echo Starting Zipping application log file >> Report_%today%.log
	Echo Folder %LogPath% don't find. >> Report_%today%.log
	Echo Application partition in other cluster node >> Report_%today%.log
	
goto END



:STEP1
REM Setting Log date zip = Current date-LogfileAge
goto DATELOG

:STEP2
REM save Old_Log folder
goto SAVEOLDLOG

:STEP3
	Echo ------------------------------------------------------------------------------------------------------------>>  Report_%today%.log
	Echo ###################################       %date% - %time:~0,2%:%time:~3,2%:%time:~6,2%      ###################################>> Report_%today%.log
	Echo Starting Zipping application log file >> Report_%today%.log
	Echo Zipping log file older than  %logfileage% days  >> Report_%today%.log
	Echo Delete log file older than %archiveage% days  >> Report_%today%.log
	Echo ------------------------------------------------------------------------------------------------------------>>  Report_%today%.log
	Echo. >> Report_%today%.log
	Echo. >> Report_%today%.log

REM Zipping old log list_APP
for /f %%f in (%Workpath%\list_APP.txt) do (

	mkdir %LogPath%\%APP%\Old_Log
	Echo ##################################          %APP%         ##################################>> Report_%today%.log
	Echo Folder Application Log : %LogPath%\%APP% >> Report_%today%.log
	Forfiles -p%APPpath% -s -m*.%logdate% -c"cmd /C %WorkPath%\7z.exe a "%APPpath%\%APPLog%.zip" "@FILE""
	Echo If already exist %APPLog%.zip create a copy with time prefix >> Report_%today%.log
	ren  %OldPath%\%APPLog%.zip %ttime%_%APPLog%.zip
	Echo and move the new %APPLog%.zip in folder %Oldpath% >> Report_%today%.log	
	move %APPpath%\%APPLog%.zip %OldPath%\%APPLog%.zip
	Forfiles -p%APPpath% -s -m*.%logdate%  -c"cmd /c del /q "@FILE"" 
	Forfiles -d-%ArchiveAge% -p%OldPath% -s -m*.* -c"cmd /c del /q "@FILE"" 
	IF EXIST "%OldPath%\%APPLog%.zip" (
	Echo Zipped log file in %APPLog%.zip >> Report_%today%.log
	) ELSE ( 
		Echo NOT ZIPPED FILE for %APP% application >> Report_%today%.log		
		)	
	Echo ------------------------------------------------------------------------------------------------------------>>  Report_%today%.log
)

goto END

:DATELOG
@echo off

set yy=%date:~9,4%
set mm=%date:~6,2%
set dd=%date:~3,2%

if %dd%==08 (
set dd=8 ) else (
if %dd%==09 (
set dd=9 ) )

if %mm%==08 (
set mm=8 ) else (
if %mm%==09 (
set mm=9 ) )

set /A dd=%dd% - %LogfileAge%
set /A mm=%mm% + 0

if /I %dd% GTR 0 goto DONE
set /A mm=%mm% - 1
if /I %mm% GTR 0 goto ADJUSTDAY
set /A mm=12
set /A yy=%yy% - 1

:ADJUSTDAY
if %mm%==1 goto SET31
if %mm%==2 goto LEAPCHK
if %mm%==3 goto SET31
if %mm%==4 goto SET30
if %mm%==5 goto SET31
if %mm%==6 goto SET30
if %mm%==7 goto SET31
if %mm%==8 goto SET31
if %mm%==9 goto SET30
if %mm%==10 goto SET31
if %mm%==11 goto SET30
if %mm%==12 goto SET31

goto ERROR

:SET31
set /A dd=31 + %dd%
goto DONE

:SET30
set /A dd=30 + %dd%
goto DONE

:LEAPCHK
set /A tt=%yy% %% 4
if not %tt%==0 goto SET28
set /A tt=%yy% %% 100
if not %tt%==0 goto SET29
set /A tt=%yy% %% 400
if %tt%==0 goto SET29

:SET28
set /A dd=28 + %dd%
goto DONE

:SET29
set /A dd=29 + %dd%

:DONE
if /i %dd% LSS 10 set dd=0%dd%
if /I %mm% LSS 10 set mm=0%mm%
set logdate=%yy%-%mm%-%dd%
set APPLog=%APP%_%logdate%

goto STEP2

:SAVEOLDLOG
for /f %%f in (%Workpath%\list_APP.txt) do (
	Echo create temp.txt to refresh date folder Old_LOG 
	Echo File temp to avoid zipping Old_LOG folder >> %Oldpath%\temp.txt
	del %Oldpath%\temp.txt
	cd %Workpath%
)

goto STEP3

:END
Echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       ZIP LOG FINISHED       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@>> Report_%today%.log
move Report_%today%.log %Workpath%\Report\Report_%today%.log
EXIT