#!/bin/sh

cd ~/
git clone https://github.com/qemu/qemu
cd ~/qemu
mkdir build
cd build
../configure --target-list=i386-softmmu
make
echo "alias qemu-system-i386=~/qemu/build/i386-softmmu/qemu-system-i386" >> ~/.bashrc
source ~/.bashrc

echo "Installed qemu-system-i386"
