mkdir "%SRC_DIR%"\build
pushd "%SRC_DIR%"\build

cmake -GNinja ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_BUILD_TYPE=release ^
      -DBENCHMARK_ENABLE_TESTING:BOOL=OFF ^
      -DBENCHMARK_ENABLE_GTEST_TESTS:BOOL=OFF ^
      ..

cmake --build . --target install --config Release

popd
