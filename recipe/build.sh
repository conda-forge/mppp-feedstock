#!/usr/bin/env bash

if [[ "$target_platform" == osx-* ]]; then
    export ENABLE_QUADMATH=no
    # Workaround for missing C++17 feature when building the tests.
    export CXXFLAGS="$CXXFLAGS -DCATCH_CONFIG_NO_CPP17_UNCAUGHT_EXCEPTIONS"
else
    if [[ "$target_platform" == linux_64 ]]; then
        export ENABLE_QUADMATH=yes
    else
        export ENABLE_QUADMATH=no
    fi
fi

mkdir build
cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DMPPP_WITH_MPFR=yes \
    -DMPPP_WITH_MPC=yes \
    -DMPPP_WITH_ARB=yes \
    -DMPPP_WITH_QUADMATH=$ENABLE_QUADMATH \
    -DMPPP_WITH_BOOST_S11N=ON \
    -DBoost_NO_BOOST_CMAKE=ON \
    -DMPPP_BUILD_TESTS=yes \
    -DMPPP_ENABLE_IPO=yes \
    -DMPPP_INSTALL_LIBDIR=lib \
    ..

make -j${CPU_COUNT} VERBOSE=1

ctest -j${CPU_COUNT} --output-on-failure

make install
