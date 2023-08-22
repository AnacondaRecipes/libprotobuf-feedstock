#!/bin/bash

pushd build_shared

cmake -D CMAKE_PREFIX_PATH=$PREFIX -D CMAKE_INSTALL_PREFIX=$PREFIX  -D BUILD_SHARED_LIBS=ON -D ABSL_PROPAGATE_CXX_STD=ON -D protobuf_ABSL_PROVIDER=package -D protobuf_JSONCPP_PROVIDER=package ..
make
cp ${SRC_DIR}/build_shared/libprotobuf-lite${SHLIB_EXT}* ${PREFIX}/lib/
cp ${SRC_DIR}/build_shared/libprotobuf${SHLIB_EXT}* ${PREFIX}/lib/
cp ${SRC_DIR}/build_shared/libprotoc${SHLIB_EXT}* ${PREFIX}/lib/

cp ${SRC_DIR}/build_shared/protoc* ${PREFIX}/bin/
popd

