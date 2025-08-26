# simplelinux build configuration

# Target architecture
export TARGET=x86_64-simple-linux-gnu
export PREFIX=/usr
export TARGET_PREFIX=/tools

# Toolchain versions
LINUX_VERSION=6.16.3
BINUTILS_VERSION=2.45
GCC_VERSION=15.2
GLIBC_VERSION=2.42

# Download URLs
LINUX_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${LINUX_VERSION}.tar.xz"
BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.xz"
GCC_URL="https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz"
GLIBC_URL="https://ftp.gnu.org/gnu/glibc/glibc-${GLIBC_VERSION}.tar.xz"

# Source tarballs
LINUX_TAR="linux-${LINUX_VERSION}.tar.xz"
BINUTILS_TAR="binutils-${BINUTILS_VERSION}.tar.xz"
GCC_TAR="gcc-${GCC_VERSION}.tar.xz"
GLIBC_TAR="glibc-${GLIBC_VERSION}.tar.xz"
