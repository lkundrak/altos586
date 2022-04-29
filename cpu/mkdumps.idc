#include <idc.idc>

static main(void) {
	GenerateFile(OFILE_IDC,fopen("altos586.idc","w"), 0, 0x100000, 0);
	GenerateFile(OFILE_LST,fopen("mkdumps.lst","w"), 0, 0x100000, 0);
	GenerateFile(OFILE_ASM,fopen("mkdumps.asm","w"), 0, 0x100000, 0);
	Exit(0);
}
