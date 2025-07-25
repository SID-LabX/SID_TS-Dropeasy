@echo off
setlocal EnableDelayedExpansion

:: Set console title and initial color
title TS to MP4 Converter Pro - Multi-File
color 0A
cls

:: Fixed FFmpeg directory
set "FFMPEG_DIR=C:\Users\birun\Downloads\Documents\ffmpeg"
set "FFMPEG_PATH=%FFMPEG_DIR%\ffmpeg.exe"

:: Step 1: Validate initial conditions
echo TS to MP4 Converter Pro - Multi-File
echo -----------------------------------
if "%~1"=="" (
    color 0C
    echo [ERROR] Drag and drop one or more .ts files to convert.
    echo Press any key to exit...
    pause
    exit /b 1
)

:: Check if FFmpeg exists
if not exist "%FFMPEG_PATH%" (
    color 0C
    echo [ERROR] FFmpeg not found at "%FFMPEG_PATH%".
    echo Please ensure FFmpeg is installed at the specified location.
    echo Press any key to exit...
    pause
    exit /b 1
)

:: Change to FFmpeg directory
cd /d "%FFMPEG_DIR%"
if errorlevel 1 (
    color 0C
    echo [ERROR] Failed to change to FFmpeg directory: "%FFMPEG_DIR%"
    echo Press any key to exit...
    pause
    exit /b 1
)

:: Step 2: Count the number of dropped files
set "FILE_COUNT=0"
for %%F in (%*) do (
    set /a FILE_COUNT+=1
)

:: Step 3: Set output directory based on file count
if !FILE_COUNT! equ 1 (
    :: Single file: Output to the same directory as the input file
    set "OUTPUT_DIR=%~dp1"
    set "LOG_FILE=%FFMPEG_DIR%\conversion_log.txt"
) else (
    :: Multiple files: Create a folder named after the first file
    set "FIRST_FILE=%~nx1"
    for /f "tokens=1 delims= " %%a in ("!FIRST_FILE!") do set "FOLDER_NAME=%%a"
    set "FOLDER_NAME=!FOLDER_NAME:~0,10!_Converted"
    set "OUTPUT_DIR=%~dp1!FOLDER_NAME!"

    :: Ensure unique folder name
    set "COUNTER=1"
    :UNIQUE_FOLDER_CHECK
    if exist "!OUTPUT_DIR!" (
        set "OUTPUT_DIR=%~dp1!FOLDER_NAME!_!COUNTER!"
        set /a COUNTER+=1
        goto UNIQUE_FOLDER_CHECK
    )

    :: Create output directory
    mkdir "!OUTPUT_DIR!"
    if errorlevel 1 (
        color 0C
        echo [ERROR] Failed to create output directory: "!OUTPUT_DIR!"
        echo Press any key to exit...
        pause
        exit /b 1
    )
    set "LOG_FILE=!OUTPUT_DIR!\conversion_log.txt"
)

:: Initialize logging
echo Conversion Log > "!LOG_FILE!"
echo Started: %date% %time% >> "!LOG_FILE!"

:: Initialize counters
set "TOTAL_FILES=0"
set "CONVERTED_FILES=0"
set "FAILED_FILES=0"

:: Step 4: Process all dropped files
:PROCESS_FILES
if "%~1"=="" goto END_PROCESSING

:: Validate .ts file
echo %~x1 | findstr /i ".ts" >nul
if errorlevel 1 (
    echo [SKIP] Unsupported file type: "%~nx1" >> "!LOG_FILE!"
    shift
    goto PROCESS_FILES
)

:: Increment total files
set /a TOTAL_FILES+=1

:: Prepare filenames
set "INPUT_FILE=%~f1"
set "INPUT_FILENAME=%~nx1"

:: Validate input file exists
if not exist "!INPUT_FILE!" (
    echo [ERROR] File not found: "!INPUT_FILENAME!" >> "!LOG_FILE!"
    set /a FAILED_FILES+=1
    shift
    goto PROCESS_FILES
)

:: Generate unique temporary filename (simplified timestamp)
set "TEMP_TIMESTAMP=%time:~0,2%%time:~3,2%%time:~6,2%"
set "TEMP_TIMESTAMP=%TEMP_TIMESTAMP: =0%"
set "TIMESTAMPED_FILENAME=!TEMP_TIMESTAMP!_!TOTAL_FILES!_!INPUT_FILENAME!"

:: Copy file to FFmpeg directory
echo Copying file: "!INPUT_FILENAME!"...
copy "!INPUT_FILE!" "!TIMESTAMPED_FILENAME!" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy file: "!INPUT_FILENAME!" >> "!LOG_FILE!"
    set /a FAILED_FILES+=1
    shift
    goto PROCESS_FILES
)

:: Prompt for output filename (simplified)
set "DEFAULT_OUTPUT=%~n1"
echo Converting: !INPUT_FILENAME!
set /p "CUSTOM_OUTPUT=Enter custom name (or press Enter for default): "
if "!CUSTOM_OUTPUT!"=="" (
    set "OUTPUT_FILENAME=!DEFAULT_OUTPUT!.mp4"
) else (
    set "OUTPUT_FILENAME=!CUSTOM_OUTPUT!.mp4"
)

:: Conversion process
echo Converting to "!OUTPUT_FILENAME!"...
ffmpeg -i "!TIMESTAMPED_FILENAME!" -c:v copy -c:a copy "!OUTPUT_FILENAME!" -y
if errorlevel 1 (
    echo [ERROR] Conversion failed: "!INPUT_FILENAME!" >> "!LOG_FILE!"
    del "!TIMESTAMPED_FILENAME!" >nul 2>&1
    set /a FAILED_FILES+=1
) else (
    :: Move to output directory
    move /Y "!OUTPUT_FILENAME!" "!OUTPUT_DIR!\!OUTPUT_FILENAME!" >nul
    if errorlevel 1 (
        echo [ERROR] Failed to move file: "!OUTPUT_FILENAME!" >> "!LOG_FILE!"
        set /a FAILED_FILES+=1
    ) else (
        set /a CONVERTED_FILES+=1
    )
)

:: Delete temporary file
del "!TIMESTAMPED_FILENAME!" >nul 2>&1

:: Clear the screen and show a clean status message
cls
echo TS to MP4 Converter Pro - Multi-File
echo -----------------------------------
echo Finished converting "!INPUT_FILENAME!"...

:: Move to next file
shift
goto PROCESS_FILES

:END_PROCESSING
:: Final summary
cls
color 0B
echo -----------------------------------
echo Conversion Complete!
echo -----------------------------------
echo Total Files: !TOTAL_FILES!
echo Converted: !CONVERTED_FILES!
echo Failed: !FAILED_FILES!
if !FILE_COUNT! equ 1 (
    echo Output Location: "!OUTPUT_DIR!"
) else (
    echo Output Folder: "!OUTPUT_DIR!"
)
echo Log File: "!LOG_FILE!"
echo Press any key to exit...
pause
exit /b 0

endlocal