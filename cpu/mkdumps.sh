set -e
set -x

WINEPATH="C:/Program Files (x86)/IDA Free" IDALOG=mkdumps.log wine idag.exe -Smkdumps.idc altos586.idb
iconv -fcp850 mkdumps.asm >altos586.asm
iconv -fcp850 mkdumps.lst >altos586.lst
