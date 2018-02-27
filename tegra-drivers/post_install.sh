#!/bin/bash

set -e

if [ -z "$LDK_PKG_DIR" ] ; then
	echo "Error: no LDK_PKG_DIR"
	exit
fi

echo "fix /etc/ld.so.conf.d/nvidia-tegra.conf"
cat >"${LDK_PKG_DIR}"/etc/ld.so.conf.d/nvidia-tegra.conf <<EOF
/usr/lib/tegra
/usr/lib/tegra-egl
EOF

echo "fix mv /usr/sbin to /usr/bin"
install -m755 "${LDK_PKG_DIR}"/usr/sbin/* "${LDK_PKG_DIR}"/usr/bin/
rm -rf "${LDK_PKG_DIR}"/usr/sbin

echo "fix mv {tegrastats,jetson_clocks.sh} to /usr/bin"
install "${LDK_PKG_DIR}"/home/ubuntu/{tegrastats,jetson_clocks.sh} "${LDK_PKG_DIR}"/usr/bin/
rm -rf "${LDK_PKG_DIR}"/home/{ubuntu,nvidia}

echo "fix mv /lib to /usr/lib"
cp -r "${LDK_PKG_DIR}"/lib/* "${LDK_PKG_DIR}"/usr/lib/
rm -rf "${LDK_PKG_DIR}"/lib

echo "fix mv /usr/lib/*-linux-* to /usr/lib"
cp -r "${LDK_PKG_DIR}"/usr/lib/*-linux-*/* "${LDK_PKG_DIR}"/usr/lib/
rm -rf "${LDK_PKG_DIR}"/usr/lib/*-linux-*/*

echo "fix /etc/nv_tegra_release"
sed -i "s#/usr/lib/[^-/]*-linux-[^/]*/#/usr/lib/#" "${LDK_PKG_DIR}"/etc/nv_tegra_release
echo "fix /etc/vulkan/icd.d/nvidia_icd.json"
ln -sf ../../../usr/lib/tegra/nvidia_icd.json "${LDK_PKG_DIR}"/etc/vulkan/icd.d/nvidia_icd.json

echo "fix /etc/init/nv.conf"
sed -i 's|/usr/bin/dpkg --print-architecture|/usr/bin/uname -m|' "${LDK_PKG_DIR}"/etc/init/{nv,nvfb}.conf
sed -i 's|/usr/bin/dpkg --print-architecture|/usr/bin/uname -m|' "${LDK_PKG_DIR}"/etc/systemd/{nv,nvfb-pre}.sh
sed -i 's|/usr/lib/aarch64-linux-gnu|/usr/lib|' "${LDK_PKG_DIR}"/etc/init/{nv,nvfb}.conf
sed -i 's|/usr/lib/aarch64-linux-gnu|/usr/lib|' "${LDK_PKG_DIR}"/etc/systemd/{nv,nvfb-pre}.sh

