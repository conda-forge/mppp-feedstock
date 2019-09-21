mkdir build
cd build

cmake ^
    -G "NMake Makefiles" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DMPPP_WITH_MPFR=yes ^
    -DMPPP_BUILD_TESTS=yes ^
    ..

cmake --build .

set PATH=%PATH%;%CD%\Release

ctest

cmake --build . --target install
