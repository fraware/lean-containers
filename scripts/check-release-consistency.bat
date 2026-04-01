@echo off
REM Validate release metadata consistency for lean-containers.
REM Canonical version is the single line in VERSION (X.Y.Z). Tags must be vX.Y.Z.
REM Usage:
REM   scripts\check-release-consistency.bat
REM   scripts\check-release-consistency.bat v0.1.0

setlocal enabledelayedexpansion

if not exist "VERSION" (
  echo [ERROR] VERSION file missing at repository root.
  exit /b 1
)

set /p VERSION=<VERSION
set VERSION=!VERSION: =!
for /f "delims=" %%i in ("!VERSION!") do set VERSION=%%i

powershell -NoProfile -Command "if ('%VERSION%' -match '^[0-9]+\.[0-9]+\.[0-9]+$') { exit 0 } else { exit 1 }"
if %errorlevel% neq 0 (
  echo [ERROR] VERSION must be X.Y.Z, got: %VERSION%
  exit /b 1
)

set TAG=v%VERSION%

if not "%~1"=="" (
  if /I not "%~1"=="%TAG%" (
    echo [ERROR] Tag %~1 does not match VERSION file ^(expected %TAG%^).
    exit /b 1
  )
)

setlocal DisableDelayedExpansion
findstr /C:"version := v!\"%VERSION%\"" Lakefile.lean >nul
set MATCH_ERR=%errorlevel%
endlocal & set MATCH_ERR=%MATCH_ERR%
if %MATCH_ERR% neq 0 (
  echo [ERROR] Lakefile.lean must set version := v!\"%VERSION%\" to match VERSION file.
  exit /b 1
)

if exist "lean-containers-%TAG%.tar.gz" (
  echo [INFO] Found release artifact: lean-containers-%TAG%.tar.gz
) else (
  echo [INFO] Artifact not present locally yet: lean-containers-%TAG%.tar.gz
)

echo [OK] Release metadata is consistent ^(VERSION=%VERSION%, tag=%TAG%^).
