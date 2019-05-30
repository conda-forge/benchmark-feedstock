#!/bin/bash

set -e
set -x

mkdir build-dir
cd build-dir

cmake \
    -DCMAKE_BUILD_TYPE=release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DTHREADS_PREFER_PTHREAD_FLAG=ON \
    -DBENCHMARK_ENABLE_TESTING=OFF \
    -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -GNinja \
    ..

ninja install

# https://github.com/google/benchmark/issues/824
if [[ `uname -s` == "Linux" ]]; then
    sed -i 's:INTERFACE_LINK_LIBRARIES "-pthread;.*:INTERFACE_LINK_LIBRARIES "-pthread;-lrt":g' ${PREFIX}/lib/cmake/benchmark/benchmarkTargets.cmake
fi
