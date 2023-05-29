#!/bin/sh
set -e

PLUGIN_VERSION=3.13.4

if [ ! -d files/arm ]; then
    ./scripts/get-plugins.sh
fi

package() {
    mkdir ipk-build

    mkdir -p ipk-build/data/etc/init.d ipk-build/data/usr/bin
    cp files/$1/uuplugin ipk-build/data/usr/bin
    cp files/uuplugin.init ipk-build/data/etc/init.d/uuplugin

    cd ipk-build
    echo 2.0 >debian-binary
    sed -i "/^Architecture:/c Architecture: $2" ../files/control
    tar -czf control.tar.gz -C ../files control
    tar -czf data.tar.gz -C data etc usr
    tar -czf uuplugin_$PLUGIN_VERSION-1_$2.ipk debian-binary control.tar.gz data.tar.gz
    cp uuplugin_$PLUGIN_VERSION-1_$2.ipk uuplugin_latest-1_$2.ipk
    mv *.ipk ../ipks
    cd ..

    rm -rf ipk-build
}

rm -rf ipk-build

for arch in aarch64_cortex-a53 aarch64_cortex-a72 mipsel_24kc mipsel_74kc \
    arm_cortex-a9_neon arm_cortex-a7_neon-vfpv4 arm_cortex-a15_neon-vfpv4; do
    package ${arch%%_*} $arch
done

package x86_64 x86_64
