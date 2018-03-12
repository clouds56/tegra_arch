# tegra_arch
Port nvidia tegra cuda to arch

see also
* see also [nvidia devtalk](https://devtalk.nvidia.com/default/topic/1017146/error-jetpack-must-be-run-on-ubuntu-14-04-or-16-04-platform-detected-16-10-platform-/?offset=1)


# Setup
1. Download following files:
  * [ArchLinuxARM-aarch64-latest.tar.gz](http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz) from [archlinuxarm](https://archlinuxarm.org/)
  * [Tegra186_Linux_R28.2.0_aarch64.tbz2](https://developer.nvidia.com/embedded/dlc/l4t-jetson-tx2-driver-package-28-2-ga) from [nvidia](https://developer.nvidia.com/embedded/develop/software)
    * select "Linux for Tegra"/L4T then "Jetson TX2 64-bit Driver Package"
  * cuda from [JetPack](https://developer.nvidia.com/embedded/jetpack)
  
2. Prepare filesystem
```
~/JetPack $ cp path/to/post_install.sh .
~/JetPack # tar jxpf path/to/Tegra186_Linux_R28.2.0_aarch64.tbz2
~/JetPack $ cd Linux_for_Tegra

~/JetPack/Linux_for_Tegra # mkdir -p pkg/etc/passwd
~/JetPack/Linux_for_Tegra # LDK_PKG_DIR=pkg ./apply_binaries.sh
~/JetPack/Linux_for_Tegra # LDK_PKG_DIR=pkg ../post_install.sh

~/JetPack/Linux_for_Tegra # tar xzf path/to/ArchLinuxARM-aarch64-latest.tar.gz -C rootfs
~/JetPack/Linux_for_Tegra # cp -RT pkg rootfs
```

3. Flash
Shutdown your TX2, connect to HOST via USB and entering recover mode (hold the recovery button while powering on the Jetson).
Then you should see your device via `lsusb`, 
```
~/JetPack/Linux_for_Tegra # ./flash.sh jetson-tx1 mmcblk0p1
```

4. Boot your arch linux
*maybe you would like to download wpa_suppliant package offline or used a cable for connecting to the internet*
setup arch linux as usual

5. Install packages in this repo
```
$ cd <package_name>
$ makepkg -s
# pacman -U <built-package>.pkg.tar.xz
```
