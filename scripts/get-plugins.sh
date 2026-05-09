#!/bin/sh
set -e

rm -rf src && mkdir src
for arch in arm aarch64 mipsel x86_64; do
    curl -O $(curl -s -H "Accept:text/plain" "https://router.uu.163.com/api/plugin?type=openwrt-$arch" | awk -F ',' '{print $1}')
    mkdir -p src/$arch/
    tar -xf uu.tar.gz -C src/$arch/
    rm uu.tar.gz
done
