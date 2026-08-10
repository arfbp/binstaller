@echo off
setlocal EnableDelayedExpansion
color 0A
title BILI INSTALLER
mode con: cols=80 lines=32

:: =======================================================
:: Self-elevation
:: =======================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Elevated rights are required.
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: =======================================================
:: Runtime variables
:: =======================================================
set "MYDIR=%~dp0"
set "ARIA2=%MYDIR%aria2c.exe"
set "DL_DIR=%MYDIR%downloads"
set "LOG_DIR=%DL_DIR%\logs"
set "TEMP_DIR=%DL_DIR%\temp"
set "HP_DIR=%DL_DIR%\hp"
set "OFFICE_DIR=%DL_DIR%\office"
set "VC_DIR=%DL_DIR%\vc"
set "VPN_DIR=%DL_DIR%\vpn"
set "TIGHTVNC_DIR=%DL_DIR%\tightvnc"
set "COMMON_FLAGS=--check-certificate=false -x 16 -s 16"
set "LOG_FILE=%LOG_DIR%\installer.log"
set "FORCE_DOWNLOAD=0"
set "INSTALL_ALL=0"
set "APP_COUNT=9"

for %%D in ("%DL_DIR%" "%LOG_DIR%" "%TEMP_DIR%" "%HP_DIR%" "%OFFICE_DIR%" "%VC_DIR%" "%VPN_DIR%" "%TIGHTVNC_DIR%") do if not exist %%~D mkdir "%%~D"

:: =======================================================
:: Application registry
:: =======================================================
call :ConfigureRegistry

:: =======================================================
:: Ensure aria2c is available
:: =======================================================
call :EnsureAria2

:: =======================================================
:: Main menu
:: =======================================================
goto MainMenu

:ConfigureRegistry
    set "APP_1_NAME=HP MFP 183 Printer"
    set "APP_1_URL=https://file.mocina.my.id/uploads/Full_Webpack-44.11.2784-LJM182-M185_UWWL_4_1_Full_Webpack.exe"
    set "APP_1_FILE=hp.exe"
    set "APP_1_TYPE=exe"
    set "APP_1_ARGS=/s"
    set "APP_1_DIR=%HP_DIR%"

    set "APP_2_NAME=EasyConnect VPN"
    set "APP_2_URL=https://file.mocina.my.id/uploads/EasyConnectInstaller.exe"
    set "APP_2_FILE=vpn.exe"
    set "APP_2_TYPE=exe"
    set "APP_2_ARGS=/S"
    set "APP_2_DIR=%VPN_DIR%"

    set "APP_3_NAME=Office 365"
    set "APP_3_URL=https://file.mocina.my.id/uploads/OfficeSetup.exe"
    set "APP_3_FILE=o365.exe"
    set "APP_3_TYPE=exe"
    set "APP_3_ARGS=/configure"
    set "APP_3_DIR=%OFFICE_DIR%"
    set "APP_3_CONFIG_URL=https://file.mocina.my.id/uploads/config.yml"
    set "APP_3_CONFIG_FILE=config.yml"

    set "APP_4_NAME=WeCom"
    set "APP_4_URL=https://file.mocina.my.id/uploads/WeCom_4.1.38.6006.exe"
    set "APP_4_FILE=wecom.exe"
    set "APP_4_TYPE=exe"
    set "APP_4_ARGS=/S"
    set "APP_4_DIR=%DL_DIR%"

    set "APP_5_NAME=VC++ Runtime AIO"
    set "APP_5_URL=https://file.mocina.my.id/uploads/Visual-C-Runtimes-All-in-One-Jun-2025.zip"
    set "APP_5_FILE=vcruntime.zip"
    set "APP_5_TYPE=zip"
    set "APP_5_ARGS="
    set "APP_5_DIR=%VC_DIR%"

    set "APP_6_NAME=Windows Switch Version"
    set "APP_6_URL=https://file.mocina.my.id/uploads/Switch%%20os%%20ver%%20win%%2010.bat"
    set "APP_6_FILE=switch_win.bat"
    set "APP_6_TYPE=bat"
    set "APP_6_ARGS="
    set "APP_6_DIR=%DL_DIR%"

    set "APP_7_NAME=Activate Windows 10 Pro"
    set "APP_7_URL=https://file.mocina.my.id/uploads/windows_10_active_nologo.bat"
    set "APP_7_FILE=activate_win.bat"
    set "APP_7_TYPE=bat"
    set "APP_7_ARGS="
    set "APP_7_DIR=%DL_DIR%"

    set "APP_8_NAME=O365 License Uninstaller"
    set "APP_8_URL=https://file.mocina.my.id/uploads/uninstall_license_0365.vbs"
    set "APP_8_FILE=uninstall_o365.vbs"
    set "APP_8_TYPE=vbs"
    set "APP_8_ARGS="
    set "APP_8_DIR=%DL_DIR%"

    set "APP_9_NAME=TightVNC Server"
    set "APP_9_URL=https://file.mocina.my.id/uploads/tightvnc-2.8.85-gpl-setup-64bit.msi"
    set "APP_9_FILE=tightvnc.msi"
    set "APP_9_TYPE=msi"
    set "APP_9_ARGS=/quiet /norestart ADDLOCAL=Server SET_USEVNCAUTHENTICATION=1 SET_PASSWORD=78616a684031333134 SET_VIEWONLYPASSWORD=78616a684031333134"
    set "APP_9_DIR=%TIGHTVNC_DIR%"
    exit /b 0

