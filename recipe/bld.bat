@echo on
set "BENCHMARK_TESTS=OFF"
if "%target_platform%" == "win-arm64" set "BENCHMARK_TESTS=ON"

mkdir "%SRC_DIR%"\build
pushd "%SRC_DIR%"\build

cmake -GNinja ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_BUILD_TYPE=release ^
      -DBENCHMARK_ENABLE_TESTING:BOOL=%BENCHMARK_TESTS% ^
      -DBENCHMARK_ENABLE_GTEST_TESTS:BOOL=%BENCHMARK_TESTS% ^
      -DBENCHMARK_USE_BUNDLED_GTEST=OFF ^
      -DBUILD_SHARED_LIBS=ON ^
      ..
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1

if "%target_platform%" == "win-arm64" (
    set "PATH=%CD%\src;%LIBRARY_BIN%;%PATH%"
    ctest --output-on-failure -C Release
    if errorlevel 1 exit /b 1
)

popd
