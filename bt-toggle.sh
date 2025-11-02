#!/usr/bin/env bash

echo "=== Bluetooth toggle debug start ==="

# Get the first connected Bluetooth card
CARD=$(pactl list cards short | grep bluez_card | awk '{print $2}')
echo "Detected Bluetooth card: $CARD"

if [ -z "$CARD" ]; then
    notify-send "Bluetooth" "No Bluetooth audio device found!"
    echo "No Bluetooth card found. Exiting."
    exit 1
fi

# Get the current profile (PipeWire-compatible)
PROFILE=$(pactl list cards | awk -v card="$CARD" '
    $1 == "Card" {found=0}
    $2 == card {found=1}
    found && /Active Profile:/ {print $3; exit}
')
echo "Current profile: $PROFILE"

case "$PROFILE" in
    a2dp-sink|a2dp-sink-sbc|a2dp-sink-aac|a2dp-sink-sbc_xq)
        echo "Switching to mic/call mode..."
        pactl set-card-profile "$CARD" headset-head-unit
        notify-send "Bluetooth" "Switched to HFP/HSP (mic)"
        ;;
    headset-head-unit|headset-head-unit-cvsd)
        echo "Switching to high-quality A2DP mode..."
        pactl set-card-profile "$CARD" a2dp-sink
        notify-send "Bluetooth" "Switched to A2DP (high quality)"
        ;;
    off)
        echo "Card is off, switching to A2DP..."
        pactl set-card-profile "$CARD" a2dp-sink
        notify-send "Bluetooth" "Switched to A2DP (high quality)"
        ;;
    *)
        notify-send "Bluetooth" "Unknown profile: $PROFILE"
        echo "Unknown profile: $PROFILE"
        ;;
esac

echo "=== Bluetooth toggle debug end ==="

