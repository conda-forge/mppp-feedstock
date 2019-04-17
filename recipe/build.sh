#!/usr/bin/env bash

if [[ "$(uname)" == "Darwin" ]]; then
    export ENABLE_QUADMATH=no
else
    export ENABLE_QUADMATH=yes
fi

mkdir build
cd build

cmake \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DMPPP_WITH_MPFR=yes \
    -DMPPP_WITH_QUADMATH=$ENABLE_QUADMATH \
    -DMPPP_BUILD_TESTS=yes \
    ..

make -j${CPU_COUNT}

ctest --output-on-failure -E integer_hash

make install
