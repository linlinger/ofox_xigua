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
#
# Only the below variable(s) need to be changed!
#
# Identifier for common folder
COMMON_SOC := sm85xx

# Define hardware platform
PRODUCT_PLATFORM := kalama

#
#
#
# The below variables will be generated automatically
#
#
# Release name (automatically taken from this file's suffix)
PRODUCT_RELEASE_NAME := $(lastword $(subst /, ,$(lastword $(subst _, ,$(firstword $(subst ., ,$(MAKEFILE_LIST)))))))

# Custom vendor used in build tree (automatically taken from this file's prefix)
CUSTOM_VENDOR := $(lastword $(subst /, ,$(firstword $(subst _, ,$(firstword $(MAKEFILE_LIST))))))

# Inherit from our custom product configuration
$(call inherit-product, vendor/twrp/config/common.mk)

# OEM Info (automatically taken from device tree path)
BOARD_VENDOR := $(or $(word 2,$(subst /, ,$(firstword $(MAKEFILE_LIST)))),$(value 2))

## Device identifier. This must come after all inclusions

PRODUCT_DEVICE := xigua
PRODUCT_NAME := $(CUSTOM_VENDOR)_$(PRODUCT_DEVICE)
PRODUCT_MODEL := PJA110
PRODUCT_SYSTEM_NAME := $(PRODUCT_MODEL)
PRODUCT_SYSTEM_DEVICE := PJA110
PRODUCT_BRAND := $(BOARD_VENDOR)
PRODUCT_MANUFACTURER := $(PRODUCT_BRAND)

# AERA UI tweaks (carried over from the authored xigua tree)
AERA_STATUS_ICONS_ALIGN := center

# AERA product flags (ported verbatim from the authored xigua tree,
# aera_xigua.mk) - required for correct feature gating incl. WLAN,
# otherwise aera_backend.cpp references uncompiled AeraSecrets symbols
AERA_MAINTAINER := AviumUI
# AERA_SCREEN_H is the theme's 1080-wide REFERENCE-space height (converted
# x4/3 to the 1440-wide logical space at compile time). Bigger value = taller
# canvas = vertically SQUASHED UI. To mimic the TWRP look (its 1080x1920 theme
# scaled X 1.148x / Y 1.371x = +19% vertical stretch): need Y-scale
# 0.8611*1.194 = 1.028 -> canvas 2772/1.028 = 2696 -> 2696*3/4 = 2022.
# (Matches TWRP's effective base: 2772/1.370833 = 2022.)
AERA_SCREEN_H := 2022
AERA_STATUS_H := 132
AERA_HIDE_NOTCH := 1
AERA_STATUS_INDENT_LEFT := 90
AERA_STATUS_INDENT_RIGHT := 90
AERA_OPTIONS_LIST_NUM := 6
AERA_USE_GREEN_LED := 0
AERA_ENABLE_ALL_PARTITION_TOOLS := 1
AERA_WORKAROUND_BACKUP_BUG := 1
AERA_USE_AIDL_BOOT_CONTROL := 0
AERA_FORCE_DATA_FORMAT_F2FS := 1
AERA_UNBIND_SDCARD_F2FS := 1
AERA_WIPE_METADATA_AFTER_DATAFORMAT := 1
AERA_DYNAMIC_FULL_SIZE := 16106127360
AERA_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO := 1
AERA_FORCE_PREBUILT_KERNEL := 1
AERA_NO_RELOAD_AFTER_DECRYPTION := 1
AERA_NO_TREBLE_COMPATIBILITY_CHECK := 1
AERA_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
AERA_ENABLE_ABL_PRESERVATION := 1
AERA_ENABLE_FRP_WIPE := 1
AERA_USE_LZ4_COMPRESSION := 1
AERA_ENABLE_WLAN := 1

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=$(PRODUCT_SYSTEM_DEVICE) \
    TARGET_PRODUCT=$(PRODUCT_SYSTEM_NAME)

# Common path for device trees
COMMON_PATH := device/oneplus/sm85xx-common

# Device path for OEM device tree
DEVICE_PATH := device/oneplus/xigua

# Inherit from hardware-specific part of the product configuration
$(call inherit-product, $(DEVICE_PATH)/device-xigua.mk)

