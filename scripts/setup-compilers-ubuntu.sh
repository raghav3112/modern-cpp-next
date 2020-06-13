#!/bin/bash
#
#   Author  : github.com/luncliff (luncliff@gmail.com)
#   References:
#       https://apt.llvm.org/
#
apt --version
if [ $? -gt 0 ]
then
  echo "The script requires APT"
  exit 1
fi

verion_name=$(. /etc/os-release;echo $VERSION)
distribution=$(. /etc/os-release;echo $UBUNTU_CODENAME)

echo "----------------------------------------------------------------------"
echo "                                                                      "
echo " Install C++ Compilers: ${verion_name}                                "
echo "  - Path      : /usr/bin                                              "
echo "  - Compiler  : g++-8, g++-9, clang-8, clang-9                        "
echo "                                                                      "
echo "----------------------------------------------------------------------"

# display release info. this will helpful for checking CI environment
cat /etc/os-release

apt update -qq
apt install -y -qq \
  build-essential software-properties-common
apt-add-repository -y ppa:ubuntu-toolchain-r/test

# http://apt.llvm.org/
# use clang for 'stable, development branch'
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
apt-add-repository "deb http://apt.llvm.org/${distribution}/ llvm-toolchain-${distribution}-8 main"
apt-add-repository "deb http://apt.llvm.org/${distribution}/ llvm-toolchain-${distribution}-9 main"

apt update -qq
apt install -y -q \
  g++-8 g++-9 clang-8 clang-9 \
  libc++abi-8-dev

pushd /usr/bin
ln -s --force gcc-9 gcc
ln -s --force g++-9 g++
ln -s --force clang-9 clang
popd # leave /usr/bin
