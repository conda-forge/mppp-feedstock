mkdir build
cd build

cmake ^
    -G "Ninja" ^
    -DCMAKE_C_COMPILER=clang-cl ^
    -DCMAKE_CXX_COMPILER=clang-cl ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DMPPP_WITH_MPFR=yes ^
    -DMPPP_WITH_MPC=yes ^
    -DMPPP_WITH_ARB=yes ^
    -DMPPP_WITH_BOOST_S11N=ON ^
    -DBoost_NO_BOOST_CMAKE=ON ^
    -DMPPP_BUILD_TESTS=yes ^
    -DMPPP_ENABLE_IPO=yes ^
    -DMPPP_WITH_FMT=ON ^
    ..

cmake --build .

set PATH=%PATH%;%CD%

ctest

cmake --build . --target install
