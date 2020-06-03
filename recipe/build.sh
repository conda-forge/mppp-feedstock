#!/usr/bin/env bash

if [[ "$(uname)" == "Darwin" ]]; then
    export ENABLE_QUADMATH=no
    export AR_CMAKE_SETTING=
    # Workaround for missing C++17 feature when building the tests.
    export CXXFLAGS="$CXXFLAGS -DCATCH_CONFIG_NO_CPP17_UNCAUGHT_EXCEPTIONS"
else
    export ENABLE_QUADMATH=yes
    # Workaround for making the LTO machinery work on Linux.
    export AR_CMAKE_SETTING="-DCMAKE_CXX_COMPILER_AR=$GCC_AR"
fi

mkdir build
cd build

cmake \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DMPPP_WITH_MPFR=yes \
    -DMPPP_WITH_MPC=yes \
    -DMPPP_WITH_ARB=yes \
    -DMPPP_WITH_QUADMATH=$ENABLE_QUADMATH \
    -DMPPP_BUILD_TESTS=yes \
    -DMPPP_ENABLE_IPO=yes \
    $AR_CMAKE_SETTING \
    -DMPPP_INSTALL_LIBDIR=lib \
    ..

make -j${CPU_COUNT} VERBOSE=1

ctest --output-on-failure -E integer_hash

make install
