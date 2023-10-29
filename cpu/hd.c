// SPDX-License-Identifier: GPL-2.0-or-later

//#define WITH_LIB8089 1
#ifndef WITH_LIB8089
#define WITH_LIB8089 0
#endif

#include <stdint.h>
#include <stdio.h>

#include <x86emu.h>
#include <8089.h>

extern x86emu_t *emu;
extern int hddfd;

extern FILE *out;
#define xprintf(...) do { \
		if (out) { \
			fprintf(out, "EMU: " __VA_ARGS__); \
			fflush (out); \
		} \
		x86emu_log(emu, "EMU: " __VA_ARGS__); \
	} while(0)
//#define xprintf(...) printf(__VA_ARGS__)

/*
Specify the SYSTEM MODEL number
(A) ACS586-10 (4hd,306cyl)                 (B) ACS586-20 (6hd,306cyl)
(C) ACS586-30 (6hd,512cyl)                 (D) ACS586-40 (8hd,512cyl)
(E) H-H 20 MB (4hd,612cyl)                 (F) Option-your choice
*/

int hdd_read_sec(int fd, uint8_t data_buf[512], unsigned cyl, unsigned head, unsigned sector);
int hdd_write_sec(int fd, uint8_t data_buf[512], unsigned cyl, unsigned head, unsigned sector);
void hdd_read(x86emu_t *emu, unsigned data, unsigned head, unsigned cylinder, unsigned sector, unsigned count);
void hdd_write(x86emu_t *emu, unsigned data, unsigned head, unsigned cylinder, unsigned sector, unsigned count);

static unsigned char iop_xenix[] = {
0x01, 0x8b,				// 0000: lpd	ga,[pp]
0x11, 0x20, 0x00, 0xf7,			// 0002: addi	ga,0f700h
0x31, 0x30, 0x00, 0x00,			// 0006: movi	gb,0h
0x71, 0x30, 0x00, 0x09,			// 000a: movi	bc,900h
0xe0, 0x00,				// 000e: wid	16,16
0xd1, 0x30, 0x08, 0xc0,			// 0010: movi	cc,0c008h
0x60, 0x00,				// 0014: xfer
0x00, 0x00,				// 0016: nop
0x11, 0x30, 0xe0, 0xff,			// 0018: movi	ga,0ffe0h
0x0a, 0x4c, 0x18, 0x10,			// 001c: movbi	[ga].18h,10h
0x0a, 0x4c, 0x06, 0x82,			// 0020: movbi	[ga].6h,82h
0x31, 0x30, 0x48, 0x09,			// 0024: movi	gb,948h
0x03, 0x8b, 0x08,			// 0028: lpd	ga,[pp].8h
0x02, 0x90, 0x04, 0x02, 0xcd, 0x21,	// 002b: movb	[gb].21h,[ga].4h
0x31, 0x30, 0x20, 0x09,			// 0031: movi	gb,920h
0x03, 0x8b, 0x04,			// 0035: lpd	ga,[pp].4h
0x02, 0x90, 0x04, 0x02, 0xcd, 0x21,	// 0038: movb	[gb].21h,[ga].4h
0x31, 0x30, 0x00, 0x09,			// 003e: movi	gb,900h
0x02, 0x90, 0x00, 0x02, 0xcd, 0x1e,	// 0042: movb	[gb].1eh,[ga].0h
0x40, 0x00,				// 0048: sintr
0x20, 0x48				// 004a: hlt
};

