#!/bin/sh
set -e

mkdir src

for arch in arm aarch64 mipsel x86_64; do
    pushd /tmp
    curl -O $(curl -s -H "Accept:text/plain" "https://router.uu.163.com/api/plugin?type=openwrt-$arch" | awk -F ',' '{print $1}')
    tar -xf uu.tar.gz
    popd

    mkdir -p "src/$arch/"
    mv /tmp/{uu.conf,uuplugin} "src/$arch/"
    rm /tmp/uu.tar.gz
done
