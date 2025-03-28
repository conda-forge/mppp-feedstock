mkdir build
cd build

cmake ^
    -G "Visual Studio 17 2022" -A x64 ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DMPPP_WITH_MPFR=yes ^
    -DMPPP_WITH_MPC=yes ^
    -DMPPP_WITH_FLINT=yes ^
    -DMPPP_WITH_BOOST_S11N=ON ^
    -DBoost_NO_BOOST_CMAKE=ON ^
    -DMPPP_BUILD_TESTS=yes ^
    -DMPPP_ENABLE_IPO=yes ^
    -DMPPP_WITH_FMT=ON ^
    ..

cmake --build . --config Release -j%CPU_COUNT%

set PATH=%PATH%;%CD%\Release

ctest --output-on-failure -j%CPU_COUNT% -V -C Release

cmake --build . --config Release --target install