:EnsureAria2
    if not exist "%ARIA2%" (
        echo [INFO] aria2c.exe not found. Downloading...
        powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://file.mocina.my.id/uploads/aria2c.exe' -OutFile '%ARIA2%'"
    )
    if exist "%ARIA2%" (
        "%ARIA2%" --version >nul 2>&1
        if errorlevel 1 (
            echo [WARN] aria2c.exe is invalid. Redownloading...
            del "%ARIA2%" >nul 2>&1
            powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://file.mocina.my.id/uploads/aria2c.exe' -OutFile '%ARIA2%'"
        )
    )
    if not exist "%ARIA2%" (
        echo [WARN] aria2c.exe unavailable. Downloads will fall back to PowerShell.
    )
    exit /b 0

:MainMenu
    cls
    call :RenderBanner "BILI INSTALLER"
    echo.
    echo   [1]  HP MFP 183 Printer
    echo   [2]  EasyConnect VPN
    echo   [3]  Office 365
    echo   [4]  WeCom
    echo   [5]  VC++ Runtime AIO
    echo   [6]  Windows Switch Version
    echo   [7]  Activate Windows 10 Pro
    echo   [8]  O365 License Uninstaller
    echo   [9]  TightVNC Server
    echo.
    echo   [10] Install Everything
    echo   [R]  Toggle Force Redownload  (Current: %FORCE_DOWNLOAD%)
    echo.
    echo   [0]  Exit
    echo.
    call :RenderDivider
    echo.
    set /p "choice=Choose an option [0-10,R]: "
    if /i "%choice%"=="R" call :ToggleForce & goto MainMenu
    if "%choice%"=="0" goto Exit
    if "%choice%"=="1" call :InstallApp 1 & goto MainMenu
    if "%choice%"=="2" call :InstallApp 2 & goto MainMenu
    if "%choice%"=="3" call :InstallApp 3 & goto MainMenu
    if "%choice%"=="4" call :InstallApp 4 & goto MainMenu
    if "%choice%"=="5" call :InstallApp 5 & goto MainMenu
    if "%choice%"=="6" call :InstallApp 6 & goto MainMenu
    if "%choice%"=="7" call :InstallApp 7 & goto MainMenu
    if "%choice%"=="8" call :InstallApp 8 & goto MainMenu
    if "%choice%"=="9" call :InstallApp 9 & goto MainMenu
    if "%choice%"=="10" call :InstallAll & goto MainMenu
    echo [WARN] Invalid selection. Choose 0-10 or R.
    pause>nul
    goto MainMenu

:RenderBanner
    echo ========================================================
    echo %~1
    echo ========================================================
    exit /b 0

:RenderDivider
    echo --------------------------------------------------------
    exit /b 0

