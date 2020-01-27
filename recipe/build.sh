#!/bin/bash

set -e
set -x

# Build shared & static version of libbenchmark
# Not pretty but the easiest without patching CMakelists.txt it seems
# https://stackoverflow.com/a/18551243/812379
for SHARED in ON OFF;do
  mkdir build-dir-$SHARED
  pushd build-dir-$SHARED

  cmake \
      -DCMAKE_BUILD_TYPE=release \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DTHREADS_PREFER_PTHREAD_FLAG=ON \
      -DBENCHMARK_ENABLE_TESTING=OFF \
      -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_SHARED_LIBS=$SHARED \
      -GNinja \
      ..

  ninja install

  popd
done

# https://github.com/google/benchmark/issues/824
if [[ `uname -s` == "Linux" ]]; then
    sed -i 's:INTERFACE_LINK_LIBRARIES "-pthread;.*:INTERFACE_LINK_LIBRARIES "-pthread;-lrt":g' ${PREFIX}/lib/cmake/benchmark/benchmarkTargets.cmake
fi
