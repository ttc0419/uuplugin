#!/bin/zsh
set -e

[ ! -d src/arm ] && ./scripts/get-plugins.sh
[ "$(uname)" = "Darwin" ] && TAR=gtar || TAR=tar

PLUGIN_VERSION=$(grep -Eo '[0-9.]+$' src/aarch64/uu.conf)

package_ipk() {
	echo 2.0 >debian-binary
	cat <<- EOF > control
	Package: uuplugin
	Version: $PLUGIN_VERSION
	Architecture: $2
	Maintainer: William Tang
	Depends: kmod-tun
	Source: https://uu.163.com/router/
	Description: UU game booster OpenWrt plugin
	EOF

	$TAR --owner 0 --group 0 -czf control.tar.gz control
	$TAR --owner 0 --group 0 -czf data.tar.gz -C data etc usr
	$TAR --owner 0 --group 0 -czf uuplugin_${PLUGIN_VERSION}_$2.ipk debian-binary control.tar.gz data.tar.gz
	cp uuplugin_${PLUGIN_VERSION}_$2.ipk uuplugin_latest_$2.ipk
}

package_apk() {
	apk mkpkg -F data -I name:uuplugin -I version:$PLUGIN_VERSION -I arch:$2 -I depends:'kmod-tun'
	cp uuplugin-$PLUGIN_VERSION.apk uuplugin-$PLUGIN_VERSION-$2.apk
	cp uuplugin-$PLUGIN_VERSION.apk uuplugin-latest-$2.apk
}

package() {
    mkdir -p $2/data/{etc/init.d,usr/bin}
    cp ../src/$1/uu.conf $2/data/etc/
    cp ../src/$1/{uuplugin,xtables-nft-multi} $2/data/usr/bin
    cp ../files/uuplugin.init $2/data/etc/init.d/uuplugin

	cd $2
    package_ipk $@
    package_apk $@
    mv *.{apk,ipk} ../../pkg
    cd ..
}

rm -rf rfs pkg && mkdir -p rfs pkg && cd rfs
for arch in aarch64_cortex-a53 aarch64_cortex-a72 mipsel_24kc mipsel_74kc \
    arm_cortex-a9_neon arm_cortex-a7_neon-vfpv4 arm_cortex-a15_neon-vfpv4; do
    package ${arch%%_*} $arch
done
package x86_64 x86_64