:ToggleForce
    if "%FORCE_DOWNLOAD%"=="0" (
        set "FORCE_DOWNLOAD=1"
        echo [INFO] Force redownload enabled.
    ) else (
        set "FORCE_DOWNLOAD=0"
        echo [INFO] Force redownload disabled.
    )
    pause>nul
    exit /b 0

:InstallApp
    set "APP_ID=%~1"
    call set "APP_NAME=%%APP_!APP_ID!_NAME%%"
    call set "APP_URL=%%APP_!APP_ID!_URL%%"
    call set "APP_FILE=%%APP_!APP_ID!_FILE%%"
    call set "APP_TYPE=%%APP_!APP_ID!_TYPE%%"
    call set "APP_ARGS=%%APP_!APP_ID!_ARGS%%"
    call set "APP_DIR=%%APP_!APP_ID!_DIR%%"
    call set "APP_CONFIG_URL=%%APP_!APP_ID!_CONFIG_URL%%"
    call set "APP_CONFIG_FILE=%%APP_!APP_ID!_CONFIG_FILE%%"
    set "APP_PATH=%APP_DIR%\%APP_FILE%"
    if not exist "%APP_DIR%" mkdir "%APP_DIR%"
    call :StatusInfo "Preparing %APP_NAME%"
    if defined APP_CONFIG_URL (
        call :DownloadFile "%APP_NAME% config" "%APP_CONFIG_URL%" "%APP_DIR%" "%APP_CONFIG_FILE%"
        if errorlevel 1 goto InstallFailed
        set "APP_ARGS=%APP_ARGS% \"%APP_DIR%\%APP_CONFIG_FILE%\""
    )
    call :DownloadFile "%APP_NAME%" "%APP_URL%" "%APP_DIR%" "%APP_FILE%"
    if errorlevel 1 goto InstallFailed
    call :RunInstaller "%APP_NAME%" "%APP_PATH%" "%APP_TYPE%" "%APP_ARGS%"
    if errorlevel 1 goto InstallFailed
    if "%INSTALL_ALL%"=="1" set "RESULT_!APP_ID!=OK"
    echo.
    pause>nul
    exit /b 0

:InstallFailed
    if "%INSTALL_ALL%"=="1" set "RESULT_!APP_ID!=FAILED"
    echo.
    pause>nul
    exit /b 1

:InstallAll
    set "INSTALL_ALL=1"
    set /a SUCCESS_COUNT=0
    set /a FAIL_COUNT=0
    for /L %%I in (1,1,%APP_COUNT%) do (
        call set "APP_NAME=%%APP_%%I_NAME%%"
        echo.
        call :StatusInfo "Installing %%I of %APP_COUNT% - !APP_NAME!"
        call :InstallApp %%I
        if errorlevel 1 (
            set /a FAIL_COUNT+=1
        ) else (
            set /a SUCCESS_COUNT+=1
        )
    )
    call :SummaryScreen
    set "INSTALL_ALL=0"
    pause>nul
    exit /b 0

:DownloadFile
    set "APP_LABEL=%~1"
    set "DOWNLOAD_URL=%~2"
    set "DOWNLOAD_DIR=%~3"
    set "DOWNLOAD_FILE=%~4"
    set "DOWNLOAD_PATH=%DOWNLOAD_DIR%\%DOWNLOAD_FILE%"
    if "%FORCE_DOWNLOAD%"=="1" if exist "%DOWNLOAD_PATH%" del "%DOWNLOAD_PATH%" >nul 2>&1
    if exist "%DOWNLOAD_PATH%" (
        call :StatusSuccess "%APP_LABEL% already available"
        exit /b 0
    )
    if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"
    call :StatusInfo "Downloading %APP_LABEL%"
    if exist "%ARIA2%" (
        "%ARIA2%" %COMMON_FLAGS% -d "%DOWNLOAD_DIR%" -o "%DOWNLOAD_FILE%" "%DOWNLOAD_URL%" >nul 2>&1
        if errorlevel 1 (
            call :StatusWarning "aria2 failed. Falling back to PowerShell"
            powershell -NoProfile -Command "Try { Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_PATH%' -UseBasicParsing } Catch { exit 1 }"
        )
    ) else (
        powershell -NoProfile -Command "Try { Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_PATH%' -UseBasicParsing } Catch { exit 1 }"
    )
    if not exist "%DOWNLOAD_PATH%" (
        call :StatusError "%APP_LABEL% download failed"
        exit /b 1
    )
    call :StatusSuccess "%APP_LABEL% downloaded"
    exit /b 0

