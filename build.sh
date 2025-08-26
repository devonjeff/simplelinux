#!/bin/bash
set -e

echo "simplelinux build script started."

# More commands will be added here to build the toolchain and base system.

# Source the configuration
source config.mk

# --- Download Sources ---
echo "--- Downloading Sources ---"
mkdir -p sources
wget --continue --directory-prefix=sources ${LINUX_URL}
wget --continue --directory-prefix=sources ${BINUTILS_URL}
wget --continue --directory-prefix=sources ${GCC_URL}
wget --continue --directory-prefix=sources ${GLIBC_URL}
echo "--- Downloads Complete ---"

echo "--- Building Toolchain (Pass 1) ---"

# Create build and tools directories
mkdir -p build/binutils-pass1
sudo mkdir -p ${TARGET_PREFIX}
sudo chown -v $(whoami) ${TARGET_PREFIX}

# --- Binutils (Pass 1) ---
echo "--- Building Binutils (Pass 1) ---"
tar -xf sources/${BINUTILS_TAR} -C build
cd build/binutils-${BINUTILS_VERSION}
./configure --prefix=${TARGET_PREFIX} --target=${TARGET} --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install
cd ../..

# --- GCC (Pass 1) ---
echo "--- Building GCC (Pass 1) ---"
export PATH=${TARGET_PREFIX}/bin:$PATH
tar -xf sources/${GCC_TAR} -C build
cd build/gcc-${GCC_VERSION}
./contrib/download_prerequisites
./configure --prefix=${TARGET_PREFIX} --target=${TARGET} --disable-nls --enable-languages=c,c++ --without-headers --disable-shared
make -j$(nproc) all-gcc
make install-gcc
cd ../..

# --- Linux API Headers ---
echo "--- Installing Linux API Headers ---"
tar -xf sources/${LINUX_TAR} -C build
cd build/linux-${LINUX_VERSION}
make mrproper
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include/* ${TARGET_PREFIX}/include
cd ../..

# --- Glibc ---
echo "--- Building Glibc ---"
mkdir -p build/glibc-build
cd build/glibc-build
tar -xf ../../sources/${GLIBC_TAR}
glibc-${GLIBC_VERSION}/configure --prefix=${PREFIX} --host=${TARGET} --build=$(glibc-${GLIBC_VERSION}/scripts/config.guess) --enable-kernel=4.14 --with-headers=${TARGET_PREFIX}/include libc_cv_forced_unwind=yes
make -j$(nproc)
make install DESTDIR=${TARGET_PREFIX}
cd ../..

# --- Libstdc++ ---
echo "--- Building Libstdc++ ---"
cd build/gcc-${GCC_VERSION}
make -j$(nproc) all-target-libstdc++-v3
make install-target-libstdc++-v3
cd ../..

# --- Binutils (Pass 2) ---
echo "--- Building Binutils (Pass 2) ---"
mkdir -p build/binutils-pass2
cd build/binutils-pass2
tar -xf ../../sources/${BINUTILS_TAR}
../binutils-${BINUTILS_VERSION}/configure --prefix=${TARGET_PREFIX} --target=${TARGET} --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install
cd ../..

# --- GCC (Pass 2) ---
echo "--- Building GCC (Pass 2) ---"
mkdir -p build/gcc-pass2
cd build/gcc-pass2
tar -xf ../../sources/${GCC_TAR}
../gcc-${GCC_VERSION}/contrib/download_prerequisites
../gcc-${GCC_VERSION}/configure --prefix=${TARGET_PREFIX} --target=${TARGET} --disable-nls --enable-languages=c,c++ --with-sysroot=${TARGET_PREFIX}
make -j$(nproc)
make install
cd ../..

echo "--- Toolchain (Pass 1) Complete ---"

echo "simplelinux build script finished."