static unsigned char iop_fw[] = {
0x51, 0x30, 0xd0, 0xff,			// 0000:	movi	gc,0ffd0h
0xaa, 0xbb, 0x04, 0x20,			// 0004:	jnbt	[pp].4h,5,x0028
0x0a, 0x4e, 0x06, 0x80,			// 0008:	movbi	[gc].6h,80h
0x02, 0x93, 0x08, 0x02, 0xce, 0x02,	// 000c:	movb	[gc].2h,[pp].8h
0xea, 0xba, 0x06, 0xfc,			// 0012: x0012:	jnbt	[gc].6h,7,x0012
0x0a, 0x4e, 0x06, 0x20,			// 0016:	movbi	[gc].6h,20h
0x13, 0x4f, 0x14, 0x00, 0x00,		// 001a:	movi	[pp].14h,0h
0x0a, 0xbe, 0x06, 0xfc,			// 001f: x001f:	jbt	[gc].6h,0,x001f
0x12, 0xba, 0x04, 0xe2, 0x00,		// 0023:	ljnbt	[gc].4h,0,x010a
0x0a, 0xcb, 0x04, 0x0f,			// 0028: x0028:	andbi	[pp].4h,0fh
0x12, 0xe7, 0x04, 0xb1, 0x00,		// 002c:	ljzb	[pp].4h,x00e2
0x02, 0x93, 0x08, 0x02, 0xce, 0x02,	// 0031:	movb	[gc].2h,[pp].8h
0xea, 0xba, 0x06, 0xfc,			// 0037: x0037:	jnbt	[gc].6h,7,x0037
0x02, 0x93, 0x14, 0x00, 0xce,		// 003b:	movb	[gc],[pp].14h
0x02, 0x93, 0x15, 0x00, 0xce,		// 0040:	movb	[gc],[pp].15h
0x02, 0x93, 0x06, 0x02, 0xce, 0x04,	// 0045:	movb	[gc].4h,[pp].6h
0x02, 0x93, 0x07, 0x02, 0xce, 0x04,	// 004b:	movb	[gc].4h,[pp].7h
0x0a, 0x4e, 0x06, 0x10,			// 0051:	movbi	[gc].6h,10h
0x03, 0x93, 0x06, 0x03, 0xcf, 0x14,	// 0055:	mov	[pp].14h,[pp].6h
0x0a, 0xbe, 0x06, 0xfc,			// 005b: x005b:	jbt	[gc].6h,0,x005b
0x2a, 0xba, 0x04, 0xfc,			// 005f: x005f:	jnbt	[gc].4h,1,x005f
0x0a, 0xe7, 0x10, 0x7b,			// 0063:	jzb	[pp].10h,x00e2
0x0a, 0xbf, 0x04, 0x0e,			// 0067:	jbt	[pp].4h,0,x0079
0x03, 0x8b, 0x0c,			// 006b:	lpd	ga,[pp].0ch
0x31, 0x30, 0x00, 0x00,			// 006e:	movi	gb,0h
0x63, 0x83, 0x0a,			// 0072:	mov	bc,[pp].0ah
0x8b, 0x9f, 0x16, 0x70,			// 0075:	call	[pp].16h,x00e9
0x31, 0x30, 0x00, 0x00,			// 0079: x0079:	movi	gb,0h
0xf1, 0x30, 0x80, 0xfe,			// 007d:	movi	mc,0fe80h
0x11, 0x30, 0xd0, 0xff,			// 0081:	movi	ga,0ffd0h
0x13, 0x4f, 0x12, 0x00, 0x02,		// 0085:	movi	[pp].12h,200h
0x0a, 0xbb, 0x04, 0x12,			// 008a:	jnbt	[pp].4h,0,x00a0
0xd1, 0x30, 0x28, 0x8a,			// 008e:	movi	cc,8a28h
0xa0, 0x00,				// 0092:	wid	8,16
0x6a, 0xbb, 0x04, 0x17,			// 0094:	jnbt	[pp].4h,3,x00af
0x13, 0x4f, 0x12, 0x05, 0x02,		// 0098:	movi	[pp].12h,205h
0x88, 0x20, 0x0f,			// 009d:	jmp	x00af
0xd1, 0x30, 0x28, 0x56,			// 00a0: x00a0:	movi	cc,5628h
0xc0, 0x00,				// 00a4:	wid	16,8
0x4a, 0xbb, 0x04, 0x05,			// 00a6:	jnbt	[pp].4h,2,x00af
0x13, 0x4f, 0x12, 0x04, 0x00,		// 00aa:	movi	[pp].12h,4h
0x63, 0x83, 0x12,			// 00af: x00af:	mov	bc,[pp].12h
0x02, 0x93, 0x09, 0x00, 0xce,		// 00b2:	movb	[gc],[pp].9h
0x60, 0x00,				// 00b7:	xfer
0x02, 0x93, 0x04, 0x02, 0xce, 0x06,	// 00b9:	movb	[gc].6h,[pp].4h
0x0a, 0xb6, 0x06, 0x33,			// 00bf:	jmcne	[gc].6h,x00f6
0x02, 0xef, 0x10,			// 00c3:	decb	[pp].10h
0x0a, 0xe7, 0x10, 0x06,			// 00c6:	jzb	[pp].10h,x00d0
0x02, 0xeb, 0x09,			// 00ca:	incb	[pp].9h
0x88, 0x20, 0xdf,			// 00cd:	jmp	x00af
0x0a, 0xbb, 0x04, 0x0e,			// 00d0: x00d0:	jnbt	[pp].4h,0,x00e2
0x23, 0x8b, 0x0c,			// 00d4:	lpd	gb,[pp].0ch
0x11, 0x30, 0x00, 0x00,			// 00d7:	movi	ga,0h
0x63, 0x83, 0x0a,			// 00db:	mov	bc,[pp].0ah
0x8b, 0x9f, 0x16, 0x07,			// 00de:	call	[pp].16h,x00e9
0x0a, 0x4f, 0x05, 0x00,			// 00e2: x00e2:	movbi	[pp].5h,0h
0x88, 0x20, 0x26,			// 00e6:	jmp	x010f
0xe0, 0x00,				// 00e9: x00e9:	wid	16,16
0xd1, 0x30, 0x08, 0xc2,			// 00eb:	movi	cc,0c208h
0x60, 0x00,				// 00ef:	xfer
0x00, 0x00,				// 00f1:	nop
0x83, 0x8f, 0x16,			// 00f3:	movp	tp,[pp].16h
0x02, 0x92, 0x06, 0x02, 0xcf, 0x05,	// 00f6: x00f6:	movb	[pp].5h,[gc].6h
0x0a, 0xcb, 0x05, 0x7e,			// 00fc:	andbi	[pp].5h,7eh
0xe2, 0xf7, 0x05,			// 0100:	setb	[pp].5h,7
0x0a, 0x4e, 0x06, 0x00,			// 0103:	movbi	[gc].6h,0h
0x88, 0x20, 0x05,			// 0107:	jmp	x010f
0x13, 0x4f, 0x05, 0x81, 0x00,		// 010a: x010a:	movi	[pp].5h,81h
0x40, 0x00,				// 010f: x010f:	sintr
0x20, 0x48				// 0111:	hlt
};

