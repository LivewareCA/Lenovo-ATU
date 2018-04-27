@ECHO OFF
CLS
REM This script uses a tool called "WinAIA64.exe" to change and set BIOS information on LENOVO laptop systems. This script is called for and run by the "startnet.cmd" script that runs at boot in a WinPE x64 Enviroment. It then uses WMIC to gather information from the BIOS, confirms the model is a LAPTOP, then prompts the user for the asset tag number. Once entered the script uses the value given and runs it in the command-line argument for the "WinAIA64.exe" utility.
REM This is only compatible in the amd_64 WinPE with WMI and Scripting modules injected.
REM winaia64.exe -set USERASSETDATA.ASSET_NUMBER=[ASSET TAG NUMBER]
:GATHER
REM Get the system settings using WMIC, then puts the results into an ARRAY.
FOR /F "tokens=*" %%A IN ('WMIC computersystem GET /FORMAT:list ^| FIND "="') DO (
    SET __ComputerSystem.%%A
    )
REM Get the some basic BIOS info and put the results into an ARRAY.
FOR /F "tokens=*" %%A IN ('WMIC bios GET /FORMAT:list ^| FIND "="') DO (
    SET __BIOS.%%A
    )
REM Find the BIOS version and serial number and set the results as variables.
FOR /F "tokens=2* delims=.=" %%A IN ('SET __BIOS.') DO (
    IF "%%A"=="SMBIOSBIOSVersion" SET currentBIOSversion=%%B
    IF "%%A"=="SerialNumber" SET lenovoSerial=%%B
    )
REM Find the computer model and assign it to a new variable.
FOR /F "tokens=2* delims=.=" %%A IN ('SET __ComputerSystem.') DO IF "%%A"=="Model" SET systemmodel=%%B

ECHO ##################################################################
ECHO #                                                                #
ECHO #   Welcome to the Microserve Asset Tag Utility for UEFI BIOS.   # 
ECHO #                                                                #
ECHO ##################################################################
ECHO.
:CASTLE
ECHO Please select system type?
ECHO 1 - Laptop
ECHO 2 - Desktop
ECHO.
SET /p ROOK=Type 1 or 2: 
IF %ROOK%==1 GOTO BLITZ
IF %ROOK%==2 GOTO MUTE
ELSE GOTO CASTLE

:BLITZ
CLS
:IQ
SET /P ASH=Please enter the LAPTOP asset tag number: 
IF "%ASH%"=="" GOTO SLEDGE
SET "BUCK=USERASSETDATA.ASSET_NUMBER="
SET "LION=%BUCK%%ASH%"
U:
CD _Laptop
 WinAIA64.exe -set %LION%
ECHO %systemmodel%,%ASH%,%lenovoSerial% >> U:\assetLog.csv
ECHO Asset Tag set as %ASH%, shutting down in 5 seconds!
PING 127.0.0.1 -n 3 > nul
EXIT
GOTO CASTLE
:SLEDGE
CLS
ECHO.
ECHO L*****************************************************
ECHO *        Blank asset tag sequence attempted!!        *
ECHO *          Please enter a valid asset tag!           *
ECHO ******************************************************
ECHO.
GOTO IQ

:MUTE
CLS
:SMOKE
SET /P DOC=Please enter the DESKTOP asset tag number: 
IF "%DOC%"=="" GOTO ELA
SET "FROST=/tag:"
SET "MIRA=%FROST%%DOC%"
U:
CD _Desktop
WFLASH2x64.exe %MIRA%
ECHO %systemmodel%,%DOC%,%lenovoSerial% >> U:\assetLog.csv
ECHO Asset Tag set as %DOC%, shutting down in 5 seconds!
EXIT
GOTO CASTLE
:ELA
CLS
ECHO.
ECHO D*****************************************************
ECHO *        Blank asset tag sequence attempted!!        *
ECHO *          Please enter a valid asset tag!           *
ECHO ******************************************************
ECHO.
GOTO SMOKE


