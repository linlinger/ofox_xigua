#!/system/bin/sh
# This script is needed to automatically set device props.
# xigua (OnePlus Ace 2 Pro) - single variant, no region switching needed.

resetprop ro.product.device "PJA110"
resetprop ro.product.odm.device "PJA110"
resetprop ro.product.product.device "PJA110"
resetprop ro.product.system_ext.device "PJA110"
resetprop ro.product.vendor.device "PJA110"

resetprop ro.product.product.model "PJA110"
resetprop ro.product.model "PJA110"
resetprop ro.product.system.model "PJA110"
resetprop ro.product.system_ext.model "PJA110"
resetprop ro.product.vendor.model "PJA110"
resetprop ro.product.odm.model "PJA110"

exit 0
