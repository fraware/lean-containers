@echo off
REM Comprehensive test script for lean-containers distribution

echo ========================================
echo Testing lean-containers Distribution
echo ========================================
echo.

REM Test 1: Build
echo [TEST 1] Building project...
lake build
if %errorlevel% neq 0 (
    echo [FAIL] Build failed
    exit /b 1
)
echo [PASS] Build successful
echo.

REM Test 2: Run tests
echo [TEST 2] Running tests...
lean FinalProductionTest.lean
if %errorlevel% neq 0 (
    echo [FAIL] Tests failed
    exit /b 1
)
echo [PASS] Tests successful
echo.

REM Test 3: Run main application
echo [TEST 3] Running main application...
lean Main.lean
if %errorlevel% neq 0 (
    echo [FAIL] Main application failed
    exit /b 1
)
echo [PASS] Main application successful
echo.

REM Test 4: Makefile targets
echo [TEST 4] Testing Makefile targets...
make -f Makefile.win build
if %errorlevel% neq 0 (
    echo [FAIL] Makefile build failed
    exit /b 1
)

make -f Makefile.win test
if %errorlevel% neq 0 (
    echo [FAIL] Makefile test failed
    exit /b 1
)

make -f Makefile.win run
if %errorlevel% neq 0 (
    echo [FAIL] Makefile run failed
    exit /b 1
)
echo [PASS] Makefile targets successful
echo.

REM Test 5: Docker (if available)
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [TEST 5] Testing Docker build...
    docker build -t lean-containers:test .
    if %errorlevel% neq 0 (
        echo [FAIL] Docker build failed
        exit /b 1
    )
    
    echo [TEST 6] Testing Docker run...
    docker run --rm lean-containers:test
    if %errorlevel% neq 0 (
        echo [FAIL] Docker run failed
        exit /b 1
    )
    echo [PASS] Docker tests successful
) else (
    echo [SKIP] Docker not available, skipping Docker tests
)
echo.

REM Test 6: Release script
echo [TEST 7] Testing release script...
if exist scripts\release.bat (
    echo [PASS] Release script exists
) else (
    echo [FAIL] Release script missing
    exit /b 1
)
echo.

REM Test 7: File structure
echo [TEST 8] Verifying file structure...
if exist Dockerfile (
    echo [PASS] Dockerfile exists
) else (
    echo [FAIL] Dockerfile missing
    exit /b 1
)

if exist .dockerignore (
    echo [PASS] .dockerignore exists
) else (
    echo [FAIL] .dockerignore missing
    exit /b 1
)

if exist .github\workflows\ci.yml (
    echo [PASS] CI workflow exists
) else (
    echo [FAIL] CI workflow missing
    exit /b 1
)
echo.

echo ========================================
echo ALL TESTS PASSED!
echo ========================================
echo.
echo The lean-containers repository is ready for distribution.
echo.
echo Quick start commands for users:
echo   make -f Makefile.win dev    # Set up development environment
echo   make -f Makefile.win build  # Build the project
echo   make -f Makefile.win test   # Run tests
echo   make -f Makefile.win run    # Run the application
echo.
echo Docker commands:
echo   docker build -t lean-containers .
echo   docker run --rm lean-containers
echo.
echo Release commands:
echo   make -f Makefile.win release-dry  # Test release process
echo   scripts\release.bat               # Create release
echo.