static unsigned char iop_hdtest_1[] = {
0x41, 0x8b,				// 0000:	lpd	gc,[pp]
0x01, 0x8b,				// 0002:	lpd	ga,[pp]
0x31, 0x30, 0x00, 0x00,			// 0004:	movi	gb,0h
0x71, 0x30, 0x00, 0x04,			// 0008:	movi	bc,400h
0x60, 0x2c,				// 000c:	not	bc
0x60, 0x38,				// 000e:	inc	bc
0x61, 0x85,				// 0010:	mov	[gb],bc
0x01, 0xa1,				// 0012:	add	ga,[gb]
0x41, 0xa1,				// 0014:	add	gc,[gb]
0x51, 0x20, 0x46, 0x03,			// 0016:	addi	gc,346h
0x23, 0x8b, 0x08,			// 001a:	lpd	gb,[pp].8h
0x02, 0x91, 0x04, 0x02, 0xce, 0x21,	// 001d:	movb	[gc].21h,[gb].4h
0x31, 0x30, 0x00, 0x00,			// 0023:	movi	gb,0h
0x01, 0x99,				// 0027:	movp	[gb],ga
0x41, 0x8d,				// 0029:	movp	gc,[gb]
0x51, 0x20, 0x1e, 0x03,			// 002b:	addi	gc,31eh
0x23, 0x8b, 0x04,			// 002f:	lpd	gb,[pp].4h
0x02, 0x91, 0x04, 0x02, 0xce, 0x21,	// 0032:	movb	[gc].21h,[gb].4h
0x31, 0x30, 0x00, 0x00,			// 0038:	movi	gb,0h
0x71, 0x30, 0x6e, 0x03,			// 003c:	movi	bc,36eh
0x93, 0x9e, 0x1a, 0xd3, 0xfd,		// 0040:	lcall	[gc].1ah,xfe18
0x11, 0x30, 0xd0, 0xff,			// 0045:	movi	ga,0ffd0h
0x0a, 0x4c, 0x28, 0x10,			// 0049:	movbi	[ga].28h,10h
0x40, 0x00,				// 004d:	sintr
0x20, 0x48,				// 004f:	hlt
};

static uint8_t sbuf[0x4000] = { 0, }; // 16K SRAM
static uint8_t data_latch;
static uint8_t data_buf[517] = { 0, };
static int data_ptr = 0;
static uint8_t command = 0x00;
static uint16_t drive = 0;
static uint16_t head = 0;
static uint8_t sector = 0;
static uint8_t stat1 = 0;
static uint8_t stat2 = 0;
static uint16_t cylinder;

static uint8_t
iop_read8 (struct i89 *iop, uint32_t addr)
{
	uint8_t value;

	value = x86emu_read_byte(emu, addr);
	xprintf ("    IOP {%s} {0x%x} = {0x%x}\n", __func__, addr, value);
	//fflush (stdout);
	return value;
}

static void
iop_write8 (struct i89 *iop, uint32_t addr, uint8_t value)
{
	xprintf ("    IOP {%s} {0x%x} = {0x%x}\n", __func__, addr, value);
	//fflush (stdout);
	x86emu_write_byte (emu, addr, value);
}

static uint8_t
iop_in8 (struct i89 *iop, uint16_t addr)
{
	const char *name = "UNKNOWN";
	uint8_t value = 0xff;

	switch (addr) {
	case 0xffd0:
		name = "Data Read";

		if (data_ptr == sizeof(data_buf)) {
			printf ("NO MORE DATA IN BUF\n");
			emu->max_instr = 0;
			break;
		}

		if (command == 0x01) {
			value = data_buf[data_ptr++];
			if (data_ptr == 512) {
				xprintf("READ FINISHED data_ptr=%d cylinder=%d head=%d sector=%d "
					"[%02x %02x %02x %02x]\n",
					data_ptr, cylinder, head, sector,
					data_buf[0], data_buf[1], data_buf[2], data_buf[3]);
				command = 0x00;
				data_ptr = 0;
				//stat2 = 0x90; // crc error

				// CYL :    4  HD :  1  SEC :   1  ** FLAGGED BAD SECTOR **
				if (cylinder == 4 && head == 1 && sector == 1)
					stat2 |= 0x04;

				// CYL :    4  HD :  1  SEC :   2  ** REC NOT FOUND **
				if (cylinder == 4 && head == 1 && sector == 2)
					stat2 |= 0x08;

				//CYL :    4  HD :  1  SEC :   3  ** CRC ERROR **
				if (cylinder == 4 && head == 1 && sector == 3)
					stat2 |= 0x10;

				// ** STATUS ERROR **
				if (cylinder == 4 && head == 1 && sector == 4)
					stat2 |= 0x20;

				// ** STATUS ERROR **
				if (cylinder == 4 && head == 1 && sector == 5)
					stat2 |= 0x40;
			}
			break;
		} else if (command == (0x01 | 0x08)) {
			value = data_buf[data_ptr++];
			if (data_ptr == 517) {
				xprintf("LONG READ FINISHED data_ptr=%d cylinder=%d head=%d sector=%d "
					"[%02x %02x %02x %02x]\n",
					data_ptr, cylinder, head, sector,
					data_buf[0], data_buf[1], data_buf[2], data_buf[3]);
				command = 0x00;
				data_ptr = 0;
			}
			break;
		}

		printf ("BAD DATA READ COMMAND {%x} DATA PTR %d\n", command, data_ptr);
		emu->max_instr = 0;
		break;
	//case 0xffd2:
	//	name = "Bad Read";
	//	stop = 1;
	//	break;
	case 0xffd4:
		name = "Seek Status Read";
		// 0xfc after reboot
		value = stat1;
		break;
	case 0xffd6:
		name = "Status Read";
		value = stat2;
		break;
	default:
		if (addr < sizeof(sbuf)) {
			name = "SRAM";
			value = sbuf[addr];
		} else {
			emu->max_instr = 0;
		}
	};

	xprintf ("    IOP {%s} 0x%04x -> 0x%02x (%s)\n", __func__, addr, value, name);
	return value;
}