:RunInstaller
    set "APPLICATION=%~1"
    set "INSTALL_PATH=%~2"
    set "INSTALL_TYPE=%~3"
    set "INSTALL_ARGS=%~4"
    if not exist "%INSTALL_PATH%" (
        call :StatusError "%APPLICATION% installer missing"
        exit /b 1
    )
    call :StatusInfo "Installing %APPLICATION%"
    if /i "%INSTALL_TYPE%"=="msi" (
        msiexec /i "%INSTALL_PATH%" /quiet /norestart %INSTALL_ARGS%
        set "LAST_CODE=%errorlevel%"
    ) else if /i "%INSTALL_TYPE%"=="exe" (
        powershell -NoProfile -Command "Start-Process -FilePath '%INSTALL_PATH%' -ArgumentList '%INSTALL_ARGS%' -Wait" >nul 2>&1
        set "LAST_CODE=%errorlevel%"
    ) else if /i "%INSTALL_TYPE%"=="bat" (
        call "%INSTALL_PATH%" %INSTALL_ARGS%
        set "LAST_CODE=%errorlevel%"
    ) else if /i "%INSTALL_TYPE%"=="vbs" (
        cscript //nologo "%INSTALL_PATH%" %INSTALL_ARGS%
        set "LAST_CODE=%errorlevel%"
    ) else if /i "%INSTALL_TYPE%"=="zip" (
        call :InstallZip "%INSTALL_PATH%"
        set "LAST_CODE=%errorlevel%"
    ) else (
        call :StatusError "%APPLICATION% unsupported installer type: %INSTALL_TYPE%"
        exit /b 1
    )
    if %LAST_CODE% neq 0 (
        call :StatusError "%APPLICATION% installation failed"
        exit /b 1
    )
    call :StatusSuccess "%APPLICATION% installed"
    exit /b 0

:InstallZip
    set "ZIP_PATH=%~1"
    if not exist "%ZIP_PATH%" (
        call :StatusError "Archive missing"
        exit /b 1
    )
    set "EXTRACT_DIR=%VC_DIR%\vcruntime"
    if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"
    if exist "%SEVENZIP%" (
        "%SEVENZIP%" x "%ZIP_PATH%" -o"%EXTRACT_DIR%" -y >nul 2>&1
    ) else (
        powershell -NoProfile -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force" >nul 2>&1
    )
    if not exist "%EXTRACT_DIR%\install_all.bat" (
        call :StatusError "VC runtime package invalid"
        exit /b 1
    )
    pushd "%EXTRACT_DIR%"
    powershell -NoProfile -Command "Start-Process -FilePath '%EXTRACT_DIR%\install_all.bat' -Wait" >nul 2>&1
    set "LAST_CODE=%errorlevel%"
    popd
    exit /b %LAST_CODE%

:StatusInfo
    echo [INFO] %~1
    exit /b 0

:StatusSuccess
    echo [ OK ] %~1
    exit /b 0

:StatusWarning
    echo [WARN] %~1
    exit /b 0

:StatusError
    echo [FAIL] %~1
    exit /b 0

:SummaryScreen
    echo.
    echo ========================================================
    echo Deployment Summary
    echo ========================================================
    for /L %%I in (1,1,%APP_COUNT%) do (
        call set "APP_NAME=%%APP_%%I_NAME%%"
        call set "APP_RESULT=%%RESULT_%%I%%"
        if not defined APP_RESULT set "APP_RESULT=SKIPPED"
        echo %%I. !APP_NAME! - !APP_RESULT!
    )
    echo ========================================================
    echo Successful : %SUCCESS_COUNT%
    echo Failed     : %FAIL_COUNT%
    echo ========================================================
    exit /b 0

:Exit
    endlocal
    exit /b 0
