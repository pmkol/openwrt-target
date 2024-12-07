#!/bin/bash -e

# kernel generic patches
rm -rf target/linux/generic
git clone https://$github/pmkol/openwrt-target target/linux/generic -b linux-6.11 --depth=1
rm -rf target/linux/generic/.git

# x86_64 - target 6.11
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/x86/64/config-6.11 > target/linux/x86/64/config-6.11
rm -rf target/linux/x86/64/config-5.15
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/x86/config-6.11 > target/linux/x86/config-6.11
mkdir -p target/linux/x86/patches-6.11
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/x86/patches-6.11/100-fix_cs5535_clockevt.patch > target/linux/x86/patches-6.11/100-fix_cs5535_clockevt.patch
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/x86/patches-6.11/103-pcengines_apu6_platform.patch > target/linux/x86/patches-6.11/103-pcengines_apu6_platform.patch
rm -rf target/linux/x86/{config-5.15,patches-5.15}
sed -ri "s/(KERNEL_PATCHVER:=)[^\"]*/\16.11/" target/linux/x86/Makefile
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/x86/base-files/etc/board.d/01_leds > target/linux/x86/base-files/etc/board.d/01_leds
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/x86/base-files/etc/board.d/02_network > target/linux/x86/base-files/etc/board.d/02_network
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/x86/base-files/etc/board.d/03_model > target/linux/x86/base-files/etc/board.d/03_model

# rockchip - target - r4s/r5s only
rm -rf target/linux/rockchip
git clone https://$github/pmkol/target_linux_rockchip target/linux/rockchip -b linux-6.11 --depth=1
rm -rf target/linux/rockchip/.git

# linux-firmware: rtw89 / rtl8723d / rtl8821c /i915 firmware
rm -rf package/firmware/linux-firmware
git clone https://$github/pmkol/package_firmware_linux-firmware package/firmware/linux-firmware --depth=1
rm -rf package/kernel/linux-firmware/.git

# rtl8812au-ct - fix linux-6.11
rm -rf package/kernel/rtl8812au-ct
git clone https://$github/pmkol/package_kernel_rtl8812au-ct package/kernel/rtl8812au-ct --depth=1
rm -rf package/kernel/rtl8812au-ct/{.git,.github}

# add rtl8812au-ac
git clone https://$github/pmkol/package_kernel_rtl8812au-ac package/kernel/rtl8812au-ac --depth=1
rm -rf package/kernel/rtl8812au-ac/{.git,.github}

# ath10k-ct
rm -rf package/kernel/ath10k-ct
git clone https://$github/pmkol/package_kernel_ath10k-ct package/kernel/ath10k-ct --depth=1
rm -rf package/kernel/ath10k-ct/{.git,.github}

# mt76 - 2024-10-11
rm -rf package/kernel/mt76
mkdir -p package/kernel/mt76/patches
curl -s https://$mirror/openwrt-23.05/patch/mt76/Makefile > package/kernel/mt76/Makefile
curl -s https://$mirror/openwrt-23.05/patch/mt76/patches/100-fix-build-with-mac80211-6.11-backport.patch > package/kernel/mt76/patches/100-fix-build-with-mac80211-6.11-backport.patch

# mac80211 - fix linux 6.11 & add rtw89
rm -rf package/kernel/mac80211
git clone https://$github/pmkol/package_kernel_mac80211 package/kernel/mac80211 --depth=1
rm -rf package/kernel/mac80211/{.git,.github}

# iwinfo: add mt7922 device id
mkdir -p package/network/utils/iwinfo/patches
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/iwinfo/0001-devices-add-MediaTek-MT7922-device-id.patch > package/network/utils/iwinfo/patches/0001-devices-add-MediaTek-MT7922-device-id.patch

# iwinfo: add rtl8812/14/21au devices
curl -s https://$mirror/openwrt-23.05/patch/openwrt-6.x/iwinfo/0004-add-rtl8812au-devices.patch > package/network/utils/iwinfo/patches/0004-add-rtl8812au-devices.patch

# wireless-regdb
curl -s https://raw.githubusercontent.com/openwrt/openwrt/openwrt-23.05/package/firmware/wireless-regdb/Makefile > package/firmware/wireless-regdb/Makefile
curl -s https://$mirror/openwrt-23.05/patch/wireless-regdb/500-world-regd-5GHz.patch > package/firmware/wireless-regdb/patches/500-world-regd-5GHz.patch

# ubnt-ledbar - fix linux-6.x
curl -s https://raw.githubusercontent.com/openwrt/openwrt/main/package/kernel/ubnt-ledbar/src/leds-ubnt-ledbar.c package/kernel/ubnt-ledbar/src/leds-ubnt-ledbar.c

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101
rm -rf package/kernel/{r8168,r8101,r8125,r8126}
git clone https://github.com/sbwml/package_kernel_r8168 package/kernel/r8168 --depth 1
git clone https://github.com/sbwml/package_kernel_r8152 package/kernel/r8152 --depth 1
git clone https://github.com/sbwml/package_kernel_r8101 package/kernel/r8101 --depth 1
git clone https://github.com/sbwml/package_kernel_r8125 package/kernel/r8125 --depth 1
git clone https://github.com/sbwml/package_kernel_r8126 package/kernel/r8126 --depth 1
rm -rf package/kernel/{r8168,r8152,r8101,r8125,r8126}/.git
rm -f package/kernel/r8168/README.md

# Shortcut Forwarding Engine
git clone https://$github/pmkol/package_new_shortcut-fe package/new/shortcut-fe --depth=1
rm -rf package/new/shortcut-fe/{.git,.github}
# shortcut-fe kernel patch
curl -s https://$mirror/openwrt-23.05/patch/kernel-6.11/net/601-netfilter-export-udp_get_timeouts-function.patch > target/linux/generic/hack-6.11/601-netfilter-export-udp_get_timeouts-function.patch
curl -s https://$mirror/openwrt-23.05/patch/kernel-6.11/net/953-net-patch-linux-kernel-to-support-shortcut-fe.patch > target/linux/generic/hack-6.11/953-net-patch-linux-kernel-to-support-shortcut-fe.patch

# FullCone module
git clone https://$github/pmkol/package_new_nft-fullcone package/new/nft-fullcone --depth=1
rm -rf package/new/nft-fullcone/{.git,.github}
# fullcone kernel patch
curl -s https://$mirror/openwrt-23.05/patch/kernel-6.11/net/952-net-conntrack-events-support-multiple-registrant.patch > target/linux/generic/hack-6.11/952-net-conntrack-events-support-multiple-registrant.patch
# bcm-fullcone kernel patch
curl -s https://$mirror/openwrt-23.05/patch/kernel-6.11/net/982-add-bcm-fullcone-support.patch > target/linux/generic/hack-6.11/982-add-bcm-fullcone-support.patch
curl -s https://$mirror/openwrt-23.05/patch/kernel-6.11/net/983-add-bcm-fullcone-nft_masq-support.patch > target/linux/generic/hack-6.11/983-add-bcm-fullcone-nft_masq-support.patch

# IPv6 NAT
git clone https://$github/pmkol/package_new_nat6 package/new/nat6 --depth=1
rm -rf package/new/nat6/{.git,.github}

# urngd
rm -rf package/system/urngd
git clone https://github.com/sbwml/package_system_urngd package/system/urngd --depth=1
rm -rf package/system/urngd/.git

# tcp-brutal
git clone https://github.com/sbwml/package_kernel_tcp-brutal package/kernel/tcp-brutal --depth=1
rm -rf package/kernel/tcp-brutal/.git
