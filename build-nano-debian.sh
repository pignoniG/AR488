#!/bin/sh
# Build AR488 for an Arduino Nano (ATmega328P) with Debian's Arduino packages:
#   sudo apt install arduino-builder arduino-core-avr gcc-avr avr-libc avrdude
# Usage: ./build-nano-debian.sh [old|new]   (Nano bootloader: old = 57600 baud clones,
#        new = Optiboot 115200; the .hex is the same, this only picks the board variant)
# Output: build/AR488_<version>_nano_sn7516x_te6_dc13.hex
set -e
cd "$(dirname "$0")"
CPU=atmega328old; [ "$1" = new ] && CPU=atmega328
OUT=$(mktemp -d)
VER=$(sed -n 's/.*FWVER.*ver\. \([^,]*\),.*/\1/p' src/AR488/AR488_Config.h | head -1)
# DECIMAL_DIG: Debian's core 1.8.7 needs it, avr-gcc 5.4 only defines it for C.
# SERIAL_RX_BUFFER_SIZE: 256-byte serial receive buffer instead of 64 (reported by ++rxbuf),
# so the host can send more ahead without overflowing it (the adapter has no flow control).
arduino-builder -compile -hardware /usr/share/arduino/hardware \
  -tools /usr/share/arduino/hardware/tools -tools /usr/bin \
  -built-in-libraries /usr/share/arduino/hardware/arduino/avr/libraries \
  -fqbn arduino:avr:nano:cpu=$CPU -build-path "$OUT" \
  -prefs=runtime.tools.avr-gcc.path=/usr -prefs=runtime.tools.avrdude.path=/usr \
  "-prefs=compiler.cpp.extra_flags=-DDECIMAL_DIG=__DECIMAL_DIG__ -DSERIAL_RX_BUFFER_SIZE=256" \
  src/AR488/AR488.ino | grep -E "Sketch uses|Global variables"
mkdir -p build
cp "$OUT/AR488.ino.hex" "build/AR488_${VER}_nano_sn7516x_te6_dc13.hex"
rm -rf "$OUT"
echo "-> build/AR488_${VER}_nano_sn7516x_te6_dc13.hex"
