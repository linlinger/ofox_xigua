#
# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This contains the module build definitions for the hardware-specific
# components for this device.
#
# As much as possible, those components should be built unconditionally,
# with device-specific names to avoid collisions, to avoid device-specific
# bitrot and build breakages. Building a component unconditionally does
# *not* include it on all devices, so it is safe even with hardware-specific
# components.

# Inherit from common
-include $(COMMON_PATH)/BoardConfigCommon.mk

# Kernel (override common: out needs the prebuilt for extract_kernel, but the
# OnePlus ABL merges the boot-partition kernel with the recovery ramdisk, so
# the recovery image itself carries no kernel - matches authored xigua tree)
TARGET_KERNEL_ARCH            := arm64
BOARD_KERNEL_IMAGE_NAME       := Image
BOARD_KERNEL_PAGESIZE         := 4096
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_PREBUILT_KERNEL        := $(DEVICE_PATH)/prebuilts/kernel
BOARD_MKBOOTIMG_ARGS          += --pagesize $(BOARD_KERNEL_PAGESIZE)

# ===== Ported verbatim from the authored xigua tree BoardConfig.mk =====

# Crypto
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
AERA_INCLUDE_CRYPTO := true
AERA_INCLUDE_CRYPTO_FBE := true
AERA_INCLUDE_FBE_METADATA_DECRYPT := true
AERA_USE_FSCRYPT_POLICY := 2

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
AERA_INCLUDE_FASTBOOTD := true
AERA_SKIP_ADDITIONAL_FSTAB := true
AERA_UI_ADAPTIVE_RESOLUTION := true

# Tool
AERA_INCLUDE_LIBRESETPROP := true
AERA_INCLUDE_LPDUMP := true
AERA_INCLUDE_LPTOOLS := true
AERA_INCLUDE_REPACKTOOLS := true
AERA_INCLUDE_RESETPROP := true

# Debug
TARGET_USES_LOGD := true
AERA_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace

# AERA display (BOE Q9+ LTPS 1240x2772, max brightness 4095)
AERA_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
AERA_DEFAULT_BRIGHTNESS := 1023
AERA_FRAMERATE := 120
AERA_MAX_BRIGHTNESS := 4095
AERA_NO_SCREEN_BLANK := true
AERA_SCREEN_BLANK_ON_BOOT := true
AERA_THEME := portrait_hdpi
TARGET_USES_VULKAN := true

# AERA file system
RECOVERY_SDCARD_ON_DATA := true
TARGET_USES_MKE2FS := true
AERA_ENABLE_FS_COMPRESSION := true
AERA_INCLUDE_FUSE_EXFAT := true
AERA_INCLUDE_FUSE_NTFS := true
AERA_INCLUDE_NTFS_3G := true
AERA_NO_EXFAT_FUSE := true

# Version overrides consumed by prepdecrypt / vendor property checks
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
AERA_DEVICE_VERSION := OnePlus_Ace_2_Pro

# Other AERA configurations
TARGET_RECOVERY_QCOM_RTC_FIX := true
AERA_EXCLUDE_APEX := true
AERA_EXCLUDE_DEFAULT_USB_INIT := true
AERA_DEFAULT_LANGUAGE := zh-CN
AERA_EXTRA_LANGUAGES := true

# Modules bundled at recovery/root/lib/modules, extracted from the installed
# ColorOS 17 vendor_dlkm so they match the boot-partition kernel
# (5.15.180-android13-OP-WILD). Dependency closure beyond this list is loaded
# from the mounted /vendor_dlkm partition.
AERA_LOAD_VENDOR_MODULES := "msm_ext_display.ko sync_fence.ko msm_hw_fence.ko hdcp_qseecom_dlkm.ko msm_drm.ko msm_kgsl.ko goodix_ts.ko atmel_mxt_ts.ko"
AERA_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# NOTE: AERA_LOAD_VENDOR_MODULES *overwrites* TW_LOAD_VENDOR_MODULES via
# aera-map-config (aera_config.mk:9), so the sm85xx-common list is lost when
# this is defined. Merge those modules back in here, otherwise qcom-hv-haptics
# (FF vibration), charger and touch bridge modules are never requested.
# Keep this UNQUOTED - embedded quotes would break the -D macro expansion.
SM85XX_BASE_MODULES := adsp_loader_dlkm.ko rproc_qcom_common.ko q6_dlkm.ko qcom_q6v5.ko qcom_q6v5_pas.ko qcom_esoc.ko qcom_sysmon.ko qcom-hv-haptics.ko haptic_feedback.ko oplus_chg.ko oplus_bsp_tp_custom.ko oplus_bsp_tp_comon.ko oplus_bsp_tp_notify.ko oplus_bsp_tp_tcm_oncell.ko oplus_bsp_tp_tcm_S3910.ko oplus_bsp_tp_syna_comnon.ko oplus_bsp_tp_gt9966.ko oplus_bsp_tp_gt9916.ko oplus_bsp_tp_goodix_comnon.ko

# WLAN: load CNSS/kiwi stack after the display modules.
AERA_LOAD_VENDOR_MODULES := "$(subst ",,$(AERA_LOAD_VENDOR_MODULES)) $(SM85XX_BASE_MODULES) smem-mailbox.ko cnss_prealloc.ko cnss_utils.ko cnss_plat_ipc_qmi_svc.ko cnss_nl.ko wlan_firmware_service.ko cnss2.ko rfkill.ko btpower.ko cfg80211.ko qca_cld3_kiwi_v2.ko"
AERA_POST_DECRYPT_MODULES := "aera_post_decrypt_stage_only.ko"
AERA_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
AERA_USE_TOOLBOX := true
AERA_INPUT_BLACKLIST := "hbtp_vm"

# TWRP specific build flags
TW_FRAMERATE := 120
TARGET_OTA_ASSERT_DEVICE := xigua
TW_MAX_BRIGHTNESS := 4095

# Vibrator: use the kernel input FF path (qcom-hv-haptics, event4).
# The AIDL path needs a vibrator HAL service which the recovery ramdisk
# does not ship - vibrate() would silently no-op.
TW_SUPPORT_INPUT_FF_HAPTICS := true

TARGET_RECOVERY_DEVICE_MODULES += libexpat
RECOVERY_LIBRARY_SOURCE_FILES += \
     $(TARGET_OUT_SHARED_LIBRARIES)/libexpat.so
