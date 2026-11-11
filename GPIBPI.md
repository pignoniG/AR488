# gpibpi branch

AR488 0.53.46 as running on the three Arduino Nano adapters of the gpibpi
VXI-11 gateway ([ar488-vxi11](https://github.com/pignoniG/ar488-vxi11-)).
Version string: `AR488 GPIB controller, ver. 0.53.46-gpibpi2, 11/11/2026`.

Changes to upstream 0.53.46:

* **Bug fix:** `++eot_char` is sent as a byte, not as decimal text (also on branch `fix-eot-fndl`).
* **Bug fix:** `++fndl` unaddresses the bus afterwards, so the next write isn't lost (also on `fix-eot-fndl`).
* **Bus drivers:** `AR488_Config.h` is set for SN75160/SN75161 bus drivers on the Jay Diddy B board: `SN7516X_TE 6`, `SN7516X_DC 13`, SC unused.
* **Serial speed 500000 baud** (`AR_SERIAL_SPEED`). This is exact on a 16 MHz AVR, where 115200 is 2.1% off, and 4× faster.
* **`++eot_escape 0|1`** (default 0, not saved to EEPROM). With 1, received data bytes
  equal to the EOT character or to DLE (0x10) are sent as DLE followed by the byte.
  An unescaped EOT then always marks the end of a reply, even in binary data.
  To decode: DLE x → x.
* **`++rxbuf`** reports the serial receive buffer size. `build-nano-debian.sh`
  builds with `-DSERIAL_RX_BUFFER_SIZE=256` (stock: 64), so the host can send
  more ahead without overflowing it. The adapter has no flow control.

The EEPROM layout is unchanged, so saved settings and the `++id name` survive
reflashing.

Build with Debian's Arduino packages: `./build-nano-debian.sh`. It writes
`build/AR488_0.53.46-gpibpi2_nano_sn7516x_te6_dc13.hex`, sha256
`b05011baaaf14b41a522bc79a16f3ee5c90c3da1efe6aa765e247f2c86c9bf9d`. This is
the image flashed on all three adapters on 2026-11-11. Flash it with:

```sh
avrdude -p m328p -c arduino -P <port> -b <57600 for old-bootloader clones | 115200 for Optiboot> -D \
  -U flash:w:build/AR488_0.53.46-gpibpi2_nano_sn7516x_te6_dc13.hex:i
```

The bootloader's upload speed is unrelated to the 500000 baud the firmware runs
at. After flashing, open the port at 500000 baud. A terminal at 115200 shows
nothing.

Details: [docs/firmware.md](https://github.com/pignoniG/ar488-vxi11-/blob/main/docs/firmware.md) in ar488-vxi11.
