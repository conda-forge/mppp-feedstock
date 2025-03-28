#!/usr/bin/env bash

if [[ "$target_platform" == osx-* ]]; then
    export ENABLE_QUADMATH=no
    # Workaround for missing C++17 feature when building the tests.
    export CXXFLAGS="$CXXFLAGS -DCATCH_CONFIG_NO_CPP17_UNCAUGHT_EXCEPTIONS"
elif [[ "$target_platform" == linux-aarch64 ]]; then
    export ENABLE_QUADMATH=no
else
    export ENABLE_QUADMATH=yes
fi

if [[ "$target_platform" == linux-ppc64le ]]; then
    export ENABLE_IPO=no
else
    export ENABLE_IPO=yes
fi

# Build & run the tests?
if [[ "$target_platform" == linux-ppc64le ]]; then
    export ENABLE_TESTS=no
else
    export ENABLE_TESTS=yes
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
    -DMPPP_WITH_FLINT=yes \
    -DMPPP_WITH_QUADMATH=$ENABLE_QUADMATH \
    -DMPPP_WITH_BOOST_S11N=ON \
    -DBoost_NO_BOOST_CMAKE=ON \
    -DMPPP_BUILD_TESTS=yes \
    -DMPPP_ENABLE_IPO=$ENABLE_IPO \
    -DMPPP_INSTALL_LIBDIR=lib \
    -DMPPP_WITH_FMT=ON \
    ..

make -j${CPU_COUNT} VERBOSE=1

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" && "$ENABLE_TESTS" == yes ]]; then
    ctest -j${CPU_COUNT} --output-on-failure
fi

make install
