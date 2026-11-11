# gpibpi branch

AR488 0.53.46 as running on the three Arduino Nano adapters of the gpibpi
VXI-11 gateway ([ar488-vxi11](https://github.com/pignoniG/ar488-vxi11-)):

* `++eot_char` sent as a byte, not as decimal text (bug fix, also on branch `fix-eot-fndl`)
* `++fndl` unaddresses the bus afterwards, so the next write isn't lost (bug fix, also on `fix-eot-fndl`)
* `AR488_Config.h`: SN75160/SN75161 bus drivers, Jay Diddy B board, `SN7516X_TE 6`, `SN7516X_DC 13`, SC unused

Build with Debian's Arduino packages: `./build-nano-debian.sh`. This builds
`build/AR488_0.53.46_nano_sn7516x_te6_dc13.hex`, sha256
`9e3a3b4a460c8614cafdd7e1c6744908883d201690a160610d99cc3dbb984a7f`, the
image flashed on all three adapters. Flash it with:

```sh
avrdude -p m328p -c arduino -P <port> -b <57600 for old-bootloader clones | 115200 for Optiboot> -D \
  -U flash:w:build/AR488_0.53.46_nano_sn7516x_te6_dc13.hex:i
```

Details: [docs/firmware.md](https://github.com/pignoniG/ar488-vxi11-/blob/main/docs/firmware.md) in ar488-vxi11.
