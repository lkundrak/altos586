set -e
set -x

dodumps()
{
	cat >mkdumps.idc <<EOF
#include <idc.idc>

static main(void) {
	GenerateFile(OFILE_IDC,fopen("$1.idc","w"), 0, 0x100000, 0);
	GenerateFile(OFILE_LST,fopen("mkdumps.lst","w"), 0, 0x100000, 0);
	GenerateFile(OFILE_ASM,fopen("mkdumps.asm","w"), 0, 0x100000, 0);
	Exit(0);
}
EOF

	WINEPATH="C:/Program Files (x86)/IDA Free" IDALOG=mkdumps.log wine idag.exe -Smkdumps.idc $1.idb
	iconv -fcp850 mkdumps.asm >$1.asm
	iconv -fcp850 mkdumps.lst >$1.lst
}

dodumps altos586-v13
dodumps altos586-a22
rm -f mkdumps.asm mkdumps.lst mkdumps.log
