#!/bin/sh
set -e

[ ! -d src/arm ] && ./scripts/get-plugins.sh
[ "$(uname)" = "Darwin" ] && TAR=gtar || TAR=tar

PLUGIN_VERSION=$(grep -Eo '[0-9.]+$' src/aarch64/uu.conf)

package() {
    mkdir build

    mkdir -p build/data/{etc/init.d,usr/sbin/uu}
    cp src/$1/uuplugin build/data/usr/sbin/uu
    cp src/$1/uu.conf build/data/etc
    cp files/uuplugin.init build/data/etc/init.d/uuplugin

    cd build
    echo 2.0 >debian-binary
    sed -i "/^Architecture:/c Architecture: $2" ../files/control
    sed -i "/^Version:/c Version: $PLUGIN_VERSION-1" ../files/control
    $TAR --owner 0 --group 0 -czf control.tar.gz -C ../files control
    $TAR --owner 0 --group 0 -czf data.tar.gz -C data etc usr
    $TAR --owner 0 --group 0 -czf uuplugin_$PLUGIN_VERSION-1_$2.ipk debian-binary control.tar.gz data.tar.gz
    cp uuplugin_$PLUGIN_VERSION-1_$2.ipk uuplugin_latest-1_$2.ipk
    mv *.ipk ../pkg
    cd ..

    rm -rf build
}

rm -rf build
mkdir -p pkg

for arch in aarch64_cortex-a53 aarch64_cortex-a72 mipsel_24kc mipsel_74kc \
    arm_cortex-a9_neon arm_cortex-a7_neon-vfpv4 arm_cortex-a15_neon-vfpv4; do
    package ${arch%%_*} $arch
done

package x86_64 x86_64
