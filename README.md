<img src="https://github.com/Sanju0910/Sanju0910/blob/main/images/of_logo.png" width=100 height=100 align="left" />  
<img src="https://github.com/Sanju0910/Sanju0910/blob/main/images/oneplus_logo.png" align="right"/>

## OrangeFox Recovery Project - OnePlus Ace 2 Pro (xigua / PJA110)

Adapted from [Wishmasterflo/ofox_salami](https://github.com/Wishmasterflo/ofox_salami) (OnePlus 11, same SM8550 platform).

### xigua adaptation notes
 - `TW_MAX_BRIGHTNESS` 550 -> **4095** (panel0-backlight real max; 550 capped screen at ~13% brightness)
 - `OF_SCREEN_H` -> 2772 (xigua panel is 1240x2772)
 - Touch race fix: synaptics_tcm registers `/dev/input/event8` *after* recovery starts
   (`on boot` vs `twrp.modules.loaded` property chain), and minuitwrp's mtime rescan
   does not fire on devtmpfs. Added `system/etc/init/touchfix.rc` + `system/etc/touchfix.sh`:
   if touch is up but recovery has no event fd open, restart recovery (init respawns it,
   ev_init then scans the complete device list). Verified live on device.
 - `variant-script.sh` simplified: unconditional PJA110 props (single-variant device)
 - `twrp.dependencies` fixed to point at the real common tree:
   [nebrassy/device_oneplus_sm85xx-common-TWRP](https://github.com/nebrassy/device_oneplus_sm85xx-common-TWRP) (android-12.1)
 - `TARGET_OTA_ASSERT_DEVICE := xigua` restored

## Original OnePlus 11 changelog

# 07-May-2026 R12.0 V11
 - New Orangefox R12.0 with new UI look
 - Synced with latest Orangefox R12.0 release Changes
 - Added KernelSU addon

# 03-Apr-2026 R11.3 V10
 - Synced with latest Orangefox source changes
 - Added KernelSU addon (experimental!) 

# 16-Mar-2026 R11.3 V9
 - Synced with latest Orangefox source changes
 - Updated builtin Magisk to Magisk 30.6

# 15-Aug-2025 R11.3 V8
 - Synced with latest Orangefox source changes
 - Updated to latest Orangefox Version R11.3

# 19-Feb-2025 R11.1 V7
 - Synced with latest Orangefox source changes
   
# 02-Feb-2024 R11.1 V6
 - Synced with latest Orangefox source changes
 - Now Orangefox will reflash itself if a ROM is flashed from within a already flashed Orangefox V6 Version on the phone.

# 18-Oct-2023 R11.1 V5
 - Synced with latest Orangefox source changes
 - Added Data decryption for Android 14
 - Fixed Magisk addon
 - Some small adjustments

# 11-Oct-2023 R11.1 V4
 - Synced with latest Orangefox source changes
 - Updated Magisk addon to Magisk 26.3

# 16-Sep-2023 R11.1 V3
 - Fixed FOX_TARGET_DEVICES
 - Adjusted screen settings
 
# 15-Sep-2023 R11.1 V2
 - Adjusted Clock and screen settings
 - Added device detection model script

# 14-Sep-2023 R11.1 V1
 - Initial Release of Orangefox Recovery for the Oneplus 11

