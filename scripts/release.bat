@echo off
REM Release script for lean-containers (Windows version)

setlocal enabledelayedexpansion

REM Check if we're in the right directory
if not exist "Lakefile.lean" (
    echo [ERROR] Please run this script from the project root directory
    exit /b 1
)

REM Get version from Lakefile.lean
for /f "tokens=2 delims=:=" %%a in ('findstr "version :=" Lakefile.lean') do (
    set VERSION=%%a
    set VERSION=!VERSION:"=!
    set VERSION=!VERSION: =!
)

if "%VERSION%"=="" (
    echo [ERROR] Could not determine version from Lakefile.lean
    exit /b 1
)

echo [INFO] Starting release process for version %VERSION%

REM Check if Docker is available
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARN] Docker not found. Skipping Docker-related checks.
    set SKIP_DOCKER=true
) else (
    set SKIP_DOCKER=false
)

REM Step 1: Clean and build
echo [INFO] Step 1: Cleaning and building project...
make clean
make build

REM Step 2: Run tests
echo [INFO] Step 2: Running tests...
make test

REM Step 3: Test Docker build (if available)
if "%SKIP_DOCKER%"=="false" (
    echo [INFO] Step 3: Testing Docker build...
    docker build -t lean-containers:%VERSION% .
    docker build -t lean-containers:latest .
    
    echo [INFO] Step 4: Testing Docker run...
    docker run --rm lean-containers:%VERSION%
) else (
    echo [WARN] Skipping Docker tests
)

REM Step 4: Create release archive
echo [INFO] Creating release archive...
if exist release rmdir /s /q release
mkdir release
xcopy src release\src\ /e /i /q
copy Lakefile.lean release\
copy lake-manifest.json release\
copy lean-toolchain release\
copy Main.lean release\
copy FinalProductionTest.lean release\
copy README.md release\
copy Makefile release\
copy Dockerfile release\
copy .dockerignore release\

REM Create tar archive (requires tar command available in Windows 10+)
tar -czf lean-containers-%VERSION%.tar.gz -C release .

echo [INFO] Release archive created: lean-containers-%VERSION%.tar.gz

REM Step 5: Summary
echo [INFO] Release process completed successfully!
echo.
echo Next steps:
echo 1. Create a GitHub release with tag v%VERSION%
echo 2. Upload lean-containers-%VERSION%.tar.gz to the release
if "%SKIP_DOCKER%"=="false" (
    echo 3. Push Docker images:
    echo    docker tag lean-containers:%VERSION% ghcr.io/your-org/lean-containers:%VERSION%
    echo    docker tag lean-containers:latest ghcr.io/your-org/lean-containers:latest
    echo    docker push ghcr.io/your-org/lean-containers:%VERSION%
    echo    docker push ghcr.io/your-org/lean-containers:latest
)
echo 4. Update documentation if needed
echo.
echo [INFO] Release ready for distribution!
