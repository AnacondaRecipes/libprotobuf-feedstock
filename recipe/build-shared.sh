#!/bin/bash

set -ex

if [ "$(uname)" == "Linux" ]; then
    # Set a default optimization level if not already set
    if [[ ! $CXXFLAGS =~ -O[0-9] ]]; then
        CXXFLAGS="$CXXFLAGS -O2"
    fi
    if [[ ! $CPPFLAGS =~ -O[0-9] ]]; then
        CPPFLAGS="$CPPFLAGS -O2"
    fi

    # protobuf uses PROTOBUF_OPT_FLAG to set the optimization level
    # unit test can fail if optimization above 0 are used.
    export PROTOBUF_OPT_FLAG="-O2"
    # to improve performance, disable checks intended for debugging
    CXXFLAGS="$CXXFLAGS -DNDEBUG"
elif [ "$(uname)" == "Darwin" ]; then
    # remove pie from LDFLAGS
    LDFLAGS="${LDFLAGS//-pie/}"
    
    # Set a default optimization level if not already set
    if [[ ! $CXXFLAGS =~ -O[0-9] ]]; then
        CXXFLAGS="$CXXFLAGS -O2"
    fi
    if [[ ! $CPPFLAGS =~ -O[0-9] ]]; then
        CPPFLAGS="$CPPFLAGS -O2"
    fi
fi

# required to pick up conda installed zlib
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

# Build configure/Makefile as they are not present.
aclocal
libtoolize
autoconf
autoreconf -i
automake --add-missing

./configure --prefix="${PREFIX}" \
            --build=${BUILD}     \
            --host=${HOST}       \
            --with-pic           \
            --with-zlib          \
            --enable-shared      \
            CC_FOR_BUILD=${CC}   \
            CXX_FOR_BUILD=${CXX}

# Skip memory hungry tests
export GTEST_FILTER="-IoTest.LargeOutput"
if [ "${HOST}" == "powerpc64le-conda_cos7-linux-gnu" ]; then
    make -j 2
    make check -j 2 || (cat src/test-suite.log; exit 1)
else
    make -j ${CPU_COUNT}
    if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
        make check -j ${CPU_COUNT} || (cat src/test-suite.log; exit 1)
    fi
fi
make install
rm ${PREFIX}/lib/libprotobuf.a
rm ${PREFIX}/lib/libprotobuf-lite.a
rm ${PREFIX}/lib/libprotoc.a
