@echo off
if "%1" == "" (
  set FILES=*.nss
) else (
  set FILES=%1
)
set DIR=%cd%
if EXIST temp0 cd temp0
nwnsc -n "C:\users\jdt\Beamdog Library\00829" -i C:\NeverwinterNights\github\CoW\ %FILES%
del *.ndb
cd %DIR%