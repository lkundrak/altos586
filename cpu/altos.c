// SPDX-License-Identifier: GPL-2.0-or-later

#include <sys/stat.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <poll.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <x86emu.h>

struct termios *orig_tio = NULL;
x86emu_memio_handler_t orig_memio = NULL;
x86emu_t *emu;
int warm = 0;
int term = 0;
int hddfd = -1;
int fddfd = -1;
unsigned romstart = 0;

// 9 sectors/track
unsigned char bootcode[512] = {
			/*  1			.code16		*/
0xeb,0x08,		/*  2 0000 EB08			jmp 1f	*/
			/*  3					*/
0x00,			// appears ignoredA

0x00,0x30,		// 0x03 -- load segment 3000:0

0x00,0x00,0x00,0x00,	// appears ignored

0x02,			// 0x09 -- type 0 CPM86 sector sector 512
			//         type 1 OASIS seems the same sector 256
			//         type 2 XENIX load one more sector sector 512

//0x02,			// 0x09 -- type 2, load one more sector
			/*  5 0009 02		.byte 0x02	*/
			/*  6					*/
			/*  7			1:		*/
0xcc,			/*  8 000a CC			int $3	*/
0xeb,0xfd,		/*  9 000b EBFD			jmp 1b	*/
			/* 10 000d 00000000	. = 0x200	*/
};

static void
flush_log (x86emu_t *emu, char *buf, unsigned size)
{
	if (!buf || !size) return;

	fwrite (buf, size, 1, stderr);
	fflush (stderr);
}

FILE *out = NULL;
#define xprintf(...) do { \
		if (out) { \
			fprintf(out, "EMU: " __VA_ARGS__); \
			fflush (out); \
		} \
		x86emu_log(emu, "EMU: " __VA_ARGS__); \
	} while(0)
//#define xprintf(...) printf(__VA_ARGS__)

static void
iopattn(x86emu_t *emu)
{
	unsigned scb, cb, pb1, pb2, tp1, tp2;
	//unsigned ptr = 0xffff6;

	scb = x86emu_read_word(emu, 0xffffa) << 4;
	scb |= x86emu_read_word(emu, 0xffff8);
	xprintf ("==== IO ATTENTION 8089 ==== Bus width = 0x%02x\n", x86emu_read_byte(emu, 0xffff6));

	xprintf ("SCB = 0x%04x (%04x:%04x)\n", scb,
		x86emu_read_word(emu, 0xffffa),
		x86emu_read_word(emu, 0xffff8));
	xprintf ("\n");

	cb = x86emu_read_word(emu, scb + 4) << 4;
	cb |= x86emu_read_word(emu, scb + 2);
	xprintf ("SCB.SOC = 0x%02x\n", x86emu_read_byte(emu, scb));
	xprintf ("SCB.CB = 0x%04x (%04x:%04x)\n", cb,
		x86emu_read_word(emu, scb + 4),
		x86emu_read_word(emu, scb + 2));
	xprintf ("\n");

	//cb = x86emu_read_word(emu, cb);

	pb1 = x86emu_read_word(emu, cb + 0 + 4) << 4;
	pb1 |= x86emu_read_word(emu, cb + 0 + 2);
	xprintf ("CB1.CCW = 0x%02x\n", x86emu_read_byte(emu, cb + 0 + 0));
	xprintf ("CB1.BUSY = 0x%02x\n", x86emu_read_byte(emu, cb + 0 + 1));
	xprintf ("CB1.PB = 0x%04x (%04x:%04x)\n", pb1,
		x86emu_read_word(emu, cb + 0 + 4),
		x86emu_read_word(emu, cb + 0 + 2));

	if (pb1) {
		tp1 = x86emu_read_word(emu, pb1 + 2) << 4;
		tp1 |= x86emu_read_word(emu, pb1);
		xprintf ("CB1.PB.TP = 0x%04x (%04x:%04x)\n", tp1,
			x86emu_read_word(emu, pb1 + 2),
			x86emu_read_word(emu, pb1));
		if (tp1 == 0xff268 || tp1 == 0xffeba) {
			unsigned pp = pb1;

			if (tp1 == 0xff268)
				xprintf("fc00:3268 Parameter block:\n");
			if (tp1 == 0xffeba)
				xprintf("fe00:1eba Parameter block:\n");

			xprintf(" 0x%05x 0x00 0x%04x Offset\n", pp + 0x00, x86emu_read_word(emu, pp + 0x00));
			xprintf(" 0x%05x 0x02 0x%04x Segment\n", pp + 0x02, x86emu_read_word(emu, pp + 0x02));
			xprintf(" 0x%05x 0x04   0x%02x IN/OUT (Command?)\n", pp + 0x04, x86emu_read_byte(emu, pp + 0x04));
			xprintf(" 0x%05x 0x05   0x%02x OUT  (Return status)\n", pp + 0x05, x86emu_read_byte(emu, pp + 0x05));
			xprintf(" 0x%05x 0x06   0x%02x IN\n", pp + 0x06, x86emu_read_byte(emu, pp + 0x06));
			xprintf(" 0x%05x 0x07   0x%02x IN\n", pp + 0x07, x86emu_read_byte(emu, pp + 0x07));
			xprintf(" 0x%05x 0x08   0x%02x IN\n", pp + 0x08, x86emu_read_byte(emu, pp + 0x08));
			xprintf(" 0x%05x 0x09   0x%02x IN/OUT\n", pp + 0x09, x86emu_read_byte(emu, pp + 0x09));
			xprintf(" 0x%05x 0x0a 0x%04x IN  (Byte count)\n", pp + 0x0a, x86emu_read_word(emu, pp + 0x0a));
			xprintf(" 0x%05x 0x0c 0x%04x IN\n", pp + 0x0c, x86emu_read_word(emu, pp + 0x0c));
			xprintf(" 0x%05x 0x0e 0x%04x UNUSED\n", pp + 0x0e, x86emu_read_word(emu, pp + 0x0e));
			xprintf(" 0x%05x 0x10 0x%04x IN/OUT (Some countdown)\n", pp + 0x10, x86emu_read_word(emu, pp + 0x10));
			xprintf(" 0x%05x 0x12 0x%04x IN/OUT (Byte count?)\n", pp + 0x12, x86emu_read_word(emu, pp + 0x12));
			xprintf(" 0x%05x 0x14   0x%02x IN/OUT\n", pp + 0x14, x86emu_read_byte(emu, pp + 0x14));
			xprintf(" 0x%05x 0x15   0x%02x IN\n", pp + 0x15, x86emu_read_byte(emu, pp + 0x15));
			xprintf(" 0x%05x 0x16 0x%04x IN/OUT (Link Register)\n", pp + 0x16, x86emu_read_word(emu, pp + 0x16));

			x86emu_write_byte(emu, cb + 0 + 1, 0); // Mark channel not busy

			// io status
			//x86emu_write_byte(emu, pp + 0x05, 0x00);
		}
	}

	xprintf ("\n");



	pb2 = x86emu_read_word(emu, cb + 8 + 4) << 4;
	pb2 |= x86emu_read_word(emu, cb + 8 + 2);
	xprintf ("CB2.CCW = 0x%02x\n", x86emu_read_byte(emu, cb + 8 + 0));
	xprintf ("CB2.BUSY = 0x%02x\n", x86emu_read_byte(emu, cb + 8 + 1));
	xprintf ("CB2.PB = 0x%04x (%04x:%04x)\n", pb2,
		x86emu_read_word(emu, cb + 8 + 4),
		x86emu_read_word(emu, cb + 8 + 2));
	if (pb2) {
		tp2 = x86emu_read_word(emu, pb2 + 2) << 4;
		tp2 |= x86emu_read_word(emu, pb2);
		xprintf ("CB2.PB.TP = 0x%04x (%04x:%04x)\n", tp2,
			x86emu_read_word(emu, pb2 + 2),
			x86emu_read_word(emu, pb2));
	}

	xprintf ("\n");

	//x86emu_stop (emu);
	//exit(0);
}