static void
iop_out8 (struct i89 *iop, uint16_t addr, uint8_t value)
{
	const char *name = "UNKNOWN";

	switch (addr) {
	case 0xffd0:
		name = "Data Write";
		data_latch = value;

		if (data_ptr == sizeof(data_buf)) {
			printf ("DATA BUF FULL\n");
			emu->max_instr = 0;
			break;
		}

		if (command == 0x00) {
			break;
		} else if (command == 0x02) {
			data_buf[data_ptr++] = data_latch;
			if (data_ptr == 512) {
				xprintf("WRITE SEC data_ptr=%d cylinder=%d head=%d sector=%d "
					"[%02x %02x %02x %02x ...]\n",
					data_ptr, cylinder, head, sector,
					data_buf[0], data_buf[1], data_buf[2], data_buf[3]);
				command = 0x00;
				data_ptr = 0;
				hdd_write_sec(hddfd, data_buf, cylinder, head, sector);
			}
			break;
		} else if (command == 0x04) {
			data_buf[data_ptr++] = data_latch;
			if (data_ptr == 4) {
				xprintf("FORMAT SEC data_ptr=%d cylinder=%d head=%d sector=%d "
					"[%02x %02x %02x %02x]\n",
					data_ptr, cylinder, head, sector,
					data_buf[0], data_buf[1], data_buf[2], data_buf[3]);
				command = 0x00;
				data_ptr = 0;
			}
			break;
		}

		printf ("BAD DATA WRITE COMMAND {%x} DATA PTR %d\n", command, data_ptr);
		emu->max_instr = 0;
		break;
	case 0xffd2:
		//printf ("HEAD AND DRIVE: %x\n", value);
		name = "Drive/Head Write";
		drive = value >> 4;
		head = value & 0x0f;
		stat2 |= 0x80; // ready
		break;
	case 0xffd4:
		name = "Cylinder Write";
		cylinder >>= 8;
		cylinder |= value << 8;
		break;
	case 0xffd6:
		command = 0x00;
		stat2 = 0x80;

		switch (value) {

		case 0x01:
			name = "Read Command. Sector number now in data buffer, data readout follows";
			command = value;
			if (data_ptr != 0 || hddfd == -1) {
				printf ("BAD READ\n");
				emu->max_instr = 0;
				break;
			}
			sector = data_latch;
			data_ptr = 0;
			//printf("\n\n\ndata_ptr=%d head=%02x cylinder=%d 0=%x 1=%x\n\n\n\n",
			//	data_ptr, head, cylinder, data_buf[0], data_buf[1]);
			hdd_read_sec(hddfd, data_buf, cylinder, head, sector);
			break;
		case 0x01 | 0x08:
			name = "Command Read Long? (517 bytes, with ECC/CRC?)";
			command = value;
			if (data_ptr != 0 || hddfd == -1) {
				printf ("BAD READ LONG\n");
				emu->max_instr = 0;
				break;
			}
			sector = data_latch;
			data_ptr = 0;
			data_buf[0] = cylinder & 0xff; // Cylinder Low
			data_buf[1] = head << 4 | cylinder >> 8; // Head<<4 | bad<<3 | cylinder hi
			data_buf[2] = sector; // Sector num


			// is offset 5 really right?
			data_buf[3] = data_buf[4] = 0;
			hdd_read_sec(hddfd, &data_buf[5], cylinder, head, sector);
			break;

		case 0x02:
			name = "Write Command. Sector number now in data buffer, data write follows";
			command = value;
			sector = data_latch;
			data_ptr = 0;
			//printf ("START AT SECTOR: %x\n", data_latch);
			break;
		case 0x04:
			name = "Command Format Sector. Sector number now in data buffer, header data write follows";
			command = value;
			sector = data_latch;
			data_ptr = 0;
			break;
		case 0x10:
			// seek to cylinder
			//printf ("SEEK TO CYLINDER: %x\n", cylinder);
			name = "Command Write, Seek to Cylinder";
			data_ptr = 0;
			if (hddfd == -1)
				break;
			stat1 |= 0x02; // seek done
			stat2 &= ~0x01; // not busy
			break;
		case 0x20:
			// if command bit 5 is on
			name = "Command Write, Select?";
			//printf ("SOME SORT OF SELECT\n");
			if (hddfd == -1)
				break;
			stat1 |= 0x01; // head/drive selected?
			break;
		case 0x80:
			// if command bit 5 is on
			//printf ("SOME SORT OF RESET\n");
			name = "Command Write, Reset?";
			stat1 = 0;
			stat2 = 0;
			cylinder = 0;
			data_ptr = 0;
			break;
		default:
			printf ("BAD COMMAND {%02x}\n", value);
			// resubmit?
			//emu->max_instr = 0;
		}
		break;

	case 0xfff8:
		name = "Unknown 0x10";
		// no idea what this is. iop idc init sets this to 10h
		if (value != 0x10) {
			printf ("BAD VAL\n");
			emu->max_instr = 0;
		}
		break;
	case 0xffe6:
		name = "Unknown 0x82 XENIX";
		// no idea what this is. iop idc init sets this to 10h
		if (value != 0x82) {
			printf ("BAD VAL\n");
			emu->max_instr = 0;
		}
		break;
	default:
		if (addr < sizeof(sbuf)) {
			name = "SRAM";
			sbuf[addr] = value;
		} else {
			name = "Bad!";
			printf ("BAD IO WRITE\n");
			emu->max_instr = 0;
		}
	};

	//if (out || addr >= 0x036e)
	xprintf ("    IOP {%s} 0x%04x <- 0x%02x (%s)\n", __func__, addr, value, name);
	//emu->max_instr = 0;
}

