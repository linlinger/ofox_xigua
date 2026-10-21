#!/system/bin/sh
# wlanfix.sh - bring up WLAN + battery for OnePlus Ace 2 Pro (xigua/SM8550)
#
# 1. Boot the ADSP: battery/charging on this device goes through pmic_glink,
#    which needs the ADSP remote processor running. Without it,
#    /sys/class/power_supply stays empty (verified 2026-10-21).
# 2. Signal CNSS that firmware is ready: the ROM's cnss-daemon writes
#    fs_ready=1; recovery has no such daemon, so CNSS never powers on the
#    WLAN block and kiwi_v2 never registers wlan0.
#    Requires the WLAN module stack (cnss2 etc.) to be loaded first.
# 3. Fallback: if wlan0 still missing, reload kiwi_v2 (fixes a probe that
#    failed before WCNSS_qcom_cfg.ini was reachable).

# --- 1. ADSP up (battery) ---
for r in /sys/class/remoteproc/remoteproc*; do
    case "$(cat "$r/name" 2>/dev/null)" in
        *adsp*)
            state="$(cat "$r/state" 2>/dev/null)"
            if [ "$state" != "running" ]; then
                echo start > "$r/state" 2>/dev/null
            fi
            ;;
    esac
done

# --- 2. fs_ready -> CNSS firmware bring-up ---
# wait until cnss2 driver has probed (fs_ready node exists)
FS_READY=""
i=0
while [ $i -lt 30 ]; do
    FS_READY="$(ls /sys/bus/platform/devices/*cnss-qca-converged/fs_ready 2>/dev/null | head -n1)"
    [ -n "$FS_READY" ] && break
    i=$((i+1))
    sleep 1
done
if [ -n "$FS_READY" ]; then
    echo 1 > "$FS_READY" 2>/dev/null
fi

# --- 3. wait for wlan0, reload kiwi as fallback ---
i=0
while [ $i -lt 20 ]; do
    [ -e /sys/class/net/wlan0 ] && exit 0
    i=$((i+1))
    sleep 1
done
KMOD="$(ls /tmp/vendor_dlkm/lib/modules/qca_cld3_kiwi_v2.ko /tmp/vendor/lib/modules/qca_cld3_kiwi_v2.ko 2>/dev/null | head -n1)"
if [ -n "$KMOD" ]; then
    rmmod kiwi_v2 2>/dev/null
    insmod "$KMOD" 2>/dev/null
fi

exit 0