static void
hddread(x86emu_t *emu, unsigned data,
	unsigned head, unsigned track, unsigned sector, unsigned count)
{
	static const unsigned secs = 9;
	int tb, lba, len;
	unsigned char c;
	int i;

	if (track != 0 || head != 0)
		return;

	tb = (track * 2 + head) * secs;
	lba = ((tb + sector) << 9);
	len = count * 512;

	xprintf ("  LBA=%d LEN=%d\n", lba, len);	

	if (hddfd == -1) {
		for (i = 0; i < sizeof(bootcode); i++)
			x86emu_write_byte (emu, data + i, bootcode[i]);
		return;
	}

	if (lseek(hddfd, lba, SEEK_SET) == -1) {
		perror("SEEK_SET");
		return;
	}

	for (i = 0; i < len; i++) {
		switch (read(hddfd, &c, 1)) {
		case 0: // EOF
			fprintf(stderr, "HDD: Short read\n");
			return;
		case -1:
			perror("read");
			return;
		default:
			x86emu_write_byte (emu, data + i, c);
		}
	}
}

static void
cpuint1_hdd(x86emu_t *emu)
{
	unsigned track, head, sector, count;
	unsigned ptr, data, cmd;

	xprintf("============== CPUINT1 HDD =========\n");

	ptr = x86emu_read_word(emu, 0x402) << 16;
	ptr |= x86emu_read_word(emu, 0x400);

	cmd = x86emu_read_byte(emu, ptr + 0);

	head = x86emu_read_byte(emu, ptr + 6) & 0x1f;
	track = x86emu_read_word(emu, ptr + 2);
	sector = x86emu_read_byte(emu, ptr + 4);

	count = x86emu_read_byte(emu, ptr + 5);

	data = x86emu_read_word(emu, ptr + 11) << 4;
	data |= x86emu_read_word(emu, ptr + 9);


	xprintf ("   0 0x%04x   0x%02x COMMAND\n", ptr + 0, x86emu_read_byte(emu, ptr + 0));
	xprintf ("   1 0x%04x   0x%02x BUSY\n", ptr + 1, x86emu_read_byte(emu, ptr + 1));

	xprintf ("   2 0x%04x 0x%04x TRACK\n", ptr + 2, x86emu_read_word(emu, ptr + 2));


	xprintf ("   4 0x%04x   0x%02x SECTOR\n", ptr + 4, x86emu_read_byte(emu, ptr + 4));
	xprintf ("   5 0x%04x   0x%02x SECTOR COUNT\n", ptr + 5, x86emu_read_byte(emu, ptr + 5));
	xprintf ("   6 0x%04x      %d DRIVE\n", ptr + 6, x86emu_read_byte(emu, ptr + 6) >> 5);
	xprintf ("   6 0x%04x   0x%02x HEAD\n", ptr + 6, x86emu_read_byte(emu, ptr + 6) & 0x1f);


	xprintf ("   9 0x%04x 0x%04x OFFSET\n", ptr + 9, x86emu_read_word(emu, ptr + 9));
	xprintf ("  11 0x%04x 0x%04x SEGMENT\n", ptr + 11, x86emu_read_word(emu, ptr + 11));
	xprintf ("  13 0x%04x   0x%02x STATUS\n", ptr + 13, x86emu_read_byte(emu, ptr + 13));


        // IOPB[4=opcode]  cmd   retries            args cmd
        // -               90                       0    init
        // 01,21           2c    from mon                addr, ...
        // 02              34    IOPB[0d=retries]   "
        // 03              50    IOPB[0d=retries]   "
        // 20              10    IOPB[0d=retries]   "

	cmd = x86emu_read_byte(emu, ptr + 0);
	switch (cmd) {
	case 0x90:
		// on boot. no argument, except ptr+13=0xff (status)
		x86emu_write_byte (emu, ptr + 13, 0x00);
		break;
	case 0x2c:
		//x86emu_write_byte (emu, ptr + 13, 0xee); //Boot Failed, Status=EE*
		xprintf ("HDD READ DMAADR=0x%05x HEAD=%d TRACK=%d START=%d COUNT=%d TO=0x%05x\n",
			data, head, track, sector, count, data);
		hddread(emu, data, head, track, sector, count);
		x86emu_write_byte (emu, ptr + 13, 0x0); // sukces
		break;
	default:
		x86emu_stop (emu);
	}

	/* Raise IR2 */
	x86emu_intr_raise(emu, 32 + 2, INTR_TYPE_SOFT, 0);
	//x86emu_stop (emu);
}


static void
fddread(x86emu_t *emu, unsigned data, unsigned secsize,
	unsigned head, unsigned track, unsigned start, unsigned end)
{
	static const unsigned secs = 9;
	int tb, lba, len;
	unsigned char c;
	int i;

	tb = (track * 2 + head) * secs;
	lba = (tb + (start - 1))*secsize;
	len = (tb + end)*secsize - lba;

	xprintf ("FDD READ LBA=0x%05x LEN=%d | HEAD=%d TRACK=%d START=%d END=%d SEC=%d TO=0x%05x\n",
		lba, len, head, track, start, end, secsize, data);

	if (fddfd == -1) {
		for (i = 0; i < sizeof(bootcode); i++)
			x86emu_write_byte (emu, data + i, bootcode[i]);
		return;
	}

	if (lseek(fddfd, lba, SEEK_SET) == -1) {
		perror("SEEK_SET");
		return;
	}

	for (i = 0; i < len; i++) {
		switch (read(fddfd, &c, 1)) {
		case 0: // EOF
			fprintf(stderr, "FDD: Short read\n");
			return;
		case -1:
			perror("read");
			return;
		default:
			x86emu_write_byte (emu, data + i, c);
		}
	}
}