// altos586-v13.bin, with 8089-based hdd controller
void
hdc_iop(x86emu_t *emu, int ch)
{
	static struct i89 iop = {
		.read8	= iop_read8,
		.write8	= iop_write8,
		.in8	= iop_in8,
		.out8	= iop_out8,
	};

	static enum i89_flags flags =
		I89_CHECK |
#if 0
		I89_PRINT_INSN |
		I89_PRINT_ADDR |
		I89_PRINT_DATA |
#endif
		I89_EXEC;

	i89_attn (&iop, ch);
	while (1) {
		int ret;

		ret = i89_insn (&iop, flags);
		if (ret) {
			if (ret < 0) {
				printf("8089 Error %d\n", ret);
				x86emu_stop (emu);
			}
			break;
		}
		//i89_dump (iop);
		//if (i89_insn (&iop, flags))
		//	break;
		if (emu->max_instr == 0) {
			x86emu_stop (emu);
			break;
		}
	}
}


static void
printpb(FILE *out, unsigned tp, unsigned pb, unsigned ch_cb, unsigned ch)
{
	int i;
	unsigned char pc = 0;
	unsigned char c;

	for (i = 0; i < 0x200; i++) {
		c = x86emu_read_byte(emu, tp+i);
		fprintf (out, "%02x ", c);
		if (pc == 0x20 && c == 0x48) // hlt
			break;
		pc = c;
	}
	fprintf (out, "\n");

	fprintf (out, "CB%d.PB AT 0x%04x (%04x:%04x):\n", ch, pb,
		x86emu_read_word(emu, ch_cb + 4),
		x86emu_read_word(emu, ch_cb + 2));

	for (i = 0; i < 0x200; i++) {
		c = x86emu_read_byte(emu, pb+i);
		fprintf (out, "%02x ", c);
		if (pc == 0x20 && c == 0x48) // hlt
			break;
		pc = c;
	}
	fprintf (out, "\n");
}

static int
emueq(x86emu_t *emu, unsigned tp, const unsigned char iopp[], int size)
{
	int i;

	for (i = 0; i < size; i++) {
		if (x86emu_read_byte(emu, tp+i) != iopp[i])
			return 0;
	}
	return 1;
}

static const char unknown[] = "UNKNOWN";

