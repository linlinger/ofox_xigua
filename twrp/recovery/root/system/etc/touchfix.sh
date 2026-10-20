#!/system/bin/sh
# xigua (OnePlus Ace 2 Pro) touch race fix
#
# The synaptics_tcm touch module registers /dev/input/event8 AFTER init
# starts the recovery service ("on boot" vs twrp.modules.loaded property
# chain). minuitwrp's mtime-based rescan does not fire on devtmpfs, so
# recovery can start with zero input devices opened (no touch).
# Verified workaround: if touch exists but recovery has no event fd
# open, kill recovery; init restarts it and ev_init then scans the
# complete input device list.

i=0
while [ $i -lt 30 ]; do
    if grep -q "synaptics" /proc/bus/input/devices 2>/dev/null; then
        break
    fi
    i=$((i+1))
    sleep 1
done

# Touch never appeared - nothing to fix (module failure is another issue)
grep -q "synaptics" /proc/bus/input/devices 2>/dev/null || exit 0

# Grace period: let a concurrently-running ev_init finish its own scan
sleep 3

pid=$(pidof recovery)
[ -n "$pid" ] || exit 0

if ! ls -l /proc/$pid/fd 2>/dev/null | grep -q "event[0-9]"; then
    kill "$pid"
fi