// FLOPPY
static void
cpuint2_floppy(x86emu_t *emu)
{
	unsigned ptr, data, cmd;
	unsigned track, head, start, end, secsize;

	ptr = x86emu_read_word(emu, 0x406) << 4;
	ptr |= x86emu_read_word(emu, 0x404);

	cmd = x86emu_read_byte(emu, ptr + 0);

	track = x86emu_read_byte(emu, ptr + 2);
	head = x86emu_read_byte(emu, ptr + 3);
	start = x86emu_read_byte(emu, ptr + 4);
	secsize = x86emu_read_byte(emu, ptr + 5);
	end = x86emu_read_byte(emu, ptr + 6);

	data = x86emu_read_word(emu, ptr + 11) << 4;
	data |= x86emu_read_word(emu, ptr + 9);

	xprintf("============== CPUINT2 FLOPPY =========\n");
	xprintf ("   0 0x%04x 0x%02x COMMAND\n", ptr + 0, x86emu_read_byte(emu, ptr + 0));
	xprintf ("   1 0x%04x 0x%02x BUSY?\n", ptr + 1, x86emu_read_byte(emu, ptr + 1));
	xprintf ("   2 0x%04x 0x%02x TRACK? (0-5)\n", ptr + 2, x86emu_read_byte(emu, ptr + 2));
	xprintf ("   3 0x%04x 0x%02x HEAD? (0,1)\n", ptr + 3, x86emu_read_byte(emu, ptr + 3));
	xprintf ("   4 0x%04x 0x%02x START SECTOR (01,02)\n", ptr + 4, x86emu_read_byte(emu, ptr + 4));    // start sector?
	xprintf ("   5 0x%04x 0x%02x SECTOR SIZE/256 (02)\n", ptr + 5, x86emu_read_byte(emu, ptr + 5));       // sector size / 256
	xprintf ("   6 0x%04x 0x%02x END SECTOR (01,03,09)\n", ptr + 6, x86emu_read_byte(emu, ptr + 6)); // end sector?
	xprintf ("   7 0x%04x 0x%02x  unk always? 50 matters not\n", ptr + 7, x86emu_read_byte(emu, ptr + 7));
	xprintf ("   8 0x%04x 0x%02x  unk always? ff matters not\n", ptr + 8, x86emu_read_byte(emu, ptr + 8));
	xprintf ("   9 0x%04x 0x%04x OFFSET\n", ptr + 9, x86emu_read_word(emu, ptr + 9));
	xprintf ("  11 0x%04x 0x%04x SEGMENT\n", ptr + 11, x86emu_read_word(emu, ptr + 11));
	xprintf ("  12 0x%04x 0x%02x  unk? 0x00, 0x30, 0x50, 0x60-0x67\n", ptr + 12, x86emu_read_byte(emu, ptr + 12));
	xprintf ("  13 0x%04x 0x%02x STATUS\n", ptr + 13, x86emu_read_byte(emu, ptr + 13));
	xprintf ("  14 0x%04x 0x%02x  unk zero\n", ptr + 14, x86emu_read_byte(emu, ptr + 14));
	xprintf ("  15 0x%04x 0x%02x  unk zero\n", ptr + 15, x86emu_read_byte(emu, ptr + 15));

	// IOPB[4] - cmd
	// 1x	   - 0f
	// 2x	   - 46 read?
	// 3x	   - 45
	// 6x	   - 4d
	// f0 ^mask

	switch (cmd) {
	case 0x46:
		if (data) {
			fddread(emu, data, 256*secsize, head, track, start, end);
			//Boot Failed, Status=EE*
			//x86emu_write_byte (emu, ptr + 13, 0xee);
			x86emu_write_byte (emu, ptr + 13, 0x00); // status 0=good
			x86emu_write_byte (emu, ptr + 1, 0x00); // 80 (timeout) -> 0
		}
		break;
	default:
		x86emu_write_byte (emu, ptr + 13, 0x00); // status
		x86emu_write_byte (emu, ptr + 1, 0x00); // 80 (timeout) -> 0
		x86emu_stop (emu);
	}

	xprintf ("\n");


	/* Raise IR7 */
	x86emu_intr_raise(emu, 32 + 7, INTR_TYPE_SOFT, 0);
}

unsigned pnewcmd = 0;