static void
check_iopb (unsigned pb, int ch, int io_ch, int run)
{
	uint16_t cylinder, count, buf_off, buf_seg;
	unsigned iob_seg, iob_off, iob, out_iob;
	uint8_t reg_28h, secs, retries, unused;
	uint8_t cmd, status, drv_hd, sector;
	unsigned pb_ptr = 4 * io_ch;
	char strbuf[65535];
	const char *name;
	int strl = 0;
	int i;

	iob_off = x86emu_read_word(emu, pb + pb_ptr + 0);
	iob_seg = x86emu_read_word(emu, pb + pb_ptr + 2);
	iob = (iob_seg << 4) + iob_off;

	cmd = x86emu_read_byte(emu, iob + 0x00);
	if (cmd == 0)
		return;

	status = x86emu_read_byte(emu, iob + 0x01);
	cylinder = x86emu_read_word(emu, iob + 0x02);
	drv_hd = x86emu_read_byte(emu, iob + 0x04);
	sector = x86emu_read_byte(emu, iob + 0x05);
	count = x86emu_read_word(emu, iob + 0x06);
	buf_off = x86emu_read_word(emu, iob + 0x08);
	buf_seg = x86emu_read_word(emu, iob + 0x0a);
	reg_28h = x86emu_read_byte(emu, iob + 0x0c);
	secs = x86emu_read_byte(emu, iob + 0x0d);
	retries = x86emu_read_byte(emu, iob + 0x0e);
	unused = x86emu_read_byte(emu, iob + 0x0f);

	switch (cmd) {
	case 0x41: name = "Read"; break;
	case 0x42: name = "Write"; break;
	case 0x44: name = "Format"; break;
	case 0x49: name = "Verify"; break;
	case 0x60: name = "Enable?"; break;
	default: name = unknown;
	}

	if (0 && count >= 6) {
		printf ("   [%02x,%02x,%02x,%02x,%02x,%02x]\n",
			x86emu_read_byte(emu, (buf_seg << 4) + buf_off + 0),
			x86emu_read_byte(emu, (buf_seg << 4) + buf_off + 1),
			x86emu_read_byte(emu, (buf_seg << 4) + buf_off + 2),
			x86emu_read_byte(emu, (buf_seg << 4) + buf_off + 3),
			x86emu_read_byte(emu, (buf_seg << 4) + buf_off + 4),
			x86emu_read_byte(emu, (buf_seg << 4) + buf_off + 5));
	}

	xprintf ("CH%d IOPB%d: cmd=%02x status=%02x cylinder=%04x drv_hd=%02x sector=%02x "
		"count=%04x buf_off=%04x buf_seg=%04x "
		"reg_28h=%02x secs=%02x retries=%02x unused=%02x\n",
		ch, io_ch, cmd, status, cylinder, drv_hd, sector,
		count, buf_off, buf_seg,
		reg_28h, secs, retries, unused);

	for (i = 0; i < count && strl < sizeof(strbuf); i++) {
		strl += snprintf (&strbuf[strl], sizeof(strbuf)-strl, "%02x ",
			x86emu_read_byte(emu, (buf_seg << 4) + buf_off + i));
		if (((i+1) % 32) == 0) {
			//printf("(%d){%s}\n", i, strbuf);
			xprintf("%s\n", strbuf);
			strl = 0;
		}
	}

	xprintf(" 0x%05x 0x%02x 0x%04x CH%d Offset\n",  pb + pb_ptr + 0, pb_ptr + 0, iob_off, ch);
	xprintf(" 0x%05x 0x%02x 0x%04x CH%d Segment\n", pb + pb_ptr + 2, pb_ptr + 2, iob_seg, ch);

	xprintf("  %d  0x%05x 0x00   0x%02x Command\n", io_ch, iob + 0x00, cmd);
	xprintf("  %d  0x%05x 0x01   0x%02x Status\n", io_ch, iob + 0x01, status);
	xprintf("  %d  0x%05x 0x02 0x%04x Cylinder\n", io_ch, iob + 0x02, cylinder);
	xprintf("  %d  0x%05x 0x04   0x%02x Drive | Head\n", io_ch, iob + 0x04, drv_hd);
	xprintf("  %d  0x%05x 0x05   0x%02x Sector\n", io_ch, iob + 0x05, sector);
	xprintf("  %d  0x%05x 0x06 0x%04x Count\n", io_ch, iob + 0x06, count);
	xprintf("  %d  0x%05x 0x08 0x%04x Buffer Offset\n", io_ch, iob + 0x08, buf_off);
	xprintf("  %d  0x%05x 0x0a 0x%04x Buffer Segment\n", io_ch, iob + 0x0a, buf_seg);
	xprintf("  %d  0x%05x 0x0c   0x%02x Unused\n", io_ch, iob + 0x0c, reg_28h);
	xprintf("  %d  0x%05x 0x0d   0x%02x Num Sectors\n", io_ch, iob + 0x0d, secs);
	xprintf("  %d  0x%05x 0x0e   0x%02x Unknown (Zero)\n", io_ch, iob + 0x0e, retries);
	xprintf("  %d  0x%05x 0x0f   0x%02x Unused\n", io_ch, iob + 0x0f, unused);
	xprintf("  %d  0x%05x 0x10   0x%02x Unknown (5d)\n", io_ch, iob + 0x10, x86emu_read_byte(emu, iob + 0x10));
	xprintf("  %d  0x%05x 0x11   0x%02x Unused\n", io_ch, iob + 0x11, x86emu_read_byte(emu, iob + 0x11));

	if (name == unknown)
		x86emu_stop (emu);

	if (!run)
		return;

	retries = 2;

	switch (cmd) {
	case 0x41:
		// Read
		hdd_read(emu, (buf_seg << 4) + buf_off, drv_hd & 0x0f, cylinder, sector, count);
		status = 0x00;
		break;
	case 0x42:
		// Write
		hdd_write(emu, (buf_seg << 4) + buf_off, drv_hd & 0x0f, cylinder, sector, count);
		status = 0x00;
		break;
	case 0x44:
		// Format
		status = 0x00;
		break;
	case 0x49:
		// Read Long
		x86emu_write_byte(emu, (buf_seg << 4) + buf_off + 0, cylinder & 0xff); // Cylinder Low
		x86emu_write_byte(emu, (buf_seg << 4) + buf_off + 1, (drv_hd & 0x0f) << 4 | cylinder >> 8); // Head<<4 | bad<<3 | cylinder hi
		x86emu_write_byte(emu, (buf_seg << 4) + buf_off + 2, sector); // Sector num
		x86emu_write_byte(emu, (buf_seg << 4) + buf_off + 3, 0x00);
		x86emu_write_byte(emu, (buf_seg << 4) + buf_off + 4, 0x00);
		hdd_read(emu, (buf_seg << 4) + buf_off + 5, drv_hd & 0x0f, cylinder, sector, count);
		status = 0x00;
		break;
	case 0x60:
		// Enable?
		status = 0x00;
		break;
	}

	out_iob = ((x86emu_read_word(emu, pb + 4 * (io_ch+2) + 2)) << 4) +
		x86emu_read_word(emu, pb + 4 * (io_ch+2) + 0);

	x86emu_write_byte(emu, out_iob + 0x00, cmd);
	x86emu_write_byte(emu, out_iob + 0x01, status);
	x86emu_write_word(emu, out_iob + 0x02, cylinder);
	x86emu_write_byte(emu, out_iob + 0x04, drv_hd);
	x86emu_write_byte(emu, out_iob + 0x05, sector);
	x86emu_write_word(emu, out_iob + 0x06, count);
	x86emu_write_word(emu, out_iob + 0x08, buf_off);
	x86emu_write_word(emu, out_iob + 0x0a, buf_seg);
	x86emu_write_byte(emu, out_iob + 0x0c, reg_28h);
	x86emu_write_byte(emu, out_iob + 0x0d, secs);
	x86emu_write_byte(emu, out_iob + 0x0e, retries);
	x86emu_write_byte(emu, out_iob + 0x0f, unused);
}


