pushd build-static
if errorlevel 1 exit 1

:: Configure and install based on protobuf's instructions and other `bld.bat`s.
cmake -G "Ninja" ^
         -DCMAKE_BUILD_TYPE=Release ^
         -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
         -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
         -DBUILD_SHARED_LIBS=OFF ^
         -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
         -DABSL_PROPAGATE_CXX_STD=ON ^
         -Dprotobuf_ABSL_PROVIDER="package" ^
         -Dprotobuf_JSONCPP_PROVIDER="package" ^
         -Dprotobuf_USE_EXTERNAL_GTEST=ON ^
         ..
if errorlevel 1 exit 1
cmake --build . --target install --config Release
if errorlevel 1 exit 1

popd