#!/bin/bash

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/lib

pushd build_static
cmake -D CMAKE_PREFIX_PATH=$PREFIX -D CMAKE_INSTALL_PREFIX=$PREFIX  -D BUILD_SHARED_LIBS=OFF -D ABSL_PROPAGATE_CXX_STD=ON -D protobuf_ABSL_PROVIDER=package -D protobuf_JSONCPP_PROVIDER=package ..
make
cp ${SRC_DIR}/build_static/libprotobuf-lite.a ${PREFIX}/lib/
cp ${SRC_DIR}/build_static/libprotobuf.a ${PREFIX}/lib/
cp ${SRC_DIR}/build_static/libprotoc.a ${PREFIX}/lib/

cp ${SRC_DIR}/build_static/protoc* ${PREFIX}/bin/
popd

