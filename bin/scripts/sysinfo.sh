#!/bin/sh

#######################################
# SYSTEM STATUS NOTIFIER (POSIX sh)
# - Instant CPU usage (delta-based)
# - Accurate RAM usage
# - CPU-preferred temperature
# - Robust battery / wpctl volume / network
# - Monospace-aligned Mako output
#######################################

# Locale safety
LC_ALL=C
export LC_ALL

############################
# 1. CPU (instant usage)
############################
read_cpu() {
    awk '/^cpu / {print $2+$4, $2+$4+$5}' /proc/stat
}

read u1 t1 <<EOF
$(read_cpu)
EOF
sleep 0.3
read u2 t2 <<EOF
$(read_cpu)
EOF

CPU_USAGE=$(awk -v u1="$u1" -v t1="$t1" -v u2="$u2" -v t2="$t2" '
BEGIN {
    dt = t2 - t1
    if (dt <= 0) print "0.0%"
    else printf "%.1f%%", (u2-u1)*100/dt
}')

############################
# 2. RAM
############################
MEM_INFO=$(awk '
/^MemTotal:/     {mt=$2}
/^MemAvailable:/ {ma=$2}
END {
    used=(mt-ma)/1048576
    total=mt/1048576
    printf "%.1f/%.1fGiB", used, total
}' /proc/meminfo)

############################
# 3. Temperature (CPU-preferred)
############################
TEMP_VAL="N/A"
preferred=""

for t in /sys/class/hwmon/hwmon*/temp*_input; do
    label="${t%_*}_label"
    if [ -f "$label" ] && grep -qiE 'cpu|package|tctl' "$label"; then
        preferred="$t"
        break
    fi
done

if [ -z "$preferred" ]; then
    for t in /sys/class/hwmon/hwmon*/temp*_input; do
        preferred="$t"
        break
    done
fi

if [ -n "$preferred" ] && [ -f "$preferred" ]; then
    read -r raw < "$preferred"
    TEMP_VAL="$((raw / 1000))°C"
fi

############################
# 4. Battery
############################
BAT_VAL="N/A"
for b in /sys/class/power_supply/BAT*; do
    [ -d "$b" ] || continue
    [ -r "$b/capacity" ] || continue
    [ -r "$b/status" ] || continue
    read -r CAP  < "$b/capacity"
    read -r STAT < "$b/status"
    case $STAT in
        Charging)    S="+" ;;
        Discharging) S="-" ;;
        Full)        S="F" ;;
        *)           S="I" ;;
    esac
    BAT_VAL="$CAP%[$S]"
    break
done

############################
# 5. Volume (WirePlumber wpctl)
############################
VOL_VAL="N/A"
# wpctl get-volume @DEFAULT_AUDIO_SINK@ returns "Volume: 0.XX [MUTED]"
if command -v wpctl >/dev/null 2>&1; then
    VOL_VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '
    {
        # Check if [MUTED] exists in the output
        if ($0 ~ /\[MUTED\]/) {
            print "Muted"
        } else {
            # Multiply 0.XX by 100 to get percentage
            printf "%d%%", $2 * 100
        }
    }')
fi

############################
# 6. Network (any active iface)
############################
NET_VAL="DOWN"
for f in /sys/class/net/*/operstate; do
    iface=${f%/operstate}
    iface=${iface##*/}
    [ "$iface" = "lo" ] && continue
    read -r s < "$f"
    if [ "$s" = "up" ]; then
        NET_VAL="$iface-UP"
        break
    fi
done

############################
# 7. Date & Time
############################
DT=$(date '+%a, %d %b %Y|%H:%M:%S')
DATE_VAL=${DT%|*}
TIME_VAL=${DT#*|}

############################
# 8. Output formatting
############################
LINE1=$(printf "CPU: %-7s | RAM: %-12s | NET: %s" "$CPU_USAGE" "$MEM_INFO" "$NET_VAL")
LINE2=$(printf "BAT: %-7s | VOL: %-12s | TMP: %s" "$BAT_VAL" "$VOL_VAL" "$TEMP_VAL")
SEP="----------------------------------------------"

notify-send -r 9999 -t 5000 \
"SYSTEM MONITOR" \
"<tt>$LINE1
$LINE2
$SEP
DATE: $DATE_VAL
TIME: $TIME_VAL</tt>"
