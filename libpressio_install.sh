#!/usr/bin/env bash

if ! which cmake &> /dev/null
then
  echo "cmake must be installed"
  exit 1
fi

rootDir=`pwd`

git clone https://github.com/CODARcode/MGARD
git clone https://github.com/CODARcode/libpressio

mkdir -p MGARD/build
pushd MGARD/build
cmake .. -DCMAKE_INSTALL_PREFIX=$rootDir/MGARD/MGARD-install -DCMAKE_INSTALL_LIBDIR=lib
make -j$(nproc)
make install
popd

mkdir -p libpressio/install
pushd libpressio/install
ln -s $rootDir/SZ/sz-install sz-install
ln -s $rootDir/zfp/zfp-install zfp-install
ln -s $rootDir/MGARD/MGARD-install MGARD-install
popd

LIBPRESSIO_CMAKE_ARGS="-DCMAKE_INSTALL_PREFIX=$rootDir/libpressio/install -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_LIBDIR=lib"
mkdir -p libpressio/build
pushd libpressio/build
cmake .. $LIBPRESSIO_CMAKE_ARGS -DLIBPRESSIO_HAS_MGARD=ON -DLIBPRESSIO_HAS_HDF=OFF -DLIBPRESSIO_HAS_MAGICK=OFF
make -j$(nproc)
make install
popd