static unsigned
pcmd1(x86emu_t *emu, unsigned ptr, int printonly, const char *name)
{
	unsigned cmd = x86emu_read_byte(emu, ptr + 1);
	unsigned stat = x86emu_read_byte(emu, ptr + 2);

	/* Busy bit not on */
	if (!printonly && (cmd & 0x80) == 0)
		goto out;

	xprintf ("[%s] {0x%04x}\n", name, ptr);
	xprintf ("   0 0x%04x   0x%02x Firmware Version Register\n",	ptr + 0, x86emu_read_byte(emu, ptr + 0));
	xprintf ("   1 0x%04x   0x%02x System Command Register\n",	ptr + 1, cmd);
	xprintf ("   2 0x%04x   0x%02x System Status Register\n",	ptr + 2, stat);
	xprintf ("   3 0x%04x 0x%04x Interrupt Vector Register\n",	ptr + 3, x86emu_read_word(emu, ptr + 3));
	xprintf ("   5 0x%04x   0x%02x New Command Register\n",		ptr + 5, x86emu_read_byte(emu, ptr + 5));

	if (printonly)
		goto out;

	switch (cmd & 0x7f) {
	case 0:
		printf ("(Command %d) DISABLE CONTROLLER\n", cmd & 0x0f);
		stat &= ~1;
		x86emu_write_byte(emu, ptr + 2, stat);
		x86emu_stop (emu);
		break;
	case 1:
		xprintf ("(Command %d) ENABLE CONTROLLER\n", cmd & 0x0f);
		stat |= 1;
		x86emu_write_byte(emu, ptr + 2, stat);
		break;
	case 2:
		printf ("(Command %d) DISABLE INTERRUPTS\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 3:
		printf ("(Command %d) ENABLE INTERRUPTS\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 4:
		printf ("(Command %d) RESET INTERRUPT\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	default:
		printf ("BAD COMMAND (%d)\n", cmd & 0x0f);
		x86emu_stop (emu);
	}

	// ack the command
	x86emu_write_byte(emu, ptr + 1, cmd & 0x7f);

	xprintf ("\n");
out:
	return 6;
}

static void
trytx (x86emu_t *emu, unsigned ptr)
{
	unsigned txbuf;
	unsigned char len;
	char c;
	int i;

	txbuf = x86emu_read_word(emu, ptr + 5);
	txbuf |= x86emu_read_byte(emu, ptr + 7) << 16;
	len = x86emu_read_byte(emu, ptr + 8);
	x86emu_write_byte(emu, ptr + 8, 0);

	if (len == 0)
		return;

	xprintf("TX: {len=%d, buf=0x%x}\n", len, txbuf);

	fprintf(stderr, "EMU: OUT: {len=%d, buf=0x%x}", len, txbuf);
	for (i = 0; i < len; i++) {
		c = x86emu_read_byte (emu, txbuf + i);
		if (c != '\r') {
			putchar(c);
			emu->max_instr += 10000;
		}
		fprintf (stderr, "{%02x} ", c);
	}
	fprintf (stderr, "| ");
	for (i = 0; i < len; i++) {
		c = x86emu_read_byte (emu, txbuf + i);
		putc (isalnum(c) ? c : '.', stderr);
	}
	fprintf(stderr, "\n");
	fflush(stderr);
	fflush(stdout);
}

static unsigned
pchcmd(x86emu_t *emu, unsigned ptr, int printonly, const char *name)
{
	unsigned parms = x86emu_read_byte(emu, ptr + 0);
	unsigned cmd = x86emu_read_byte(emu, ptr + 4);

	/* Busy bit not on */
	if (!printonly && (cmd & 0x80) == 0)
		goto out;

	xprintf ("[%s] {0x%04x}\n", name, ptr);
	xprintf ("    0 0x%04x   0x%04x Channel Parameter Register\n",			ptr + 0, parms);
	xprintf ("    2 0x%04x   0x%04x Channel Status Register\n",			ptr + 2, x86emu_read_word(emu, ptr + 2));
	xprintf ("    4 0x%04x     0x%02x Channel Command Register\n",			ptr + 4, cmd);
	xprintf ("    5 0x%04x 0x%02x%02x%02x Transmit Data Buffer Address Register\n",	ptr + 5,
		x86emu_read_byte(emu, ptr + 7),
		x86emu_read_byte(emu, ptr + 6),
		x86emu_read_byte(emu, ptr + 5));
	xprintf ("    8 0x%04x   0x%04x Transmit Data Buffer Length Register\n",	ptr + 8, x86emu_read_word(emu, ptr + 8));

	if (parms & 0x0080) {
		xprintf ("   10 0x%04x 0x%02x%02x%02x Receive Data Buffer Address Register\n",	ptr + 10,
			x86emu_read_byte(emu, ptr + 12),
			x86emu_read_byte(emu, ptr + 11),
			x86emu_read_byte(emu, ptr + 10));
		xprintf ("   13 0x%04x   0x%04x Receive Data Buffer Length Register\n",		ptr + 13, x86emu_read_word(emu, ptr + 13));
		xprintf ("   15 0x%04x   0x%04x Receive Buffer Input Pointer Register\n",	ptr + 15, x86emu_read_word(emu, ptr + 15));
		xprintf ("   17 0x%04x   0x%04x Receive Buffer Output Pointer Register\n",	ptr + 17, x86emu_read_word(emu, ptr + 17));
	} else {
		xprintf ("   10 0x%04x   0x%04x Unused\n",					ptr + 10, x86emu_read_word(emu, ptr + 10));
		xprintf ("   12 0x%04x   0x%04x Unused\n",					ptr + 12, x86emu_read_word(emu, ptr + 12));
		xprintf ("   14 0x%04x   0x%04x Unused\n",					ptr + 14, x86emu_read_word(emu, ptr + 14));
		xprintf ("   16 0x%04x   0x%04x Unused\n",					ptr + 16, x86emu_read_word(emu, ptr + 16));
		xprintf ("   18 0x%04x     0x%02x TTY Receive Register\n",			ptr + 18, x86emu_read_byte(emu, ptr + 18));
	}

	xprintf ("   19 0x%04x   0x%04x Selectable Rate Register\n",			ptr + 19, x86emu_read_word(emu, ptr + 19));
	xprintf ("   21 0x%04x     0x%02x Reserved\n",					ptr + 21, x86emu_read_byte(emu, ptr + 21));

	if (cmd & 0x80) xprintf ("0x80 command valid\n");
	if (cmd & 0x40) xprintf ("0x40 transmit interrupt enable\n");
	if (cmd & 0x20) xprintf ("0x20 receive interrupt enable\n");
	if (cmd & 0x10) xprintf ("0x10 modem interrupt enable\n");

	if (printonly)
		goto out;

	switch (cmd & 0x7f) {
	case 0: xprintf ("(Command %d) no operation\n", cmd & 0x0f); break;
	case 1:
		xprintf ("(Command %d) initialize channel\n", cmd & 0x0f);
		//x86emu_write_word(emu, ptr + 2, 0x100a);
		//x86emu_write_word(emu, ptr + 2, 0x110b);
		x86emu_write_word(emu, ptr + 2, 0x100b);
		break;
	case 2:
		xprintf ("(Command %d) start transmitter\n", cmd & 0x0f);
		break;
	case 3:
		xprintf ("(Command %d) acknowledge receiver\n", cmd & 0x0f);
		x86emu_write_word(emu, ptr + 2, 0x100b);
		//x86emu_stop (emu);
		break;
	case 4:
		printf ("(Command %d) abort transmitter\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 5:
		printf ("(Command %d) reserved\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 6:
		printf ("(Command %d) 'Break' control\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 7:
		printf ("(Command %d) network control\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 8:
		printf ("(Command %d) change parameters\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 9:
		printf ("(Command %d) reset error conditions\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 10:
		printf ("(Command %d) reset modem interrupt request\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	case 11:
		printf ("(Command %d) execute from MultiBus\n", cmd & 0x0f);
		x86emu_stop (emu);
		break;
	default:
		printf ("BAD COMMAND (%d)\n", cmd & 0x0f);
		x86emu_stop (emu);
	}

	trytx(emu, ptr);

	// ack the command
	x86emu_write_byte(emu, ptr + 4, cmd & 0x7f);

	xprintf ("\n");
out:
	return 22;
}

static int
fcmd(x86emu_t *emu, unsigned ptr, int printonly, unsigned char fdparms[])
{
	unsigned cmd = x86emu_read_byte(emu, ptr + 0);
	int track, head, sec;
	unsigned ptr2;
	int secsize;

	track = x86emu_read_byte(emu, ptr + 3);
	head = x86emu_read_byte(emu, ptr + 4);
	sec = x86emu_read_byte(emu, ptr + 5);

	ptr2 = x86emu_read_byte(emu, ptr + 6);
	ptr2 |= x86emu_read_byte(emu, ptr + 7) << 8;
	ptr2 |= x86emu_read_byte(emu, ptr + 8) << 16;

	xprintf ("        0 0x%04x       0x%02x Command Register?\n",	ptr + 0, cmd);
	xprintf ("        1 0x%04x       0x%02x Status Register?\n",	ptr + 1, x86emu_read_byte(emu, ptr + 1));
	xprintf ("        2 0x%04x       0x%02x\n",			ptr + 2, x86emu_read_byte(emu, ptr + 2));
	xprintf ("        3 0x%04x       0x%02x Track\n",			ptr + 3, track);
	xprintf ("        4 0x%04x       0x%02x Head\n",			ptr + 4, head);
	xprintf ("        5 0x%04x       0x%02x Sector\n",		ptr + 5, sec);
	xprintf ("        6 0x%04x   0x%06x Data Buffer\n", ptr + 6, ptr2);
	xprintf ("        9 0x%04x       0x%02x Unknown\n",		ptr + 9, sec);

	switch (cmd & 0x70) {
	case 0x10:
		xprintf ("        SEEK\n");
		x86emu_write_byte(emu, ptr + 1, 0x00); // status = success
		// seek
		return 0;
	case 0x20:
		secsize = fdparms[2];
		secsize |= fdparms[3] << 8;
		xprintf ("        READ SECTOR (secsize=%d)\n", secsize);

		fddread(emu, ptr2, secsize, head, track, sec, sec);
		x86emu_write_byte(emu, ptr + 1, 0x00); // status = success
		// read sector
		return 0;
	}
	
//qw/20 00 00/, # Cmd, Status, 0x00
//qw/05 01 05/, # Track/Head/Sector
//qw/00 25 00 00/, # Buffer

	return 1;
}

static unsigned
ucmd(x86emu_t *emu, unsigned ptr, int printonly, const char *name)
{
	static unsigned char fdparms[64] = { 0, };
	unsigned cmd = x86emu_read_byte(emu, ptr + 0);
	unsigned ptr2, ptr3;
	unsigned cnt, start, end;
	int i;

	/* Busy bit not on */
	if (!printonly && (cmd & 0x80) == 0)
		goto out;

	xprintf ("[%s] {0x%04x}\n", name, ptr);
	xprintf ("    0 0x%04x       0x%02x Command Register?\n",	ptr + 0, cmd);
	xprintf ("    1 0x%04x       0x%02x Status Register?\n",	ptr + 1, x86emu_read_byte(emu, ptr + 1)); // IOP write 0

	ptr2 = x86emu_read_byte(emu, ptr + 2);
	ptr2 |= x86emu_read_byte(emu, ptr + 3) << 8;
	ptr2 |= x86emu_read_byte(emu, ptr + 4) << 16;
	xprintf ("    2 0x%04x   0x%06x Queue Pointer\n", ptr + 2, ptr2);

	cnt = x86emu_read_byte(emu, ptr + 5);
	end = x86emu_read_byte(emu, ptr + 6);
	start = x86emu_read_byte(emu, ptr + 7);

	xprintf ("    5 0x%04x       0x%02x Queue Length\n",	ptr + 5,  cnt);
	xprintf ("    6 0x%04x       0x%02x Queue End\n",	ptr + 6,  end);
	xprintf ("    7 0x%04x       0x%02x Queue Start\n",	ptr + 7,  start);
	xprintf ("    8 0x%04x       0x%02x Unknown\n",	ptr + 8,  x86emu_read_byte(emu, ptr + 8));
	xprintf ("    9 0x%04x       0x%02x Unknown\n",	ptr + 9,  x86emu_read_byte(emu, ptr + 9));

	if (cmd == 0x87) {
		xprintf ("   SET FLOPPY PARAMS\n");
		for (i = 0; i < sizeof(fdparms); i++) {
			fdparms[i] = x86emu_read_byte(emu, ptr + 10 + i);
			if (i % 16 == 0)
				xprintf ("  %.2d 0x%04x            | ", 10 + i, ptr + 10 + i);
			xprintf ("%02x ", fdparms[i]);
			if (i % 16 == 15)
				xprintf ("\n");
		}

		x86emu_write_byte(emu, ptr + 0, 0x00); // zero out command
		x86emu_write_byte(emu, ptr + 1, 0x00); // status = success
	// ack the command
	//x86emu_write_byte(emu, ptr + 0, cmd & 0x7f);
	} else if (cmd == 0x88) {
		//if ((cmd & 0xbf) == 0x88) {
		int bad = 0;

		xprintf ("    FLOPPY COMMAND SET\n");
		for (i = start; i != end;) {
		//for (i = 0; i < (cnt ?: 1); i++) { // badbadbad
			ptr3 = x86emu_read_byte(emu, ptr2 + 0);
			ptr3 |= x86emu_read_byte(emu, ptr2 + 1) << 8;
			ptr3 |= x86emu_read_byte(emu, ptr2 + 2) << 16;

			xprintf ("    [Floppy Command %d] {0x%04x:0x%04x}\n", i, ptr2, ptr3);
			bad |= fcmd(emu, ptr3, printonly, fdparms);
			// break on bad???

			i++;
			ptr2 += 4;
			if (i == cnt) {
				i -= cnt;
				ptr2 -= 4*cnt;
			}
		}

		if (!printonly) {
			x86emu_write_byte(emu, ptr + 1, 0x48);
			if (bad) {
				x86emu_write_byte(emu, ptr + 1, 0xc0);
			} else {
				x86emu_write_byte(emu, ptr + 1, 0x40);
			}

			x86emu_write_byte(emu, ptr + 0, 0x00); // zero out command
			x86emu_write_byte(emu, ptr + 1, 0x00); // status = success
			x86emu_write_byte(emu, ptr + 7, end); // commands done
		}
	} else if (cmd == 0x8f) {
		// what is this
		if (start == end) {
			x86emu_write_byte(emu, ptr + 0, 0x00); // zero out command
			x86emu_write_byte(emu, ptr + 1, 0x00); // status = success
			x86emu_write_byte(emu, ptr + 7, end); // commands done
		} else {
			printf ("\nBAD FLOPPY COMMAND: 0x%x cnt=%d\n", cmd, cnt);
			x86emu_stop (emu);
		}
	} else if (!printonly) {
		printf ("\nBAD FLOPPY COMMAND: 0x%x\n", cmd);
		x86emu_stop (emu);
	}


#if 0
	for (i = 0; i < 64; i++) {
		fcmd(emu, ptr2 + (i*4), printonly, "floppy-op");
	}
#else
#endif

	if (printonly)
		goto out;

	// ack the command
	//x86emu_write_byte(emu, ptr + 0, cmd & 0x7f);

	xprintf ("\n");
//	x86emu_stop (emu);
out:
	return 22;
}

static unsigned ch1_ptr = 0;

static void
tryrx (void)
{
	unsigned rxptr;
	unsigned inptr;
	int c;

	c = getchar();
	if (c == EOF) {
		if (errno != EAGAIN) {
			perror("getchar");
			x86emu_stop (emu);
		}
	} else {
		// characters available
		x86emu_write_word(emu, ch1_ptr + 2, x86emu_read_word(emu, ch1_ptr + 2) | 0x0100);

		if (x86emu_read_word(emu, ch1_ptr + 0) & 0x0080) {
			/* Ring buffer input */
			inptr = x86emu_read_word(emu, ch1_ptr + 15); // input pointer

			/* rx buffer addr */
			rxptr = x86emu_read_byte(emu, ch1_ptr + 12) << 16; // buffer addr hi
			rxptr |= x86emu_read_word(emu, ch1_ptr + 10); // buffer addr lo
			rxptr += inptr;

			fprintf(stderr, "EMU: IN: {0x%x} {0x%02x}\n", rxptr, c);
			if (c == '\n')
				c = '\r';
			x86emu_write_byte(emu, rxptr, c);

			inptr++;
			if (inptr >= x86emu_read_byte(emu, ch1_ptr + 13)) // length
				inptr = 0; /* wrap around */
			x86emu_write_word(emu, ch1_ptr + 15, inptr); // input pointer
		} else {
			/* Unbuffered input */
			fprintf(stderr, "EMU: IN: {unbuffered} {0x%02x}\n", c);
			x86emu_write_byte(emu, ch1_ptr + 18, c);
		}
	}
}


static void
pcmd(x86emu_t *emu, unsigned ptr, int printonly)
{
	xprintf ("[0x1fffc]  0x%04x Initialization Register\n", ptr);
	ptr += pcmd1(emu, ptr, printonly, "System Registers");
	ch1_ptr = ptr;
	ptr += pchcmd(emu, ptr, printonly, "Communication Channel Registers 0");
	ptr += pchcmd(emu, ptr, printonly, "Communication Channel Registers 1");
	ptr += pchcmd(emu, ptr, printonly, "Communication Channel Registers 2");
	ptr += pchcmd(emu, ptr, printonly, "Communication Channel Registers 3");
	ptr += pchcmd(emu, ptr, printonly, "Communication Channel Registers 4");
	ptr += pchcmd(emu, ptr, printonly, "Communication Channel Registers 5");
	ptr += ucmd(emu, ptr, printonly, "Floppy Channel");
}

static void
ckcmd(x86emu_t *emu)
{
	static unsigned oldcmd = 0;
	unsigned newcmd;
	unsigned ptr;

	ptr = x86emu_read_word(emu, 0x1fffc);
	ptr |= x86emu_read_word(emu, 0x1fffe) << 16;

	if (ptr)
		x86emu_write_byte(emu, ptr, 0x32);

	pnewcmd = ptr + 5;
	newcmd = x86emu_read_byte(emu, pnewcmd);

	if (newcmd == oldcmd)
		return;

	xprintf("=== COMMAND %d -> %d {0x%05x} === {ptr=0x%02x} ===\n", oldcmd, newcmd, pnewcmd, ptr);
	oldcmd = newcmd;

	pcmd(emu, ptr, 0);

#if 0
	xprintf ("   0 0x%04x 0x%02x read, write, format command\n", ptr + 0, x86emu_read_byte(emu, ptr + 0));
	xprintf ("   1 0x%04x 0x%02x status\n", ptr + 1, x86emu_read_byte(emu, ptr + 1));
	xprintf ("   2 0x%04x 0x%02x cylinder-low\n", ptr + 2, x86emu_read_byte(emu, ptr + 2));
	xprintf ("   3 0x%04x 0x%02x cylinder-high\n", ptr + 3, x86emu_read_byte(emu, ptr + 3));
	xprintf ("   4 0x%04x 0x%02x head and drive\n", ptr + 4, x86emu_read_byte(emu, ptr + 4));
	xprintf ("   5 0x%04x 0x%02x starting sector no.\n", ptr + 5, x86emu_read_byte(emu, ptr + 5));
	xprintf ("   6 0x%04x 0x%02x byte count-low\n", ptr + 6, x86emu_read_byte(emu, ptr + 6));
	xprintf ("   7 0x%04x 0x%02x byte count-high\n", ptr + 7, x86emu_read_byte(emu, ptr + 7));
	xprintf ("   8 0x%04x 0x%02x system memory address-offset low\n", ptr + 8, x86emu_read_byte(emu, ptr + 8));
	xprintf ("   9 0x%04x 0x%02x system memory address-offset high\n", ptr + 9, x86emu_read_byte(emu, ptr + 9));
	xprintf ("  10 0x%04x 0x%02x system memory address-segment low\n", ptr + 10, x86emu_read_byte(emu, ptr + 10));
	xprintf ("  11 0x%04x 0x%02x system memory address-segment high\n", ptr + 11, x86emu_read_byte(emu, ptr + 11));
	xprintf ("  12 0x%04x 0x%02x reserved\n", ptr + 12, x86emu_read_byte(emu, ptr + 12));
	xprintf ("  13 0x%04x 0x%02x number of sectors processed before error\n", ptr + 13, x86emu_read_byte(emu, ptr + 13));
	xprintf ("  14 0x%04x 0x%02x reserved\n", ptr + 14, x86emu_read_byte(emu, ptr + 14));
	xprintf ("  15 0x%04x 0x%02x job done\n", ptr + 15, x86emu_read_byte(emu, ptr + 15));
#endif

	//x86emu_stop (emu);
}

unsigned mmu[256] = { 0, }; 

static void
mmuflags(char flags[9], unsigned val)
{
	flags[0] = val & 0x0100 ? 'X' : '-';
	flags[1] = val & 0x0200 ? 'X' : '-';
	flags[2] = val & 0x0400 ? 'X' : '-';
	flags[3] = val & 0x0800 ? 'I' : 'i';
	flags[4] = val & 0x1000 ? 'S' : 's';
	flags[5] = val & 0x2000 ? 'B' : 'b';
	flags[6] = val & 0x4000 ? 'A' : 'a';
	flags[7] = val & 0x8000 ? 'W' : 'w';
}
	
static unsigned
memio_handler(x86emu_t *emu, u32 addr, u32 *val, unsigned type)
{
	unsigned ret;

	if (type == (X86EMU_MEMIO_W | X86EMU_MEMIO_8) && addr >= 0x80000 && addr < romstart) {
		/* V1.3 firmware does this during memory sizing. */
		xprintf ("UNMAPPED MEM WRITE8 0x%04x\n", addr);
		return 0;
	}

	switch (type) {
	case X86EMU_MEMIO_8 | X86EMU_MEMIO_I:
		*val = 0xff;
		switch (addr) {
		case 0x0105:
			// "PIT - Counter 1"
			xprintf ("READ8 0x%04x -> 0x%02x PIT - Counter 1\n", addr, *val);
			//x86emu_stop (emu);
			break;
		default:
			printf ("BAD READ8 0x%04x\n", addr);
			x86emu_stop (emu);
		}
		break;

	case X86EMU_MEMIO_16 | X86EMU_MEMIO_I:
		switch (addr) {
		case 0x0070: // 1
			*val = 0x0000; // doesn't matter
			// MMU - Clear Violation Port ?
			xprintf ("READ16 0x%04x -> 0x%04x MMU - Clear Violation Port\n", addr, *val);
			return 0;
		case 0x0060: // 2
			//*val = 0x0000; // FAILED POWER-UP TEST 2
			//*val = 0xfdff;
			*val = 0x0000;
			if (warm)
				*val |= 0x0200; // warm start bit

			// MMU - Error Address 2 - Read Only.
			xprintf ("READ16 0x%04x -> 0x%04x MMU - Error Address 2\n", addr, *val);
			return 0;
		case 0x0078: // 1
			//*val = 0x0000; // doesn't matter
			*val = 0x3000; // jumpers
			// MMU - Violation Port - Read Only.
			xprintf ("READ16 0x%04x -> 0x%04x MMU - Violation Port\n", addr, *val);
			return 0;

		default:
			// MMU
			if (addr >= 0x200 && addr < 0x400 && (addr & 1) == 0) {
				uint32_t base = (addr & 0x1ff) << 11;
				uint32_t target = (*val & 0xff) << 12;
				char flags[9];

				mmuflags(flags, *val);
				xprintf ("MMU READ16 0x%04x -> 0x%04x [base=%05x target=%05x flags=%s]\n",
					addr, *val, base, target, flags);
				*val = mmu[(addr >> 1) & 0xff];
				return 0;
			}

			//} else if (addr == 0x00e5) {
			printf ("BAD READ16 0x%04x\n", addr);
			x86emu_stop (emu);
		}
		break;


	case X86EMU_MEMIO_8 | X86EMU_MEMIO_O:
		switch (addr) {
		case 0x0080: // <- 0x73
			// PIC - ICW2, ICW3, ICW4, or OCW1
			xprintf ("WRITE8 0x%04x <- 0x%02x PIC - ICW2, ICW3, ICW4, or OCW1\n", addr, *val);
			return 0;

		case 0x0040: // 0x00
			// UNKNOWN_PORT_40 sdx
			xprintf ("WRITE8 0x%04x <- 0x%02x SDX UNKNOWN PORT\n", addr, *val);
			return 0;

		case 0x0050:
			// Z80A I/O Processor Chan att.
			xprintf ("WRITE8 0x%04x <- 0x%02x Z80A I/O Processor Chan att.\n", addr, *val);
			ckcmd(emu);
			return 0;

		case 0x0058: /* <- 0x00 */
			// Control Bits Port - Write Only.
			// ccpm, also16
			xprintf ("WRITE8 0x%04x <- 0x%02x Control Bits Port\n", addr, *val);
			return 0;


		case 0x0070: // sdx 0x00
			// MMU - Clear Violation Port ?
			xprintf ("WRITE8 0x%04x <- 0x%02x MMU - Clear Violation Port\n", addr, *val);
			return 0;


		case 0x0082: // <- 0x13
			// PIC - ICW1, OCW2, or OCW3
			xprintf ("WRITE8 0x%04x <- 0x%02x PIC - ICW1, OCW2, or OCW3\n", addr, *val);
			return 0;
		case 0xff00: // <- 0x03
			// "Reserved for system bus I/O."
			xprintf ("WRITE8 0x%04x <- 0x%02x (8089 interrupt?)\n", addr, *val);
			iopattn(emu);
			return 0;

		case 0xff80: // <- 0x00
			// "Reserved for system bus I/O."
			// ccpm
			xprintf ("WRITE8 0x%04x <- 0x%02x (8089 interrupt?)\n", addr, *val);
			iopattn(emu);
			return 0;

		case 0x0101: // <- 0x70
			// "PIT - Control Word Register - Write Only"
			xprintf ("WRITE8 0x%04x <- 0x%02x PIT - Control Word Register\n", addr, *val);
			return 0;
		case 0x0103: // <- 0x50
			// "PIT - Counter 2"
			xprintf ("WRITE8 0x%04x <- 0x%02x PIT - Counter 2 \n", addr, *val);
			if (*val == 0x50) {
				/* Stop to get attention. We'll have to schedule
				 * triggering the timer interrupt soon. */
				x86emu_stop (emu);
			}
			return 0;
		case 0x0105: // <- 0x70
			// "PIT - Counter 1"
			xprintf ("WRITE8 0x%04x <- 0x%02x PIT - Counter 1\n", addr, *val);
			return 0;


		case 0x0107: // <- 0x20, 0x00
			// "PIT - Counter 0"
			// ccpm
			xprintf ("WRITE8 0x%04x <- 0x%02x PIT - Counter 0\n", addr, *val);
			return 0;

		default:
			printf ("BAD WRITE8 0x%04x <- 0x%02x\n", addr, *val);
			x86emu_stop (emu);
		}
		break;


	case X86EMU_MEMIO_16 | X86EMU_MEMIO_O:
		switch (addr) {
		case 0x0050:
			// Z80 on main board
			// Z80A I/O Processor Chan att.
			xprintf ("WRITE16 0x%04x <- 0x%02x (serial interrupt Z80 on CPU board) Z80A I/O Processor Chan att.\n", addr, *val);
			ckcmd(emu);
			return 0;
		case 0x0058: /* <- 0x100 */
			// Control Bits Port - Write Only.
			xprintf ("WRITE16 0x%04x <- 0x%02x Control Bits Port\n", addr, *val);
			return 0;
		case 0x7000: /* - 0x7007 */
			/* 586T: "Requests hard disk or memory-to-memory operation" */
			/* Descriptor pointer at 400H */
			xprintf ("WRITE16 0x%04x <- 0x%02x (hard disk interrupt Z80 on controller board) CPUINT1\n", addr, *val);
			cpuint1_hdd(emu);
			return 0;
		case 0x7008: /* - 0x700F */
			/* 586T: "Requests floppy disk operation" */
			/* 586: "Requests floppy disk operation" */
			/* Descriptor pointer at 404H */
			xprintf ("WRITE16 0x%04x <- 0x%02x (floppy interrupt Z80 on CPU board) CPUINT2\n", addr, *val);
			cpuint2_floppy(emu);
			return 0;
		case 0x7010: /* - 0x7017 */
			/* 586T: "Requests tape operation" */
			/* Descriptor pointer at 408H */
			printf ("WRITE16 0x%04x <- 0x%02x (tape interrupt on controller board?) CPUINT3\n", addr, *val);
			x86emu_stop (emu);
			return 0;
		default:
			// MMU
			if (addr >= 0x200 && addr < 0x400 && (addr & 1) == 0) {
				uint32_t base = (addr & 0x1ff) << 11;
				uint32_t target = (*val & 0xff) << 12;
				char flags[9];

				mmuflags(flags, *val);
				xprintf ("MMU WRITE16 0x%04x <- 0x%02x [base=%05x target=%05x flags=%s]\n",
					addr, *val, base, target, flags);
				mmu[(addr >> 1) & 0xff] = *val;
				return 0;
			}

			printf ("BAD WRITE16 0x%04x <- 0x%04x\n", addr, *val);
			x86emu_stop (emu);
		}
		break;
	}

	//if (type == (X86EMU_MEMIO_R | X86EMU_MEMIO_16) && addr == ch1_ptr + 15) {
		if (term) {
			x86emu_stop (emu);
			return 0;
		}
		tryrx();
	//}

	ret = orig_memio(emu, addr, val, type);

#if 0
	// EMU:    15 0x042b   0x0000 Receive Buffer Input Pointer Register
	if (type == (X86EMU_MEMIO_R | X86EMU_MEMIO_16) && addr == 0x042b) {
		int c;

		if (term) {
			x86emu_stop (emu);
			return 0;
		}

		c = getchar();
		if (c == EOF) {
			if (errno != EAGAIN) {
				perror("getchar");
				x86emu_stop (emu);
			}
		} else {
			unsigned ptr;

			/* rx buffer addr */
			ptr = x86emu_read_byte(emu, 0x428) << 16;
			ptr |= x86emu_read_word(emu, 0x426);
			ptr += *val;

			if (c == '\n')
				c = '\r';
			x86emu_write_byte(emu, ptr, c);

			(*val)++;
			if (*val >= x86emu_read_byte(emu, 0x429))
				*val = 0; /* wrap around */
			x86emu_write_word(emu, 0x042b, *val);
		}

		//*val = 1;
		//x86emu_stop (emu);
	}
#endif


	if (type == (X86EMU_MEMIO_W | X86EMU_MEMIO_8) && pnewcmd && addr == pnewcmd) {
		xprintf ("WRITE8 MEM 0x%04x <- 0x%02x New Command\n", addr, *val);
		ckcmd(emu);
		//x86emu_stop (emu);
	}

	//if (type == X86EMU_MEMIO_W && addr >= 0x410 && addr < 0x416) {
	//	printf ("============== {%x} <- 0x%x =======\n", addr, *val);
	//	xprintf ("============== {%x} <- 0x%x =======\n", addr, *val);
	//	//x86emu_stop (emu);
	//}

	return ret;
}

static void
cleanup(void)
{
	if (orig_tio) {
		if (tcsetattr(STDIN_FILENO, TCSANOW, orig_tio) == -1)
			perror("cleanup: tcsetattr");
		orig_tio = NULL;
	}

	if (emu) {
		//x86emu_dump (emu, X86EMU_DUMP_DEFAULT | X86EMU_DUMP_ACC_MEM);
		x86emu_dump (emu, X86EMU_DUMP_DEFAULT);
		x86emu_clear_log (emu, 1);
		x86emu_done (emu);
		emu = NULL;
	}
}

static void
sigint2 (int signum)
{
	cleanup();
	signal(SIGINT, SIG_DFL);
}

static void
sigint1 (int signum)
{
	term = 1;
	signal(SIGINT, sigint2);
}

static void
sighup2 (int signum)
{
	cleanup();
	signal(SIGHUP, SIG_DFL);
}

static void
sighup1 (int signum)
{
	term = 1;
	signal(SIGHUP, sighup2);
}

int
main (int argc, char *argv[])
{
    	struct pollfd fds = { STDIN_FILENO, POLLIN, 0 };
	struct termios tio, tio_raw;
	struct stat statbuf;
	unsigned addr;
	unsigned flags;
	unsigned ret;
	int f;
	int debug = 0;
	char c;

	//out = stderr;
	//out = stdout;

	if (argc != 2 && argc != 3) {
		fprintf (stderr, "Usage: %s <rom> [<floppy>]\n", argv[0]);
		return 1;
	}

	emu = x86emu_new (X86EMU_PERM_R | X86EMU_PERM_W | X86EMU_PERM_X, 0);

	//x86emu_set_log (emu, 1000000, flush_log);
	x86emu_set_log (emu, 10000000, flush_log);

	x86emu_set_seg_register (emu, emu->x86.R_CS_SEL, 0xf000);
	emu->x86.R_IP = 0xfff0;

	f = open(argv[1], O_RDONLY);
	if (f == -1) {
		perror(argv[1]);
		return 1;
	}
	if (fstat (f, &statbuf) == -1) {
		perror(argv[1]);
		return 1;
	}
	switch (statbuf.st_size) {
	case 0x2000:
		romstart = 0xfe000;
		break;
	case 0x4000:
		romstart = 0xfc000;
		break;
	default:
		fprintf(stderr, "Wrong file size: %ld\n", statbuf.st_size);
		return 1;
	}
	for (addr = romstart; addr <= 0xfffff; addr++) {
		switch (read(f, &c, 1)) {
		case 0:
			break;
		case 1:
			x86emu_write_byte (emu, addr, c);
			continue;
		case -1:
		default:
			perror(argv[1]);
			return 1;
		}
		break;
	}
	close (f);


	if (argc == 3) {
		fddfd = open(argv[2], O_RDONLY);
		if (fddfd == -1) {
			perror(argv[2]);
			return 1;
		}
	}



	orig_memio = x86emu_set_memio_handler(emu, memio_handler);
	//x86emu_reset_access_stats (emu);

	//emu->max_instr = max_instructions;
	flags = X86EMU_RUN_NO_EXEC | X86EMU_RUN_NO_CODE | X86EMU_RUN_LOOP | X86EMU_RUN_MAX_INSTR;

	if (!getenv("COLD"))
		warm = 1; // skip POST
	if (getenv("DEBUG"))
		debug = 1;

	if (debug) {
		emu->log.trace = X86EMU_TRACE_DEFAULT;
	} else {
		out = stderr;
	}

	if (tcgetattr(STDIN_FILENO, &tio) == -1) {
		perror("tcgetattr");
		return 1;
	}
	orig_tio = &tio;

	tio_raw = tio;
        tio_raw.c_lflag &= ~(ECHO | ECHONL | ICANON | IEXTEN);
	if (tcsetattr(STDIN_FILENO, TCSANOW, &tio_raw) == -1) {
		perror("tcsetattr");
		return 1;
	}

	if (fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK) == -1) {
		perror("F_SETFL");
		return 1;
	}

	signal(SIGINT, sigint1);
	signal(SIGHUP, sighup1);
	while (!term) {
		if (emu->max_instr == 0) {
			emu->max_instr = emu->x86.R_TSC;
			emu->max_instr += warm ? 1500000 : 10360000;
		}
		ret = x86emu_run (emu, flags);

		if (ret == X86EMU_RUN_MAX_INSTR) {
			// SDX diagnostics
			if (emu->x86.R_CS == 0x6000 && emu->x86.R_IP >= 0x042a && emu->x86.R_IP <= 0x042d) {
				xprintf("Fatal error.\n");
				break;
			}

			if ((emu->x86.R_IP >= 0x228f && emu->x86.R_IP <= 0x2291) || // a2.2
				(emu->x86.R_IP >= 0x021a && emu->x86.R_IP <= 0x021c)) { // V1.3
				/* Timer test. We're in the loop that awaits the interrupt IR1.
				 * Fire it now. */
				x86emu_intr_raise(emu, 32 + 1, INTR_TYPE_SOFT, 0);
				emu->max_instr =0;
			} else {
				if (debug && !warm)
					break;
				emu->max_instr += 3000000;
				if(0)
				poll(&fds, 1, 10000);
			}
		} else {
			if ((emu->x86.R_IP == 0x228a) || // a2.2
				(emu->x86.R_IP == 0x0215)) { // V1.3
				/* Timer test. Run a little more and then fire an interrupt. */
				emu->max_instr = emu->x86.R_TSC + 10;
			} else {
				break;
			}
		}
	}

	cleanup();
	return 0;
}