static void
check_iop(x86emu_t *emu, int ch, unsigned ch_cb, unsigned pb, unsigned ccw, int io_ch, int run)
{
	static int idc_loaded = 0;
	unsigned tp;

	switch (ccw & 7) {
	case 0: // do not start this channel
		break;
	case 1: // start channel from iop memory
		xprintf("Disk I/O Parameter block:\n");
		xprintf(" 0x%05x 0x00 0x%04x Offset\n", pb + 0x00, x86emu_read_word(emu, pb + 0x00));
		xprintf(" 0x%05x 0x02 0x%04x Segment\n", pb + 0x02, x86emu_read_word(emu, pb + 0x02));

		if (run) {
			if (!idc_loaded) {
				printf("IDC NOT LOADED\n");
				xprintf("IDC NOT LOADED\n");
				x86emu_stop (emu);
				break;
			}
			x86emu_write_byte(emu, ch_cb + 1, 0); // Mark channel not busy
		}
		check_iopb (pb, ch, io_ch, run);

		break;
	case 3: // start channel from main memory
		tp = x86emu_read_word(emu, pb + 2) << 4;
		tp += x86emu_read_word(emu, pb);
		xprintf ("CB%d.PB.TP = 0x%04x (%04x:%04x)\n", ch, tp,
			x86emu_read_word(emu, pb + 2),
			x86emu_read_word(emu, pb));

		if (emueq(emu, tp, iop_fw, sizeof(iop_fw))) {
			unsigned cmd, data, head, cylinder, sector, count;

			cmd = x86emu_read_byte(emu, pb + 0x04);

			data = x86emu_read_word(emu, pb + 0x0e) << 4;
			data += x86emu_read_word(emu, pb + 0xc);

			head = x86emu_read_byte(emu, pb + 0x08) & 0x0f;
			cylinder = x86emu_read_word(emu, pb + 0x06);
			sector = x86emu_read_byte(emu, pb + 0x09);
			count = x86emu_read_byte(emu, pb + 0x10);

			xprintf("Disk I/O Parameter block:\n");
			xprintf(" 0x%05x 0x00 0x%04x Offset\n", pb + 0x00, x86emu_read_word(emu, pb + 0x00));
			xprintf(" 0x%05x 0x02 0x%04x Segment\n", pb + 0x02, x86emu_read_word(emu, pb + 0x02));
			xprintf(" 0x%05x 0x04   0x%02x Opcode\n", pb + 0x04, cmd);
			xprintf(" 0x%05x 0x05   0x%02x Status\n", pb + 0x05, x86emu_read_byte(emu, pb + 0x05));
			xprintf(" 0x%05x 0x06 0x%04x Cylinder\n", pb + 0x06, cylinder);
			xprintf(" 0x%05x 0x08   0x%02x Drive and head\n", pb + 0x08, x86emu_read_byte(emu, pb + 0x08));
			xprintf(" 0x%05x 0x09   0x%02x Start sector\n", pb + 0x09, sector);
			xprintf(" 0x%05x 0x0a 0x%04x Byte count\n", pb + 0x0a, x86emu_read_word(emu, pb + 0x0a));
			xprintf(" 0x%05x 0x0c 0x%04x Buffer Offset\n", pb + 0x0c, x86emu_read_word(emu, pb + 0x0c));
			xprintf(" 0x%05x 0x0e 0x%04x Buffer Segment\n", pb + 0x0e, x86emu_read_word(emu, pb + 0x0e));
			xprintf(" 0x%05x 0x10   0x%02x Sector count\n", pb + 0x10, count);
			xprintf(" 0x%05x 0x11   0x%02x Reserved\n", pb + 0x11, x86emu_read_byte(emu, pb + 0x11));
			xprintf(" 0x%05x 0x12 0x%04x Reserved\n", pb + 0x12, x86emu_read_word(emu, pb + 0x12));
			xprintf(" 0x%05x 0x14 0x%04x Reserved\n", pb + 0x14, x86emu_read_word(emu, pb + 0x14));
			xprintf(" 0x%05x 0x16 0x%04x IN/OUT (Link Register)\n", pb + 0x16, x86emu_read_word(emu, pb + 0x16));

			if (run) {
				x86emu_write_byte(emu, ch_cb + 1, 0); // Mark channel not busy
				switch (cmd) {
				case 0x00:
					x86emu_write_byte(emu, pb + 0x05, 0x00); // io status
					break;
				case 0x21:
					hdd_read(emu, data, head, cylinder, sector, count);
					x86emu_write_byte(emu, pb + 0x05, 0x00); // io status
					x86emu_write_byte(emu, pb + 0x14, x86emu_read_word(emu, pb + 0x06));
					break;
				default:
					printf("HD COMMAND %02x\n", cmd);
					x86emu_stop (emu);
				}
			}
		} else if (emueq(emu, tp, iop_xenix, sizeof(iop_xenix))) {
			printf("XENIX IOP IO\n");
			xprintf("XENIX IOP IO\n");
			printpb(stdout, tp, pb, ch_cb, ch);
			if (run)
				x86emu_stop (emu);
		} else if (emueq(emu, tp, iop_hdtest_1, sizeof(iop_hdtest_1))) {
			xprintf("HD TEST IOP IO 1\n");
			//printpb(stdout, tp, pb, ch_cb, ch);
			if (run) {
				idc_loaded = 1;
				x86emu_write_byte(emu, ch_cb + 1, 0); // Mark channel not busy
			}
		} else if (tp == 0x20000) {
			// Use this for debugging the emulator
			xprintf ("UNKNOWN 8089 CB%d.PB.TP AT 0x%04x (%04x:%04x):\n", ch, tp,
				x86emu_read_word(emu, pb + 2),
				x86emu_read_word(emu, pb));
			//printpb(stderr, tp, pb, ch_cb, ch);
			if (run)
				x86emu_stop (emu);
		} else {
			printf ("UNKNOWN 8089 CB%d.PB.TP AT 0x%04x (%04x:%04x):\n", ch, tp,
				x86emu_read_word(emu, pb + 2),
				x86emu_read_word(emu, pb));
			printpb(stdout, tp, pb, ch_cb, ch);
			if (run)
				x86emu_stop (emu);
		}
		break;
	case 7: // halt channel
		break;
	default:
		printf("UNHANDLED CCW\n");
		xprintf("UNHANDLED CCW\n");
		x86emu_stop (emu);
	}

}

