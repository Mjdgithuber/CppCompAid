:: Matthew J. Dennerlein C++ compiler aid
:: I wrote this to aid my compiling for C++. I use it for emacs, running this through emacs terminal,
:: but this will work just fine on cygwin. To use this, drop this batch into a new folder and double
:: click it. You should see a simple file structure appear. All source code should be placed within
:: the src folder. The objects folder will contain the object files, the generated program.exe and
:: past exe's stored in the backup folder. To use in cygwin, navigate to the folder holding this exe
:: and type "./compile.bat" or "./compile.bat help" to find out about some tags
:: CURRENT STANDARD c++11

@echo off

SETLOCAL EnableDelayedExpansion

ECHO.

:: Create directories if not set up properly
SET _mkdir=false
IF NOT EXIST %0/../objects/ (
	SET _mkdir=true
	MKDIR %0/../objects/
)

IF NOT EXIST %0/../objects/backup/ (
	SET _mkdir=true
	MKDIR %0/../objects/backup/
)

IF NOT EXIST %0/../src/ (
	SET _mkdir=true
	MKDIR %0/../src
)

:: Exit batch if any directories were made
IF "%_mkdir%" == "true" (
	EXIT /B
	ECHO ** Set up directory^^! **
	PAUSE
)

:: Delete old object files
FOR /R %0/../objects %%K IN (*.o) DO (
	DEL "%%K"
)
ECHO ** Deleted old object files^^! **

ECHO.

PAUSE

:: Checks to see if any params were passed in
SET file=none
SET parm_entered=false
IF NOT %1.==. (
	SET parm_entered=true
	IF /I "%1" == "f" (
		IF %2.==. (
			ECHO.
			ECHO ** No file passed^^! Ex^^: ./compile f filename.cpp **
			EXIT /B
		) ELSE (
			FOR /R %0/../ %%M IN (%2*) DO (
				:: Gets last 3 chars in file name
				SET _temp=%%M
				SET _temp=!_temp:~-3!

				IF "!_temp!"=="cpp" (
					ECHO.
					ECHO %%M
					SET /P corr=Correct file? ^(y/n^)
					IF /I "!corr!" == "y" (
						SET file=%%M
						GOTO :break
					)
				)
			)
			
			
		)
		
	) ELSE (
		IF /I "%1" == "c" (
			ECHO.
			SET /P cn=Would you like to clean out backups folder? ^(y/n^)
			IF /I "!cn!" == "y" (
				DEL %0\..\objects\backup\*.exe
				ECHO.
				ECHO ** Cleaned backups folder^^! **
				ECHO.
			) ELSE (
				ECHO.
				ECHO ** Aborted Cleaning **
				ECHO.
				)
			EXIT /B
		) ELSE (
			IF /I "%1" == "r" (
				ECHO. 
				ECHO Attempting to run without compiling
				IF EXIST %0/../objects/program.exe (
					ECHO.
					start "" %0/../objects/program.exe
					ECHO ** Successfully ran program without recompiling **
					ECHO.
					EXIT /B
				) ELSE (
					ECHO.
					ECHO ** ERROR: No program found^^! Try to recompile^^! **
					ECHO.
					EXIT /B
				)
			) ELSE (
				IF /I "%1" == "help" (
					ECHO.
					ECHO This batch file is an aid to compiling C++ programs.
					ECHO Running this batch, will create a directiory if it 
					ECHO doesn't already exist. It will then compile each file
					ECHO in the src folder, and put all of the objects files
					ECHO into the objects folder. If all went well it will
					ECHO generate an .exe called program, in the objects foler.
					ECHO The batch also keeps past .exe in the backups folder
					ECHO within the objects folder.
					ECHO Valid params:
					ECHO 'f' followed by 'file_name' allows for compilation of a single file
					ECHO 'c' cleans out the backup folder
					ECHO 'r' runs the program without recompiling the project
					EXIT /B
				) ELSE (
					ECHO.
					ECHO ** Invalid param^^! Valid params^^: 'f', 'c', 'r', 'help' **
					ECHO.
					EXIT /B
				)
			)
		)
	)	
	:break
	IF "%file%" == "none" (
		ECHO.
		ECHO ** No files found. Exiting **
		ECHO.
		EXIT /B
	)
)

