@echo off

rem  Inno Setup
rem  Copyright (C) 1997-2018 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Batch file to compile all projects with Unicode support

setlocal

if exist compilesettings.bat goto compilesettingsfound
:compilesettingserror
echo compilesettings.bat is missing or incomplete. It needs to be created
echo with either of the following lines, adjusted for your system:
echo.
echo   set DELPHI2009ROOT=C:\Program Files\CodeGear\RAD Studio\6.0  [Path to Delphi 2009 (or 2010)]
echo or
echo   set DELPHIXEROOT=C:\Program Files\Embarcadero\RAD Studio\8.0 [Path to Delphi XE (or later)]
goto failed2

:compilesettingsfound
set DELPHI2009ROOT=
set DELPHIXEROOT=
call .\compilesettings.bat
if "%DELPHI2009ROOT%"=="" if "%DELPHIXEROOT%"=="" goto compilesettingserror
if not "%DELPHI2009ROOT%"=="" if not "%DELPHIXEROOT%"=="" goto compilesettingserror

rem -------------------------------------------------------------------------

rem  Compile each project separately because it seems Delphi
rem  carries some settings (e.g. $APPTYPE) between projects
rem  if multiple projects are specified on the command line.
rem  Note:
rem  Command line parameter "--peflags:1" below equals the
rem  {$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED} directive.
rem  This causes the Delphi compiler to not just set the flag
rem  but also it actually strips relocations. Used instead of
rem  calling StripReloc like compile.bat does.

set DELPHIXEDISABLEDWARNINGS=-W-SYMBOL_DEPRECATED -W-SYMBOL_PLATFORM -W-UNSAFE_CAST -W-EXPLICIT_STRING_CAST -W-EXPLICIT_STRING_CAST_LOSS -W-IMPLICIT_INTEGER_CAST_LOSS -W-IMPLICIT_CONVERSION_LOSS

cd Projects
if errorlevel 1 goto exit

cd ISPP
if errorlevel 1 goto failed

echo - ISPP.dpr
if "%DELPHIXEROOT%"=="" (
"%DELPHI2009ROOT%\bin\dcc32.exe" --no-config --string-checks:off -Q -B -H -W %1 -U"%DELPHI2009ROOT%\lib" -E..\..\Files ISPP.dpr
) else (
"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release" -E..\..\Files ISPP.dpr
)
if errorlevel 1 goto failed

cd ..

echo - Compil32.dpr
if "%DELPHIXEROOT%"=="" (
"%DELPHI2009ROOT%\bin\dcc32.exe" --no-config --peflags:1 --string-checks:off -Q -B -H -W %1 -U"%DELPHI2009ROOT%\lib;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS Compil32.dpr
) else (
"%DELPHIXEROOT%\bin\dcc32.exe" --no-config --peflags:1 -NSsystem;system.win;winapi;vcl -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS Compil32.dpr
)
if errorlevel 1 goto failed

echo - ISCC.dpr
if "%DELPHIXEROOT%"=="" (
"%DELPHI2009ROOT%\bin\dcc32.exe" --no-config --peflags:1 --string-checks:off -Q -B -H -W %1 -U"%DELPHI2009ROOT%\lib;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS ISCC.dpr
) else (
"%DELPHIXEROOT%\bin\dcc32.exe" --no-config --peflags:1 -NSsystem;system.win;winapi -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS ISCC.dpr
)
if errorlevel 1 goto failed

echo - ISCmplr.dpr
if "%DELPHIXEROOT%"=="" (
"%DELPHI2009ROOT%\bin\dcc32.exe" --no-config --string-checks:off -Q -B -H -W %1 -U"%DELPHI2009ROOT%\lib;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS ISCmplr.dpr
) else (
"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS ISCmplr.dpr
)
if errorlevel 1 goto failed

echo - SetupLdr.dpr
if "%DELPHIXEROOT%"=="" (
"%DELPHI2009ROOT%\bin\dcc32.exe" --no-config --peflags:1 --string-checks:off -Q -B -H -W %1 -U"%DELPHI2009ROOT%\lib;..\Components" -E..\Files SetupLdr.dpr
) else (
"%DELPHIXEROOT%\bin\dcc32.exe" --no-config --peflags:1 -NSsystem;system.win;winapi -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components" -E..\Files SetupLdr.dpr
)
if errorlevel 1 goto failed

echo - Setup.dpr
if "%DELPHIXEROOT%"=="" (
"%DELPHI2009ROOT%\bin\dcc32.exe" --no-config --peflags:1 --string-checks:off -Q -B -H -W %1 -U"%DELPHI2009ROOT%\lib;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS Setup.dpr
) else (
"%DELPHIXEROOT%\bin\dcc32.exe" --no-config --peflags:1 -NSsystem;system.win;winapi;vcl -Q -B -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS Setup.dpr
)
if errorlevel 1 goto failed

echo - Renaming files
cd ..\Files
if errorlevel 1 goto failed
move SetupLdr.exe SetupLdr.e32
if errorlevel 1 goto failed
move Setup.exe Setup.e32
if errorlevel 1 goto failed

echo Success!
cd ..
goto exit

:failed
echo *** FAILED ***
cd ..
:failed2
exit /b 1

:exit