static void
ch_attn(x86emu_t *emu, unsigned ch_cb, int ch)
{
	unsigned pb, ccw;

	ccw = x86emu_read_byte(emu, ch_cb + 0);
	pb = x86emu_read_word(emu, ch_cb + 4) << 4;
	pb += x86emu_read_word(emu, ch_cb + 2);
	xprintf ("CB%d.CCW = 0x%02x\n", ch, ccw);
	xprintf ("CB%d.BUSY = 0x%02x\n", ch, x86emu_read_byte(emu, ch_cb + 1));
	xprintf ("CB%d.PB = 0x%04x (%04x:%04x)\n", ch, pb,
		x86emu_read_word(emu, ch_cb + 4),
		x86emu_read_word(emu, ch_cb + 2));

	xprintf("=== PB Before IOP:\n");
	if (WITH_LIB8089) {
		check_iop(emu, ch, ch_cb, pb, ccw, 1, 0);
		check_iop(emu, ch, ch_cb, pb, ccw, 2, 0);
		hdc_iop(emu, ch-1);
	} else {
		check_iop(emu, ch, ch_cb, pb, ccw, 1, 1);
		check_iop(emu, ch, ch_cb, pb, ccw, 2, 1);
	}
	xprintf("=== PB After IOP:\n");
	check_iop(emu, ch, ch_cb, pb, ccw, 2, 0);
	check_iop(emu, ch, ch_cb, pb, ccw, 3, 0);
	xprintf("=== PB End.\n");
}


// altos586-v13.bin, with 8089-based hdd controller
void
iopattn(x86emu_t *emu)
{
	unsigned scb, cb;

//out=stdout;
	scb = x86emu_read_word(emu, 0xffffa) << 4;
	scb += x86emu_read_word(emu, 0xffff8);
	xprintf ("==== IO ATTENTION 8089 ==== Bus width = 0x%02x\n", x86emu_read_byte(emu, 0xffff6));

	xprintf ("SCB = 0x%04x (%04x:%04x)\n", scb,
		x86emu_read_word(emu, 0xffffa),
		x86emu_read_word(emu, 0xffff8));
	xprintf ("\n");

	cb = x86emu_read_word(emu, scb + 4) << 4;
	cb += x86emu_read_word(emu, scb + 2);
	xprintf ("SCB.SOC = 0x%02x\n", x86emu_read_byte(emu, scb));
	xprintf ("SCB.CB = 0x%04x (%04x:%04x)\n", cb,
		x86emu_read_word(emu, scb + 4),
		x86emu_read_word(emu, scb + 2));
	xprintf ("\n");

	ch_attn(emu, cb + 0, 1);
	//ch_attn(emu, cb + 8, 2);
//out=NULL;
}
