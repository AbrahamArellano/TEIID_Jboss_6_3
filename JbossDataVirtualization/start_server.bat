@ECHO OFF

@if not "%ECHO%" == ""  echo %ECHO%
@if "%OS%" == "Windows_NT" setlocal

if "%OS%" == "Windows_NT" (
  set "SETUPDIR=%~dp0%"
) else (
  set SETUPDIR=.
)

rem Read an optional configuration file.
if "x%SETUP_CONF%" == "x" (
   set "SETUP_CONF=%SETUPDIR%setup_conf.bat"
)
if exist "%SETUP_CONF%" (
   echo Calling "%SETUP_CONF%"
   call "%SETUP_CONF%" %*
) else (
   echo Config file not found "%SETUP_CONF%"
   goto END
)

set "RESOLVED_JBOSS_HOME=%SETUPDIR%"
popd

if "x%JBOSS_HOME%" == "x" (
  set "JBOSS_HOME=%RESOLVED_JBOSS_HOME%%SERVER_DIR%"
)

if EXIST "%JBOSS_HOME%\bin\standalone.bat" goto INSTALL

   echo "Stop, first run setup_dv.bat to install DV Server"
   goto END


:INSTALL

echo "Starting H2 database..."

start cmd /k "%SETUPDIR%\start_h2_server.bat"

echo "Starting DV Server ..."

#cd %JBOSS_HOME%\bin

call  "%JBOSS_HOME%\bin\standalone.bat"

cd %SETUPDIR%

echo **********************
echo DV Server is started
echo **********************

:END