IF "%file%" == "none" (
	SET compilelist=

	:: Compile all .cpp into object files
	FOR /R %0/../src %%J IN (*.cpp) DO (
	
		:: Gets last 3 chars in file name
		SET _temp=%%J
		SET _temp=!_temp:~-3!
		REM ECHO !_temp!

		:: Checks to make sure file is really .cpp which makes it EMACS safe
		IF "!_temp!"=="cpp" (
			g++ -std=c++11 -g -Wall -Wextra -Wfloat-equal -Wundef -Wcast-align -Wwrite-strings -Wlogical-op -Wmissing-declarations -Wredundant-decls -Wshadow -Woverloaded-virtual -c "%%J" -o "objects/%%~nJ.o" 
			SET compilelist=!compilelist!%%J 
		)
	)
) ELSE (
	FOR %%F IN ("!file!") DO (
		g++ -std=c++11 -g -Wall -Wextra -Wfloat-equal -Wundef -Wcast-align -Wwrite-strings -Wlogical-op -Wmissing-declarations -Wredundant-decls -Wshadow -Woverloaded-virtual -c "!file!" -o "objects/%%~nF.o" 
	)
)

ECHO.
ECHO ** Generated new object files ***
ECHO.

PAUSE
ECHO.

SET PROG="false"
IF EXIST %0/../objects/backup/program.exe (
	SET PROG="true"
)

REM ECHO %PROG% ***

IF !PROG! == "true" (
	SET _lrg=1
	FOR /R %0/../objects/backup %%P IN (*.exe) DO (
		REM ECHO %%P

		SET _temp=%%P
		SET _temp2=!_temp:~-6!
		SET _temp2=!_temp2:~0,1%!
	
		IF "!_temp2!" NEQ "-" (
			REM ECHO TOO BIG
			SET _temp2=!_temp:~-7!
			SET _temp2=!_temp2:~0,1%!
		
			IF "!_temp2!" NEQ "-" (
				REM ECHO WAY TOO BIG
				SET _temp2=!_temp:~-8!
				SET _temp2=!_temp2:~0,1%!
			
				IF "!_temp2!" NEQ "-" (	
					REM ECHO MEGA BIG
				
					SET _temp2=!_temp:~-9!
					SET _temp2=!_temp2:~0,1%!
				
					IF "!_temp2!" NEQ "-" (
						REM ECHO OMEGA BIG
						SET _temp="overflow"
					) ELSE (
						SET _temp=!_temp:~-8!
						SET _temp=!_temp:~0,4%!
					)				
				) ELSE (
					SET _temp=!_temp:~-7!
					SET _temp=!_temp:~0,3%!
				)
			) ELSE (
				SET _temp=!_temp:~-6!
				SET _temp=!_temp:~0,2%!
			)
		) ELSE (
			SET _temp=!_temp:~-5!
			SET _temp=!_temp:~0,1%!
		)
	


	
		REM ECHO !_temp!

		IF "!_temp!" NEQ "overflow" (
			IF !_temp! GEQ !_lrg! (
				SET /a "_lrg=!_temp!+1"
				REM ECHO Lrg = !_lrg!
			)
		)
	)
	REM ECHO Lrg = !_lrg!

	IF EXIST %0/../objects/program.exe (
		REN "%~dp0objects\backup\program.exe" "program-old-!_lrg!.exe"
		MOVE /-Y "%~dp0objects\program.exe" "%~dp0objects\backup\program.exe"
		ECHO ** Moved previous program to backup folder^^! **
		ECHO.
	) ELSE (
		ECHO ** No program to backup^^! **
		ECHO.
	)
	
) ELSE (
	IF EXIST %0/../objects/program.exe (
		MOVE /-Y "%~dp0objects\program.exe" "%~dp0objects\backup\program.exe"
		ECHO ** Moved previous program to backup folder^^! **
		ECHO.
	) ELSE (
		ECHO ** No program to backup^^! **
		ECHO.
	)
)
PAUSE

:: Link all .object files to create final exe

SET var=
SETLOCAL EnableDelayedExpansion
FOR /R %0/../objects %%H IN (*.o) DO (

	:: Go into the objects folder and get all file names
	SET var=!var!"%%H" 

)

:: Print a list of all linked objects
:: ECHO !var!

:: Link all objects in the !var! string
g++ -std=c++11 -g !var! -o %0/../objects/program

IF EXIST %0/../objects/program.exe (
	start "" %0/../objects/program.exe
) ELSE (
	ECHO.
	ECHO ** Fix errors and recompile^^! Find prevoius program.exe in backups folder^^! **
	ECHO.
)

REM ECHO finished