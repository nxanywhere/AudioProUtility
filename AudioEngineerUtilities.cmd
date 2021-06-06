@echo off
:: BatchGotAdmin
:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
:main
cls
call :setESC
title Universal Utility v1.0.1
echo %ESC%[101;93mPlease select menu. %ESC%[0m
echo ----------------------------------------
echo 1.Audio Utilities
echo 2.basic Utilities
echo 3.Reset Daw Programs
SET /P M1=Type 1,or 2 then press ENTER:
IF %M1%==1 GOTO menu
IF %M1%==2 GOTO bumenu
IF %M1%==3 GOTO resetdaw

:menu
cls
title AudioEngineer Utilities v1.0.1
call :setESC
echo ---------------------------------
echo %ESC%[101;93mPlease select choice.%ESC%[0m
echo ---------------------------------
echo 1.Loudness Meter Checker
echo 2.Symlink Spectrasonic Library
echo 3.restart Audioservices
echo 4.Fixing VSTPath
echo 5.spectrum analyzer
echo 6.spectrum analyzer (realtime) - %ESC%[91mnot available%ESC%[0m
echo 7.install plugins (.dll)
echo 8.download youtube audio 
echo 9.audio converter
echo 10.about
echo 11.back to main...
SET /P M=Type 1, 2, 3, 4, 5, 6, 7, 8, ,9 or 10 then press ENTER:
IF %M%==1 GOTO loudnessmeter
IF %M%==2 GOTO symlink-Spectrasonic
IF %M%==3 GOTO RestartAudioSrv
IF %M%==4 GOTO VSTFixer-Auto
IF %M%==5 GOTO specanylizer
IF %M%==6 GOTO specanylizer-rt
IF %M%==7 GOTO pkgvst
IF %M%==8 GOTO ytdl
IF %M%==9 GOTO AuConvert
IF %M%==10 GOTO about
IF %M%==11 GOTO main


:VSTFixer-Auto
title Adding Registry keys....
REG ADD "HKLM\Software\VST" /v "VSTPluginsPath" /t REG_SZ /d "C:\\Program Files\\Common Files\\Audio Plug-ins\\VST2"
REG ADD "HKLM\Software\VST3" /v "VST3PluginsPath" /t REG_SZ /d "C:\\Program Files\\Common Files\\Audio Plug-ins\\VST3"
REG ADD "HKLM\Software\WOW6432Node\VST" /v "VSTPluginsPath" /t REG_SZ /d "C:\\Program Files (x86)\\Common Files\\Audio Plug-ins\\VST2"
REG ADD "HKLM\Software\WOW6432Node\VST3" /v "VSTPluginsPath" /t REG_SZ /d "C:\\Program Files (x86)\\Common Files\\Audio Plug-ins\\VST3"

mkdir "C:\Program Files\Common Files\Audio Plug-ins\VST2"
mkdir "C:\Program Files\Common Files\Audio Plug-ins\VST3"
mkdir "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"
mkdir "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST3" 

title Moving VST2 Path.....
echo %ESC%[7;31mMoving VST2 (64bit) to New location...%ESC%[0m
cd "C:\Program Files\VSTPlugins"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files\Steinberg\VSTPlugins"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files\Common Files\VST"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files\VST"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST2"
rem
echo %ESC%[7;31mMoving VST2 (32bit) to New location...%ESC%[0m
cd "C:\Program Files (x86)\VSTPlugins"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files (x86)\Steinberg\VSTPlugins"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files (x86)\Common Files\VST"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"
cd "C:\Program Files (x86)\VST"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST2"

title Moving VST3 Path.... 
echo %ESC%[7;31mMoving VST3 (64bit) to New location...%ESC%[0m
cd "C:\Program Files\Common Files\VST3"
move "*" "C:\Program Files\Common Files\Audio Plug-ins\VST3"

echo %ESC%[7;31mMoving VST3 (32bit) to New location...%ESC%[0m
cd "C:\Program Files (x86)\Common Files\VST3"
move "*" "C:\Program Files (x86)\Common Files\Audio Plug-ins\VST3"

echo  %ESC%[42mdone!!!%ESC%[0m
pause
cls 
title Fixing in FL Studio
set /P c=Are you sure you want to fixing VSTPath on FL Studio[Y/N]?
if /I "%c%" EQU "Y" goto :somewhere
if /I "%c%" EQU "N" goto :somewhere_else

:somewhere
echo --------------------------------------
echo Fixing......
echo --------------------------------------
REG Add "HKLM\SOFTWARE\Image-Line\Shared\Paths" /v "VST Plugins" /t REG_SZ /d "C:\Program Files\Common Files\Audio Plug-ins\VST2"
echo Done!!
echo in Other DAW your can setting vstpath in preferences, Enjoy!
echo --------------------------
set /P D=Are you sure you want to Restart Computer[Y/N]?
if /I "%D%" EQU "Y" goto :reboot
if /I "%D%" EQU "N" goto :EOF

:somewhere_else
echo in Other DAW your can setting vstpath in preferences, Enjoy!
echo --------------------------
set /P D=Are you sure you want to Restart Computer[Y/N]?
if /I "%D%" EQU "Y" goto :reboot
if /I "%D%" EQU "N" goto :EOF

:EOF
exit

:reboot
shutdown -r -t 00

:RestartAudioSrv
cls
title restarting Audioservices.....
net stop audiosrv
net start audiosrv
echo done!
pause
goto menu

:loudnessmeter
setlocal
set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.OpenFileDialog;"
set "ps=%ps% $f.Filter = 'Audio Files (*.wav)|*.wav|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "Filename=%%I"
ffmpeg -nostats -i "%Filename%" -filter_complex ebur128=peak=true -f null -
pause
goto menu

:symlink-Spectrasonic
set "psCommand="(new-object -COM 'Shell.Application').BrowseForFolder(0,'Please choose an spectrasonic library original.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
mklink /j "C:\Programdata\spectrasonic" "%folder%"
echo done!
pause
goto menu

:specanylizer
cls
title specanylizer
echo ----------------------------------------
echo please select quality
echo ----------------------------------------
echo 1.draft
echo 2.medium
echo 3.ultra high
SET /P Z=Type 1, 2, or 3 then press ENTER:
IF %Z%==1 GOTO low
IF %Z%==2 GOTO medium
IF %Z%==3 GOTO extreme

:specanylizer-rt
echo soon.........
pause
goto menu

:low
set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.OpenFileDialog;"
set "ps=%ps% $f.Filter = 'Audio Files (*.wav)|*.wav|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "Filename01=%%I"

set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.SaveFileDialog;"
set "ps=%ps% $f.Filter = 'Picture files (*.png)|*.png|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "Filename02=%%I"
title processing......
ffmpeg -i "%Filename01%" -y -lavfi showspectrumpic=s=1920x816:mode=separate:scale=log "%Filename02%"
echo done!
goto menu

:medium
set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.OpenFileDialog;"
set "ps=%ps% $f.Filter = 'Audio Files (*.wav)|*.wav|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "Filename03=%%I"

set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.SaveFileDialog;"
set "ps=%ps% $f.Filter = 'Picture files (*.png)|*.png|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "Filename04=%%I"
title processing......
ffmpeg -i "%Filename03%" -y -lavfi showspectrumpic=s=4096x2304:mode=separate:scale=log "%Filename04%"
echo done!
goto menu

:extreme
set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.OpenFileDialog;"
set "ps=%ps% $f.Filter = 'Audio Files (*.wav)|*.wav|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "Filename05=%%I"

set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.SaveFileDialog;"
set "ps=%ps% $f.Filter = 'Picture files (*.png)|*.png|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "Filename06=%%I"
title processing......
ffmpeg -i "%Filename05%" -y -lavfi showspectrumpic=s=8192x4088:mode=separate:scale=log "%Filename06%"
echo done!
goto menu

:pkgvst
cls
title vstinstaller (dll) 64bit only
echo -------------------------
echo select installation mode
echo -------------------------
echo 1.dll file only
echo 2.plugins file and contents
echo **before installing please extract your plugins from compressed files!
SET /P L=Type 1, or 2 then press ENTER:
IF %L%==1 GOTO pluginsfileonly
IF %L%==2 GOTO pluginspkgdir
:pluginsfileonly
set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.OpenFileDialog;"
set "ps=%ps% $f.Filter = 'Vstplugins files (*.dll)|*.dll|VST3 Files (*.vst3)|*.vst3';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "Filename07=%%I"
echo choose path
echo 1.C:\Program Files\Common Files\VST
echo 2.C:\Program Files\Vstplugins
echo 3.C:\Program Files\Steinberg\VSTPlugins
SET /P vstpth=Type 1, 2, or 3 then press ENTER:
IF %vstpth%==1 GOTO dir1
IF %vstpth%==2 GOTO dir2
IF %vstpth%==3 GOTO dir3

:dir1
move "%filename07%" "C:\Program Files\Common Files\VST"
echo installation complete!
pause
goto menu

:dir2
move "%filename07%" "C:\Program Files\Vstplugins"
echo installation complete!
pause
goto menu

:dir3
move "%filename07%" "C:\Program Files\Steinberg\VSTPlugins"
echo installation complete!
pause
goto menu

:pluginspkgdir
set "psCommand="(new-object -COM 'Shell.Application').BrowseForFolder(0,'Please choose an spectrasonic library original.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "vstdir0=%%I"echo installation complete!
echo 1.C:\Program Files\Common Files\VST
echo 2.C:\Program Files\Vstplugins
echo 3.C:\Program Files\Steinberg\VSTPlugins
SET /P vstpthdir9=Type 1, 2, or 3 then press ENTER:
IF %vstpthdir9%==1 GOTO dir4
IF %vstpthdir9%==2 GOTO dir5
IF %vstpthdir9%==3 GOTO dir6

:dir4
move "%vstdir0%\*" "C:\Program Files\Common Files\VST"
echo installation complete!
pause
goto menu

:dir5
move "%vstdir0%\*" "C:\Program Files\Vstplugins"
echo installation complete!
pause
goto menu

:dir6
move "%vstdir0%\*" "C:\Program Files\Steinberg\VSTPlugins"
echo installation complete!
pause
goto menu

:ytdl
cls
title Youtube-DL
echo select file format.....
echo 1.wav format
echo 2.mp3 format
echo 3.check update youtube-dl
echo 4.back to menu
SET /P ytdl10=Type 1, 2, or 3 then press ENTER:
IF %ytdl10%==1 GOTO mp3ytdl
IF %ytdl10%==2 GOTO wavytdl
IF %ytdl10%==3 GOTO ytdlupdate
IF %ytdl10%==4 GOTO menu

:mp3ytdl
Set /p url="Please enter youtube URL: "
youtube-dl -o "%userprofile%/Downloads/%%(title)s.%%(ext)s" -f bestaudio/best --extract-audio --audio-format mp3 -i --audio-quality 320k --ignore-config --hls-prefer-native %URL%
echo done!
pause
goto menu

:wavytdl
Set /p url="Please enter youtube URL: "
youtube-dl -o "%userprofile%/Downloads/%%(title)s.%%(ext)s" -f bestaudio/best --extract-audio --audio-format wav -i --ignore-config --hls-prefer-native %URL%
echo done!
pause
goto menu

:ytdlupdate
youtube-dl --update
pause
goto ytdl

:about
echo Create by Nxanywhere 
echo ---------------------------
echo Ref. Software using in batch file
echo Youtube-DL - Download Audio and Video tools
echo FFMPeg - command-line tool that converts audio or video formats. It can also capture and encode in real-time from various hardware and software sources
echo ffplay - simple media player utilizing SDL and the FFmpeg libraries
echo ffprobe - command-line tool to display media information
pause
goto menu

:AuConvert
cls
title Audio converter
echo ----------------------------
echo select input and output file here
echo ----------------------------
set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.OpenFileDialog;"
set "ps=%ps% $f.Filter = 'Wave Audio Files (*.wav)|*.wav|Mpeg Layer 3 Files (*.mp3)|*.mp3|Flac Files (*.Flac)|*.Flac|Steinberg Wave 64bit Files (*.w64)|*.w64|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "FilenameAUi=%%I"

set "ps=Add-Type -AssemblyName System.windows.forms;"
set "ps=%ps% $f = New-Object System.Windows.Forms.SaveFileDialog;"
set "ps=%ps% $f.Filter = 'Wave Audio Files (*.wav)|*.wav|Mpeg Layer 3 Files (*.mp3)|*.mp3|Flac Files (*.Flac)|*.Flac|Steinberg Wave 64bit Files (*.w64)|*.w64|All Files (*.*)|*.*';"
set "ps=%ps% $f.showHelp = $true;"
set "ps=%ps% $f.ShowDialog();"
set "ps=%ps% $f.FileName"
for /f "delims=" %%I in ('powershell "%ps%"') do set "FilenameAU=%%I"

ffmpeg -i "%filenameAUi%" "%filenameAU%"
pause
goto menu

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)

:bumenu
cls
title Basic Utilities v1.0.1
call :setESC
echo ---------------------------------
echo %ESC%[101;93mPlease select choice.%ESC%[0m
echo ---------------------------------
echo 1.Clean temporary files
echo 2.Symlink (easy)
echo 3.restart Explorer
echo 4.Clear Recycle bin
echo 5.back to menu...
SET /P XXX=Type 1, 2, 3, or 4 then press ENTER:
IF %XXX%==1 GOTO tmpclr
IF %XXX%==2 GOTO symlinkx
IF %XXX%==3 GOTO exprestart
IF %XXX%==4 GOTO binclr
IF %XXX%==5 GOTO main

:tmpclr
cls
cd %temp%
del "*"
pause
goto bumenu

:symlinkx
cls
set "psCommand="(new-object -COM 'Shell.Application').BrowseForFolder(0,'Please choose an folder to link.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folderx1=%%I"

set "psCommand="(new-object -COM 'Shell.Application').BrowseForFolder(0,'Please choose an original folder.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folderx2=%%I"
mklink /j "%folderx1%" "%folderx2%"
pause
goto bumenu

:exprestart
cls
taskkill /F /IM explorer.exe & start explorer
goto bumenu

:binclr
del /s /q %systemdrive%\$Recycle.bin
pause 
goto bumenu

:resetdaw
cls
title reset DAW
echo ----------------------------------
echo Reset DAW programs
echo ----------------------------------
echo 1.FL Studio reset
echo 2.Cubase LE AI Elements Reset (after launch please holdkey ctrl+shift+alt in 1-2 sec)
echo 3.Ableton Live Suite
echo 4.back to main
SET /P DE=Type 1, 2, or 3 then press ENTER:
IF %DE%==1 GOTO fllaunch
IF %DE%==2 GOTO cblaunch
IF %DE%==3 GOTO ABReset
IF %DE%==4 GOTO main

:cblaunch
title Cubase LE AI Elements Reset..
cls 
call :setESC
echo -----------------------------------
echo %ESC%[41mCubase LE AI Elements Reset%ESC%[0m
echo -----------------------------------
echo 1.Cubase LE AI Elements 11
echo 2.Cubase LE AI Elements 10
echo 3.back to reset daw programs
SET /P CBOptions=Type 1, 2, or 3 then press ENTER:
IF %CBOptions%==1 GOTO cblaunch11
IF %CBOptions%==2 GOTO cblaunch10
IF %CBOptions%==3 GOTO resetdaw

:fllaunch
title FL Studio Reset..
cls 
call :setESC
echo -----------------------------------
echo %ESC%[101mFL Studio Reset%ESC%[0m
echo -----------------------------------
echo Select version..
echo 1.FL Studio 20
echo 2.FL Studio 12
echo 3.FL Studio 11
echo 4.back to reset daw programs
SET /P FLOptions=Type 1, 2, or 3 then press ENTER:
IF %FLOptions%==1 GOTO fllaunch20
IF %FLOptions%==2 GOTO fllaunch12
IF %FLOptions%==3 GOTO fllaunch11
IF %FLOptions%==4 GOTO resetdaw

:ABReset
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 11
echo 2.version 10
echo 3.version 9
echo 4.back to reset daw programs
SET /P ABOptions=Type 1, 2, or 3 then press ENTER:
IF %ABOptions%==1 GOTO AB11
IF %ABOptions%==2 GOTO AB10
IF %ABOptions%==3 GOTO AB09
IF %ABOptions%==4 GOTO resetdaw

:AB11
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 11.0.2
echo 2.version 11.0.1
echo 3.version 11.0
echo 4.back to Ableton reset
SET /P ABOptions11=Type 1, 2, or 3 then press ENTER:
IF %ABOptions11%==1 GOTO ABReset1102
IF %ABOptions11%==2 GOTO ABReset1101
IF %ABOptions11%==3 GOTO ABReset1100
IF %ABOptions11%==4 GOTO ABReset

:AB10
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 10.1.35
echo 2.version 10.1.30
echo 3.version 10.1.25
echo 4.version 10.1.18
echo 5.version 10.1.17
echo 6.version 10.1.15
echo 7.version 10.1.14
echo 8.version 10.1.13
echo 9.version 10.1.9
echo 10.next page.....
SET /P ABOptions10=Type 1, 2, 3, 4, 5, 6, 7, 8, 9, or 10 then press ENTER:
IF %ABOptions10%==1 GOTO ABReset10135
IF %ABOptions10%==2 GOTO ABReset10130
IF %ABOptions10%==3 GOTO ABReset10125
IF %ABOptions10%==4 GOTO ABReset10118
IF %ABOptions10%==5 GOTO ABReset10117
IF %ABOptions10%==6 GOTO ABReset10115
IF %ABOptions10%==7 GOTO ABReset10114
IF %ABOptions10%==8 GOTO ABReset10113
IF %ABOptions10%==9 GOTO ABReset1019
IF %ABOptions10%==10 GOTO ABReset10next

:AB09
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 9.7.7
echo 2.version 9.7.6
echo 3.version 9.7.5
echo 4.version 9.7.4
echo 5.version 9.7.3
echo 6.version 9.7.2
echo 7.version 9.7.1
echo 8.version 9.7
echo 9.version 9.6.2
echo 10.next page.....
SET /P ABOptions9=Type 1, 2, 3, 4, 5, 6, 7, 8, 9, or 10 then press ENTER:
IF %ABOptions9%==1 GOTO ABReset977
IF %ABOptions9%==2 GOTO ABReset976
IF %ABOptions9%==3 GOTO ABReset975
IF %ABOptions9%==4 GOTO ABReset974
IF %ABOptions9%==5 GOTO ABReset973
IF %ABOptions9%==6 GOTO ABReset972
IF %ABOptions9%==7 GOTO ABReset971
IF %ABOptions9%==8 GOTO ABReset970
IF %ABOptions9%==9 GOTO ABReset962
IF %ABOptions9%==10 GOTO ABReset9next

:ABReset9next
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 9.6.1
echo 2.version 9.6
echo 3.version 9.5
echo 4.version 9.2.3
echo 5.version 9.2.2
echo 6.version 9.2.1
echo 7.version 9.2
echo 8.version 9.1.10
echo 9.version 9.1.9
echo 10.next page.....
SET /P ABOptions9x=Type 1, 2, 3, 4, 5, 6, 7, 8, 9, or 10 then press ENTER:
IF %ABOptions9x%==1 GOTO ABReset961
IF %ABOptions9x%==2 GOTO ABReset960
IF %ABOptions9x%==3 GOTO ABReset950
IF %ABOptions9x%==4 GOTO ABReset923
IF %ABOptions9x%==5 GOTO ABReset922
IF %ABOptions9x%==6 GOTO ABReset921
IF %ABOptions9x%==7 GOTO ABReset920
IF %ABOptions9x%==8 GOTO ABReset9110
IF %ABOptions9x%==9 GOTO ABReset919
IF %ABOptions9x%==10 GOTO ABReset9next2

:ABReset9next2
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 9.1.8
echo 2.version 9.1.7
echo 3.version 9.1.6
echo 4.version 9.1.5
echo 5.version 9.1.4
echo 6.version 9.1.3
echo 7.version 9.1.2
echo 8.version 9.1.1
echo 9.version 9.1
echo 10.next page.....
SET /P ABOptions9w=Type 1, 2, 3, 4, 5, 6, 7, 8, 9, or 10 then press ENTER:
IF %ABOptions9w%==1 GOTO ABReset918
IF %ABOptions9w%==2 GOTO ABReset917
IF %ABOptions9w%==3 GOTO ABReset916
IF %ABOptions9w%==4 GOTO ABReset915
IF %ABOptions9w%==5 GOTO ABReset914
IF %ABOptions9w%==6 GOTO ABReset913
IF %ABOptions9w%==7 GOTO ABReset912
IF %ABOptions9w%==8 GOTO ABReset911
IF %ABOptions9w%==9 GOTO ABReset910
IF %ABOptions9w%==10 GOTO ABReset9next3

:ABReset9next3
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 9.0.6
echo 2.version 9.0.5
echo 3.version 9.0.4
echo 4.version 9.0.3
echo 5.version 9.0.2
echo 6.version 9.0.1
echo 7.version 9.0
echo 8.back to Ableton live reset
SET /P ABOptions9w=Type 1, 2, 3, 4, 5, 6, 7, or 8 then press ENTER:
IF %ABOptions9w%==1 GOTO ABReset906
IF %ABOptions9w%==2 GOTO ABReset905
IF %ABOptions9w%==3 GOTO ABReset904
IF %ABOptions9w%==4 GOTO ABReset903
IF %ABOptions9w%==5 GOTO ABReset902
IF %ABOptions9w%==6 GOTO ABReset901
IF %ABOptions9w%==7 GOTO ABReset900
IF %ABOptions9w%==8 GOTO ABReset

:ABReset10next
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 10.1.7
echo 2.version 10.1.6
echo 3.version 10.1.5
echo 4.version 10.1.4
echo 5.version 10.1.3
echo 6.version 10.1.2
echo 7.version 10.1.1
echo 8.version 10.1
echo 9.version 10.0.6
echo 10.next page.....
SET /P ABOptions10x=Type 1, 2, 3, 4, 5, 6, 7, 8, 9, or 10 then press ENTER:
IF %ABOptions10x%==1 GOTO ABReset1017
IF %ABOptions10x%==2 GOTO ABReset1016
IF %ABOptions10x%==3 GOTO ABReset1015
IF %ABOptions10x%==4 GOTO ABReset1014
IF %ABOptions10x%==5 GOTO ABReset1013
IF %ABOptions10x%==6 GOTO ABReset1012
IF %ABOptions10x%==7 GOTO ABReset1011
IF %ABOptions10x%==8 GOTO ABReset1010
IF %ABOptions10x%==9 GOTO ABReset1006
IF %ABOptions10x%==10 GOTO ABReset10next2

:ABReset10next2
cls
call :setESC
title ABReset
echo -----------------------------------
echo %ESC%[7mAbleton Live Reset%ESC%[0m
echo -----------------------------------
cd %appdata%\Ableton
echo current version location
dir
echo -----------------------------------
echo 1.Version 10.0.5
echo 2.version 10.0.4
echo 3.version 10.0.3
echo 4.version 10.0.2
echo 5.version 10.0.1
echo 6.version 10.0
echo 7.back to Ableton reset menu
SET /P ABOptions10x=Type 1, 2, 3, 4, 5, 6, or 7 then press ENTER:
IF %ABOptions10x%==1 GOTO ABReset1005
IF %ABOptions10x%==2 GOTO ABReset1004
IF %ABOptions10x%==3 GOTO ABReset1003
IF %ABOptions10x%==4 GOTO ABReset1002
IF %ABOptions10x%==5 GOTO ABReset1001
IF %ABOptions10x%==6 GOTO ABReset1000
IF %ABOptions10x%==7 GOTO ABReset


:ABReset1102
cd "%appdata%\Ableton\Live 11.0.2\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 11[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart11
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1101
cd "%appdata%\Ableton\Live 11.0.1\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 11[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart11
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1100
cd "%appdata%\Ableton\Live 11.0.0\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 11.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 11[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart11
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset10135
cd "%appdata%\Ableton\Live 10.1.35\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset10130
cd "%appdata%\Ableton\Live 10.1.30\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset10125
cd "%appdata%\Ableton\Live 10.1.25\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset10118
cd "%appdata%\Ableton\Live 10.1.18\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset10117
cd "%appdata%\Ableton\Live 10.1.17\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset10115
cd "%appdata%\Ableton\Live 10.1.15\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset10114
cd "%appdata%\Ableton\Live 10.1.14\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset10113
cd "%appdata%\Ableton\Live 10.1.13\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1019
cd "%appdata%\Ableton\Live 10.1.9\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1017
cd "%appdata%\Ableton\Live 10.1.7\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1016
cd "%appdata%\Ableton\Live 10.1.6\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw


:ABReset1015
cd "%appdata%\Ableton\Live 10.1.5\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1014
cd "%appdata%\Ableton\Live 10.1.4\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1013
cd "%appdata%\Ableton\Live 10.1.3\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1012
cd "%appdata%\Ableton\Live 10.1.2\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1011
cd "%appdata%\Ableton\Live 10.1.1\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1010
cd "%appdata%\Ableton\Live 10.1\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 10.1.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1006
cd "%appdata%\Ableton\Live 10.0.6\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1005
cd "%appdata%\Ableton\Live 10.0.5\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1004
cd "%appdata%\Ableton\Live 10.0.4\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1003
cd "%appdata%\Ableton\Live 10.0.3\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1002
cd "%appdata%\Ableton\Live 10.0.2\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1001
cd "%appdata%\Ableton\Live 10.0.1\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset1000
cd "%appdata%\Ableton\Live 10.0\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 10.0.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 10[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart10
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset977
cd "%appdata%\Ableton\Live 9.7.7\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset976
cd "%appdata%\Ableton\Live 9.7.6\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset975
cd "%appdata%\Ableton\Live 9.7.5\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset974
cd "%appdata%\Ableton\Live 9.7.4\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset973
cd "%appdata%\Ableton\Live 9.7.3\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset972
cd "%appdata%\Ableton\Live 9.7.2\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset971
cd "%appdata%\Ableton\Live 9.7.1\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset970
cd "%appdata%\Ableton\Live 9.7\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 9.7.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset962
cd "%appdata%\Ableton\Live 9.6.2\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset961
cd "%appdata%\Ableton\Live 9.6.1\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset960
cd "%appdata%\Ableton\Live 9.6\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 9.6.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset950
cd "%appdata%\Ableton\Live 9.5\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 9.5.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset923
cd "%appdata%\Ableton\Live 9.2.3\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset922
cd "%appdata%\Ableton\Live 9.2.2\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset921
cd "%appdata%\Ableton\Live 9.2.1\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset920
cd "%appdata%\Ableton\Live 9.2\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 9.2.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset9110
cd "%appdata%\Ableton\Live 9.1.10\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset919
cd "%appdata%\Ableton\Live 9.1.9\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset918
cd "%appdata%\Ableton\Live 9.1.8\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset917
cd "%appdata%\Ableton\Live 9.1.7\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset916
cd "%appdata%\Ableton\Live 9.1.6\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset915
cd "%appdata%\Ableton\Live 9.1.5\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset914
cd "%appdata%\Ableton\Live 9.1.4\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset913
cd "%appdata%\Ableton\Live 9.1.3\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset912
cd "%appdata%\Ableton\Live 9.1.2\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset911
cd "%appdata%\Ableton\Live 9.1.1\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset910
cd "%appdata%\Ableton\Live 9.1\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 9.1.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset906
cd "%appdata%\Ableton\Live 9.0.6\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset905
cd "%appdata%\Ableton\Live 9.0.5\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset904
cd "%appdata%\Ableton\Live 9.0.4\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset903
cd "%appdata%\Ableton\Live 9.0.3\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset902
cd "%appdata%\Ableton\Live 9.0.2\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset901
cd "%appdata%\Ableton\Live 9.0.1\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:ABReset900
cd "%appdata%\Ableton\Live 9.0\Preferences"
del /F /Q "Preferences.cfg"
cd "%appdata%\Ableton\Live 9.0.0\Preferences"
del /F /Q "Preferences.cfg"
echo reset completed!
set /P ABC=Are you sure you want to launch ableton live 9[Y/N]?
if /I "%ABC%" EQU "Y" goto :abstart9
if /I "%ABC%" EQU "N" goto :resetdaw

:abstart11
call "C:\ProgramData\Ableton\Live 11 Suite\Program\Ableton Live 11 Suite.exe"

:abstart10
call "C:\ProgramData\Ableton\Live 10 Suite\Program\Ableton Live 10 Suite.exe"

:abstart9
call "C:\ProgramData\Ableton\Live 9 Suite\Program\Ableton Live 9 Suite.exe"

:fllaunch20
"C:\Program Files\Image-Line\FL Studio 20\FL.exe" /reset
pause
goto resetdaw

:fllaunch12
"C:\Program Files (x86)\Image-Line\FL Studio 12\FL.exe" /reset
pause
goto resetdaw

:fllaunch11
"C:\Program Files (x86)\Image-Line\FL Studio 11\FL.exe" /reset
pause
goto resetdaw

:cblaunch11
echo **press holdkey ctrl+shift+alt in 1-2 sec
"C:\Program Files\Steinberg\Cubase LE AI Elements 11\Cubase LE AI Elements 11.exe"

:cblaunch10
echo **press holdkey ctrl+shift+alt in 1-2 sec
"C:\Program Files\Steinberg\Cubase LE AI Elements 10\Cubase LE AI Elements 10.exe"