set -e
set -x

WINEPREFIX=$PWD IDALOG=mkdumps.log wine idaw.exe -Smkdumps.idc -A iop.bin
iconv -fcp850 mkdumps.asm >iop.asm
iconv -fcp850 mkdumps.lst >iop.lst
