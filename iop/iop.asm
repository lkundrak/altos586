; ───────────────────────────────────────────────────────────────────────────

IY_STRUCT	struc ;	(sizeof=0x2e)
field_0:	.db ?
field_1:	.db ?
field_2:	.db ?
field_3:	.db ?
field_4:	.db ?
field_5:	.db ?
field_6:	.db ?
field_7:	.db ?
field_8:	.db ?
field_9:	.db ?
field_A:	.db ?
field_B:	.db ?
field_C:	.db ?
field_D:	.db ?
field_E:	.db ?
field_F:	.db ?
field_10:	.db ?
field_11:	.db ?
field_12:	.db ?
field_13:	.db ?
field_14:	.db ?
field_15:	.db ?
field_16:	.db ?
field_17:	.db ?
field_18:	.db ?
field_19:	.db ?
field_1A:	.db ?
field_1B:	.db ?
field_1C:	.db ?
field_1D:	.db ?
field_1E:	.db ?
field_1F:	.db ?
field_20:	.db ?
field_21:	.db ?
field_22:	.db ?
field_23:	.db ?
field_24:	.db ?
field_25:	.db ?
field_26:	.db ?
field_27:	.db ?
field_28:	.db ?
field_29:	.db ?
field_2A:	.db ?
field_2B:	.db ?
field_2C:	.db ?
LAST:		.db ?
IY_STRUCT	ends

; ───────────────────────────────────────────────────────────────────────────

IX_STRUCT	struc ;	(sizeof=0xd)
field_0:	.db ?
field_1:	.db ?
PORT_BASE_1:	.db ?			; enum PORTS
PORT_BASE_2:	.db ?			; enum PORTS
field_4:	.db ?
field_5:	.db ?
field_6:	.db ?
field_7:	.db ?
field_8:	.db ?
field_9:	.db ?
field_A:	.db ?
field_B:	.db ?
LAST:		.db ?
IX_STRUCT	ends

; ───────────────────────────────────────────────────────────────────────────

HOST_RAM_ADDR	struc ;	(sizeof=0x3)
LO:		.db ?
MID:		.db ?
HI:		.db ?
HOST_RAM_ADDR	ends

; ───────────────────────────────────────────────────────────────────────────

FDC_COMMAND_S	struc ;	(sizeof=0x9)
COMMAND:	.db ?
STATUS:		.db ?
field_2:	.db ?
TRACK_NUMBER:	.db ?
HEAD:		.db ?
SECTOR:		.db ?
BUFFER_ADDR_MID_LO:.dw ?
BUFFER_ADDR_HI:	.db ?
FDC_COMMAND_S	ends

; ───────────────────────────────────────────────────────────────────────────

; enum PORTS
BUS_ADDRESS_LATCH: = 0			; Address Latch	- System memory	block number (bits 0 thru 4)
PIT0_COUNTER_0:	 = 20h			; PIT 0	- Counter 0 provides baud rate for port	3
PIT0_COUNTER_1:	 = 21h			; PIT 0	- Counter 1 provides baud rate for port	4
PIT0_COUNTER_2:	 = 22h			; PIT 0	- Counter 2 provides baud rate for port	1
PIT0_CONTROL:	 = 23h			; PIT 0	- Control byte for PIT 0
PIT1_COUNTER_0:	 = 24h			; PIT 1	- Counter 0 provides baud rate for port	2
PIT1_COUNTER_1:	 = 25h			; PIT 1	- Counter 1 provides baud rate for port	5
PIT1_COUNTER_2:	 = 26h			; PIT 1	- Counter 2 timer interrupt
PIT1_CONTROL:	 = 27h			; PIT 1	- Control byte for PIT 1
SIO0_CHAN_A_DATA: = 28h			; SIO 0	- Channel A data for serial port 3
SIO0_CHAN_A_CONTROL: = 29h		; SIO 0	- Channel A control for	serial port 3
SIO0_CHAN_B_DATA: = 2Ah			; SIO 0	- Channel B data for serial port 4
SIO0_CHAN_B_CONTROL: = 2Bh		; SIO 0	- Channel B control for	serial port 4
SIO1_CHAN_A_DATA: = 2Ch			; SIO 1	- Channel A data for serial port 1
SIO1_CHAN_A_CONTROL: = 2Dh		; SIO 1	- Channel A control for	serial port 1
SIO1_CHAN_B_DATA: = 2Eh			; SIO 1	- Channel B data for serial port 2
SIO1_CHAN_B_CONTROL: = 2Fh		; SIO 1	- Channel B control for	serial port 2
SIO2_CHAN_A_DATA: = 30h			; SIO 2	- Channel A data for serial port 5
SIO2_CHAN_A_CONTROL: = 31h		; SIO 2	- Channel A control for	serial port 5
SIO2_CHAN_B_DATA: = 32h			; SIO 2	- Channel B data for serial port 6
SIO2_CHAN_B_CONTROL: = 33h		; SIO 2	- Channel B control for	serial port 6
PIO_DATA_A:	 = 34h			; PIO -	Data port A
PIO_COMMAND_A:	 = 35h			; PIO -	Command	port A
PIO_DATA_B:	 = 36h			; PIO -	Data port B
PIO_COMMAND_B:	 = 37h			; PIO -	Command	port B
FDC_CMD_STAT:	 = 38h			; FDC -	Write command, Read status
FDC_TRACK:	 = 39h			; FDC -	Track number
FDC_SECTOR:	 = 3Ah			; FDC -	Sector number
FDC_DATA:	 = 3Bh			; FDC -	Read/Write data
DMA_ALL:	 = 3Ch			; DMA -	All read and write registers
DMA_CLEAR:	 = 40h			; DMA -	Clear carrier sense and	parity error bit
RTC_MSEC:	 = 80h			; RTC -	Counter	- thousandths of seconds
RTC_DCSEC:	 = 81h			; RTC -	Counter	- hundredths and tenths	of seconds
RTC_SECONDS:	 = 82h			; RTC -	Counter	- seconds
RTC_MINUTES:	 = 83h			; RTC -	Counter	- minutes
RTC_HOURS:	 = 84h			; RTC -	Counter	- hours
RTC_DAY_OF_WEEK: = 85h			; RTC -	Counter	- Day of Week
RTC_DAY_OF_MONTH: = 86h			; RTC -	Counter	- Day of Month
RTC_MONTHS:	 = 87h			; RTC -	Counter	- Months
RTC_LATCH_MSEC:	 = 88h			; RTC -	Latches	- Thousandths of seconds
RTC_LATCH_DCSEC: = 89h			; RTC -	Latches	- Hundredths and tenths	of seconds
RTC_LATCH_SECONDS: = 8Ah		; RTC -	Latches	- Seconds
RTC_LATCH_MINUTES: = 8Bh		; RTC -	Latches	- Minutes
RTC_LATCH_HOURS: = 8Ch			; RTC -	Latches	- Hours
RTC_LATCH_DAY_OF_WEEK: = 8Dh		; RTC -	Latches	- Day of the Week
RTC_LATCH_DAY_OF_MONTH:	= 8Eh		; RTC -	Latches	- Day of the Month
RTC_LATCH_MONTHS: = 8Fh			; RTC -	Latches	- Months
RTC_INT_STATUS:	 = 90h			; RTC -	Interrupt Status Register
RTC_INT_CONTROL: = 91h			; RTC -	Interrupt Control Register
RTC_COUNTER_RESET: = 92h		; RTC -	Counter	Reset
RTC_LATCH_RESET: = 93h			; RTC -	Latch Reset
RTC_STATUS:	 = 94h			; RTC -	Status Bit
RTC_GO_CMD:	 = 95h			; RTC -	"GO" Command
RTC_STANDBY_INT: = 96h			; RTC -	Standby	Interrupt
RTC_TEST:	 = 9Fh			; RTC -	Test Mode

; ───────────────────────────────────────────────────────────────────────────

; enum SYS_REGS
SYS_FW_VER:	 = 0			; SYS -	Firmware Version Register
SYS_SYS_CMD:	 = 1			; SYS -	System Command Register
SYS_SYS_STAT:	 = 2			; SYS -	System Status Register
SYS_INT_VEC:	 = 3			; SYS -	Interrupt Vector Register
SYS_NEW_CMD:	 = 5			; SYS -	New Command Register
CH0_CHAN_PARM:	 = 6			; CH 0 - Channel Parameter Register
CH0_CHAN_STAT:	 = 8			; CH 0 - Channel Status	Register
CH0_CHAN_CMD:	 = 0Ah			; CH 0 - Channel Command Register
CH0_XMIT_BUF_ADDR: = 0Bh		; CH 0 - Transmit Data Buffer Address Register
CH0_XMIT_BUF_LEN: = 0Eh			; CH 0 - Transmit Data Buffer Length Register
CH0_RECV_BUF_ADDR: = 10h		; CH 0 - Receive Data Buffer Address Register
CH0_RECV_BUF_LEN: = 13h			; CH 0 - Receive Data Buffer Length Register
CH0_RECV_BUF_IN_PTR: = 15h		; CH 0 - Receive Buffer	Input Pointer Register
CH0_RECV_BUF_OUT_PTR: =	17h		; CH 0 - Receive Buffer	Output Pointer Register
CH0_TTY_RECV:	 = 19h			; CH 0 - TTY Receive Register
CH0_SEL_RATE:	 = 1Ah			; CH 0 - Selectable Rate Register
CH1_CHAN_PARM:	 = 1Ch			; CH 1 - Channel Parameter Register
CH1_CHAN_STAT:	 = 1Eh			; CH 1 - Channel Status	Register
CH1_CHAN_CMD:	 = 20h			; CH 1 - Channel Command Register
CH1_XMIT_BUF_ADDR: = 21h		; CH 1 - Transmit Data Buffer Address Register
CH1_XMIT_BUF_LEN: = 24h			; CH 1 - Transmit Data Buffer Length Register
CH1_RECV_BUF_ADDR: = 26h		; CH 1 - Receive Data Buffer Address Register
CH1_RECV_BUF_LEN: = 29h			; CH 1 - Receive Data Buffer Length Register
CH1_RECV_BUF_IN_PTR: = 2Bh		; CH 1 - Receive Buffer	Input Pointer Register
CH1_RECV_BUF_OUT_PTR: =	2Dh		; CH 1 - Receive Buffer	Output Pointer Register
CH1_TTY_RECV:	 = 2Fh			; CH 1 - TTY Receive Register
CH1_SEL_RATE:	 = 30h			; CH 1 - Selectable Rate Register
CH2_CHAN_PARM:	 = 32h			; CH 2 - Channel Parameter Register
CH2_CHAN_STAT:	 = 34h			; CH 2 - Channel Status	Register
CH2_CHAN_CMD:	 = 36h			; CH 2 - Channel Command Register
CH2_XMIT_BUF_ADDR: = 37h		; CH 2 - Transmit Data Buffer Address Register
CH2_XMIT_BUF_LEN: = 3Ah			; CH 2 - Transmit Data Buffer Length Register
CH2_RECV_BUF_ADDR: = 3Ch		; CH 2 - Receive Data Buffer Address Register
CH2_RECV_BUF_LEN: = 3Fh			; CH 2 - Receive Data Buffer Length Register
CH2_RECV_BUF_IN_PTR: = 41h		; CH 2 - Receive Buffer	Input Pointer Register
CH2_RECV_BUF_OUT_PTR: =	43h		; CH 2 - Receive Buffer	Output Pointer Register
CH2_TTY_RECV:	 = 45h			; CH 2 - TTY Receive Register
CH2_SEL_RATE:	 = 46h			; CH 2 - Selectable Rate Register
CH3_CHAN_PARM:	 = 48h			; CH 3 - Channel Parameter Register
CH3_CHAN_STAT:	 = 4Ah			; CH 3 - Channel Status	Register
CH3_CHAN_CMD:	 = 4Ch			; CH 3 - Channel Command Register
CH3_XMIT_BUF_ADDR: = 4Dh		; CH 3 - Transmit Data Buffer Address Register
CH3_XMIT_BUF_LEN: = 50h			; CH 3 - Transmit Data Buffer Length Register
CH3_RECV_BUF_ADDR: = 52h		; CH 3 - Receive Data Buffer Address Register
CH3_RECV_BUF_LEN: = 55h			; CH 3 - Receive Data Buffer Length Register
CH3_RECV_BUF_IN_PTR: = 57h		; CH 3 - Receive Buffer	Input Pointer Register
CH3_RECV_BUF_OUT_PTR: =	59h		; CH 3 - Receive Buffer	Output Pointer Register
CH3_TTY_RECV:	 = 5Bh			; CH 3 - TTY Receive Register
CH3_SEL_RATE:	 = 5Ch			; CH 3 - Selectable Rate Register
CH4_CHAN_PARM:	 = 5Eh			; CH 4 - Channel Parameter Register
CH4_CHAN_STAT:	 = 60h			; CH 4 - Channel Status	Register
CH4_CHAN_CMD:	 = 62h			; CH 4 - Channel Command Register
CH4_XMIT_BUF_ADDR: = 63h		; CH 4 - Transmit Data Buffer Address Register
CH4_XMIT_BUF_LEN: = 66h			; CH 4 - Transmit Data Buffer Length Register
CH4_RECV_BUF_ADDR: = 68h		; CH 4 - Receive Data Buffer Address Register
CH4_RECV_BUF_LEN: = 6Bh			; CH 4 - Receive Data Buffer Length Register
CH4_RECV_BUF_IN_PTR: = 6Dh		; CH 4 - Receive Buffer	Input Pointer Register
CH4_RECV_BUF_OUT_PTR: =	6Fh		; CH 4 - Receive Buffer	Output Pointer Register
CH4_TTY_RECV:	 = 71h			; CH 4 - TTY Receive Register
CH4_SEL_RATE:	 = 72h			; CH 4 - Selectable Rate Register
CH5_CHAN_PARM:	 = 74h			; CH 5 - Channel Parameter Register
CH5_CHAN_STAT:	 = 76h			; CH 5 - Channel Status	Register
CH5_CHAN_CMD:	 = 78h			; CH 5 - Channel Command Register
CH5_XMIT_BUF_ADDR: = 79h		; CH 5 - Transmit Data Buffer Address Register
CH5_XMIT_BUF_LEN: = 7Ch			; CH 5 - Transmit Data Buffer Length Register
CH5_RECV_BUF_ADDR: = 7Eh		; CH 5 - Receive Data Buffer Address Register
CH5_RECV_BUF_LEN: = 81h			; CH 5 - Receive Data Buffer Length Register
CH5_RECV_BUF_IN_PTR: = 83h		; CH 5 - Receive Buffer	Input Pointer Register
CH5_RECV_BUF_OUT_PTR: =	85h		; CH 5 - Receive Buffer	Output Pointer Register
CH5_TTY_RECV:	 = 87h			; CH 5 - TTY Receive Register
CH5_SEL_RATE:	 = 88h			; CH 5 - Selectable Rate Register
UNK_CMD_XXX:	 = 8Ah			; UNK -	Command	Register?
UNK_STAT_XXX:	 = 8Bh			; UNK -	Status Register?
UNK_Some_BUF:	 = 8Ch			; UNK -	Some Buffer?
UNK_Sector_size: = 96h			; UNK -	Sector size?
UNKNOWN:	 = 0D4h			; UNKNOWN

;
; ╔═════════════════════════════════════════════════════════════════════════╗
; ║	This file is generated by The Interactive Disassembler (IDA)	    ║
; ║			      Freeware version				    ║
; ║	Copyright (c) 2000 by DataRescue sa/nv,	http://www.datarescue.com   ║
; ╚═════════════════════════════════════════════════════════════════════════╝
;

; Processor:	    z80
; Target assembler: Table Driven Assembler (TASM) by Speech Technology Inc.

; ═══════════════════════════════════════════════════════════════════════════

; Segment type:	Pure code
; segment 'ROM'

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

START:					; CODE XREF: DO_NMI_HANDLER+5Aj
		ld	hl, SRAM_JUMP_SLOT1
		ld	de, 3		; How long a jump slot is
		ld	bc, 5		; How many jump	slots
		ld	sp, STACK_TOP

RET_TO_SRAM:				; CODE XREF: START+12j
		ld	(hl), 0C9h ; '╔' ; Fill jump slots with 0C9h == RET
		add	hl, de
		dec	bc
		ld	a, b
		or	c
		jr	nz, RET_TO_SRAM
		ld	bc, 7F1h	; Length of rest of SRAM, after	the jump slots

ERASE_SRAM:				; CODE XREF: START+1Dj
		ld	(hl), 0		; Fill rest of SRAM with zeroes
		inc	hl
		dec	bc
		ld	a, b
		or	c
		jr	nz, ERASE_SRAM	; Fill rest of SRAM with zeroes

loc_0_1F:				; CODE XREF: START+1Fj
		jr	loc_0_1F	; Endless loop
; End of function START			; Waiting for interrupt

; ───────────────────────────────────────────────────────────────────────────
byte_0_21:	.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0 ;	DATA XREF: ROM:1C27r
					; ROM:1C41w
		.db 0, 0, 0, 0,	0, 0

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Mode 1 interrupt handler
; Attributes: bp-based frame

INT_HANDLER:				; CODE XREF: ROM:1C44p	ROM:1C45p
					; ROM:1C46p
		jp	DO_INT_HANDLER
; End of function INT_HANDLER

; ───────────────────────────────────────────────────────────────────────────
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

NMI_HANDLER:
		jp	DO_NMI_HANDLER
; End of function NMI_HANDLER

; ───────────────────────────────────────────────────────────────────────────
		.db 0, 0, 0, 0,	0, 0, 0
; ───────────────────────────────────────────────────────────────────────────
		jp	CHECK_STUFF	; Called from *many* sites
; ───────────────────────────────────────────────────────────────────────────
		jp	ZERO_SAVED_TASK_sub_028C
; ───────────────────────────────────────────────────────────────────────────
		jp	sub_0_286
; ───────────────────────────────────────────────────────────────────────────
		jp	sub_0_280
; ───────────────────────────────────────────────────────────────────────────
		jp	TAIL_EI
; ───────────────────────────────────────────────────────────────────────────
		jp	BUS_READ8	; hl=host address
					; returns b=value
; ───────────────────────────────────────────────────────────────────────────
		jp	BUS_WRITE8	; b=data byte

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

DO_NMI_HANDLER:				; CODE XREF: NMI_HANDLERj
		call	SRAM_JUMP_SLOT1	; Beginning of SRAM
					; There's a jump slot there
		di	
		ld	hl, CCB_PTR	; Start	of the rest of SRAM
		ld	bc, 7F1h	; Length of the	rest of	SRAM

WIPE_SRAM:				; CODE XREF: DO_NMI_HANDLER+10j
		ld	(hl), 0		; Zero out
		inc	hl
		dec	bc
		ld	a, b
		or	c
		jr	nz, WIPE_SRAM
		ld	a, 0FFh
		ld	(FF_FROM_BEGINNING), a ; NMI handler puts FF here first
		ld	sp, STACK_TOP
		call	INIT_PIO
		call	INIT_PIO	; Why twice?
		ld	a, 0Ah
		ld	(_0A_FROM_BEGINNING), a
		xor	a		; a=0
		ld	(_00_FROM_BEGINNING), a
		ld	(_00_FROM_BEGINNING_0),	a
		ld	hl, ARR12_WIPED_FROM_BEGINNING
		ld	c, 12
		call	MEMSET		; hl=dest, c=count, a=fill
		ld	hl, 0
		ld	(_00_FROM_BEGINNING_1),	hl
		ld	hl, (word_0_1CCB)
		ld	a, (byte_0_1CCD)
		ld	de, CCB_PTR
		ld	bc, 3		; 3 bytes: lo mid hi
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		call	PIO_A_BIT5_OFF
		ld	hl, CCB_PTR
		ld	a, (hl)		; CCB lo. (0x16)
		and	0FEh ; '■'      ; Even address
		ld	e, a
		ld	a, (hl)		; CCB lo (0x16)
		inc	hl
		ld	d, (hl)		; CCB mid (0x04)
		or	(hl)
		inc	hl
		or	(hl)		; CCB hi (0x00)
		ld	a, (hl)
		jp	z, START
		ex	de, hl
		ld	de, _00_FROM_BEGINNING_0
		call	BUS_READ16	; This reads 0x416, 0x417 -- firmware version and cmd reg
		ld	hl, byte_0_26D6
		ld	a, (hl)
		dec	hl
		or	(hl)
		ld	(hl), 0
		cp	1
		jr	nz, loc_0_F7
		ld	(hl), 1

loc_0_F7:				; CODE XREF: DO_NMI_HANDLER+6Ej
		ld	hl, FF_FROM_BEGINNING ;	NMI handler puts FF here first
		ld	(SAVE_DE_ADDR),	hl
		ld	hl, CHANNEL_VECTOR
		call	PICK_CALLBACK
		im	1		; Interrupt mode 1
		ld	hl, SERIAL_SOMETHINGS
		ld	b, 6

loc_0_10A:				; CODE XREF: DO_NMI_HANDLER+95j
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		inc	hl
		ld	(de), a
		inc	de
		ld	a, (hl)
		inc	hl
		ld	(de), a
		inc	de
		ld	a, 28h ; '('
		ld	(de), a
		dec	b
		jr	nz, loc_0_10A
		call	INIT_PIT1	; Set up timer interrupt and UART5
		call	ZERO_TO_SOME_VAR_sub_03AC
		ld	a, 0
		ld	(FF_FROM_BEGINNING), a ; NMI handler puts FF here first
		jp	TAIL_sub_02B4	; Switch task?
; End of function DO_NMI_HANDLER

; ───────────────────────────────────────────────────────────────────────────
CHANNEL_VECTOR:	.db 0			; DATA XREF: DO_NMI_HANDLER+78o
		.dw HANDLER00_sub_1A3D
		.db 1
		.dw HANDLER01_SYS_COMMAND
		.db 2
		.dw HANDLER02_SIO_sub_0A26
		.db 3
		.dw HANDLER03_SIO_sub_0A30
		.db 4
		.dw HANDLER04_SIO_sub_0A3A
		.db 5
		.dw HANDLER05_SIO_sub_0A44
		.db 6
		.dw HANDLER06_SIO_sub_0A4E
		.db 7
		.dw HANDLER07_SIO_sub_0A58
		.db 8
		.dw HANDLER08_FDC_sub_1547 ; On	init
		.db 9
		.dw HANDLER09_RTC_sub_1AD7
		.db 0FFh
SERIAL_SOMETHINGS:.dw unk_0_2570, CH0_BUF, unk_0_259E, CH1_BUF,	unk_0_25CC
					; DATA XREF: DO_NMI_HANDLER+80o
		.dw CH2_BUF, unk_0_25FA, CH3_BUF, unk_0_2628, CH4_BUF
		.dw unk_0_2656,	CH5_BUF

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; hl+=a
; Attributes: bp-based frame

ADD16:					; CODE XREF: sub_0_1BF+6j
					; sub_0_2E9+12p sub_0_44F+4p
					; sub_0_46F+4p	sub_0_4B8+3p ...
		add	a, l
		ld	l, a
		ret	nc
		inc	h
		ret	
; End of function ADD16


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; hl=dest, c=count, a=fill
; Attributes: bp-based frame

MEMSET:					; CODE XREF: DO_NMI_HANDLER+31p
					; MEMSET+3j
					; HANDLER08_FDC_sub_1547+107p
					; HANDLER08_FDC_sub_1547+10Fp
		ld	(hl), a
		inc	hl
		dec	c
		jp	nz, MEMSET	; hl=dest, c=count, a=fill
		ret	
; End of function MEMSET


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_16D:				; CODE XREF: XH_sub_0BA2+23p
					; XH_sub_0BA2+6Ep YH_sub_0F85+10p
					; sub_0_105E+7p
					; FH_JUMP_SLOT5_sub_1097+23p
		push	ix
		push	hl
		pop	ix
		ld	a, (ix+IX_STRUCT.field_4)
		cp	(ix+IX_STRUCT.PORT_BASE_2)
		jp	z, loc_0_1BB
		call	sub_0_1C8
		ld	c, a
		call	sub_0_1BF
		ld	b, (hl)
		ld	a, c
		ld	(ix+IX_STRUCT.field_4),	a
		jp	loc_0_1B7
; End of function sub_0_16D


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_18A:				; CODE XREF: sub_0_1046+13p
					; FH_JUMP_SLOT4_sub_1133+21p
		push	ix
		push	hl
		pop	ix
		ld	a, (ix+IX_STRUCT.PORT_BASE_2)
		call	sub_0_1C8
		cp	(ix+IX_STRUCT.field_4)
		jp	z, loc_0_1BB
		ld	c, a
		call	sub_0_1BF
		ld	(hl), b
		ld	(ix+IX_STRUCT.PORT_BASE_2), c
		jp	loc_0_1B7
; End of function sub_0_18A


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_1A6:				; CODE XREF: sub_0_1046+8p
		push	ix
		push	hl
		pop	ix
		ld	a, (ix+IX_STRUCT.PORT_BASE_2)
		call	sub_0_1C8
		cp	(ix+IX_STRUCT.field_4)
		pop	ix
		ret	
; End of function sub_0_1A6

; ───────────────────────────────────────────────────────────────────────────

loc_0_1B7:				; CODE XREF: sub_0_16D+1Aj
					; sub_0_18A+19j
		push	ix
		pop	hl
		scf	

loc_0_1BB:				; CODE XREF: sub_0_16D+Bj sub_0_18A+Ej
		ccf	
		pop	ix
		ret	

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_1BF:				; CODE XREF: sub_0_16D+12p
					; sub_0_18A+12p
		ld	l, (ix+IX_STRUCT)
		ld	h, (ix+IX_STRUCT.field_1)
		jp	ADD16		; hl+=a
; End of function sub_0_1BF


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_1C8:				; CODE XREF: sub_0_16D+Ep sub_0_18A+8p
					; sub_0_1A6+8p
		inc	a
		cp	(ix+IX_STRUCT.PORT_BASE_1)
		ret	nz
		xor	a
		ret	
; End of function sub_0_1C8


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; hl=host address
; returns b=value
; Attributes: bp-based frame

BUS_READ8:				; CODE XREF: ROM:007Fj
					; BUS_READ8_STH+3j SIO_L1H_sub_0D28+8p
					; ROM:123Ep MONITOR_sub_12A7+Fp ...
		push	ix
		di	
		call	HOST_MEM_WINDOW	; a:h:l	= address hi:mid:low
					; ret hl=0x8xxx	address
					; clobbers ix with 24-bit host mem address pointer
					; 
		ld	b, (hl)
		ld	ix, ARR12_WIPED_FROM_BEGINNING+0Bh
		call	SET_BUS_ADDRESS_LATCH ;	ret hl=0x8xxx address
		ei	
		pop	ix
		ret	
; End of function BUS_READ8


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; b=data byte
; Attributes: bp-based frame

BUS_WRITE8:				; CODE XREF: ROM:0082j
					; BUS_WRITE8_STH+3j sub_0_5B1+13p
					; HANDLER_SIO_L0_COMMON+B7p
					; XH_sub_0BA2+4Fp ...
		push	ix
		di	
		call	HOST_MEM_WINDOW	; a:h:l	= address hi:mid:low
					; ret hl=0x8xxx	address
					; clobbers ix with 24-bit host mem address pointer
					; 
		ld	(hl), b
		ld	ix, ARR12_WIPED_FROM_BEGINNING+0Bh
		call	SET_BUS_ADDRESS_LATCH ;	ret hl=0x8xxx address
		ei	
		pop	ix
		ret	
; End of function BUS_WRITE8


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; ix=24-bit host mem address pointer, (de)=destination
; Attributes: bp-based frame

BUS_READ16:				; CODE XREF: DO_NMI_HANDLER+61p
					; SIO_L1H_sub_065F+10p	sub_0_6AD+Dp
					; SIO0_sub_070B+Cp SIO_L1H_sub_0D4C+8p ...
		ld	bc, 2
		jr	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
; End of function BUS_READ16		; c=count, (de)=source
					; ix=preserved,	interrupts off/on

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; ix=24-bit host mem address pointer, (de)=source
; Attributes: bp-based frame

BUS_WRITE16:				; CODE XREF: HANDLER_SIO_L0_COMMON+95p
					; XH_sub_0BA2+5Ap YH_sub_0F85+42p
		ld	bc, 2
		jr	WRITE_BUS_MEMORY ; hl=host address
; End of function BUS_WRITE16		; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; ix=24-bit host mem address pointer
; c=count, (de)=source
; ix=preserved,	interrupts off/on
; Attributes: bp-based frame

READ_BUS_MEMORY:			; CODE XREF: DO_NMI_HANDLER+46p
					; BUS_READ16+3j SIO0_sub_070B+26p
					; SIO_L1_sub_0E3D+Cp sub_0_E5B+Cp ...
		push	ix
		di			; Interupts off
		call	HOST_MEM_WINDOW	; a:h:l	= address hi:mid:low
					; ret hl=0x8xxx	address
					; clobbers ix with 24-bit host mem address pointer
					; 

READ_BYTE:				; CODE XREF: READ_BUS_MEMORY+Bj
		ld	a, (hl)		; hl=0x8xxx host mem address
		ld	(de), a
		call	NEXT_BUS_BYTE
		jr	nz, READ_BYTE	; hl=0x8xxx host mem address
		ld	ix, ARR12_WIPED_FROM_BEGINNING+0Bh
		call	SET_BUS_ADDRESS_LATCH ;	Reset the latch
		ei	
		pop	ix		; Interrupts on
		ret	
; End of function READ_BUS_MEMORY


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; hl=host address
; ix=24-bit host mem address pointer (for window)
; c=count, (de)=source
; ix=preserved,	interrupts off/on
; Attributes: bp-based frame

WRITE_BUS_MEMORY:			; CODE XREF: BUS_WRITE16+3j
					; DO_CHECK_STUFF+35p SIO_sub_0C4A+1Dp
					; ROM:1221p ROM:1231p	...
		push	ix
		di	
		call	HOST_MEM_WINDOW	; a:h:l	= address hi:mid:low
					; ret hl=0x8xxx	address
					; clobbers ix with 24-bit host mem address pointer
					; 

loc_0_21B:				; CODE XREF: WRITE_BUS_MEMORY+Bj
		ld	a, (de)
		ld	(hl), a
		call	NEXT_BUS_BYTE
		jr	nz, loc_0_21B
		ld	ix, ARR12_WIPED_FROM_BEGINNING+0Bh
		call	SET_BUS_ADDRESS_LATCH ;	ret hl=0x8xxx address
		ei	
		pop	ix
		ret	
; End of function WRITE_BUS_MEMORY


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; a:h:l	= address hi:mid:low
; ret hl=0x8xxx	address
; clobbers ix with 24-bit host mem address pointer
; 
; Attributes: bp-based frame

HOST_MEM_WINDOW:			; CODE XREF: BUS_READ8+3p
					; BUS_WRITE8+3p READ_BUS_MEMORY+3p
					; WRITE_BUS_MEMORY+3p
		ld	ix, BUS_ADDR
		ld	(ix+HOST_RAM_ADDR), l ;	0xfc
		ld	(ix+HOST_RAM_ADDR.MID),	h ; 0xff
		ld	(ix+HOST_RAM_ADDR.HI), a ; 0x01
		jr	SET_BUS_ADDRESS_LATCH ;	ret hl=0x8xxx address
; End of function HOST_MEM_WINDOW


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

NEXT_BUS_BYTE:				; CODE XREF: READ_BUS_MEMORY+8p
					; WRITE_BUS_MEMORY+8p
		ld	ix, BUS_ADDR
		ld	l, (ix+HOST_RAM_ADDR)
		inc	l
		ld	a, (_00_FROM_BEGINNING_0)
		xor	l
		ld	l, a
		inc	(ix+HOST_RAM_ADDR)
		jp	nz, loc_0_25B
		inc	(ix+HOST_RAM_ADDR.MID)
		jp	nz, loc_0_258
		inc	(ix+HOST_RAM_ADDR.HI)

loc_0_258:				; CODE XREF: NEXT_BUS_BYTE+16j
		call	SET_BUS_ADDRESS_LATCH ;	ret hl=0x8xxx address

loc_0_25B:				; CODE XREF: NEXT_BUS_BYTE+10j
		inc	de
		dec	bc
		ld	a, b
		or	c		; Is zero?
		ret	
; End of function NEXT_BUS_BYTE


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; ret hl=0x8xxx	address
; Attributes: bp-based frame

SET_BUS_ADDRESS_LATCH:			; CODE XREF: BUS_READ8+Bp
					; BUS_WRITE8+Bp READ_BUS_MEMORY+11p
					; WRITE_BUS_MEMORY+11p
					; HOST_MEM_WINDOW+Dj ...
		ld	a, (ix+HOST_RAM_ADDR.HI)
		add	a, a
		ld	l, a
		ld	a, (ix+HOST_RAM_ADDR.MID)
		rlca	
		and	1
		or	l
		ld	(ADDRESS_LATCH_SET_VALUE), a
		out	(0), a
		ld	a, (ix+HOST_RAM_ADDR.MID)
		or	80h ; 'Ç'       ; Host addresses are at 0x80..
		ld	h, a		; Top part: 0x80...
		ld	l, (ix+HOST_RAM_ADDR)
		ld	a, (_00_FROM_BEGINNING_0)
		xor	l
		ld	l, a
		ret	
; End of function SET_BUS_ADDRESS_LATCH


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_280:				; CODE XREF: ROM:0079j	sub_0_360+Cp
					; sub_0_360+21p INTH_sub_08A9+42p
					; FH_JUMP_SLOT3_sub_10F3+35p ...
		call	sub_0_292
		ld	(hl), 1
		ret	
; End of function sub_0_280


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_286:				; CODE XREF: ROM:0076j
		call	sub_0_292
		ld	(hl), 0
		ret	
; End of function sub_0_286


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

ZERO_SAVED_TASK_sub_028C:		; CODE XREF: ROM:0073j
					; SIO_sub_0807+3Bp SIO_sub_0807+60p
					; HANDLER_SIO_L0_COMMON+1Ap
					; HANDLER_SIO_L0_COMMON+2Dp ...
		ld	hl, (SAVED_TASK_XXX)
		ld	(hl), 0
		ret	
; End of function ZERO_SAVED_TASK_sub_028C


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_292:				; CODE XREF: sub_0_280p sub_0_286p
		ld	a, l
		add	a, l
		add	a, l
		ld	l, a
		ld	h, 0
		ld	de, byte_0_26DC
		add	hl, de
		ret	
; End of function sub_0_292


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Called from *many* sites
; Attributes: bp-based frame

CHECK_STUFF:				; CODE XREF: ROM:0070j	sub_0_360+Fp
					; sub_0_360+24p SIO0_sub_070B+54p
					; SIO0_sub_070B+57p ...
		push	ix
		push	iy
		push	hl
		push	de
		push	bc
		push	af
		call	DO_CHECK_STUFF
		ld	hl, 0
		add	hl, sp
		ex	de, hl
		ld	hl, (SAVED_TASK_XXX)
		inc	hl
		ld	(hl), e
		inc	hl
		ld	(hl), d
; End of function CHECK_STUFF


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Switch task?
; Attributes: bp-based frame

TAIL_sub_02B4:				; CODE XREF: DO_NMI_HANDLER+A2j
		call	sub_0_2C9
		ld	(SAVED_TASK_XXX), hl
		inc	hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		ld	sp, hl
		pop	af
		pop	bc
		pop	de
		pop	hl
		pop	iy
		pop	ix
		ret	
; End of function TAIL_sub_02B4


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_2C9:				; CODE XREF: TAIL_sub_02B4p
					; sub_0_2C9+10j
		ld	hl, _0A_FROM_BEGINNING
		inc	(hl)
		ld	a, 9
		cp	(hl)
		jr	nc, loc_0_2D4
		ld	(hl), 0

loc_0_2D4:				; CODE XREF: sub_0_2C9+7j
		ld	l, (hl)
		call	sub_0_2DB
		ret	nz
		jr	sub_0_2C9
; End of function sub_0_2C9


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_2DB:				; CODE XREF: sub_0_2C9+Cp
		ld	h, 0
		add	hl, hl
		ld	de, off_0_1CB7
		add	hl, de
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		ld	a, (hl)
		or	a
		ret	
; End of function sub_0_2DB


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; a=1,2,3..; de=handler	addr
; Attributes: bp-based frame

sub_0_2E9:				; CODE XREF: PICK_CALLBACK+9p
		ld	hl, (SAVE_DE_ADDR)
		dec	hl
		ld	(hl), d
		dec	hl
		ld	(hl), e
		ld	de, 65524
		add	hl, de
		push	hl
		ld	l, a
		add	a, l
		add	a, l
		ld	hl, byte_0_26DC
		call	ADD16		; hl+=a
		ld	(hl), 1
		inc	hl
		pop	de
		ld	(hl), e
		inc	hl
		ld	(hl), d
		ld	hl, 65496
		add	hl, de
		ld	(SAVE_DE_ADDR),	hl
		ret	
; End of function sub_0_2E9


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

PICK_CALLBACK:				; CODE XREF: DO_NMI_HANDLER+7Bp
					; PICK_CALLBACK+Dj
		ld	a, (hl)		; a=0, 1, 2...
		inc	hl
		or	a		; OR with itself. S flag = bit 7 on
		ret	m		; S flag means we've reached a -1 = 0xff
		ld	e, (hl)		; e=handler addr lo
		inc	hl
		ld	d, (hl)		;  e=handler addr hi
					; de=handler addr
		inc	hl
		push	hl
		call	sub_0_2E9	; a=1,2,3..; de=handler	addr
		pop	hl
		jp	PICK_CALLBACK
; End of function PICK_CALLBACK


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

INIT_PIO:				; CODE XREF: DO_NMI_HANDLER+1Ap
					; DO_NMI_HANDLER+1Dp
		ld	hl, PIO_COMMAND_A_INIT
		ld	bc, 535h	; PIO -	Command	port A
		otir	
		ld	hl, PIO_COMMAND_B_INIT
		ld	bc, 537h	; PIO -	Command	port B
		otir	
		ret	
; ───────────────────────────────────────────────────────────────────────────
PIO_COMMAND_A_INIT:.db 11001111b, 11011111b, 0,	110111b, 11111111b ; DATA XREF:	INIT_PIOo
					; 1. 1100 1111	 Mode control
					; 2.  1101 1111	   IIOI	IIII (5	= output)
					; 3. 0000 0000	 Interrupt vector 0
					; 4. 0011 0111	 Interrupt control
					; 5. 1111 1111	   Disable all
PIO_COMMAND_B_INIT:.db 11001111b, 10000100b, 0,	110111b, 11111111b ; DATA XREF:	INIT_PIO+8o
; End of function INIT_PIO		; 1. 1100 1111	 Mode control
					; 2.  1000 0100	   IOOO	OIOO
					; 3. 0000 0000	 Interrupt vector 0
					; 4. 0011 0111	 Interrupt control
					; 5. 1111 1111	   Disable all

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; a=result
; Attributes: bp-based frame

PIO_A_NEG_LOW_4_BITS:			; CODE XREF: FDC_NEVIEM_sub_03B6+6p
					; SIO_L1H_sub_0D4C+45p
		in	a, (34h)
		cpl			; complement ~
		and	0Fh
		ret	
; End of function PIO_A_NEG_LOW_4_BITS


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; a=result
; Attributes: bp-based frame

PIO_A_GET_BIT6:				; CODE XREF: sub_0_1AD2p
		in	a, (34h)
		and	40h ; '@'
		ret	
; End of function PIO_A_GET_BIT6


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; a=result
; Attributes: bp-based frame

PIO_A_GET_BIT7_FDC_INTRQ:		; CODE XREF: FDC_READ_TRACK+8p
					; FDC_WRITE_TRACK+8p FDC_RUN_CMD+5p
		in	a, (34h)
		and	80h ; 'Ç'
		ret	
; End of function PIO_A_GET_BIT7_FDC_INTRQ


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Goes to an unpopulated pin (via a driver) a=result
; Attributes: bp-based frame

orphan_PIO_B_GET_BIT2_AUX_FDC:
		in	a, (36h)
		and	4
		ret	
; End of function orphan_PIO_B_GET_BIT2_AUX_FDC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; a=result
; Attributes: bp-based frame

orphan_PIO_B_GET_BIT7_PIT_OUT2:
		in	a, (36h)
		and	80h ; 'Ç'
		ret	
; End of function orphan_PIO_B_GET_BIT7_PIT_OUT2


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

PIO_A_BIT5_ON:				; CODE XREF: DO_CHECK_STUFF+42j
		in	a, (34h)
		or	20h ; ' '
		out	(34h), a
		ret	
; End of function PIO_A_BIT5_ON


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

PIO_A_BIT5_OFF:				; CODE XREF: DO_NMI_HANDLER+49p
					; DO_CHECK_STUFF+15p
		in	a, (34h)
		and	0DFh ; '▀'
		out	(34h), a
		ret	
; End of function PIO_A_BIT5_OFF


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_360:				; CODE XREF: sub_0_8F1+5p
					; FDC_SUBHANDLER02_WRITE_BUS+Fp
					; FDC_SUBHANDLER03_READ_BUS+Fp
					; FDC_SUBHANDLER05_READ_TRACK+Fp
					; FDC_SUBHANDLER06_WRITE_TRACK+Fp
		push	hl

loc_0_361:				; CODE XREF: sub_0_360+12j
		ld	hl, unk_0_2552
		ld	a, (hl)
		or	a
		jr	z, loc_0_374
		ld	a, (byte_0_2551)
		ld	l, a
		call	sub_0_280
		call	CHECK_STUFF	; Called from *many* sites
		jr	loc_0_361
; ───────────────────────────────────────────────────────────────────────────

loc_0_374:				; CODE XREF: sub_0_360+6j
		ld	(hl), 1

loc_0_376:				; CODE XREF: sub_0_360+27j
		ld	hl, unk_0_2553
		ld	a, (hl)
		or	a
		jr	z, loc_0_389
		ld	a, (byte_0_2551)
		ld	l, a
		call	sub_0_280
		call	CHECK_STUFF	; Called from *many* sites
		jr	loc_0_376
; ───────────────────────────────────────────────────────────────────────────

loc_0_389:				; CODE XREF: sub_0_360+1Bj
		ld	(hl), 1
		dec	hl
		ld	(hl), 0
		pop	hl
		ld	a, h
		ld	(byte_0_2551), a
		ld	a, l
		cp	4
		ccf	
		jr	c, ZERO_TO_SOME_VAR_sub_03AC
		ld	c, 0
		call	SHIFT_OR_WHAT	; c=by how much
		in	a, (36h)
		and	0FCh ; '³'      ; BIT1 off
		or	l		; BIT0 on
		out	(36h), a
		ret	
; End of function sub_0_360


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_sub_03A6:				; CODE XREF: SIO_sub_0807+1Dp
		ld	hl, unk_0_2552
		ld	a, (hl)
		or	a
		ret	z
; End of function SIO_sub_03A6


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

ZERO_TO_SOME_VAR_sub_03AC:		; CODE XREF: DO_NMI_HANDLER+9Ap
					; sub_0_360+37j SIO0_sub_06F3+6p
					; FDC_SUBHANDLER02_WRITE_BUS+1Bp
					; FDC_SUBHANDLER03_READ_BUS+1Bp ...
		ld	hl, unk_0_2553
		ld	(hl), 0
		ret	
; End of function ZERO_TO_SOME_VAR_sub_03AC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SELECT_DRIVE:			; CODE XREF: HANDLER08_FDC_sub_1547+1Ep
					; HANDLER08_FDC_sub_1547+56p
		ld	b, 0
		jr	FDC_SET_DRIVE_SELECT
; End of function FDC_SELECT_DRIVE


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; A=param (2?)
; Attributes: bp-based frame

FDC_NEVIEM_sub_03B6:			; CODE XREF: HANDLER08_FDC_sub_1547+6Dp
					; FDC_COMMON_HANDLER+3p
		cp	2
		ccf	
		ret	c
		inc	a
		ld	b, a
		call	PIO_A_NEG_LOW_4_BITS ; a=result
		and	b
		scf	
		ret	z
; End of function FDC_NEVIEM_sub_03B6


FDC_SET_DRIVE_SELECT:			; CODE XREF: FDC_SELECT_DRIVE+2j
		ld	a, b
		dec	a
		ld	(FDC_DRIVE_OR_WHAT), a
		ld	l, b
		ld	c, 3
		call	SHIFT_OR_WHAT	; c=by how much
		in	a, (36h)
		and	0E7h ; 'þ'      ; BIT3 BIT4 off DS0/DS1
		or	l		; BIT0 on
		xor	18h
		out	(36h), a
		ret	

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SET_SIDE:				; CODE XREF: FDC_COMMON_HANDLER+4Dp
					; FDC_DMA_sub_183D+14p
					; FDC_DMA_sub_1864+14p
		cp	2
		ccf	
		ret	c
		ld	l, a
		ld	c, 5
		call	SHIFT_OR_WHAT	; c=by how much
		in	a, (36h)
		and	0DFh ; '▀'      ; BIT5 off (SIDE 0)
		or	l		; BIT0 in
		out	(36h), a
		ret	
; End of function FDC_SET_SIDE


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_DMA_WHAT:				; CODE XREF: FDC_DMA_sub_183D+Ep
					; FDC_DMA_sub_1864+Ep
		cp	2
		ccf	
		ret	c
		ld	l, a
		ld	c, 6
		call	SHIFT_OR_WHAT	; c=by how much
		in	a, (36h)
		and	0BFh ; '┐'      ; what
		or	l		; what
		out	(40h), a
		ret	
; End of function FDC_DMA_WHAT


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; c=by how much
; Attributes: bp-based frame

SHIFT_OR_WHAT:				; CODE XREF: sub_0_360+3Bp ROM:03CAp
					; FDC_SET_SIDE+7p FDC_DMA_WHAT+7p
					; SHIFT_OR_WHAT+3j
		dec	c
		ret	m
		add	hl, hl
		jr	SHIFT_OR_WHAT	; c=by how much
; End of function SHIFT_OR_WHAT


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

DO_CHECK_STUFF:				; CODE XREF: CHECK_STUFF+8p
		ld	hl, HOST_MEM_byte_26FE
		di	
		ld	a, (hl)
		ld	(hl), 0
		ei	
		or	a
		ret	z
		call	FDC_CHECK_sub_0478
		ld	ix, unk_0_2260
		bit	2, (ix+IX_STRUCT.PORT_BASE_1)
		call	z, PIO_A_BIT5_OFF
		bit	3, (ix+IX_STRUCT.PORT_BASE_1)
		jr	nz, loc_0_429
		ld	a, (ix+IX_STRUCT.PORT_BASE_2)
		or	(ix+IX_STRUCT.field_4)
		and	88h ; 'ê'
		jp	z, loc_0_42D

loc_0_429:				; CODE XREF: DO_CHECK_STUFF+1Cj
		set	2, (ix+IX_STRUCT.PORT_BASE_1)

loc_0_42D:				; CODE XREF: DO_CHECK_STUFF+26j
		ld	e, SYS_SYS_STAT	; SYS -	System Status Register
		call	MAKE_CCB_ADDRESS
		ld	bc, 3
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		bit	1, (ix+IX_STRUCT.PORT_BASE_1)
		ret	z
		bit	2, (ix+IX_STRUCT.PORT_BASE_1)
		ret	z
		jp	PIO_A_BIT5_ON
; End of function DO_CHECK_STUFF


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

TAIL_EI:				; CODE XREF: ROM:007Cj	sub_0_458+14j
					; FDC_CHECK_sub_0478+2Fj sub_0_4E6+9j
					; sub_0_4F2+Aj	...
		push	af
		ld	a, (FF_FROM_BEGINNING) ; NMI handler puts FF here first
		or	a
		jr	nz, loc_0_44D
		ei	

loc_0_44D:				; CODE XREF: TAIL_EI+5j
		pop	af
		ret	
; End of function TAIL_EI


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_44F:				; CODE XREF: XH_sub_0BA2+20p
					; XH_sub_0BA2+6Bp SIO_L1H_sub_0C96+2p
					; SIO_L1H_sub_0C96+32p
					; SIO_L1H_sub_0C96+3Cp	...
		push	iy
		pop	hl
		ld	a, b
		call	ADD16		; hl+=a
		ld	a, (hl)
		ret	
; End of function sub_0_44F


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_458:				; CODE XREF: sub_0_969+12p
					; sub_0_996+11p
					; HANDLER_SIO_L0_COMMON+6Bp
					; SIO_sub_0B40+16p sub_0_E96+Bp ...
		call	sub_0_46F
		di	
		or	(hl)
		jp	loc_0_466
; ───────────────────────────────────────────────────────────────────────────

loc_0_460:				; CODE XREF: sub_0_6AD+33p
					; sub_0_6AD+3Bp sub_0_987+Bp
					; sub_0_9B7+10p SIO_L1H_sub_0DE3+5p ...
		call	sub_0_46F
		cpl	
		di	
		and	(hl)

loc_0_466:				; CODE XREF: sub_0_458+5j
		ld	(hl), a
		ld	a, 1
		ld	(HOST_MEM_byte_26FE), a
		jp	TAIL_EI
; End of function sub_0_458


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_46F:				; CODE XREF: sub_0_458p sub_0_458+8p
		ld	hl, ARR12_WIPED_FROM_BEGINNING+1
		add	a, a
		call	ADD16		; hl+=a
		ld	a, b
		ret	
; End of function sub_0_46F


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_CHECK_sub_0478:			; CODE XREF: DO_CHECK_STUFF+Ap
		di	
		ld	hl, 0
		ld	b, 8

loc_0_47E:				; CODE XREF: FDC_CHECK_sub_0478+29j
		ld	de, ARR12_WIPED_FROM_BEGINNING+0Bh
		ld	c, 5
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, hl
		ex	de, hl

loc_0_488:				; CODE XREF: FDC_CHECK_sub_0478+23j
		ld	a, (hl)
		dec	hl
		and	b
		jp	z, loc_0_499
		and	(hl)
		jp	z, loc_0_499
		ld	a, e
		and	0F0h ; '­'
		or	c
		or	8
		ld	e, a

loc_0_499:				; CODE XREF: FDC_CHECK_sub_0478+13j
					; FDC_CHECK_sub_0478+17j
		dec	hl
		dec	c
		jp	p, loc_0_488
		ex	de, hl
		rrc	b
		jp	nc, loc_0_47E
		ld	(_00_FROM_BEGINNING_1),	hl
		jp	TAIL_EI
; End of function FDC_CHECK_sub_0478


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_04AA:				; CODE XREF: FDC_COMMON_HANDLER+64p
					; orphan_sub_193B+2p
		ld	a, (FDC_DRIVE_OR_WHAT)
		or	a
		ld	a, 0Ah
		jr	z, loc_0_4B4
		add	a, 20h ; ' '

loc_0_4B4:				; CODE XREF: FDC_sub_04AA+6j
		add	a, e
		ld	e, a
; End of function FDC_sub_04AA


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


SET_A_TO_6:				; CODE XREF: HANDLER08_FDC_sub_1547+ADp
					; HANDLER08_FDC_sub_1547+B8p
					; HANDLER08_FDC_sub_1547+DBp
					; HANDLER08_FDC_sub_1547+E8p
					; HANDLER08_FDC_sub_1547+14Cp ...
		ld	a, 6
; End of function SET_A_TO_6


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_4B8:				; CODE XREF: SIO_L1H_sub_065F+Cp
					; sub_0_6AD+9p	SIO0_sub_070B+8p
					; SIO0_sub_070B+1Fp SIO_sub_0807+5Ap ...
		ld	hl, byte_0_1CD2
		call	ADD16		; hl+=a
		ld	a, (hl)
		add	a, 6
		add	a, e
		ld	e, a
; End of function sub_0_4B8


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


MAKE_CCB_ADDRESS:			; CODE XREF: DO_CHECK_STUFF+2Fp
					; UNKNOWN_SYS_REG_ADDR+4j ROM:1204p
					; MONITOR_PUTCHAR+29p
					; HANDLER00_sub_1A3D+5p ...
		ld	a, e		; e=offset (0x05)
		ld	hl, unk_0_2260
		call	ADD16		; hl+=a
		push	hl
		ld	a, e
		ld	hl, CCB_PTR
		add	a, (hl)		; add CCB offset to there
		ld	e, a		; bottom byte 0x1b
		call	XXX_ADD_WITH_CARRY
		ld	d, a		; top byte. 0x04
		call	XXX_ADD_WITH_CARRY
		ex	de, hl		; hl=host address
		pop	de
		ret	
; End of function MAKE_CCB_ADDRESS


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

XXX_ADD_WITH_CARRY:			; CODE XREF: MAKE_CCB_ADDRESS+Ep
					; MAKE_CCB_ADDRESS+12p
		inc	hl
		ld	a, 0
		adc	a, (hl)
		ret	
; End of function XXX_ADD_WITH_CARRY


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Maybe	RTC?
; Attributes: bp-based frame

UNKNOWN_SYS_REG_ADDR:			; CODE XREF: HANDLER00_sub_1A3D+5Dp
					; HANDLER09_RTC_sub_1AD7+15p
					; HANDLER09_RTC_sub_1AD7+B1p
					; HANDLER09_RTC_sub_1AD7+BCp
		ld	a, UNKNOWN	; UNKNOWN
		add	a, e
		ld	e, a
		jr	MAKE_CCB_ADDRESS
; End of function UNKNOWN_SYS_REG_ADDR


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; (ix+2) == ioport-1
; b = data out
; a = data in
; Attributes: bp-based frame

sub_0_4E6:				; CODE XREF: XH_sub_0C26+2p
					; XH_sub_0C72+6p SIO_L1H_sub_0C96+1Bp
					; FH_JUMP_SLOT3_sub_10F3+Fp
					; FH_JUMP_SLOT4_sub_1133+9p ...
		di	
		ld	c, (ix+2)
		inc	c
		out	(c), b
		in	a, (c)
		jp	TAIL_EI
; End of function sub_0_4E6


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; write	b,a to port_base_2+1
; save a in (hl)
; (ix+2) == ioport-1
; Attributes: bp-based frame

sub_0_4F2:				; CODE XREF: HANDLER_SIO_L0_COMMON+8p
					; HANDLER_SIO_L0_COMMON+Fp
					; SIO_L1H_sub_0C96+7p
					; SIO_L1H_sub_0C96+37p
					; SIO_L1H_sub_0C96+41p	...
		di	
		ld	(hl), a
		ld	c, (ix+IX_STRUCT.PORT_BASE_1)
		inc	c
		out	(c), b
		out	(c), a
		jp	TAIL_EI
; End of function sub_0_4F2


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_4FF:				; CODE XREF: XH_sub_0BA2+18p
					; XH_sub_0BA2+30p XH_sub_0BA2+73p
					; SIO_sub_0C4A+22p XH_sub_0C72+1Ej ...
		push	af
		cpl	
		di	
		and	(iy+IY_STRUCT.field_23)
		jp	SOME_TAIL
; End of function sub_0_4FF


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

DI_sub_0508:				; CODE XREF: XH_sub_0C72+21j
					; SIO_L1H_sub_0D0C+16p
					; SIO_sub_0E27+13j SIO_L1H_sub_0F22+9j
					; SIO_L1H_sub_0F32+10p	...
		push	af
		di	
		or	(iy+IY_STRUCT.field_23)
; End of function DI_sub_0508


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SOME_TAIL:				; CODE XREF: sub_0_4FF+6j
		ld	(iy+IY_STRUCT.field_23), a
		pop	af
		jp	TAIL_EI
; End of function SOME_TAIL


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

BUS_READ8_STH:				; CODE XREF: XH_sub_0C26+Cp
					; SIO_L1H_sub_0DEC+2Cp	sub_0_1023+Bp
		call	CALCULATE_BUS_IO_STH
		jp	BUS_READ8	; hl=host address
; End of function BUS_READ8_STH		; returns b=value


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

BUS_WRITE8_STH:				; CODE XREF: XH_sub_0BA2+7Bp
		call	CALCULATE_BUS_IO_STH
		jp	BUS_WRITE8	; b=data byte
; End of function BUS_WRITE8_STH


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

CALCULATE_BUS_IO_STH:			; CODE XREF: BUS_READ8_STHp
					; BUS_WRITE8_STHp
		push	iy
		pop	hl
		ld	d, 0
		add	hl, de
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		ex	de, hl
		ret	
; End of function CALCULATE_BUS_IO_STH


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

BUS_LATCH_sub_052D:			; CODE XREF: FDC_HANDLER_COMMON_sub_1781+1p
					; FDC_READ_TRACK+Dp FDC_WRITE_TRACK+Dp
		ld	a, (byte_0_270E)
		ld	hl, (unk_0_270D)

loc_0_533:				; CODE XREF: SIO_L1H_sub_0DEC+27p
					; FDC_sub_1A08+10p
		push	hl
		ld	hl, (word_0_270B)
		ld	(unk_0_270D), hl
		pop	hl
		ld	(word_0_270B+1), a
		ld	a, h
		and	80h ; 'Ç'
		ld	(word_0_270B), a
		push	ix
		ld	ix, ARR12_WIPED_FROM_BEGINNING+0Bh
		call	SET_BUS_ADDRESS_LATCH ;	ret hl=0x8xxx address
		pop	ix
		ret	
; End of function BUS_LATCH_sub_052D


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_550:				; CODE XREF: XH_sub_0C26+1Fp
					; sub_0_1023+1Dp
		push	iy
		pop	hl
		ld	d, 0
		add	hl, de
		scf	

loc_0_557:				; CODE XREF: sub_0_550+11j
		ld	a, (hl)
		sbc	a, 0
		ld	(hl), a
		push	af
		or	d
		ld	d, a
		pop	af
		inc	hl
		dec	b
		jp	nz, loc_0_557
		xor	a
		or	d
		ret	
; End of function sub_0_550


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_567:				; CODE XREF: XH_sub_0C26+18p
					; sub_0_1023+16p
		push	iy
		pop	hl
		ld	d, 0
		add	hl, de
		scf	

loc_0_56E:				; CODE XREF: sub_0_567+11j
		ld	a, (hl)
		adc	a, 0
		ld	(hl), a
		push	af
		or	d
		ld	d, a
		pop	af
		inc	hl
		dec	b
		jp	nz, loc_0_56E
		xor	a
		or	d
		ret	
; End of function sub_0_567


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_57E:				; CODE XREF: sub_0_6AD+2Bp
					; sub_0_987+4p	sub_0_9B7+3p
					; sub_0_9B7+9p	SIO_L1H_sub_0C96+16p ...
		call	sub_0_59D
		ld	a, c
; End of function sub_0_57E


loc_0_582:				; DATA XREF: SIO0_sub_070B+45o
					; SIO_sub_0807+Fo
		call	sub_0_586
		ld	a, b

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


sub_0_586:				; CODE XREF: ROM:0582p
		di	
		cpl	
		and	(hl)
		ld	(hl), a
		inc	hl
		jp	TAIL_EI
; End of function sub_0_586


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_58E:				; CODE XREF: sub_0_969+Bp sub_0_996+Ap
					; XH_sub_0C72+10p SIO_L1H_sub_0C96+25p
					; sub_0_E96+3p	...
		call	sub_0_59D
		ld	a, c
		call	sub_0_596
		ld	a, b
; End of function sub_0_58E


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


sub_0_596:				; CODE XREF: sub_0_58E+4p
		di	
		or	(hl)
		ld	(hl), a
		inc	hl
		jp	TAIL_EI
; End of function sub_0_596


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_59D:				; CODE XREF: sub_0_57Ep sub_0_58Ep
		ld	(iy+IX_STRUCT.field_B+1Ah), 1
		ld	e, (ix+IX_STRUCT.field_8)
		ld	d, (ix+IX_STRUCT.field_9)
		ld	hl, 2
		add	hl, de
		ret	
; End of function sub_0_59D


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_5AC:
		call	sub_0_5D7
		scf	
		ret	z
; End of function orphan_sub_5AC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


sub_0_5B1:				; CODE XREF: XH_sub_0BA2+29p
					; YH_sub_0F85+16p
		push	de
		ld	e, (iy+IY_STRUCT.field_1A)
		ld	d, (iy+IY_STRUCT.field_1B)
		ld	l, (iy+IY_STRUCT.field_15)
		ld	h, (iy+IY_STRUCT.field_16)
		ld	a, (iy+IY_STRUCT.field_17)
		add	hl, de
		adc	a, 0
		call	BUS_WRITE8	; b=data byte
		pop	de
		ld	(iy+IY_STRUCT.field_1A), e
		ld	(iy+IY_STRUCT.field_1B), d
		ret	
; End of function sub_0_5B1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_5CF:				; CODE XREF: XH_sub_0BA2+33p
					; SIO_L1H_sub_0CEE+10p	YH_sub_0F85+1Bp
		ld	e, (iy+IY_STRUCT.field_1A)
		ld	d, (iy+IY_STRUCT.field_1B)
		jr	loc_0_5ED
; End of function sub_0_5CF


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_5D7:				; CODE XREF: orphan_sub_5ACp
					; XH_sub_0BA2+13p YH_sub_0F85+5p
		ld	e, (iy+IY_STRUCT.field_1A)
		ld	d, (iy+IY_STRUCT.field_1B)
		inc	de
		ld	a, (iy+IY_STRUCT.field_18)
		cp	e
		jr	nz, loc_0_5ED
		ld	a, (iy+IY_STRUCT.field_19)
		cp	d
		jr	nz, loc_0_5ED
		ld	de, 0

loc_0_5ED:				; CODE XREF: sub_0_5CF+6j sub_0_5D7+Bj
					; sub_0_5D7+11j
		ld	a, (iy+IY_STRUCT.field_1C)
		cp	e
		ret	nz
		ld	a, (iy+IY_STRUCT.field_1D)
		cp	d
		ret	
; End of function sub_0_5D7


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Set up timer interrupt and UART5
; Attributes: bp-based frame

INIT_PIT1:				; CODE XREF: DO_NMI_HANDLER+97p
		ld	a, 0B4h	; '┤'
		out	(27h), a
		ld	a, 0A8h	; '¿'
		out	(26h), a
		ld	a, 61h ; 'a'
		out	(25h), a
		ret	
; End of function INIT_PIT1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_604:				; CODE XREF: SIO_L1H_sub_0D4C+17p
		ld	e, (ix+IX_STRUCT.field_8)
		ld	d, (ix+IX_STRUCT.field_9)
		ld	hl, 1
		add	hl, de
		ld	a, (hl)
		and	0Fh
		ld	hl, 13h
		add	hl, de
		or	a
		call	nz, sub_0_638
		bit	0, (iy+IY_STRUCT.field_27)
		jr	z, loc_0_622
		ld	hl, loc_0_641

loc_0_622:				; CODE XREF: sub_0_604+19j
		ld	c, (ix+IX_STRUCT.field_5)
		ld	a, (ix+IX_STRUCT.field_6)
		cp	0FFh
		ret	z
		out	(c), a
		ld	c, (ix+IX_STRUCT.field_7)
		ld	a, (hl)
		out	(c), a
		inc	hl
		ld	a, (hl)
		out	(c), a
		ret	
; End of function sub_0_604


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_638:				; CODE XREF: sub_0_604+12p
		dec	a
		add	a, a
		ld	hl, loc_0_641
		call	ADD16		; hl+=a
		ret	
; End of function sub_0_638

; ───────────────────────────────────────────────────────────────────────────

loc_0_641:				; DATA XREF: sub_0_604+1Bo
					; sub_0_638+2o
		ld	b, a
		djnz	loc_0_65B+2
		dec	bc
		inc	de
		add	hl, bc
		inc	hl
		ex	af, af'
		ld	(de), a
		inc	b
		add	hl, bc
		ld	(bc), a
		inc	b
		ld	bc, 0AEh ; '«'
		sbc	a, h
		nop	
		add	a, d
		nop	
		ld	d, a
		nop	
		ld	b, c
		nop	
		dec	hl
		nop	

loc_0_65B:				; CODE XREF: ROM:0642j
		ld	hl, 1000h
		nop	

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_065F:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		bit	1, (ix+IX_STRUCT.LAST)
		jp	z, JUST_RETURN_SH
		ld	a, (ix+IX_STRUCT)
		ld	e, 0
		call	sub_0_4B8
		push	de
		call	BUS_READ16	; ix=24-bit host mem address pointer, (de)=destination
		pop	de
		ld	a, (de)
		ld	hl, ARR12_WIPED_FROM_BEGINNING+2
		res	3, (hl)
		bit	7, a
		jr	z, loc_0_67F
		set	3, (hl)

loc_0_67F:				; CODE XREF: SIO_L1H_sub_065F+1Cj
		ld	hl, ARR12_WIPED_FROM_BEGINNING+4
		res	3, (hl)
		bit	6, a
		jr	z, loc_0_68A
		set	3, (hl)

loc_0_68A:				; CODE XREF: SIO_L1H_sub_065F+27j
		inc	de
		ld	a, (de)
		ld	hl, off_0_69D
		rrca	
		rrca	
		rrca	
		rrca	
		and	0Eh
		call	ADD16		; hl+=a
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		jp	(hl)
; End of function SIO_L1H_sub_065F

; ───────────────────────────────────────────────────────────────────────────
off_0_69D:	.dw nullsub_5, sub_0_6AD, SIO0_sub_070B, SIO0_sub_07E6
					; DATA XREF: SIO_L1H_sub_065F+2Do
		.dw SIO0_sub_06F3, nullsub_5, nullsub_5, nullsub_5

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_6AD:				; DATA XREF: ROM:069Do
		ld	(iy+IY_STRUCT.field_2A), 0
		ld	a, (ix+IX_STRUCT)
		ld	e, 13h
		call	sub_0_4B8
		push	de
		call	BUS_READ16	; ix=24-bit host mem address pointer, (de)=destination
		pop	hl
		ld	a, (hl)
		ld	(iy+IY_STRUCT.field_28), a
		inc	hl
		ld	b, (hl)
		bit	0, b
		jr	z, loc_0_6CC
		set	7, (iy+IY_STRUCT.field_2A)

loc_0_6CC:				; CODE XREF: sub_0_6AD+19j
		call	sub_0_E5B
		call	sub_0_8F1
		call	sub_0_8FA
		ld	bc, 0FFFFh
		call	sub_0_57E
		ld	a, (ix+IX_STRUCT)
		ld	b, 4
		call	loc_0_460
		ld	a, (ix+IX_STRUCT)
		ld	b, 2
		call	loc_0_460
		call	sub_0_996
		set	1, (iy+IY_STRUCT.field_27)
		ret	
; End of function sub_0_6AD


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO0_sub_06F3:				; DATA XREF: ROM:069Do
		call	DMA_ALL_STH
		call	SIO0_CHANA_CTL_STH
		call	ZERO_TO_SOME_VAR_sub_03AC
		call	sub_0_987
		call	sub_0_9B7
		ld	(iy+IY_STRUCT.field_2A), 0
		res	1, (iy+IY_STRUCT.field_27)
		ret	
; End of function SIO0_sub_06F3


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO0_sub_070B:				; DATA XREF: ROM:069Do
		call	sub_0_9B7
		ld	a, (ix+IX_STRUCT)
		ld	e, 0
		call	sub_0_4B8
		push	de
		call	BUS_READ16	; ix=24-bit host mem address pointer, (de)=destination
		pop	hl
		ld	a, (hl)
		and	3Fh ; '?'
		ld	e, a
		inc	hl
		ld	a, (hl)
		and	1Fh
		ld	d, a
		push	de
		ld	a, (ix+IX_STRUCT)
		ld	e, 5
		call	sub_0_4B8
		push	de
		ld	bc, 5
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		pop	hl
		push	hl
		ld	bc, 0A01Ch
		ld	e, (hl)
		ld	(hl), c
		inc	hl
		ld	d, (hl)
		ld	(hl), b
		set	7, d
		inc	hl
		inc	hl
		ld	c, (hl)
		inc	hl
		ld	b, (hl)
		inc	bc
		ld	hl, unk_0_201C
		ex	de, hl
		ldir	
		pop	hl
		ld	bc, 0FF29h	; SIO 0	- Channel A control for	serial port 3
		ld	de, loc_0_582

loc_0_753:				; CODE XREF: SIO0_sub_070B+5Dj
		di	
		in	a, (40h)
		nop	
		nop	
		in	a, (34h)
		and	10h
		jr	z, loc_0_771
		ei	
		call	CHECK_STUFF	; Called from *many* sites
		call	CHECK_STUFF	; Called from *many* sites
		call	CHECK_STUFF	; Called from *many* sites
		djnz	loc_0_753
		set	2, (iy+IY_STRUCT.field_2A)
		pop	de
		jr	loc_0_7D7
; ───────────────────────────────────────────────────────────────────────────

loc_0_771:				; CODE XREF: SIO0_sub_070B+51j
		out	(c), d
		out	(c), e
		ld	a, 3
		out	(c), a
		ld	a, 20h ; ' '
		out	(c), a
		call	DMA_sub_092D
		ld	hl, ARR_3_OR_5_VAL
		ld	b, 5
		otir	
		ld	hl, ARR_7_VAL_29
		ld	bc, 729h	; SIO 0	- Channel A control for	serial port 3
		otir	
		pop	de
		ld	b, e
		call	DELAY_A_BIT	; b=by how much
		ld	a, 87h ; 'ç'
		out	(3Ch), a
		nop	
		nop	
		nop	
		nop	
		ld	a, 0D0h	; 'ð'
		out	(c), a
		set	5, (iy+IY_STRUCT.field_23)
		ei	
		ld	bc, 7D0h

loc_0_7A8:				; CODE XREF: SIO0_sub_070B+A6j
		in	a, (29h)
		bit	6, a
		jr	nz, loc_0_7BC
		dec	bc
		ld	a, b
		or	c
		jr	nz, loc_0_7A8
		set	3, (iy+IY_STRUCT.field_2A)
		call	DMA_ALL_STH
		jr	loc_0_7CA
; ───────────────────────────────────────────────────────────────────────────

loc_0_7BC:				; CODE XREF: SIO0_sub_070B+A1j
		ld	a, 0BFh	; '┐'
		out	(3Ch), a
		in	a, (3Ch)
		bit	5, a
		jr	z, loc_0_7CA
		set	1, (iy+IY_STRUCT.field_2A)

loc_0_7CA:				; CODE XREF: SIO0_sub_070B+AFj
					; SIO0_sub_070B+B9j
		ld	b, d
		inc	b
		inc	b
		call	DELAY_A_BIT	; b=by how much
		call	SIO0_CHANA_CTL_STH
		res	5, (iy+IY_STRUCT.field_23)

loc_0_7D7:				; CODE XREF: SIO0_sub_070B+64j
		call	sub_0_9ED
		jp	nz, loc_0_7E0
		call	sub_0_8FA

loc_0_7E0:				; CODE XREF: SIO0_sub_070B+CFj
		call	sub_0_996
		jp	SIO_sub_0807
; End of function SIO0_sub_070B


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO0_sub_07E6:				; DATA XREF: ROM:069Do
		call	sub_0_9F9
		jr	nz, loc_0_7F0
		call	sub_0_987
		jr	loc_0_7F3
; ───────────────────────────────────────────────────────────────────────────

loc_0_7F0:				; CODE XREF: SIO0_sub_07E6+3j
		call	sub_0_969

loc_0_7F3:				; CODE XREF: SIO0_sub_07E6+8j
		bit	0, (iy+IY_STRUCT.field_2A)
		ret	z
		call	sub_0_9DE
		ret	nz
		call	SIO0_CHANA_CTL_STH
		ld	(iy+IY_STRUCT.field_1A), c
		call	sub_0_8FA
		ret	
; End of function SIO0_sub_07E6


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

nullsub_5:				; DATA XREF: ROM:069Do
		ret	
; End of function nullsub_5


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_sub_0807:				; CODE XREF: SIO0_sub_070B+D8j
					; SIO_sub_0B40+4j
		di	
		bit	6, (iy+IY_STRUCT.field_2A)
		res	6, (iy+IY_STRUCT.field_2A)
		ei	
		jr	z, loc_0_816
		call	sub_0_969

loc_0_816:				; CODE XREF: SIO_sub_0807+Aj
		ld	de, loc_0_582
		di	
		in	a, (40h)
		nop	
		nop	
		in	a, (34h)
		and	10h
		jr	nz, loc_0_85B
		call	SIO_sub_03A6
		jr	z, loc_0_85B
		ld	c, 29h ; ')'
		bit	7, (iy+IY_STRUCT.field_2A)
		jr	z, loc_0_835
		out	(c), d
		out	(c), e

loc_0_835:				; CODE XREF: SIO_sub_0807+28j
		ld	a, 3
		out	(c), a
		ld	a, 20h ; ' '
		out	(c), a
		set	0, (iy+IY_STRUCT.field_2A)
		ei	
		call	ZERO_SAVED_TASK_sub_028C
		call	sub_0_8F1

loc_0_848:				; CODE XREF: SIO_sub_0807+4Aj
		call	CHECK_STUFF	; Called from *many* sites
		ld	a, (byte_0_2551)
		cp	(ix+IX_STRUCT.field_1)
		jr	nz, loc_0_848
		call	sub_0_9ED
		jr	nz, loc_0_85B
		call	sub_0_8FA

loc_0_85B:				; CODE XREF: SIO_sub_0807+1Bj
					; SIO_sub_0807+20j SIO_sub_0807+4Fj
		ei	
		ld	e, 4
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		ex	de, hl
		bit	7, (hl)
		call	z, ZERO_SAVED_TASK_sub_028C
		ret	
; End of function SIO_sub_0807


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

XINTH_sub_086B:				; CODE XREF: JINTH_sub_1070+4j
		and	a
		bit	5, (iy+IY_STRUCT.field_23)
		ret	nz
		ld	b, 2

loc_0_873:				; CODE XREF: XINTH_sub_086B+1Fj
		ld	a, 1
		out	(29h), a
		in	a, (29h)
		bit	5, a
		jr	nz, INTH_sub_08A9
		bit	7, a
		jr	nz, INTH_sub_08A9
		bit	4, (iy+IY_STRUCT.field_2A)
		ret	nz
		bit	6, a
		jr	nz, loc_0_88D
		djnz	loc_0_873
		ret	
; ───────────────────────────────────────────────────────────────────────────

loc_0_88D:				; CODE XREF: XINTH_sub_086B+1Dj
		bit	0, (iy+IY_STRUCT.field_2A)
		jr	nz, loc_0_89A
		set	4, (iy+IY_STRUCT.field_2A)
		scf	
		reti	
; ───────────────────────────────────────────────────────────────────────────

loc_0_89A:				; CODE XREF: XINTH_sub_086B+26j
		in	a, (28h)
		ld	(iy+IY_STRUCT.field_29), a
		set	5, (iy+IY_STRUCT.field_2A)
		call	SIO0_CHANA_CTL_STH
		scf	
		reti	
; End of function XINTH_sub_086B


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

INTH_sub_08A9:				; CODE XREF: XINTH_sub_086B+10j
					; XINTH_sub_086B+14j
		push	af
		ld	hl, DMA_ALL_3
		ld	bc, 33Ch	; DMA -	All read and write registers
		otir	
		ld	e, 6
		call	sub_0_9CB
		ld	b, 2
		inir	
		call	DMA_ALL_STH
		in	a, (28h)
		pop	af
		and	60h ; '`'
		or	1
		dec	hl
		dec	hl
		dec	hl
		ld	(hl), a
		call	SIO0_CHANA_CTL_STH
		call	sub_0_9DE
		jr	nz, loc_0_8D9
		ld	(iy+IY_STRUCT.field_1A), c
		call	sub_0_8FA
		jr	loc_0_8E0
; ───────────────────────────────────────────────────────────────────────────

loc_0_8D9:				; CODE XREF: INTH_sub_08A9+26j
		set	0, (iy+IY_STRUCT.field_2A)
		call	SIO0_sub_0918

loc_0_8E0:				; CODE XREF: INTH_sub_08A9+2Ej
		set	6, (iy+IY_STRUCT.field_2A)
		res	4, (iy+IY_STRUCT.field_2A)
		ld	l, (ix+IX_STRUCT.field_1)
		call	sub_0_280
		scf	
		reti	
; End of function INTH_sub_08A9


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_8F1:				; CODE XREF: sub_0_6AD+22p
					; SIO_sub_0807+3Ep
		ld	h, (ix+IX_STRUCT.field_1)
		ld	l, 1
		call	sub_0_360
		ret	
; End of function sub_0_8F1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_8FA:				; CODE XREF: sub_0_6AD+25p
					; SIO0_sub_070B+D2p SIO0_sub_07E6+1Cp
					; SIO_sub_0807+51p INTH_sub_08A9+2Bp
		ld	e, 0
		call	sub_0_9CB
		di	
		call	DMA_sub_092D
		ld	hl, ARR_3_OR_5_VAL
		ld	b, 3
		otir	
		res	0, (iy+IY_STRUCT.field_2A)
		call	SIO0_sub_0918
		ld	a, 87h ; 'ç'
		out	(3Ch), a
		jp	TAIL_EI
; End of function sub_0_8FA


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO0_sub_0918:				; CODE XREF: INTH_sub_08A9+34p
					; sub_0_8FA+14p
		ld	hl, SIO0_CHAN_A_CONTROL_VALS
		ld	bc, 829h
		otir	
		ld	a, (iy+IY_STRUCT.field_28)
		out	(c), a
		ld	hl, ARR_6_VAL
		ld	b, 6
		otir	
		ret	
; End of function SIO0_sub_0918


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

DMA_sub_092D:				; CODE XREF: SIO0_sub_070B+72p
					; sub_0_8FA+6p
		push	hl
		ld	hl, ARR_5_DMA_ALL
		ld	bc, 53Ch	; DMA -	All read and write registers
		otir	
		pop	hl
		ld	a, (hl)
		out	(c), a
		inc	hl
		ld	a, (hl)
		xor	80h ; 'Ç'
		out	(c), a
		inc	hl
		inc	hl
		ld	b, 2
		otir	
		ret	
; End of function DMA_sub_092D

; ───────────────────────────────────────────────────────────────────────────
ARR_5_DMA_ALL:	.db 0C3h, 14h, 28h, 92h, 79h ; DATA XREF: DMA_sub_092D+1o
ARR_3_OR_5_VAL:	.db 85h, 28h, 0CFh, 5, 0CFh ; DATA XREF: SIO0_sub_070B+75o
					; sub_0_8FA+9o
DMA_ALL_3:	.db 0BBh, 6, 0A7h	; DATA XREF: INTH_sub_08A9+1o
ARR_7_VAL_29:	.db 14h, 20h, 11h, 0C0h, 5, 0EBh, 80h ;	DATA XREF: SIO0_sub_070B+7Co
SIO0_CHAN_A_CONTROL_VALS:.db 18h, 4, 20h, 15h, 80h, 3, 0FCh, 6 ; DATA XREF: SIO0_sub_0918o
ARR_6_VAL:	.db 7, 7Eh, 11h, 0ECh, 23h, 0FDh ; DATA	XREF: SIO0_sub_0918+Do

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_969:				; CODE XREF: SIO0_sub_07E6+Ap
					; SIO_sub_0807+Cp
		ld	a, (iy+IY_STRUCT.field_2A)
		and	20h ; ' '
		or	40h ; '@'
		ld	b, (iy+IY_STRUCT.field_29)
		ld	c, a
		call	sub_0_58E
		ld	a, 1
		ld	b, 8
		call	sub_0_458
		res	5, (iy+IY_STRUCT.field_2A)
		ld	(iy+IY_STRUCT.field_29), 0
		ret	
; End of function sub_0_969


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_987:				; CODE XREF: SIO0_sub_06F3+9p
					; SIO0_sub_07E6+5p
		ld	b, 0FFh
		ld	c, 60h ; '`'
		call	sub_0_57E
		ld	a, 1
		ld	b, 8
		call	loc_0_460
		ret	
; End of function sub_0_987


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_996:				; CODE XREF: sub_0_6AD+3Ep
					; SIO0_sub_070B+D5p
		ld	a, (iy+IY_STRUCT.field_2A)
		and	0Eh
		or	1
		ld	b, 0
		ld	c, a
		call	sub_0_58E
		ld	a, 2
		ld	b, 8
		call	sub_0_458
		res	1, (iy+IY_STRUCT.field_2A)
		res	3, (iy+IY_STRUCT.field_2A)
		res	2, (iy+IY_STRUCT.field_2A)
		ret	
; End of function sub_0_996


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_9B7:				; CODE XREF: SIO0_sub_06F3+Cp
					; SIO0_sub_070Bp
		ld	bc, 1
		call	sub_0_57E
		ld	bc, 0Eh
		call	sub_0_57E
		ld	a, 2
		ld	b, 8
		call	loc_0_460
		ret	
; End of function sub_0_9B7


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_9CB:				; CODE XREF: INTH_sub_08A9+Bp
					; sub_0_8FA+2p
		ld	a, (iy+IY_STRUCT.field_1A)
; End of function sub_0_9CB


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


sub_0_9CE:				; CODE XREF: sub_0_9ED+6p sub_0_9F9+6p
		rlca	
		rlca	
		rlca	
		add	a, e
		ld	l, (iy+IY_STRUCT.field_15)
		ld	h, (iy+IY_STRUCT.field_16)
		call	ADD16		; hl+=a
		set	7, h
		ret	
; End of function sub_0_9CE


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_9DE:				; CODE XREF: SIO0_sub_07E6+12p
					; INTH_sub_08A9+23p
		ld	b, (iy+IY_STRUCT.field_18)
		ld	c, (iy+IY_STRUCT.field_1A)
		inc	c
		ld	a, b
		cp	c
		jr	nz, loc_0_9F0
		ld	c, 0
		jr	loc_0_9F0
; End of function sub_0_9DE


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_9ED:				; CODE XREF: SIO0_sub_070B+CCp
					; SIO_sub_0807+4Cp
		ld	c, (iy+IY_STRUCT.field_1A)

loc_0_9F0:				; CODE XREF: sub_0_9DE+9j sub_0_9DE+Dj
		ld	a, c
		ld	e, 5
		call	sub_0_9CE
		bit	0, (hl)
		ret	
; End of function sub_0_9ED


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_9F9:				; CODE XREF: SIO0_sub_07E6p
		ld	b, (iy+IY_STRUCT.field_18)

loc_0_9FC:				; CODE XREF: sub_0_9F9+Cj
		ld	a, b
		ld	e, 5
		call	sub_0_9CE
		bit	0, (hl)
		ret	nz
		djnz	loc_0_9FC
		ret	
; End of function sub_0_9F9


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_A08:
		ld	bc, 2000

loc_0_A0B:				; CODE XREF: orphan_sub_A08+Bj
		bit	4, (iy+IY_STRUCT.field_2A)
		ret	z
		dec	bc
		ld	a, b
		or	c
		jr	nz, loc_0_A0B
		ret	
; End of function orphan_sub_A08


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO0_CHANA_CTL_STH:			; CODE XREF: SIO0_sub_06F3+3p
					; SIO0_sub_070B+C5p SIO0_sub_07E6+16p
					; XINTH_sub_086B+38p INTH_sub_08A9+20p
		ld	a, 18h
		out	(29h), a
		ret	
; End of function SIO0_CHANA_CTL_STH


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

DMA_ALL_STH:				; CODE XREF: SIO0_sub_06F3p
					; SIO0_sub_070B+ACp INTH_sub_08A9+12p
		ld	a, 0C3h	; '├'
		out	(3Ch), a
		ret	
; End of function DMA_ALL_STH


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; b=by how much
; Attributes: bp-based frame

DELAY_A_BIT:				; CODE XREF: SIO0_sub_070B+86p
					; SIO0_sub_070B+C2p DELAY_A_BIT+3j
		call	locret_0_A25
		djnz	DELAY_A_BIT	; b=by how much

locret_0_A25:				; CODE XREF: DELAY_A_BITp
		ret	
; End of function DELAY_A_BIT


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER02_SIO_sub_0A26:			; DATA XREF: ROM:0131o
		ld	ix, IX_stru_1BFE
		ld	iy, IY_CH0_stru_2568
		jr	HANDLER_SIO_L0_COMMON ;	i0X27D7,iy=pointers
; End of function HANDLER02_SIO_sub_0A26 ; (ix+2) == ioport-1, (ix+3) == ioport-1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER03_SIO_sub_0A30:			; DATA XREF: ROM:0134o
		ld	ix, IX_stru_1C0B
		ld	iy, IY_CH1_stru_2596
		jr	HANDLER_SIO_L0_COMMON ;	i0X27D7,iy=pointers
; End of function HANDLER03_SIO_sub_0A30 ; (ix+2) == ioport-1, (ix+3) == ioport-1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER04_SIO_sub_0A3A:			; DATA XREF: ROM:0137o
		ld	ix, IX_stru_1C18
		ld	iy, IY_CH2_stru_25C4
		jr	HANDLER_SIO_L0_COMMON ;	i0X27D7,iy=pointers
; End of function HANDLER04_SIO_sub_0A3A ; (ix+2) == ioport-1, (ix+3) == ioport-1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER05_SIO_sub_0A44:			; DATA XREF: ROM:013Ao
		ld	ix, IX_stru_1C25
		ld	iy, IY_CH3_stru_25F2
		jr	HANDLER_SIO_L0_COMMON ;	i0X27D7,iy=pointers
; End of function HANDLER05_SIO_sub_0A44 ; (ix+2) == ioport-1, (ix+3) == ioport-1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER06_SIO_sub_0A4E:			; DATA XREF: ROM:013Do
		ld	ix, IX_stru_1C32
		ld	iy, IY_CH4_stru_2620
		jr	HANDLER_SIO_L0_COMMON ;	i0X27D7,iy=pointers
; End of function HANDLER06_SIO_sub_0A4E ; (ix+2) == ioport-1, (ix+3) == ioport-1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER07_SIO_sub_0A58:			; DATA XREF: ROM:0140o
		ld	ix, IX_stru_1C3F
		ld	iy, IY_CH5_stru_264E
; End of function HANDLER07_SIO_sub_0A58


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; i0X27D7,iy=pointers
; (ix+2) == ioport-1, (ix+3) ==	ioport-1
; Attributes: bp-based frame

HANDLER_SIO_L0_COMMON:			; CODE XREF: HANDLER02_SIO_sub_0A26+8j
					; HANDLER03_SIO_sub_0A30+8j
					; HANDLER04_SIO_sub_0A3A+8j
					; HANDLER05_SIO_sub_0A44+8j
					; HANDLER06_SIO_sub_0A4E+8j ...
		ld	(iy+IY_STRUCT.field_26), 0
		ld	b, 2
		ld	a, 0
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	b, 1
		ld	a, 4
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	de, JINTH_sub_1070 ; (ix+3) == ioport-1
					; de = return address
		call	STH_INT_RELATED_PERHAPS
		jr	nc, loc_0_A82
		call	ZERO_SAVED_TASK_sub_028C
		call	CHECK_STUFF	; Called from *many* sites
		jr	HANDLER_SIO_L0_COMMON ;	i0X27D7,iy=pointers
					; (ix+2) == ioport-1, (ix+3) ==	ioport-1
; ───────────────────────────────────────────────────────────────────────────

loc_0_A82:				; CODE XREF: HANDLER_SIO_L0_COMMON+18j
		call	CHECK_STUFF	; Called from *many* sites
		ei	

loc_0_A86:				; CODE XREF: HANDLER_SIO_L0_COMMON+33j
					; HANDLER_SIO_L0_COMMON+BDj
		ld	a, (_00_FROM_BEGINNING)
		bit	0, a
		jr	nz, loc_0_A95
		call	ZERO_SAVED_TASK_sub_028C
		call	CHECK_STUFF	; Called from *many* sites
		jr	loc_0_A86
; ───────────────────────────────────────────────────────────────────────────

loc_0_A95:				; CODE XREF: HANDLER_SIO_L0_COMMON+2Bj
		ld	hl, loc_0_AE1
		push	hl
		ld	c, (ix+IX_STRUCT.field_8)
		ld	b, (ix+IX_STRUCT.field_9)
		ld	hl, 4
		add	hl, bc
		ld	a, (hl)
		bit	7, a
		jp	z, SIO_sub_0B40
		ld	(iy+IY_STRUCT.field_26), 1
		push	hl
		res	7, a
		rrca	
		rrca	
		rrca	
		rrca	
		and	0Fh
		ld	b, a
		ld	a, (ix+IX_STRUCT)
		add	a, a
		ld	hl, ARR12_WIPED_FROM_BEGINNING
		call	ADD16		; hl+=a
		ld	a, (hl)
		and	8
		or	b
		ld	(hl), a
		ld	b, 0
		ld	a, (ix+IX_STRUCT)
		call	sub_0_458
		pop	hl
		ld	a, (hl)
		and	0Fh
		cp	10h
		ret	nc
		add	a, a
		ld	hl, V_SIO_L0_off_0B20
		call	ADD16		; hl+=a
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		jp	(hl)
; ───────────────────────────────────────────────────────────────────────────

loc_0_AE1:				; DATA XREF: HANDLER_SIO_L0_COMMON+35o
		di	
		ld	a, (iy+IY_STRUCT.field_25)
		ld	(iy+IY_STRUCT.field_25), 0
		ei	
		or	a
		jr	z, loc_0_AF8
		ld	e, 2
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		call	BUS_WRITE16	; ix=24-bit host mem address pointer, (de)=source

loc_0_AF8:				; CODE XREF: HANDLER_SIO_L0_COMMON+8Bj
		ld	a, (iy+IY_STRUCT.field_26)
		or	a
		jr	z, loc_0_B1A
		ld	(iy+IY_STRUCT.field_26), 0
		ld	e, 4
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		ex	de, hl
		ld	b, (hl)
		ld	(hl), 0
		ex	de, hl
		bit	7, b
		push	af
		ld	a, b
		and	70h ; 'p'
		ld	b, a
		pop	af
		call	nz, BUS_WRITE8	; b=data byte

loc_0_B1A:				; CODE XREF: HANDLER_SIO_L0_COMMON+9Cj
		call	CHECK_STUFF	; Called from *many* sites
		jp	loc_0_A86
; ───────────────────────────────────────────────────────────────────────────
V_SIO_L0_off_0B20:.dw SIO_L1H_nullsub_2, SIO_L1H_sub_0C96, SIO_L1H_sub_0D0C
					; DATA XREF: HANDLER_SIO_L0_COMMON+76o
		.dw SIO_L1H_sub_0CEE, SIO_L1H_sub_0CEB,	SIO_L1H_nullsub_2
		.dw SIO_L1H_sub_0D28, SIO_L1H_sub_065F,	SIO_L1H_sub_0D4C
		.dw SIO_L1H_sub_0DDC, SIO_L1H_sub_0DE3,	SIO_L1H_sub_0DEC
		.dw SIO_L1H_sub_0EC3, SIO_L1H_sub_0F2E,	SIO_L1H_sub_0F22
		.dw SIO_L1H_sub_0F32
; End of function HANDLER_SIO_L0_COMMON


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_sub_0B40:				; CODE XREF: HANDLER_SIO_L0_COMMON+46j
					; XH_sub_0BA2+60j XH_sub_0BA2+66j
					; XH_sub_0BA2+76j XH_sub_0BA2+81j ...
		bit	1, (iy+IY_STRUCT.field_27)
		jp	nz, SIO_sub_0807
		ld	a, (iy+IY_STRUCT.LAST)
		ld	(iy+IY_STRUCT.LAST), 0
		or	a
		jr	z, loc_0_B59
		ld	a, (ix+IX_STRUCT)
		ld	b, 1
		call	sub_0_458

loc_0_B59:				; CODE XREF: SIO_sub_0B40+Fj
		bit	0, (iy+IY_STRUCT.field_27)
		ld	hl, off_0_B72
		jr	z, loc_0_B65
		ld	hl, off_0_B82

loc_0_B65:				; CODE XREF: SIO_sub_0B40+20j
		ld	a, (iy+IY_STRUCT.field_23)
		and	3Eh ; '>'
		call	ADD16		; hl+=a
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		jp	(hl)
; End of function SIO_sub_0B40

; ───────────────────────────────────────────────────────────────────────────
off_0_B72:	.dw XH_sub_0C72, XH_sub_0C72, XH_sub_0C72, XH_sub_0BA2
					; DATA XREF: SIO_sub_0B40+1Do
		.dw XH_sub_0C26, XH_sub_0C26, XH_sub_0C26, XH_sub_0BA2 ; (ix+2)	== ioport-1
					; b = data out
off_0_B82:	.dw YH_nullsub_3, YH_sub_0F52, YH_sub_0F85, YH_sub_0F52
					; DATA XREF: SIO_sub_0B40+22o
		.dw YH_sub_0FD6, YH_sub_0FD6, YH_sub_0FD6, YH_sub_0FD6
		.dw YH_sub_1014, YH_sub_1014, YH_sub_1014, YH_sub_1014
		.dw YH_sub_100B, YH_sub_100B, YH_sub_100B, YH_sub_100B

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

XH_sub_0BA2:				; DATA XREF: ROM:0B72o
		ld	e, 0
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		ex	de, hl
		bit	7, (hl)
		jp	z, loc_0_C0B
		call	sub_0_E5B
		push	hl
		push	de

loc_0_BB5:				; CODE XREF: XH_sub_0BA2+2Cj
		call	sub_0_5D7
		ld	a, 2
		call	z, sub_0_4FF
		jr	z, loc_0_BD5
		push	de
		ld	b, 8
		call	sub_0_44F
		call	sub_0_16D
		pop	de
		jr	c, loc_0_BD0
		call	sub_0_5B1
		jr	loc_0_BB5
; ───────────────────────────────────────────────────────────────────────────

loc_0_BD0:				; CODE XREF: XH_sub_0BA2+27j
		ld	a, 4
		call	sub_0_4FF

loc_0_BD5:				; CODE XREF: XH_sub_0BA2+1Bj
		call	sub_0_5CF
		pop	hl
		pop	de
		jr	z, loc_0_C05
		ld	bc, 9
		ldir	
		ld	a, (iy+IY_STRUCT.field_19)
		or	a
		jr	z, loc_0_BF4
		ld	e, 10h
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		ld	b, 80h ; 'Ç'
		call	BUS_WRITE8	; b=data byte

loc_0_BF4:				; CODE XREF: XH_sub_0BA2+43j
		ld	e, 0Fh
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		call	BUS_WRITE16	; ix=24-bit host mem address pointer, (de)=source
		call	sub_0_E96
		jp	SIO_sub_0B40
; ───────────────────────────────────────────────────────────────────────────

loc_0_C05:				; CODE XREF: XH_sub_0BA2+38j
		call	sub_0_E87
		jp	SIO_sub_0B40
; ───────────────────────────────────────────────────────────────────────────

loc_0_C0B:				; CODE XREF: XH_sub_0BA2+Bj
		ld	b, 8
		call	sub_0_44F
		call	sub_0_16D
		ld	a, 4
		call	c, sub_0_4FF
		jp	c, SIO_sub_0B40
		ld	e, 12h
		call	BUS_WRITE8_STH
		call	sub_0_E96
		jp	SIO_sub_0B40
; End of function XH_sub_0BA2


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; (ix+2) == ioport-1
; b = data out
; Attributes: bp-based frame

XH_sub_0C26:				; CODE XREF: XH_sub_0C26+22j
					; DATA XREF: ROM:0B72o
		ld	b, 0
		call	sub_0_4E6	; (ix+2) == ioport-1
					; b = data out
					; a = data in
		and	0Ch
		xor	0Ch
		ret	nz
		ld	e, 1Eh
		call	BUS_READ8_STH
		ld	c, (ix+IX_STRUCT.PORT_BASE_1)
		out	(c), b
		ld	e, 1Eh
		ld	b, 3
		call	sub_0_567
		ld	e, 21h ; '!'
		ld	b, 2
		call	sub_0_550
		jr	nz, XH_sub_0C26	; recurse
; End of function XH_sub_0C26


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


SIO_sub_0C4A:				; CODE XREF: SIO_L1H_sub_0C96+4Ep
					; SIO_L1H_sub_0CEBj
		ld	e, 5
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		push	hl
		push	de
		push	af
		push	iy
		pop	hl
		ld	bc, 1Eh
		add	hl, bc
		ld	bc, 5
		ldir	
		pop	af
		pop	de
		pop	hl
		ld	bc, 5
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	a, 8
		call	sub_0_4FF
		jp	sub_0_EA5
; End of function SIO_sub_0C4A


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

XH_sub_0C72:				; DATA XREF: ROM:0B72o
		ld	(iy+IY_STRUCT.field_25), 1
		ld	b, 1
		call	sub_0_4E6	; (ix+2) == ioport-1
					; b = data out
					; a = data in
		and	1
		jr	z, loc_0_C88
		ld	bc, 1
		call	sub_0_58E
		call	ZERO_SAVED_TASK_sub_028C

loc_0_C88:				; CODE XREF: XH_sub_0C72+Bj
		ld	a, (iy+IY_STRUCT.field_B)
		cp	(iy+IY_STRUCT.field_C)
		ld	a, 4
		jp	z, sub_0_4FF
		jp	DI_sub_0508
; End of function XH_sub_0C72


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0C96:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ld	b, 0
		call	sub_0_44F
		ld	a, 18h
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		call	SIO_sub_0E27
		call	SIO_L1H_sub_0D4C
		call	SIO_L1H_sub_0DDC
		ld	bc, 0Ah
		call	sub_0_57E
		ld	b, 0
		call	sub_0_4E6	; (ix+2) == ioport-1
					; b = data out
					; a = data in
		rrca	
		rrca	
		and	0Ah
		ld	c, a
		ld	b, 0
		call	sub_0_58E
		ld	(iy+IY_STRUCT.field_B),	0
		ld	(iy+IX_STRUCT.LAST), 0
		ld	b, 3
		call	sub_0_44F
		or	1
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	b, 5
		call	sub_0_44F
		or	8
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	b, 1
		call	sub_0_44F
		or	1Dh
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		call	SIO_sub_0C4A
		jp	SIO_L1H_sub_0DDC
; End of function SIO_L1H_sub_0C96


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_nullsub_2:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ret	
; End of function SIO_L1H_nullsub_2


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0CEB:			; CODE XREF: SIO_L1H_sub_0D0C+9j
					; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		jp	SIO_sub_0C4A
; End of function SIO_L1H_sub_0CEB


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0CEE:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ld	e, 0
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		ex	de, hl
		bit	7, (hl)
		jr	z, loc_0_D03
		call	sub_0_E5B
		call	sub_0_5CF
		jr	nz, loc_0_D06

loc_0_D03:				; CODE XREF: SIO_L1H_sub_0CEE+Bj
		call	sub_0_E87

loc_0_D06:				; CODE XREF: SIO_L1H_sub_0CEE+13j
		call	SIO_sub_0E27
		jp	SIO_sub_0B40
; End of function SIO_L1H_sub_0CEE


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0D0C:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		call	SIO_L1_sub_0E3D
		ld	a, (iy+IY_STRUCT.field_21)
		or	(iy+IY_STRUCT.field_22)
		jr	z, SIO_L1H_sub_0CEB
		ld	bc, 1
		call	sub_0_57E
		call	sub_0_EB4
		ld	a, 8
		call	DI_sub_0508
		jp	SIO_sub_0B40
; End of function SIO_L1H_sub_0D0C


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0D28:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ld	a, (ix+IX_STRUCT)
		ld	e, 0
		call	sub_0_4B8
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	6, b
		jr	z, loc_0_D3E
		call	SIO_L1_sub_0D46
		or	10h
		jr	loc_0_D43
; ───────────────────────────────────────────────────────────────────────────

loc_0_D3E:				; CODE XREF: SIO_L1H_sub_0D28+Dj
		call	SIO_L1_sub_0D46
		and	0EFh ; '´'

loc_0_D43:				; CODE XREF: SIO_L1H_sub_0D28+14j
		jp	sub_0_4F2	; write	b,a to port_base_2+1
; End of function SIO_L1H_sub_0D28	; save a in (hl)
					; (ix+2) == ioport-1

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1_sub_0D46:			; CODE XREF: SIO_L1H_sub_0D28+Fp
					; SIO_L1H_sub_0D28+16p
		ld	b, 5
		call	sub_0_44F
		ret	
; End of function SIO_L1_sub_0D46


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0D4C:			; CODE XREF: SIO_L1H_sub_0C96+Dp
					; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ld	a, (ix+IX_STRUCT)
		ld	e, 13h
		call	sub_0_4B8
		call	BUS_READ16	; ix=24-bit host mem address pointer, (de)=destination
		ld	a, (ix+IX_STRUCT)
		ld	e, 0
		call	sub_0_4B8
		push	de
		call	BUS_READ16	; ix=24-bit host mem address pointer, (de)=destination
		call	sub_0_604
		pop	hl
		push	hl
		ld	a, (hl)
		rrca	
		rrca	
		rrca	
		rrca	
		and	3
		ld	hl, byte_0_1CCE
		call	ADD16		; hl+=a
		ld	a, (hl)
		ld	(iy+IY_STRUCT.field_24), a
		pop	hl
		ld	a, (hl)
		and	0Fh
		or	40h ; '@'
		ld	(iy+IY_STRUCT.field_4),	a
		ld	b, 8
		ld	a, (hl)
		and	30h ; '0'
		add	a, a
		or	b
		inc	hl
		bit	1, (ix+IX_STRUCT.LAST)
		jr	z, loc_0_D99
		ld	b, a
		call	PIO_A_NEG_LOW_4_BITS ; a=result
		bit	2, a
		ld	a, b
		jr	nz, loc_0_DA7

loc_0_D99:				; CODE XREF: SIO_L1H_sub_0D4C+42j
		bit	7, (hl)
		jp	z, loc_0_DA0
		set	7, a

loc_0_DA0:				; CODE XREF: SIO_L1H_sub_0D4C+4Fj
		bit	6, (hl)
		jp	z, loc_0_DA7
		set	1, a

loc_0_DA7:				; CODE XREF: SIO_L1H_sub_0D4C+4Bj
					; SIO_L1H_sub_0D4C+56j
		ld	(iy+IY_STRUCT.field_5),	a
		dec	hl
		ld	a, (hl)
		and	30h ; '0'
		add	a, a
		add	a, a
		ld	b, a
		ld	a, (iy+IY_STRUCT.field_3)
		and	1
		or	b
		ld	(iy+IY_STRUCT.field_3),	a
		ld	(iy+IY_STRUCT.field_1),	1Dh
		push	iy
		pop	hl
		inc	hl
		ld	b, 1
		call	SIO_L1_sub_0DD6
		ld	b, 2
		inc	hl
		ld	b, 3
		call	SIO_L1_sub_0DD6
		ld	b, 4
		call	SIO_L1_sub_0DD6
		ld	b, 5
; End of function SIO_L1H_sub_0D4C


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


SIO_L1_sub_0DD6:			; CODE XREF: SIO_L1H_sub_0D4C+78p
					; SIO_L1H_sub_0D4C+80p
					; SIO_L1H_sub_0D4C+85p
		ld	a, (hl)
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		inc	hl
		ret	
; End of function SIO_L1_sub_0DD6


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0DDC:			; CODE XREF: SIO_L1H_sub_0C96+10p
					; SIO_L1H_sub_0C96+51j
					; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ld	bc, 0F0h ; '­'
		call	sub_0_57E
		ret	
; End of function SIO_L1H_sub_0DDC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0DE3:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ld	b, 1
		ld	a, (ix+IX_STRUCT)
		call	loc_0_460
		ret	
; End of function SIO_L1H_sub_0DE3


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0DEC:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		bit	2, (ix+IX_STRUCT.LAST)
		ret	z
		set	2, (iy+IY_STRUCT.field_27)
		call	SIO_L1_sub_0E3D
		ld	a, (ix+0)
		ld	e, 4
		call	sub_0_4B8
		ld	b, 0
		call	BUS_WRITE8	; b=data byte
		ld	a, 1Eh
		push	iy
		pop	hl
		call	ADD16		; hl+=a
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		ex	de, hl
		call	loc_0_533
		ld	e, 1Eh
		call	BUS_READ8_STH
		ld	b, 1Eh
		call	sub_0_44F
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		set	7, h
		jp	(hl)
; End of function SIO_L1H_sub_0DEC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_sub_0E27:				; CODE XREF: SIO_L1H_sub_0C96+Ap
					; SIO_L1H_sub_0CEE+18p
		ld	e, 12h
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		ld	(iy+IY_STRUCT.field_12), l
		ld	(iy+IY_STRUCT.field_13), h
		ld	(iy+IY_STRUCT.field_14), a
		ld	a, 2
		jp	DI_sub_0508
; End of function SIO_sub_0E27


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1_sub_0E3D:			; CODE XREF: SIO_L1H_sub_0D0Cp
					; SIO_L1H_sub_0DEC+9p
					; SIO_L1H_sub_0F32+1Cj
		ld	e, 5
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		push	de
		ld	bc, 5
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		push	iy
		pop	hl
		ld	de, 1Eh
		add	hl, de
		pop	de
		ex	de, hl
		ld	bc, 5
		ldir	
		ret	
; End of function SIO_L1_sub_0E3D


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_E5B:				; CODE XREF: sub_0_6AD+1Fp
					; XH_sub_0BA2+Ep SIO_L1H_sub_0CEE+Dp
					; sub_0_E5B+29j YH_sub_0F85p
		ld	e, 0Ah
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		push	de
		ld	bc, 9
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		push	iy
		pop	hl
		ld	de, 15h
		add	hl, de
		ex	de, hl
		pop	hl
		push	hl
		push	de
		ld	bc, 9
		ldir	
		pop	de
		pop	hl
		ld	a, (iy+IY_STRUCT.field_1D)
		and	80h ; 'Ç'
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, sub_0_E5B
		ret	
; End of function sub_0_E5B


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_E87:				; CODE XREF: XH_sub_0BA2+63p
					; SIO_L1H_sub_0CEE+15p
					; SIO_L1H_sub_0EC3+5Bp	YH_sub_0F85+4Bp
		ld	bc, 100h
		call	sub_0_57E
		ld	a, (ix+IX_STRUCT)
		ld	b, 2
		call	loc_0_460
		ret	
; End of function sub_0_E87


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_E96:				; CODE XREF: XH_sub_0BA2+5Dp
					; XH_sub_0BA2+7Ep YH_sub_0F85+45p
		ld	bc, 256
		call	sub_0_58E
		ld	a, (ix+IX_STRUCT)
		ld	b, 2
		call	sub_0_458
		ret	
; End of function sub_0_E96


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_EA5:				; CODE XREF: SIO_sub_0C4A+25j
					; SIO_L1H_sub_0EC3+58p	YH_sub_1014+7p
		ld	bc, 4096
		call	sub_0_58E
		ld	a, (ix+IX_STRUCT)
		ld	b, 4
		call	sub_0_458
		ret	
; End of function sub_0_EA5


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_EB4:				; CODE XREF: SIO_L1H_sub_0D0C+11p
					; SIO_L1H_sub_0F32+19p
		ld	bc, 4096
		call	sub_0_57E
		ld	a, (ix+IX_STRUCT)
		ld	b, 4
		call	loc_0_460
		ret	
; End of function sub_0_EB4


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0EC3:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		bit	0, (ix+IX_STRUCT.LAST)
		jp	z, JUST_RETURN_SH
		set	0, (iy+IY_STRUCT.field_27)
		ld	a, 0Eh
		call	sub_0_4FF
		ld	b, 0
		call	sub_0_44F
		ld	a, 18h
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	a, (ix+IX_STRUCT)
		ld	e, 13h
		call	sub_0_4B8
		push	de
		call	BUS_READ16	; ix=24-bit host mem address pointer, (de)=destination
		pop	hl
		ld	a, (hl)
		ld	(iy+IY_STRUCT.field_28), a
		inc	hl
		ld	a, (hl)
		ld	(iy+IY_STRUCT.field_29), a
		ld	b, 5
		call	sub_0_44F
		ld	a, 0E0h	; 'Ó'
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	b, 3
		call	sub_0_44F
		ld	a, 0C0h	; '└'
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	b, 4
		call	sub_0_44F
		ld	a, 10h
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	b, 1
		call	sub_0_44F
		ld	a, 1Dh
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		call	sub_0_EA5
		call	sub_0_E87
		ret	
; End of function SIO_L1H_sub_0EC3


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0F22:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		bit	0, (iy+IY_STRUCT.field_27)
		jp	z, JUST_RETURN_SH
		ld	a, 2
		jp	DI_sub_0508
; End of function SIO_L1H_sub_0F22


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0F2E:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ld	a, 8
		jr	loc_0_F34
; End of function SIO_L1H_sub_0F2E


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

SIO_L1H_sub_0F32:			; DATA XREF: HANDLER_SIO_L0_COMMON+C0o
		ld	a, 0Ah

loc_0_F34:				; CODE XREF: SIO_L1H_sub_0F2E+2j
		bit	0, (iy+IY_STRUCT.field_27)
		jp	z, JUST_RETURN_SH
		push	af
		ld	a, 2
		call	sub_0_4FF
		pop	af
		call	DI_sub_0508
		ld	bc, 1
		call	sub_0_57E
		call	sub_0_EB4
		jp	SIO_L1_sub_0E3D
; End of function SIO_L1H_sub_0F32

; [COLLAPSED FUNCTION YH_nullsub_3, 00000001 BYTES. PRESS KEYPAD "+" TO EXPAND]

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

YH_sub_0F52:				; DATA XREF: ROM:0B82o
		call	ZERO_SAVED_TASK_sub_028C
		ld	b, 6
		call	sub_0_44F
		ld	a, (iy+IY_STRUCT.field_28)
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	b, 7
		call	sub_0_44F
		ld	a, (iy+IY_STRUCT.field_29)
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	b, 3
		call	sub_0_44F
		ld	a, 11h
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		ld	a, 2
		call	sub_0_4FF
		ld	a, 4
		call	DI_sub_0508
		call	CHECK_STUFF	; Called from *many* sites
		jp	SIO_sub_0B40
; End of function YH_sub_0F52


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

YH_sub_0F85:				; DATA XREF: ROM:0B82o
		call	sub_0_E5B
		push	hl
		push	de

loc_0_F8A:				; CODE XREF: YH_sub_0F85+19j
		call	sub_0_5D7
		jr	z, loc_0_FA0
		push	de
		ld	b, 8
		call	sub_0_44F
		call	sub_0_16D
		pop	de
		jr	c, loc_0_FA0
		call	sub_0_5B1
		jr	loc_0_F8A
; ───────────────────────────────────────────────────────────────────────────

loc_0_FA0:				; CODE XREF: YH_sub_0F85+8j
					; YH_sub_0F85+14j
		call	sub_0_5CF
		pop	hl
		pop	de
		jr	z, loc_0_FD0
		ld	bc, 9
		ldir	
		ld	a, (iy+IY_STRUCT.field_19)
		or	a
		jr	z, loc_0_FBF
		ld	e, 10h
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		ld	b, 80h ; 'Ç'
		call	BUS_WRITE8	; b=data byte

loc_0_FBF:				; CODE XREF: YH_sub_0F85+2Bj
		ld	e, 0Fh
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		call	BUS_WRITE16	; ix=24-bit host mem address pointer, (de)=source
		call	sub_0_E96
		jp	SIO_sub_0B40
; ───────────────────────────────────────────────────────────────────────────

loc_0_FD0:				; CODE XREF: YH_sub_0F85+20j
		call	sub_0_E87
		jp	SIO_sub_0B40
; End of function YH_sub_0F85


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

YH_sub_0FD6:				; DATA XREF: ROM:0B82o
		call	sub_0_1023
		jr	c, YH_sub_1014
		ld	(iy+IY_STRUCT.field_2A), b
		call	sub_0_1023
		jr	c, YH_sub_1014
		ld	(iy+IY_STRUCT.field_2B), b
		ld	b, 5
		call	sub_0_44F
		or	0Ah
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1

loc_0_FF0:				; CODE XREF: YH_sub_0FD6+28j
		ld	e, 2
		ld	a, (ix+IX_STRUCT)
		call	sub_0_4B8
		ld	a, (de)
		and	8
		call	z, CHECK_STUFF	; Called from *many* sites
		jr	z, loc_0_FF0
		call	sub_0_1046
		ld	a, 10h
		call	DI_sub_0508
		jp	sub_0_105E
; End of function YH_sub_0FD6


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

YH_sub_100B:				; DATA XREF: ROM:0B82o
		call	sub_0_1046
		ret	nc
		ld	a, 8
		jp	sub_0_4FF
; End of function YH_sub_100B


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

YH_sub_1014:				; CODE XREF: YH_sub_0FD6+3j
					; YH_sub_0FD6+Bj
					; DATA XREF: ROM:0B82o
		ld	a, (iy+IY_STRUCT.field_10)
		cp	(iy+IY_STRUCT.field_11)
		ret	nz
		call	sub_0_EA5
		ld	a, 10h
		jp	sub_0_4FF
; End of function YH_sub_1014


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_1023:				; CODE XREF: YH_sub_0FD6p
					; YH_sub_0FD6+8p sub_0_1046+Ep
		ld	b, 21h ; '!'
		call	sub_0_44F
		inc	hl
		or	(hl)
		scf	
		ret	z
		ld	e, 1Eh
		call	BUS_READ8_STH
		ld	a, (ix+IX_STRUCT.PORT_BASE_1)
		push	bc
		ld	e, 1Eh
		ld	b, 3
		call	sub_0_567
		ld	e, 21h ; '!'
		ld	b, 2
		call	sub_0_550
		pop	bc
		or	a
		ret	
; End of function sub_0_1023


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_1046:				; CODE XREF: YH_sub_0FD6+2Ap
					; YH_sub_100Bp	sub_0_1046+16j
		push	iy
		pop	hl
		ld	de, 0Dh
		add	hl, de
		push	hl
		call	sub_0_1A6
		pop	hl
		ret	z
		push	hl
		call	sub_0_1023
		pop	hl
		ret	c
		call	sub_0_18A
		jr	sub_0_1046
; End of function sub_0_1046


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_105E:				; CODE XREF: YH_sub_0FD6+32j
		push	iy
		pop	hl
		ld	de, 0Dh
		add	hl, de
		call	sub_0_16D
		ld	c, (ix+2)
		ret	c
		out	(c), b
		ret	
; End of function sub_0_105E


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

JUST_RETURN_SH:				; CODE XREF: SIO_L1H_sub_065F+4j
					; SIO_L1H_sub_0EC3+4j
					; SIO_L1H_sub_0F22+4j
					; SIO_L1H_sub_0F32+6j
		ret	
; End of function JUST_RETURN_SH


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; (ix+3) == ioport-1
; de = return address
; Attributes: bp-based frame

JINTH_sub_1070:				; DATA XREF: HANDLER_SIO_L0_COMMON+12o
		bit	1, (iy+IY_STRUCT.field_27)
		jp	nz, XINTH_sub_086B
		call	sub_0_1193	; (ix+3) == ioport-1
		bit	1, b
		ret	z
		ld	a, (ix+IX_STRUCT.field_4)
		xor	c
		bit	3, a
		ret	nz
		ld	hl, off_0_108F
		call	ADD16		; hl+=a
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		jp	(hl)
; End of function JINTH_sub_1070

; ───────────────────────────────────────────────────────────────────────────
off_0_108F:	.dw FH_JUMP_SLOT5_sub_1097 ; DATA XREF:	JINTH_sub_1070+14o
		.dw FH_JUMP_SLOT3_sub_10F3
		.dw FH_JUMP_SLOT4_sub_1133 ; (ix+2) == ioport-1
		.dw FH_JUMP_SLOT2_sub_116E

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FH_JUMP_SLOT5_sub_1097:			; DATA XREF: ROM:108Fo
		bit	2, (iy+IY_STRUCT.field_27)
		jp	nz, SRAM_JUMP_SLOT5
		bit	0, (iy+IY_STRUCT.field_27)
		jr	z, loc_0_10DE
		bit	5, (iy+IY_STRUCT.field_23)
		jr	z, loc_0_10B3
		res	5, (iy+IY_STRUCT.field_23)
		ld	b, (iy+IY_STRUCT.field_2B)
		jr	loc_0_10EB
; ───────────────────────────────────────────────────────────────────────────

loc_0_10B3:				; CODE XREF: FH_JUMP_SLOT5_sub_1097+11j
		push	iy
		pop	hl
		ld	de, 0Dh
		add	hl, de
		call	sub_0_16D
		jr	nc, loc_0_10EB
		set	5, (iy+IY_STRUCT.field_23)
		ld	b, (iy+IY_STRUCT.field_2A)
		bit	3, (iy+IY_STRUCT.field_23)
		jr	z, loc_0_10EB
		res	5, (iy+IY_STRUCT.field_23)
		res	4, (iy+IY_STRUCT.field_23)
		ld	b, 5
		call	sub_0_44F
		and	0F5h ; '§'
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1

loc_0_10DE:				; CODE XREF: FH_JUMP_SLOT5_sub_1097+Bj
		push	iy
		pop	hl
		ld	b, 0
		ld	a, 28h ; '('
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		scf	
		reti	
; ───────────────────────────────────────────────────────────────────────────

loc_0_10EB:				; CODE XREF: FH_JUMP_SLOT5_sub_1097+1Aj
					; FH_JUMP_SLOT5_sub_1097+26j
					; FH_JUMP_SLOT5_sub_1097+33j
		ld	c, (ix+2)
		out	(c), b
		scf	
		reti	
; End of function FH_JUMP_SLOT5_sub_1097


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FH_JUMP_SLOT3_sub_10F3:			; DATA XREF: ROM:1091o
		bit	2, (iy+IY_STRUCT.field_27)
		jp	nz, SRAM_JUMP_SLOT3
		ld	bc, 0Eh
		call	sub_0_57E
		ld	b, 0
		call	sub_0_4E6	; (ix+2) == ioport-1
					; b = data out
					; a = data in
		ld	(iy+IY_STRUCT.field_2C), a
		add	a, a
		push	af
		rrca	
		rrca	
		rrca	
		and	0Ah
		ld	c, a
		ld	b, 0
		pop	af
		jr	nc, loc_0_1119
		ld	a, 4
		or	c
		ld	c, a

loc_0_1119:				; CODE XREF: FH_JUMP_SLOT3_sub_10F3+20j
		call	sub_0_58E
		push	iy
		pop	hl
		ld	b, 0
		ld	(iy+IY_STRUCT.LAST), 0FFh
		ld	l, (ix+IX_STRUCT.field_1)
		call	sub_0_280
		ld	a, 10h
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1
		scf	
		reti	
; End of function FH_JUMP_SLOT3_sub_10F3


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; (ix+2) == ioport-1
; Attributes: bp-based frame

FH_JUMP_SLOT4_sub_1133:			; DATA XREF: ROM:1093o
		bit	2, (iy+27h)
		jp	nz, SRAM_JUMP_SLOT4

loc_0_113A:				; CODE XREF: FH_JUMP_SLOT4_sub_1133+38j
		ld	b, 0
		call	sub_0_4E6	; (ix+2) == ioport-1
					; b = data out
					; a = data in
		and	1
		jp	z, loc_0_1175
		ld	c, (ix+IX_STRUCT.PORT_BASE_1)
		in	a, (c)
		and	(iy+IY_STRUCT.field_24)
		ld	b, a
		push	iy
		pop	de
		ld	hl, 8
		add	hl, de
		call	sub_0_18A
		jp	nc, loc_0_1160
		ld	bc, 0A0h ; 'á'
		call	sub_0_58E

loc_0_1160:				; CODE XREF: FH_JUMP_SLOT4_sub_1133+24j
		ld	a, 4
		call	DI_sub_0508
		ld	l, (ix+1)
		call	sub_0_280
		jp	loc_0_113A
; End of function FH_JUMP_SLOT4_sub_1133


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FH_JUMP_SLOT2_sub_116E:			; DATA XREF: ROM:1095o
		bit	2, (iy+IY_STRUCT.field_27)
		jp	nz, SRAM_JUMP_SLOT2

loc_0_1175:				; CODE XREF: FH_JUMP_SLOT4_sub_1133+Ej
		ld	b, 1
		call	sub_0_4E6	; (ix+2) == ioport-1
					; b = data out
					; a = data in
		and	70h ; 'p'
		jr	z, loc_0_1190
		or	80h ; 'Ç'
		ld	c, a
		ld	b, 0
		call	sub_0_58E
		push	iy
		pop	hl
		ld	b, 0
		ld	a, 30h ; '0'
		call	sub_0_4F2	; write	b,a to port_base_2+1
					; save a in (hl)
					; (ix+2) == ioport-1

loc_0_1190:				; CODE XREF: FH_JUMP_SLOT2_sub_116E+Ej
		scf	
		reti	
; End of function FH_JUMP_SLOT2_sub_116E


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; (ix+3) == ioport-1
; Attributes: bp-based frame

sub_0_1193:				; CODE XREF: JINTH_sub_1070+7p
		di	
		ld	c, (ix+IX_STRUCT.PORT_BASE_2)
		inc	c
		ld	a, 0
		out	(c), a
		in	b, (c)
		inc	c
		inc	c
		ld	a, 2
		out	(c), a
		in	a, (c)
		and	0Eh
		ld	c, a
		jp	TAIL_EI
; End of function sub_0_1193

; ───────────────────────────────────────────────────────────────────────────
MONITOR_SPACES:	.text "    "            ; DATA XREF: MONITOR_PRINT_STH+32o
		.db 0
MONITOR_ARR_5_byte_11B1:.db 14h, 0CEh, 0, 0, 81h ; DATA	XREF: ROM:121Bo
MONITOR_ARR_5_byte_11B6:.db 14h, 0C5h, 0, 0, 81h ; DATA	XREF: ROM:122Bo
MONITOR_BANNER:	.db 0Dh			; DATA XREF: ROM:1245o
		.db 0Ah
		.db 0Ah
		.db 0Ah
		.text "5-86 IOP monitor - version 6.2"
		.db 0Ah
		.db 0Dh
		.db 0Ah
		.db 0
MONITOR_Z80:	.text "Z80- "           ; DATA XREF: MONITOR_PRINT_STH+Co
		.db 0
MONITOR_CONT:	.db 0Dh			; DATA XREF: MONITOR_PROMPT+6o
		.db 0Ah
		.text "-> "
		.db 0

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_11ED:			; CODE XREF: orphan_sub_11ED+10j
		ld	ix, IX_stru_1C25
		ld	iy, IY_CH3_stru_25F2
		ld	a, (_00_FROM_BEGINNING)
		bit	0, a
		call	z, CHECK_STUFF	; Called from *many* sites
		jr	z, orphan_sub_11ED
; End of function orphan_sub_11ED


MONITOR_ENTRY:				; DATA XREF: ROM:1AB5o
		call	CHECK_STUFF	; Called from *many* sites
		ld	e, SYS_FW_VER	; SYS -	Firmware Version Register
		call	MAKE_CCB_ADDRESS
		ld	(BUS_ADDR), hl
		ld	(byte_0_26D9), a
		ld	hl, 1
		ld	(unk_0_26DA), hl
		ld	a, (ix+0)
		ld	e, 0
		call	sub_0_4B8
		ld	de, MONITOR_ARR_5_byte_11B1
		ld	bc, 5
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	a, 4
		ld	e, 0
		call	sub_0_4B8
		ld	de, MONITOR_ARR_5_byte_11B6
		ld	bc, 5
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on

loc_0_1234:				; CODE XREF: ROM:1243j
		call	CHECK_STUFF	; Called from *many* sites
		ld	a, 1
		ld	e, 4
		call	sub_0_4B8
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	7, b
		jr	nz, loc_0_1234
		ld	hl, MONITOR_BANNER ; "\r\n\n\n5-86 IOP monitor - version 6.2\n\r\n"
		call	MONITOR_PUTS

loc_0_124B:				; CODE XREF: ROM:1251j
		call	MONITOR_PROMPT
		call	MONITOR_sub_135F
		jr	loc_0_124B

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_PROMPT:				; CODE XREF: ROM:124Bp
		ld	hl, unk_0_267E
		ld	(byte_0_267C), hl
		ld	hl, MONITOR_CONT ; "\r\n-> "
		call	MONITOR_PUTS

loc_0_125F:				; CODE XREF: MONITOR_PROMPT+1Ej
					; MONITOR_PROMPT+33j
					; MONITOR_PROMPT+4Cj
		call	MONITOR_sub_12A7
		cp	7Fh ; ''
		jr	nz, loc_0_1268
		ld	a, 8

loc_0_1268:				; CODE XREF: MONITOR_PROMPT+11j
		cp	8
		jr	nz, loc_0_1288
		ld	a, (byte_0_267C)
		cp	7Eh ; '~'
		jr	z, loc_0_125F
		dec	a
		ld	(byte_0_267C), a
		ld	a, 8
		call	MONITOR_PUTCHAR
		ld	a, 20h ; ' '
		call	MONITOR_PUTCHAR
		ld	a, 8
		call	MONITOR_PUTCHAR
		jr	loc_0_125F
; ───────────────────────────────────────────────────────────────────────────

loc_0_1288:				; CODE XREF: MONITOR_PROMPT+17j
		cp	1Bh
		jr	nz, loc_0_1292
		call	ZERO_SAVED_TASK_sub_028C
		call	CHECK_STUFF	; Called from *many* sites

loc_0_1292:				; CODE XREF: MONITOR_PROMPT+37j
		ld	hl, (byte_0_267C)
		ld	(hl), a
		inc	hl
		ld	(byte_0_267C), hl
		call	MONITOR_PUTCHAR
		cp	0Dh
		jr	nz, loc_0_125F
		ld	a, 0Ah
		call	MONITOR_PUTCHAR
		ret	
; End of function MONITOR_PROMPT


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_12A7:			; CODE XREF: MONITOR_PROMPT+Cp
					; MONITOR_sub_12A7+17j
					; MONITOR_sub_12A7+2Ej
		ld	a, (byte_0_26D6)
		and	1
		add	a, 3
		ld	(byte_0_26D6), a
		ld	e, 3
		call	sub_0_4B8
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	0, b
		call	z, CHECK_STUFF	; Called from *many* sites
		jr	z, MONITOR_sub_12A7
		ld	a, (byte_0_26D6)
		ld	e, 12h
		call	sub_0_4B8
		call	BUS_READ8	; hl=host address
					; returns b=value
		ld	a, b
		push	af
		ld	b, 83h ; 'â'
		call	MONITOR_sub_1322
		pop	af
		cp	0Ah
		jr	z, MONITOR_sub_12A7
		ret	
; End of function MONITOR_sub_12A7


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_PUTCHAR:			; CODE XREF: MONITOR_PROMPT+26p
					; MONITOR_PROMPT+2Bp
					; MONITOR_PROMPT+30p
					; MONITOR_PROMPT+47p
					; MONITOR_PROMPT+50p ...
		ld	b, a
		push	hl
		push	af
		push	bc

loc_0_12DC:				; CODE XREF: MONITOR_PUTCHAR+14j
		ld	a, (ix+IX_STRUCT)
		ld	e, 3
		call	sub_0_4B8
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	4, b
		call	z, CHECK_STUFF	; Called from *many* sites
		jr	z, loc_0_12DC
		ld	a, (ix+IX_STRUCT)
		ld	e, 5
		call	sub_0_4B8
		ld	de, BUS_ADDR
		ld	bc, 5
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	e, SYS_FW_VER	; SYS -	Firmware Version Register
		call	MAKE_CCB_ADDRESS
		pop	bc
		call	BUS_WRITE8	; b=data byte
		ld	b, 82h ; 'é'
		call	MONITOR_sub_1310
		pop	af
		pop	hl
		ret	
; End of function MONITOR_PUTCHAR


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_1310:			; CODE XREF: MONITOR_PUTCHAR+32p
		ld	a, (byte_0_26D6)
		push	af
		ld	a, (ix+0)
		ld	(byte_0_26D6), a
		call	MONITOR_sub_1322
		pop	af
		ld	(byte_0_26D6), a
		ret	
; End of function MONITOR_sub_1310


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_1322:			; CODE XREF: MONITOR_sub_12A7+28p
					; MONITOR_sub_1310+Ap
		push	bc

loc_0_1323:				; CODE XREF: MONITOR_sub_1322+11j
		ld	a, (byte_0_26D6)
		ld	e, 4
		call	sub_0_4B8
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	7, b
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1323
		ld	a, (byte_0_26D6)
		ld	e, 4
		call	sub_0_4B8
		pop	bc
		call	BUS_WRITE8	; b=data byte

loc_0_1341:				; CODE XREF: MONITOR_sub_1322+2Fj
		ld	a, (byte_0_26D6)
		ld	e, 4
		call	sub_0_4B8
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	7, b
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1341
		ret	
; End of function MONITOR_sub_1322


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_PUTS:				; CODE XREF: ROM:1248p
					; MONITOR_PROMPT+9p MONITOR_PUTS+9j
					; MONITOR_ILLEGAL_INPUT+3p
					; MONITOR_PRINT_STH+3p	...
		ld	a, (hl)
		or	a
		ret	z
		push	hl
		call	MONITOR_PUTCHAR
		pop	hl
		inc	hl
		jr	MONITOR_PUTS
; End of function MONITOR_PUTS


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_135F:			; CODE XREF: ROM:124Ep
		ld	hl, unk_0_267E
		ld	(byte_0_267C), hl
		ld	hl, 1
		ld	(word_0_26CF), hl
		dec	hl
		ld	(word_0_26D1), hl
		ld	(word_0_26D3), hl
		call	MONITOR_sub_13EC
		jp	c, MONITOR_ILLEGAL_INPUT
		jr	loc_0_137D
; ───────────────────────────────────────────────────────────────────────────

loc_0_137A:				; CODE XREF: MONITOR_sub_135F+29j
					; MONITOR_sub_135F+2Dj
		call	MONITOR_sub_1433

loc_0_137D:				; CODE XREF: MONITOR_sub_135F+19j
		call	sub_0_1429
		jr	z, loc_0_138E
		cp	3Dh ; '='
		jr	z, loc_0_13C2
		cp	20h ; ' '
		jr	z, loc_0_137A
		cp	2Ch ; ','
		jr	z, loc_0_137A

loc_0_138E:				; CODE XREF: MONITOR_sub_135F+21j
		call	MONITOR_sub_14FC
		call	MONITOR_sub_1408
		jr	c, MONITOR_ILLEGAL_INPUT
		ld	hl, (word_0_26CF)
		ld	a, l
		or	h
		ret	z

loc_0_139C:				; CODE XREF: MONITOR_sub_135F+5Fj
		call	MONITOR_PRINT_STH

loc_0_139F:				; CODE XREF: MONITOR_sub_135F+61j
		call	MONITOR_sub_148D
		call	MONITOR_HEX_NUMBER
		ld	a, 20h ; ' '
		call	MONITOR_PUTCHAR
		ld	hl, (word_0_26CF)
		dec	hl
		ld	(word_0_26CF), hl
		ld	a, l
		or	h
		ret	z
		ld	hl, (word_0_26D3)
		inc	hl
		ld	(word_0_26D3), hl
		ld	a, l
		and	0Fh
		jr	z, loc_0_139C
		jr	loc_0_139F
; ───────────────────────────────────────────────────────────────────────────

loc_0_13C2:				; CODE XREF: MONITOR_sub_135F+25j
					; MONITOR_sub_135F+8Bj
		call	MONITOR_sub_14FC
		ret	z
		call	MONITOR_sub_14C3
		jr	c, MONITOR_ILLEGAL_INPUT
		ld	a, h
		or	a
		jr	nz, MONITOR_ILLEGAL_INPUT
		ld	b, l
		ld	a, (_00_FROM_BEGINNING_0)
		cp	3Ah ; ':'
		jr	z, loc_0_13DD
		ld	hl, (word_0_26D3)
		ld	(hl), b
		jr	loc_0_13E3
; ───────────────────────────────────────────────────────────────────────────

loc_0_13DD:				; CODE XREF: MONITOR_sub_135F+76j
		call	MONITOR_sub_14A1
		call	BUS_WRITE8	; b=data byte

loc_0_13E3:				; CODE XREF: MONITOR_sub_135F+7Cj
		ld	hl, (word_0_26D3)
		inc	hl
		ld	(word_0_26D3), hl
		jr	loc_0_13C2
; End of function MONITOR_sub_135F


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_13EC:			; CODE XREF: MONITOR_sub_135F+13p
		ld	a, 20h ; ' '
		ld	(_00_FROM_BEGINNING_0),	a
		call	MONITOR_sub_14C3
		ret	c
		cp	3Ah ; ':'
		jr	nz, loc_0_1403
		ld	(_00_FROM_BEGINNING_0),	a
		ld	(word_0_26D1), hl
		call	MONITOR_sub_14C3
		ret	c

loc_0_1403:				; CODE XREF: MONITOR_sub_13EC+Bj
		ld	(word_0_26D3), hl
		or	a
		ret	
; End of function MONITOR_sub_13EC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_1408:			; CODE XREF: MONITOR_sub_135F+32p
		call	MONITOR_sub_14C3
		ld	(word_0_26CF), hl
		ret	
; End of function MONITOR_sub_1408


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_ILLEGAL_INPUT:			; CODE XREF: MONITOR_sub_135F+16j
					; MONITOR_sub_135F+35j
					; MONITOR_sub_135F+6Aj
					; MONITOR_sub_135F+6Ej
		ld	hl, MONITOR_ILLEGAL_MESSAGE ; "\r\n\nIllegal input\r\n"
		call	MONITOR_PUTS
		ret	
; End of function MONITOR_ILLEGAL_INPUT

; ───────────────────────────────────────────────────────────────────────────
MONITOR_ILLEGAL_MESSAGE:.db 0Dh		; DATA XREF: MONITOR_ILLEGAL_INPUTo
		.db 0Ah
		.db 0Ah
		.text "Illegal input"
		.db 0Dh
		.db 0Ah
		.db 0

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_1429:				; CODE XREF: MONITOR_sub_135F+1Ep
					; MONITOR_sub_1433p
					; MONITOR_sub_14C3+7p
		ld	hl, (byte_0_267C)
		ld	a, (hl)
		call	MONITOR_sub_143C
		cp	0Dh
		ret	
; End of function sub_0_1429


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_1433:			; CODE XREF: MONITOR_sub_135F+1Bp
					; MONITOR_sub_14C3+19p
		call	sub_0_1429
		ret	z
		inc	hl
		ld	(byte_0_267C), hl
		ret	
; End of function MONITOR_sub_1433


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_143C:			; CODE XREF: sub_0_1429+4p
		cp	61h ; 'a'
		ret	c
		cp	7Bh ; '{'
		ret	nc
		sub	20h ; ' '
		ret	
; End of function MONITOR_sub_143C


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_PRINT_STH:			; CODE XREF: MONITOR_sub_135F+3Dp
		ld	hl, MONITOR_BANNER+23h
		call	MONITOR_PUTS
		ld	a, (_00_FROM_BEGINNING_0)
		cp	3Ah ; ':'
		push	af
		ld	hl, MONITOR_Z80	; "Z80- "
		call	nz, MONITOR_PUTS
		pop	af
		jr	nz, loc_0_146B
		ld	a, (word_0_26D1+1)
		call	MONITOR_HEX_NUMBER
		ld	a, (word_0_26D1)
		call	MONITOR_HEX_NUMBER
		ld	a, 3Ah ; ':'
		call	MONITOR_PUTCHAR

loc_0_146B:				; CODE XREF: MONITOR_PRINT_STH+13j
		ld	a, (word_0_26D3+1)
		call	MONITOR_HEX_NUMBER
		ld	a, (word_0_26D3)
		call	MONITOR_HEX_NUMBER
		ld	hl, MONITOR_SPACES ; "    "
		call	MONITOR_PUTS
		ret	
; End of function MONITOR_PRINT_STH


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_HEX_NUMBER:			; CODE XREF: MONITOR_sub_135F+43p
					; MONITOR_PRINT_STH+18p
					; MONITOR_PRINT_STH+1Ep
					; MONITOR_PRINT_STH+29p
					; MONITOR_PRINT_STH+2Fp
		push	af
		call	MONITOR_TOP_DIGIT
		call	MONITOR_PUTCHAR
		pop	af
		call	MONITOR_HEX_DIGIT
		call	MONITOR_PUTCHAR
		ret	
; End of function MONITOR_HEX_NUMBER


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_148D:			; CODE XREF: MONITOR_sub_135F+40p
		ld	a, (_00_FROM_BEGINNING_0)
		cp	3Ah ; ':'
		jr	z, loc_0_1499
		ld	hl, (word_0_26D3)
		ld	a, (hl)
		ret	
; ───────────────────────────────────────────────────────────────────────────

loc_0_1499:				; CODE XREF: MONITOR_sub_148D+5j
		call	MONITOR_sub_14A1
		call	BUS_READ8	; hl=host address
					; returns b=value
		ld	a, b
		ret	
; End of function MONITOR_sub_148D


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_14A1:			; CODE XREF: MONITOR_sub_135F+7Ep
					; MONITOR_sub_148D+Cp
		ld	hl, (word_0_26D1)
		xor	a
		add	hl, hl
		adc	a, a
		add	hl, hl
		adc	a, a
		add	hl, hl
		adc	a, a
		add	hl, hl
		adc	a, a
		ld	de, (word_0_26D3)
		add	hl, de
		adc	a, 0
		ret	
; End of function MONITOR_sub_14A1


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_TOP_DIGIT:			; CODE XREF: MONITOR_HEX_NUMBER+1p
		rrca	
		rrca	
		rrca	
		rrca	
; End of function MONITOR_TOP_DIGIT


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████


MONITOR_HEX_DIGIT:			; CODE XREF: MONITOR_HEX_NUMBER+8p
		and	0Fh
		add	a, '7'
		cp	'A'
		ret	nc
		add	a, 249
		ret	
; End of function MONITOR_HEX_DIGIT


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_14C3:			; CODE XREF: MONITOR_sub_135F+67p
					; MONITOR_sub_13EC+5p
					; MONITOR_sub_13EC+13p
					; MONITOR_sub_1408p
		call	MONITOR_sub_14FC
		ld	hl, 0

loc_0_14C9:				; CODE XREF: MONITOR_sub_14C3+27j
		push	hl
		call	sub_0_1429
		pop	hl
		ret	z
		cp	' '
		ret	z
		cp	','
		ret	z
		cp	':'
		ret	z
		cp	'='
		ret	z
		push	hl
		call	MONITOR_sub_1433
		pop	hl
		call	MONITOR_sub_14EC
		ret	c
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	hl, hl
		add	a, l
		ld	l, a
		jr	loc_0_14C9
; End of function MONITOR_sub_14C3


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_14EC:			; CODE XREF: MONITOR_sub_14C3+1Dp
		cp	':'
		jr	nc, loc_0_14F3
		sub	'0'
		ret	
; ───────────────────────────────────────────────────────────────────────────

loc_0_14F3:				; CODE XREF: MONITOR_sub_14EC+2j
		cp	'G'
		ccf	
		ret	c
		sub	'7'
		cp	0Ah
		ret	
; End of function MONITOR_sub_14EC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

MONITOR_sub_14FC:			; CODE XREF: MONITOR_sub_135F+2Fp
					; MONITOR_sub_135F+63p
					; MONITOR_sub_14C3p
		ld	hl, (byte_0_267C)
		dec	hl

loc_0_1500:				; CODE XREF: MONITOR_sub_14FC+8j
					; MONITOR_sub_14FC+Cj
					; MONITOR_sub_14FC+10j
					; MONITOR_sub_14FC+14j
		inc	hl
		ld	a, (hl)
		cp	' '
		jr	z, loc_0_1500
		cp	','
		jr	z, loc_0_1500
		cp	':'
		jr	z, loc_0_1500
		cp	'='
		jr	z, loc_0_1500
		ld	(byte_0_267C), hl
		cp	0Dh
		ret	
; End of function MONITOR_sub_14FC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_1518:
		ex	(sp), hl
		ld	(word_0_26DE), hl
		ex	(sp), hl
		push	af
		ld	a, (byte_0_26DC)
		or	a
		jr	z, loc_0_1545
		ex	(sp), hl
		ld	(word_0_26E0), hl
		ex	(sp), hl
		ld	(word_0_26E6), hl
		push	hl
		ld	(word_0_26E4), de
		push	de
		ld	(word_0_26E2), bc
		push	bc
		ld	hl, unk_0_26DD

loc_0_153A:				; CODE XREF: orphan_sub_1518+27j
		ld	a, (hl)
		or	a
		call	z, CHECK_STUFF	; Called from *many* sites
		jr	z, loc_0_153A
		dec	(hl)
		pop	bc
		pop	de
		pop	hl

loc_0_1545:				; CODE XREF: orphan_sub_1518+Aj
		pop	af
		ret	
; End of function orphan_sub_1518


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; On init
; Attributes: bp-based frame

HANDLER08_FDC_sub_1547:			; DATA XREF: ROM:0143o
		ld	iy, FDC_IY_BUF_unk_22EA
		ld	a, 3
		ld	(FDC_3_byte_2687), a
		xor	a
		ld	(byte_0_267C), a
		ld	(FDC_byte_2688), a
		ld	hl, 7D0h
		ld	(FDC_word_2689), hl
		call	CHECK_STUFF	; Called from *many* sites
		ei	
		xor	a
		ld	(FDC_byte_268B), a
		call	FDC_SELECT_DRIVE
		in	a, (39h)
		out	(3Bh), a
		ld	a, 10h		; Seek
		call	FDC_RUN_CMD	; Write	command	read status (a=i/o value)
					; Called on init
		ld	b, 8
		ld	a, 4
		call	sub_0_458
		call	FDC_sub_1957
		jr	loc_0_15A9
; ───────────────────────────────────────────────────────────────────────────

loc_0_157D:				; CODE XREF: HANDLER08_FDC_sub_1547+8Fj
					; HANDLER08_FDC_sub_1547+98j
		ld	b, 8
		ld	a, 4
		call	sub_0_458
		call	FDC_sub_1957
		ld	hl, (FDC_word_2689)

loc_0_158A:				; CODE XREF: HANDLER08_FDC_sub_1547+50j
		push	hl
		call	FDC_sub_1930
		pop	hl
		jr	nz, loc_0_15C2
		dec	hl
		ld	a, l
		or	h
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_158A
		xor	a
		ld	(FDC_byte_268B), a
		call	FDC_SELECT_DRIVE
		in	a, (39h)
		out	(3Bh), a
		ld	a, 10h		; Seek
		call	FDC_RUN_CMD	; Write	command	read status (a=i/o value)
					; Called on init

loc_0_15A9:				; CODE XREF: HANDLER08_FDC_sub_1547+34j
		call	ZERO_SAVED_TASK_sub_028C
		call	CHECK_STUFF	; Called from *many* sites
		ld	a, (byte_0_268E)
		and	1
		call	FDC_NEVIEM_sub_03B6 ; A=param (2?)
		ld	a, 0C8h	; '╚'

loc_0_15B9:				; CODE XREF: HANDLER08_FDC_sub_1547+79j
		dec	a
		call	nz, CHECK_STUFF	; Called from *many* sites
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_15B9

loc_0_15C2:				; CODE XREF: HANDLER08_FDC_sub_1547+48j
					; HANDLER08_FDC_sub_1547+E4j
					; HANDLER08_FDC_sub_1547+F9j
					; HANDLER08_FDC_sub_1547+112j
					; HANDLER08_FDC_sub_1547+122j ...
		ld	b, 8
		ld	a, 4
		call	loc_0_460
		call	FDC_sub_1930
		jr	nz, loc_0_15F2
		call	FDC_sub_1957
		ld	a, (byte_0_267C)
		and	0Fh
		jr	z, loc_0_157D
		ld	a, (byte_0_267C)
		and	0A0h ; 'á'
		xor	0A0h ; 'á'
		jr	z, loc_0_157D
		ld	a, (byte_0_267C)
		bit	0, a		; ---- 0x01 ----
		jr	nz, loc_0_162D
		bit	1, a		; ---- 0x02 ---- <========
		jr	nz, loc_0_1643
		bit	2, a		; ---- 0x04 ----
		jr	nz, loc_0_165C
		jr	loc_0_166C
; ───────────────────────────────────────────────────────────────────────────

loc_0_15F2:				; CODE XREF: HANDLER08_FDC_sub_1547+85j
		ld	e, 0
		call	SET_A_TO_6
		ld	bc, 1
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	e, 0
		call	SET_A_TO_6
		ex	de, hl
		res	7, (hl)
		ld	b, (hl)
		ld	(hl), 0
		ld	hl, ARR12_WIPED_FROM_BEGINNING+8
		res	3, (hl)
		bit	6, b
		jr	z, loc_0_1613
		set	3, (hl)

loc_0_1613:				; CODE XREF: HANDLER08_FDC_sub_1547+C8j
		ld	hl, byte_0_267C
		res	7, (hl)
		ld	a, 0Fh
		and	(hl)
		or	b
		ld	(hl), a		; <====	|= 0x02
		call	FDC_sub_1957
		ld	e, 0
		call	SET_A_TO_6
		ld	bc, 1
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		jr	loc_0_15C2
; ───────────────────────────────────────────────────────────────────────────

loc_0_162D:				; CODE XREF: HANDLER08_FDC_sub_1547+9Fj
		ld	e, 0Ah
		call	SET_A_TO_6
		ld	bc, 64
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	hl, byte_0_267C
		res	0, (hl)
		call	CHECK_STUFF	; Called from *many* sites
		jp	loc_0_15C2
; ───────────────────────────────────────────────────────────────────────────

loc_0_1643:				; CODE XREF: HANDLER08_FDC_sub_1547+A3j
		ld	hl, byte_0_267C
		res	1, (hl)
		xor	a
		ld	hl, FDC_ARR_16_byte_2304
		ld	c, 16
		call	MEMSET		; hl=dest, c=count, a=fill
		ld	hl, FDC_ARR_16_byte_2324
		ld	c, 16
		call	MEMSET		; hl=dest, c=count, a=fill
		jp	loc_0_15C2
; ───────────────────────────────────────────────────────────────────────────

loc_0_165C:				; CODE XREF: HANDLER08_FDC_sub_1547+A7j
		ld	hl, byte_0_267C
		res	2, (hl)
		ld	a, 3
		ld	(FDC_3_byte_2687), a
		call	CHECK_STUFF	; Called from *many* sites
		jp	loc_0_15C2
; ───────────────────────────────────────────────────────────────────────────

loc_0_166C:				; CODE XREF: HANDLER08_FDC_sub_1547+A9j
		ld	hl, byte_0_267C
		bit	4, (hl)
		jr	z, loc_0_1675
		res	3, (hl)

loc_0_1675:				; CODE XREF: HANDLER08_FDC_sub_1547+12Aj
		call	FDC_sub_1969
		jr	c, GO_OUT
		call	FDC_PICK_HANDLER_FROM_VECTOR
		ld	(byte_0_268D), a
		call	FDC_sub_1971
		ld	a, (iy+7)
		inc	a
		cp	(iy+5)
		jr	nz, loc_0_168D
		xor	a

loc_0_168D:				; CODE XREF: HANDLER08_FDC_sub_1547+143j
		ld	(iy+IY_STRUCT.field_7),	a
		ld	b, a
		ld	e, 7
		call	SET_A_TO_6
		call	BUS_WRITE8	; b=data byte
		jr	loc_0_16A0
; ───────────────────────────────────────────────────────────────────────────

GO_OUT:					; CODE XREF: HANDLER08_FDC_sub_1547+131j
		ld	hl, byte_0_267C
		res	3, (hl)

loc_0_16A0:				; CODE XREF: HANDLER08_FDC_sub_1547+152j
		call	CHECK_STUFF	; Called from *many* sites
		jp	loc_0_15C2
; End of function HANDLER08_FDC_sub_1547


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_PICK_HANDLER_FROM_VECTOR:		; CODE XREF: HANDLER08_FDC_sub_1547+133p
		ld	a, (FDC_SUB_COMMAND_BUFFER) ; === FDC COMMAND BUFFER === 11020
		push	af
		inc	a
		and	1111b
		jr	nz, A_IS_VALID_COMMAND
		ld	a, 1111b

A_IS_VALID_COMMAND:			; CODE XREF: FDC_PICK_HANDLER_FROM_VECTOR+7j
		ld	(FDC_SUBCOMMAND), a
		xor	a
		ld	(FDC_ZERO), a
		pop	af
		rrca	
		rrca	
		rrca	
		and	1110b
		ld	hl, FDC_SUBHANDLER_VECTOR
		call	ADD16		; hl+=a
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ex	de, hl
		ld	(FDC_HANDLER_ADDRESS), hl ; Handler address
; End of function FDC_PICK_HANDLER_FROM_VECTOR


FDC_HANDLER_TAIL:			; CODE XREF: FDC_SUBHANDLER00_07_NOTHING+3j
					; FDC_SUBHANDLER01_SEEK+3j
					; FDC_SUBHANDLER01_SEEK+9j
					; FDC_SUBHANDLER02_WRITE_BUS+3j
					; FDC_SUBHANDLER02_WRITE_BUS+9j ...
		ld	b, a
		ld	hl, FDC_ZERO
		ld	a, (FDC_SUBCOMMAND)
		cp	(hl)
		ld	a, b
		jr	nz, loc_0_16DC
		ld	hl, byte_0_267C
		set	7, (hl)
		ret	
; ───────────────────────────────────────────────────────────────────────────

loc_0_16DC:				; CODE XREF: ROM:16D4j
		inc	(hl)
		ld	hl, (FDC_HANDLER_ADDRESS) ; Handler address
		jp	(hl)		; Call the handler
; ───────────────────────────────────────────────────────────────────────────
FDC_SUBHANDLER_VECTOR:.dw FDC_SUBHANDLER00_07_NOTHING, FDC_SUBHANDLER01_SEEK
					; DATA XREF: FDC_PICK_HANDLER_FROM_VECTOR+18o
		.dw FDC_SUBHANDLER02_WRITE_BUS,	FDC_SUBHANDLER03_READ_BUS
		.dw FDC_SUBHANDLER04_CHECK_IS_ZERO, FDC_SUBHANDLER05_READ_TRACK
		.dw FDC_SUBHANDLER06_WRITE_TRACK, FDC_SUBHANDLER00_07_NOTHING

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SUBHANDLER00_07_NOTHING:		; DATA XREF: ROM:16E1o
		call	FDC_COMMON_HANDLER ; Called at the beginning of	all floppy handlers
		jp	c, FDC_HANDLER_TAIL
		ret	
; End of function FDC_SUBHANDLER00_07_NOTHING


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SUBHANDLER01_SEEK:			; DATA XREF: ROM:16E1o
		call	FDC_COMMON_HANDLER ; Called at the beginning of	all floppy handlers
		jp	c, FDC_HANDLER_TAIL
		call	FDC_SEEK_AND_LOAD_HEAD
		jp	c, FDC_HANDLER_TAIL
		ret	
; End of function FDC_SUBHANDLER01_SEEK


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SUBHANDLER02_WRITE_BUS:		; DATA XREF: ROM:16E1o
		call	FDC_COMMON_HANDLER ; Called at the beginning of	all floppy handlers
		jp	c, FDC_HANDLER_TAIL
		call	FDC_SEEK_AND_LOAD_HEAD
		jp	c, FDC_HANDLER_TAIL
		ld	hl, 2048
		call	sub_0_360
		call	FDC_DMA_sub_183D
		jp	c, FDC_HANDLER_COMMON_sub_1781 ; Called	in the midst of	most FDC handlers
		call	FDC_WRITE_BUS
		call	ZERO_TO_SOME_VAR_sub_03AC
		or	a
		ret	
; End of function FDC_SUBHANDLER02_WRITE_BUS


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SUBHANDLER03_READ_BUS:		; DATA XREF: ROM:16E1o
		call	FDC_COMMON_HANDLER ; Called at the beginning of	all floppy handlers
		jp	c, FDC_HANDLER_TAIL
		call	FDC_SEEK_AND_LOAD_HEAD
		jp	c, FDC_HANDLER_TAIL
		ld	hl, 2048
		call	sub_0_360
		call	FDC_READ_BUS
		call	FDC_DMA_sub_1864
		jp	c, FDC_HANDLER_COMMON_sub_1781 ; Called	in the midst of	most FDC handlers
		call	ZERO_TO_SOME_VAR_sub_03AC
		or	a
		ret	
; End of function FDC_SUBHANDLER03_READ_BUS


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SUBHANDLER04_CHECK_IS_ZERO:		; DATA XREF: ROM:16E1o
		or	a
		ret	
; End of function FDC_SUBHANDLER04_CHECK_IS_ZERO


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SUBHANDLER05_READ_TRACK:		; DATA XREF: ROM:16E1o
		call	FDC_COMMON_HANDLER ; Called at the beginning of	all floppy handlers
		jp	c, FDC_HANDLER_TAIL
		call	FDC_SEEK_AND_LOAD_HEAD
		jp	c, FDC_HANDLER_TAIL
		ld	hl, 2048
		call	sub_0_360
		call	FDC_READ_TRACK
		jp	c, FDC_HANDLER_COMMON_sub_1781 ; Called	in the midst of	most FDC handlers
		call	ZERO_TO_SOME_VAR_sub_03AC
		or	a
		ret	
; End of function FDC_SUBHANDLER05_READ_TRACK


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SUBHANDLER06_WRITE_TRACK:		; DATA XREF: ROM:16E1o
		call	FDC_COMMON_HANDLER ; Called at the beginning of	all floppy handlers
		jp	c, FDC_HANDLER_TAIL
		call	FDC_SEEK_AND_LOAD_HEAD
		jp	c, FDC_HANDLER_TAIL
		ld	hl, 2048
		call	sub_0_360
		call	FDC_WRITE_TRACK
		jp	c, FDC_HANDLER_COMMON_sub_1781 ; Called	in the midst of	most FDC handlers
		call	ZERO_TO_SOME_VAR_sub_03AC
		or	a
		ret	
; End of function FDC_SUBHANDLER06_WRITE_TRACK


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Called in the	midst of most FDC handlers
; Attributes: bp-based frame

FDC_HANDLER_COMMON_sub_1781:		; CODE XREF: FDC_SUBHANDLER02_WRITE_BUS+15j
					; FDC_SUBHANDLER03_READ_BUS+18j
					; FDC_SUBHANDLER05_READ_TRACK+15j
					; FDC_SUBHANDLER06_WRITE_TRACK+15j
		push	af
		call	BUS_LATCH_sub_052D
		call	ZERO_TO_SOME_VAR_sub_03AC
		pop	af
		jp	FDC_HANDLER_TAIL
; End of function FDC_HANDLER_COMMON_sub_1781


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Called at the	beginning of all floppy	handlers
; Attributes: bp-based frame

FDC_COMMON_HANDLER:			; CODE XREF: FDC_SUBHANDLER00_07_NOTHINGp
					; FDC_SUBHANDLER01_SEEKp
					; FDC_SUBHANDLER02_WRITE_BUSp
					; FDC_SUBHANDLER03_READ_BUSp
					; FDC_SUBHANDLER05_READ_TRACKp	...
		ld	a, (byte_0_268E)
		call	FDC_NEVIEM_sub_03B6 ; A=param (2?)
		ld	a, 80h ; 'Ç'
		ret	c
		ld	hl, FDC_byte_268B
		ld	a, (byte_0_268E)
		inc	a
		cp	(hl)
		jr	z, loc_0_17C6
		ld	(hl), a
		in	a, (39h)
		out	(3Bh), a
		ld	a, 18h		; Seek with head load
		call	FDC_RUN_CMD	; Write	command	read status (a=i/o value)
					; Called on init
		ld	a, 0C8h	; '╚'

loc_0_17AB:				; CODE XREF: FDC_COMMON_HANDLER+38j
		dec	a
		call	nz, CHECK_STUFF	; Called from *many* sites
		call	nz, CHECK_STUFF	; Called from *many* sites
		call	nz, CHECK_STUFF	; Called from *many* sites
		call	nz, CHECK_STUFF	; Called from *many* sites
		call	nz, CHECK_STUFF	; Called from *many* sites
		call	nz, CHECK_STUFF	; Called from *many* sites
		call	nz, CHECK_STUFF	; Called from *many* sites
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_17AB

loc_0_17C6:				; CODE XREF: FDC_COMMON_HANDLER+11j
		ld	a, (byte_0_2690)
		and	1
		add	a, a
		ld	b, a
		ld	a, (FDC_byte_2688)
		res	1, a
		or	b
		ld	(FDC_byte_2688), a
		ld	a, (byte_0_2690)
		call	FDC_SET_SIDE
		ld	a, 80h ; 'Ç'
		ret	c
		in	a, (39h)
		out	(3Bh), a
		ld	a, 18h		; Seek with head load
		call	FDC_RUN_CMD	; Write	command	read status (a=i/o value)
					; Called on init
		and	0C0h ; '└'
		bit	7, a
		scf	
		ret	nz
		ld	e, 0
		call	FDC_sub_04AA
		push	de
		pop	ix
		ld	a, (byte_0_268E)
		inc	a
		ld	hl, FDC_3_byte_2687
		and	(hl)
		ret	z
		cpl	
		and	(hl)
		ld	(hl), a
		ld	a, 8		; Restore (seek	zero) with head	load
		call	FDC_RUN_CMD	; Write	command	read status (a=i/o value)
					; Called on init
		ld	a, (byte_0_268E)
		ld	hl, unk_0_267E
		call	ADD16		; hl+=a
		xor	a
		ld	(hl), a
		ret	
; End of function FDC_COMMON_HANDLER


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_SEEK_AND_LOAD_HEAD:			; CODE XREF: FDC_SUBHANDLER01_SEEK+6p
					; FDC_SUBHANDLER02_WRITE_BUS+6p
					; FDC_SUBHANDLER03_READ_BUS+6p
					; FDC_SUBHANDLER05_READ_TRACK+6p
					; FDC_SUBHANDLER06_WRITE_TRACK+6p
		ld	a, (byte_0_268E)
		ld	hl, unk_0_267E
		call	ADD16		; hl+=a
		ld	a, (hl)
		call	FDC_sub_1836
		out	(39h), a
		ld	a, (byte_0_268F)
		ld	(hl), a
		push	af
		call	FDC_sub_1836
		out	(3Bh), a
		ld	a, 18h		; Seek with head load
		call	FDC_RUN_CMD	; Write	command	read status (a=i/o value)
					; Called on init
		pop	af
		out	(39h), a
		xor	a
		ret	
; End of function FDC_SEEK_AND_LOAD_HEAD


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_1836:				; CODE XREF: FDC_SEEK_AND_LOAD_HEAD+Ap
					; FDC_SEEK_AND_LOAD_HEAD+14p
		ld	e, (ix+IX_STRUCT.field_4)
		dec	e
		ret	nz
		add	a, a
		ret	
; End of function FDC_sub_1836


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_DMA_sub_183D:			; CODE XREF: FDC_SUBHANDLER02_WRITE_BUS+12p
		call	FDC_sub_19B5
		ld	hl, ARR_1_VAL_37
		ld	b, 1
		ld	c, DMA_ALL	; DMA -	All read and write registers
		otir	
		ld	a, 0
		call	FDC_DMA_WHAT
		ld	a, (byte_0_2690)
		call	FDC_SET_SIDE
		ld	a, (byte_0_2691)
		out	(3Ah), a
		ld	a, 88h ; 'ê'
		call	FDC_sub_190D
		and	9Ch ; '£'
		jp	nz, FDC_sub_1923
		ret	
; End of function FDC_DMA_sub_183D


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_DMA_sub_1864:			; CODE XREF: FDC_SUBHANDLER03_READ_BUS+15p
		call	FDC_sub_19B5
		ld	hl, DMA_ALL_3_0
		ld	b, 3
		ld	c, DMA_ALL	; DMA -	All read and write registers
		otir	
		ld	a, 0
		call	FDC_DMA_WHAT
		ld	a, (byte_0_2690)
		call	FDC_SET_SIDE
		ld	a, (byte_0_2691)
		out	(3Ah), a
		ld	a, 0A8h	; '¿'
		call	FDC_sub_190D
		and	0DCh ; '▄'
		jp	nz, FDC_sub_1923
		ret	
; End of function FDC_DMA_sub_1864


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_WRITE_BUS:				; CODE XREF: FDC_SUBHANDLER02_WRITE_BUS+18p
		call	FDC_sub_189B
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		xor	a
		ret	
; End of function FDC_WRITE_BUS


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_READ_BUS:				; CODE XREF: FDC_SUBHANDLER03_READ_BUS+12p
		call	FDC_sub_189B
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		xor	a
		ret	
; End of function FDC_READ_BUS


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_189B:				; CODE XREF: FDC_WRITE_BUSp
					; FDC_READ_BUSp
		ld	hl, word_0_2692
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		ex	de, hl
		ld	de, unk_0_201C
		ld	c, (ix+IX_STRUCT.PORT_BASE_1)
		ld	b, (ix+IX_STRUCT.PORT_BASE_2)
		ret	
; End of function FDC_sub_189B


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_READ_TRACK:				; CODE XREF: FDC_SUBHANDLER05_READ_TRACK+12p
		call	FDC_sub_19DC
		di	
		ld	a, 0E0h	; 'Ó'   ; Read track
		out	(38h), a

WAIT_FOR_INTRQ:				; CODE XREF: FDC_READ_TRACK+Bj
		call	PIO_A_GET_BIT7_FDC_INTRQ ; a=result
		jr	z, WAIT_FOR_INTRQ
		call	BUS_LATCH_sub_052D
		ei	
		call	CHECK_STUFF	; Called from *many* sites
		in	a, (38h)
		and	84h ; 'ä'
		ret	z
		scf	
		ret	
; End of function FDC_READ_TRACK


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_WRITE_TRACK:			; CODE XREF: FDC_SUBHANDLER06_WRITE_TRACK+12p
		call	FDC_sub_1A08
		di	
		ld	a, 0F0h	; '­'   ; Write track
		out	(38h), a

loc_0_18D1:				; CODE XREF: FDC_WRITE_TRACK+Bj
		call	PIO_A_GET_BIT7_FDC_INTRQ ; a=result
		jr	z, loc_0_18D1
		call	BUS_LATCH_sub_052D
		ei	
		call	CHECK_STUFF	; Called from *many* sites
		in	a, (38h)
		and	0C4h ; '─'
		ret	z
		scf	
		ret	
; End of function FDC_WRITE_TRACK


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_18E4:
		ld	bc, 0
		call	orphan_sub_18F2
		ret	nz
		ld	c, (ix+IX_STRUCT.PORT_BASE_1)
		ld	b, (ix+IX_STRUCT.PORT_BASE_2)
		dec	bc
; End of function orphan_sub_18E4


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_18F2:			; CODE XREF: orphan_sub_18E4+3p
		ld	hl, word_0_2692
		push	hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		ex	de, hl
		add	hl, bc
		adc	a, 0
		ex	de, hl
		ld	e, a
		ld	hl, (CCB_PTR+1)
		ld	a, (hl)
		xor	d
		and	80h ; 'Ç'
		inc	hl
		xor	(hl)
		xor	e
		pop	hl
		ret	
; End of function orphan_sub_18F2


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_190D:				; CODE XREF: FDC_DMA_sub_183D+1Ep
					; FDC_DMA_sub_1864+1Ep
		push	hl
		ld	hl, FDC_byte_2688
		or	(hl)
		pop	hl
; End of function FDC_sub_190D


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Write	command	read status (a=i/o value)
; Called on init
; Attributes: bp-based frame

FDC_RUN_CMD:				; CODE XREF: HANDLER08_FDC_sub_1547+27p
					; HANDLER08_FDC_sub_1547+5Fp
					; FDC_COMMON_HANDLER+1Ap
					; FDC_COMMON_HANDLER+59p
					; FDC_COMMON_HANDLER+78p ...
		out	(38h), a

loc_0_1915:				; CODE XREF: FDC_RUN_CMD+8j
		call	CHECK_STUFF	; Called from *many* sites
		call	PIO_A_GET_BIT7_FDC_INTRQ ; a=result
		jr	z, loc_0_1915
		call	CHECK_STUFF	; Called from *many* sites
		in	a, (38h)
		ret	
; End of function FDC_RUN_CMD


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_1923:				; CODE XREF: FDC_DMA_sub_183D+23j
					; FDC_DMA_sub_1864+23j
		ld	b, a
		ld	a, (byte_0_268E)
		inc	a
		ld	hl, FDC_3_byte_2687
		or	(hl)
		ld	(hl), a
		scf	
		ld	a, b
		ret	
; End of function FDC_sub_1923


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_1930:				; CODE XREF: HANDLER08_FDC_sub_1547+44p
					; HANDLER08_FDC_sub_1547+82p
		ld	e, 0
		call	SET_A_TO_6
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	7, b
		ret	
; End of function FDC_sub_1930


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_193B:
		ld	e, 0
		call	FDC_sub_04AA
		ld	bc, 20h	; ' '
		jp	WRITE_BUS_MEMORY ; hl=host address
; End of function orphan_sub_193B	; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_1946:
		ld	e, 0
		call	SET_A_TO_6
		ex	de, hl
		inc	hl
		ld	b, (hl)
		dec	hl
		ld	(hl), b
		ex	de, hl
		ld	bc, 4Ah	; 'J'
		jp	WRITE_BUS_MEMORY ; hl=host address
; End of function orphan_sub_1946	; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_1957:				; CODE XREF: HANDLER08_FDC_sub_1547+31p
					; HANDLER08_FDC_sub_1547+3Dp
					; HANDLER08_FDC_sub_1547+87p
					; HANDLER08_FDC_sub_1547+D6p
		ld	a, (byte_0_267C)
		ld	b, a
		ld	e, 1
		call	SET_A_TO_6
		ex	de, hl
		ld	(hl), b
		ex	de, hl
		ld	bc, 1
		jp	WRITE_BUS_MEMORY ; hl=host address
; End of function FDC_sub_1957		; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_1969:				; CODE XREF: HANDLER08_FDC_sub_1547+12Ep
		call	FDC_sub_1978	; ret: c=bad
		ret	c
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ret	
; End of function FDC_sub_1969


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_1971:				; CODE XREF: HANDLER08_FDC_sub_1547+139p
		call	FDC_sub_1978	; ret: c=bad
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ret	
; End of function FDC_sub_1971


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; ret: c=bad
; Attributes: bp-based frame

FDC_sub_1978:				; CODE XREF: FDC_sub_1969p
					; FDC_sub_1971p
		ld	e, 2
		call	SET_A_TO_6
		ld	bc, 6
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	a, (iy+IY_STRUCT.field_7)
		cp	(iy+IY_STRUCT.field_6)
		scf	
		ret	z
		add	a, a
		add	a, a
		add	a, (iy+IY_STRUCT.field_2)
		ld	l, a
		ld	a, 0
		adc	a, (iy+IY_STRUCT.field_3)
		ld	h, a
		ld	a, 0
		adc	a, (iy+IY_STRUCT.field_4)
		ld	de, FDC_SOME_BUS_BUF3
		ld	bc, 3
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	hl, FDC_SOME_BUS_BUF3
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		ld	a, (hl)
		ex	de, hl
		ld	de, FDC_SUB_COMMAND_BUFFER ; === FDC COMMAND BUFFER ===	11020
		ld	bc, 9
		ret	
; End of function FDC_sub_1978


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_19B5:				; CODE XREF: FDC_DMA_sub_183Dp
					; FDC_DMA_sub_1864p
		ld	hl, ARR_5_DMA_ALL_0
		ld	b, 5
		ld	c, DMA_ALL	; DMA -	All read and write registers
		otir	
		ld	de, unk_0_201C
		ld	c, DMA_ALL	; DMA -	All read and write registers
		out	(c), e
		out	(c), d
		ld	e, (ix+IX_STRUCT.PORT_BASE_1)
		ld	d, (ix+IX_STRUCT.PORT_BASE_2)
		dec	de
		out	(c), e
		out	(c), d
		ld	hl, ARR_3_DMA_ALL
		ld	b, 3
		ld	c, DMA_ALL	; DMA -	All read and write registers
		otir	
		ret	
; End of function FDC_sub_19B5


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_19DC:				; CODE XREF: FDC_READ_TRACKp
		ld	hl, ARR_5_DMA_ALL_0
		ld	b, 5
		ld	c, DMA_ALL	; DMA -	All read and write registers
		otir	
		ld	hl, (word_0_2692)
		ld	a, (byte_0_2694)
		push	hl
		push	bc
		call	BUS_READ8	; hl=host address
					; returns b=value
		pop	bc
		pop	hl
		set	7, h
		out	(c), l
		out	(c), h
		ld	a, 0FFh
		out	(c), a
		out	(c), a
		ld	hl, ARR_3_DMA_ALL
		ld	b, 3
		ld	c, DMA_ALL	; DMA -	All read and write registers
		otir	
		ret	
; End of function FDC_sub_19DC


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

FDC_sub_1A08:				; CODE XREF: FDC_WRITE_TRACKp
		ld	hl, ARR_5_DMA_ALL_0
		ld	b, 5
		ld	c, DMA_ALL	; DMA -	All read and write registers
		otir	
		ld	hl, (word_0_2692)
		ld	a, (byte_0_2694)
		push	hl
		call	loc_0_533
		pop	hl
		set	7, h
		out	(c), l
		out	(c), h
		ld	a, 0FFh
		out	(c), a
		out	(c), a
		ld	hl, ARR_3_DMA_ALL
		ld	b, 6
		ld	c, DMA_ALL	; DMA -	All read and write registers
		otir	
		ret	
; End of function FDC_sub_1A08

; ───────────────────────────────────────────────────────────────────────────
ARR_5_DMA_ALL_0:.db 0C3h, 14h, 28h, 92h, 79h ; DATA XREF: FDC_sub_19B5o
					; FDC_sub_19DCo FDC_sub_1A08o
ARR_3_DMA_ALL:	.db 85h, 3Bh, 0CFh	; DATA XREF: FDC_sub_19B5+1Do
					; FDC_sub_19DC+22o FDC_sub_1A08+20o
DMA_ALL_3_0:	.db 5, 0CFh		; DATA XREF: FDC_DMA_sub_1864+3o
ARR_1_VAL_37:	.db 87h			; DATA XREF: FDC_DMA_sub_183D+3o

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER00_sub_1A3D:			; CODE XREF: HANDLER00_sub_1A3D+10j
					; HANDLER00_sub_1A3D+6Aj
					; DATA XREF: ROM:012Bo
		call	CHECK_STUFF	; Called from *many* sites
		ld	e, SYS_NEW_CMD	; SYS -	New Command Register
		call	MAKE_CCB_ADDRESS
		call	BUS_READ8	; hl=host address
					; returns b=value
		ld	hl, LAST_CMD_COUNTER
		ld	a, b
		cp	(hl)
		jr	z, HANDLER00_sub_1A3D ;	Wait for next command
		ld	(hl), a		; New command found!
					; Take a note of this command.
		ld	e, SYS_SYS_CMD	; SYS -	System Command Register
		call	MAKE_CCB_ADDRESS
		push	de
		call	BUS_READ8	; hl=host address
					; returns b=value
		pop	hl
		ld	(hl), b
		ld	l, 1
		bit	7, b
		call	nz, sub_0_280
		ld	hl, byte_0_1AA9

loc_0_1A65:				; CODE XREF: HANDLER00_sub_1A3D+40j
					; HANDLER00_sub_1A3D+49j
		ld	a, (hl)
		inc	hl
		cp	0FFh
		jp	z, loc_0_1A89
		ld	e, 4
		push	hl
		call	sub_0_4B8
		push	de
		call	BUS_READ8	; hl=host address
					; returns b=value
		pop	hl
		ld	(hl), b
		pop	hl
		ld	e, (hl)
		inc	hl
		bit	7, b
		jp	z, loc_0_1A65
		push	hl
		ld	l, e
		call	sub_0_280
		pop	hl
		jp	loc_0_1A65
; ───────────────────────────────────────────────────────────────────────────

loc_0_1A89:				; CODE XREF: HANDLER00_sub_1A3D+2Cj
		ld	e, 0
		call	SET_A_TO_6
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	7, b
		ld	l, 8
		call	nz, sub_0_280
		ld	e, 0
		call	UNKNOWN_SYS_REG_ADDR ; Maybe RTC?
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	7, b
		ld	l, 9
		call	nz, sub_0_280
		jr	HANDLER00_sub_1A3D
; End of function HANDLER00_sub_1A3D

; ───────────────────────────────────────────────────────────────────────────
byte_0_1AA9:	.db 0, 2, 1, 3,	2, 4, 3, 5, 4, 6, 5, 7 ; DATA XREF: HANDLER00_sub_1A3D+25o
MONITOR_PTR:	.dw MONITOR_ENTRY
		.dw sub_0_1AD2

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

orphan_sub_1AB9:
		call	STH_INT_RELATED_PERHAPS
		call	CHECK_STUFF	; Called from *many* sites
		ei	

loc_0_1AC0:				; CODE XREF: orphan_sub_1AB9+17j
		call	ZERO_SAVED_TASK_sub_028C
		call	CHECK_STUFF	; Called from *many* sites
		ld	e, SYS_SYS_STAT	; SYS -	System Status Register
		call	MAKE_CCB_ADDRESS
		ld	b, 8
		call	BUS_WRITE8	; b=data byte
		jr	loc_0_1AC0
; End of function orphan_sub_1AB9


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

sub_0_1AD2:				; DATA XREF: ROM:1AB7o
		call	PIO_A_GET_BIT6	; a=result
		ret	z
		ret	
; End of function sub_0_1AD2


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER09_RTC_sub_1AD7:			; DATA XREF: ROM:0146o
		call	CHECK_STUFF	; Called from *many* sites
		ld	e, SYS_FW_VER	; SYS -	Firmware Version Register
		call	MAKE_CCB_ADDRESS
		ld	b, 50
		call	BUS_WRITE8	; b=data byte

loc_0_1AE4:				; CODE XREF: HANDLER09_RTC_sub_1AD7+C4j
		call	ZERO_SAVED_TASK_sub_028C
		call	CHECK_STUFF	; Called from *many* sites
		ld	e, 0
		call	UNKNOWN_SYS_REG_ADDR ; Maybe RTC?
		ld	bc, 8
		push	de
		call	READ_BUS_MEMORY	; ix=24-bit host mem address pointer
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		pop	hl
		res	7, (hl)
		ld	a, (hl)
		cp	2
		jr	nz, loc_0_1B1E
		push	hl
		out	(95h), a
		inc	hl
		ld	a, (hl)
		out	(82h), a
		inc	hl
		ld	a, (hl)
		out	(83h), a
		inc	hl
		ld	a, (hl)
		out	(84h), a
		inc	hl
		ld	a, (hl)
		out	(85h), a
		inc	hl
		ld	a, (hl)
		out	(86h), a
		inc	hl
		ld	a, (hl)
		out	(87h), a
		inc	hl
		ld	a, (hl)
		out	(89h), a
		pop	hl

loc_0_1B1E:				; CODE XREF: HANDLER09_RTC_sub_1AD7+25j
		push	hl

loc_0_1B1F:				; CODE XREF: HANDLER09_RTC_sub_1AD7+51j
					; HANDLER09_RTC_sub_1AD7+5Ej
					; HANDLER09_RTC_sub_1AD7+6Bj
					; HANDLER09_RTC_sub_1AD7+78j
					; HANDLER09_RTC_sub_1AD7+85j ...
		pop	hl
		push	hl
		in	a, (94h)
		bit	0, a
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1B1F
		inc	hl
		in	a, (82h)
		ld	(hl), a
		in	a, (94h)
		bit	0, a
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1B1F
		inc	hl
		in	a, (83h)
		ld	(hl), a
		in	a, (94h)
		bit	0, a
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1B1F
		inc	hl
		in	a, (84h)
		ld	(hl), a
		in	a, (94h)
		bit	0, a
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1B1F
		inc	hl
		in	a, (85h)
		ld	(hl), a
		in	a, (94h)
		bit	0, a
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1B1F
		inc	hl
		in	a, (86h)
		ld	(hl), a
		in	a, (94h)
		bit	0, a
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1B1F
		inc	hl
		in	a, (87h)
		ld	(hl), a
		in	a, (94h)
		bit	0, a
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1B1F
		inc	hl
		in	a, (89h)
		ld	(hl), a
		in	a, (94h)
		bit	0, a
		call	nz, CHECK_STUFF	; Called from *many* sites
		jr	nz, loc_0_1B1F
		pop	hl
		ld	e, 1
		call	UNKNOWN_SYS_REG_ADDR ; Maybe RTC?
		ld	bc, 7
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	e, 0
		call	UNKNOWN_SYS_REG_ADDR ; Maybe RTC?
		ld	b, 0
		call	BUS_WRITE8	; b=data byte
		jp	loc_0_1AE4
; End of function HANDLER09_RTC_sub_1AD7


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

HANDLER01_SYS_COMMAND:			; CODE XREF: HANDLER01_SYS_COMMAND+4Fj
					; DATA XREF: ROM:012Eo
		call	CHECK_STUFF	; Called from *many* sites
		ld	e, SYS_SYS_CMD	; SYS -	System Command Register
		call	MAKE_CCB_ADDRESS
		call	BUS_READ8	; hl=host address
					; returns b=value
		bit	7, b
		jr	z, loc_0_1BE7
		ld	a, b
		and	7Fh ; ''
		ld	hl, HANDLER01_unk_1BF0
		call	ADD16		; hl+=a
		ld	b, (hl)
		ld	a, b
		and	7Fh ; ''
		bit	7, b
		ld	hl, _00_FROM_BEGINNING
		jp	nz, loc_0_1BC7
		cpl	
		and	(hl)
		jp	loc_0_1BC8
; ───────────────────────────────────────────────────────────────────────────

loc_0_1BC7:				; CODE XREF: HANDLER01_SYS_COMMAND+21j
		or	(hl)

loc_0_1BC8:				; CODE XREF: HANDLER01_SYS_COMMAND+26j
		ld	(hl), a
		dec	hl
		ld	(hl), 0
		ld	e, SYS_SYS_STAT	; SYS -	System Status Register
		call	MAKE_CCB_ADDRESS
		ld	bc, 1
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	e, SYS_SYS_CMD	; SYS -	System Command Register
		call	MAKE_CCB_ADDRESS
		ld	bc, 1
		call	WRITE_BUS_MEMORY ; hl=host address
					; ix=24-bit host mem address pointer (for window)
					; c=count, (de)=source
					; ix=preserved,	interrupts off/on
		ld	a, 1
		ld	(HOST_MEM_byte_26FE), a

loc_0_1BE7:				; CODE XREF: HANDLER01_SYS_COMMAND+Dj
		call	ZERO_SAVED_TASK_sub_028C
		call	CHECK_STUFF	; Called from *many* sites
		jp	HANDLER01_SYS_COMMAND
; End of function HANDLER01_SYS_COMMAND

; ───────────────────────────────────────────────────────────────────────────

HANDLER01_unk_1BF0:			; DATA XREF: HANDLER01_SYS_COMMAND+12o
		ld	bc, 281h
		add	a, d
		inc	b
		call	ZERO_SAVED_TASK_sub_028C
		call	CHECK_STUFF	; Called from *many* sites
		jp	2800h
; ───────────────────────────────────────────────────────────────────────────

IX_stru_1BFE:				; DATA XREF: HANDLER02_SIO_sub_0A26o
		nop	
		ld	(bc), a
		inc	l
		inc	l
		ex	af, af'
		inc	hl
		or	(hl)
		ld	(word_0_2266), hl
		ld	d, h
		dec	h
		nop	

IX_stru_1C0B:				; DATA XREF: HANDLER03_SIO_sub_0A30o
		ld	bc, 2E03h
		inc	l
		nop	
		daa	
		ld	(hl), 24h ; '$'
		ld	a, h
		ld	(word_0_2554), hl
		nop	

IX_stru_1C18:				; DATA XREF: HANDLER04_SIO_sub_0A3Ao
		ld	(bc), a
		inc	b
		jr	z, loc_0_1C44
		ex	af, af'
		inc	hl
		ld	(hl), 20h ; ' '
		sub	d
		ld	(word_0_2554), hl
		ld	(bc), a

IX_stru_1C25:				; DATA XREF: HANDLER05_SIO_sub_0A44o
					; orphan_sub_11EDo
		inc	bc
		dec	b
		ld	hl, (byte_0_21+7)
		inc	hl
		halt	
		ld	hl, 22A8h
		ld	d, h
		dec	h
		nop	

IX_stru_1C32:				; DATA XREF: HANDLER06_SIO_sub_0A4Eo
		inc	b
		ld	b, 30h ; '0'
		jr	nc, IX_stru_1C3F
		daa	
		halt	
		dec	h
		cp	(hl)
		ld	(word_0_2554), hl
		dec	b

IX_stru_1C3F:				; CODE XREF: ROM:1C35j
					; DATA XREF: HANDLER07_SIO_sub_0A58o
		dec	b
		rlca	
		ld	(byte_0_21+0Fh), a

loc_0_1C44:				; CODE XREF: ROM:1C1Aj
		rst	38h		; Mode 1 interrupt handler
		rst	38h		; Mode 1 interrupt handler
		rst	38h		; Mode 1 interrupt handler
		call	nc, 6822h
		dec	h
		nop	

; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

STH_INT_RELATED_PERHAPS:		; CODE XREF: HANDLER_SIO_L0_COMMON+15p
					; orphan_sub_1AB9p
		ld	hl, byte_0_2698
		ld	a, (hl)
		cp	0Ah
		scf	
		ret	z
		inc	(hl)
		add	a, a
		ld	b, a
		add	a, a
		add	a, b
		ld	hl, unk_0_2699
		call	ADD16		; hl+=a
		push	ix
		pop	bc
		ld	(hl), c
		inc	hl
		ld	(hl), b
		inc	hl
		push	iy
		pop	bc
		ld	(hl), c
		inc	hl
		ld	(hl), b
		inc	hl
		ld	(hl), e
		inc	hl
		ld	(hl), d
		or	a
		ret	
; End of function STH_INT_RELATED_PERHAPS


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

DO_INT_HANDLER:				; CODE XREF: INT_HANDLERj
		exx	
		ex	af, af'
		push	ix
		push	iy
		ld	a, 0FFh
		ld	(FF_FROM_BEGINNING), a ; NMI handler puts FF here first
		ld	hl, unk_0_2699
		ld	a, (byte_0_2698)
		ld	b, a

loc_0_1C84:				; CODE XREF: DO_INT_HANDLER+19j
		dec	b
		jp	m, loc_0_1C8D
		call	INT_sub_1C9A
		jr	nc, loc_0_1C84

loc_0_1C8D:				; CODE XREF: DO_INT_HANDLER+13j
		xor	a
		ld	(FF_FROM_BEGINNING), a ; NMI handler puts FF here first
		exx	
		ex	af, af'
		pop	iy
		pop	ix
		ei	
		reti	
; End of function DO_INT_HANDLER


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

INT_sub_1C9A:				; CODE XREF: DO_INT_HANDLER+16p
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		push	de
		pop	ix
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		push	de
		pop	iy
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		inc	hl
		push	hl
		push	bc
		ld	hl, INT_RET_sub_1CB4
		push	hl
		ex	de, hl
		jp	(hl)
; End of function INT_sub_1C9A


; ███████████████ S U B	R O U T	I N E ███████████████████████████████████████

; Attributes: bp-based frame

INT_RET_sub_1CB4:			; DATA XREF: INT_sub_1C9A+14o
		pop	bc
		pop	hl
		ret	
; End of function INT_RET_sub_1CB4

; ───────────────────────────────────────────────────────────────────────────
off_0_1CB7:	.dw byte_0_26DC		; DATA XREF: sub_0_2DB+3o
		.dw unk_0_26F7
		.dw word_0_26DE+1
		.dw unk_0_26E8
		.dw unk_0_26EE
		.dw word_0_26E2
		.dw word_0_26E4+1
		.dw unk_0_26EB
		.dw unk_0_26F1
		.dw unk_0_26F4
word_0_1CCB:	.dw 0FFFCh		; DATA XREF: DO_NMI_HANDLER+3Ar
byte_0_1CCD:	.db 1			; DATA XREF: DO_NMI_HANDLER+3Dr
byte_0_1CCE:	.db 1Fh, 7Fh, 3Fh, 0FFh	; DATA XREF: SIO_L1H_sub_0D4C+23o
byte_0_1CD2:	.db 0, 16h, 2Ch, 42h, 58h, 6Eh,	84h ; DATA XREF: sub_0_4B8o
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0
		.db 0, 0, 0, 0,	0, 0, 0, 0
; end of 'ROM'

; ═══════════════════════════════════════════════════════════════════════════

; Segment type:	Regular
; segment 'RAM'
		.org 2000h
SRAM_JUMP_SLOT1:.block 1		; CODE XREF: DO_NMI_HANDLERp
					; DATA XREF: STARTo
		.block 1
		.block 1
SRAM_JUMP_SLOT2:.block 1		; CODE XREF: FH_JUMP_SLOT2_sub_116E+4j
		.block 1
		.block 1
SRAM_JUMP_SLOT3:.block 1		; CODE XREF: FH_JUMP_SLOT3_sub_10F3+4j
		.block 1
		.block 1
SRAM_JUMP_SLOT4:.block 1		; CODE XREF: FH_JUMP_SLOT4_sub_1133+4j
		.block 1
		.block 1
SRAM_JUMP_SLOT5:.block 1		; CODE XREF: FH_JUMP_SLOT5_sub_1097+4j
		.block 1
		.block 1
CCB_PTR:	.block 3		; DATA XREF: DO_NMI_HANDLER+4o
					; DO_NMI_HANDLER+40o
					; DO_NMI_HANDLER+4Co
					; MAKE_CCB_ADDRESS+9o
					; orphan_sub_18F2+Fr
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
unk_0_201C:	.block 1		; DATA XREF: SIO0_sub_070B+3Bo
					; FDC_sub_189B+9o FDC_sub_19B5+9o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
unk_0_2260:	.block 1		; DATA XREF: DO_CHECK_STUFF+Do
					; MAKE_CCB_ADDRESS+1o
		.block 1
_00_FROM_BEGINNING:.block 1		; DATA XREF: DO_NMI_HANDLER+26w
					; HANDLER_SIO_L0_COMMON+26r
					; orphan_sub_11ED+8r
					; HANDLER01_SYS_COMMAND+1Eo
_00_FROM_BEGINNING_1:.block 2		; DATA XREF: DO_NMI_HANDLER+37w
					; FDC_CHECK_sub_0478+2Cw
		.block 1
word_0_2266:	.block 2		; DATA XREF: ROM:1C05w
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
FDC_IY_BUF_unk_22EA:.block 1		; DATA XREF: HANDLER08_FDC_sub_1547o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
FDC_ARR_16_byte_2304:.block 10h		; DATA XREF: HANDLER08_FDC_sub_1547+102o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
FDC_ARR_16_byte_2324:.block 10h		; DATA XREF: HANDLER08_FDC_sub_1547+10Ao
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
FF_FROM_BEGINNING:.block 1		; DATA XREF: DO_NMI_HANDLER+14w
					; DO_NMI_HANDLER+72o
					; DO_NMI_HANDLER+9Fw TAIL_EI+1r
					; DO_INT_HANDLER+8w ...
					; NMI handler puts FF here first
byte_0_2551:	.block 1		; DATA XREF: sub_0_360+8r
					; sub_0_360+1Dr sub_0_360+30w
					; SIO_sub_0807+44r
unk_0_2552:	.block 1		; DATA XREF: sub_0_360+1o
					; SIO_sub_03A6o
unk_0_2553:	.block 1		; DATA XREF: sub_0_360+16o
					; ZERO_TO_SOME_VAR_sub_03ACo
word_0_2554:	.block 2		; DATA XREF: ROM:1C14w	ROM:1C21w
					; ROM:1C3Bw
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
IY_CH0_stru_2568:.block	1		; DATA XREF: HANDLER02_SIO_sub_0A26+4o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
unk_0_2570:	.block 1		; DATA XREF: ROM:0149o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
IY_CH1_stru_2596:.block	1		; DATA XREF: HANDLER03_SIO_sub_0A30+4o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
unk_0_259E:	.block 1		; DATA XREF: ROM:0149o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
IY_CH2_stru_25C4:.block	1		; DATA XREF: HANDLER04_SIO_sub_0A3A+4o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
unk_0_25CC:	.block 1		; DATA XREF: ROM:0149o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
IY_CH3_stru_25F2:.block	1		; DATA XREF: HANDLER05_SIO_sub_0A44+4o
					; orphan_sub_11ED+4o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
unk_0_25FA:	.block 1		; DATA XREF: ROM:0149o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
IY_CH4_stru_2620:.block	1		; DATA XREF: HANDLER06_SIO_sub_0A4E+4o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
unk_0_2628:	.block 1		; DATA XREF: ROM:0149o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
IY_CH5_stru_264E:.block	1		; DATA XREF: HANDLER07_SIO_sub_0A58+4o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
unk_0_2656:	.block 1		; DATA XREF: ROM:0149o
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
byte_0_267C:	.block 1		; DATA XREF: MONITOR_PROMPT+3w
					; MONITOR_PROMPT+19r
					; MONITOR_PROMPT+21w
					; MONITOR_PROMPT+3Fr
					; MONITOR_PROMPT+44w ...
FDC_DRIVE_OR_WHAT:.block 1		; DATA XREF: ROM:03C4w	FDC_sub_04AAr
unk_0_267E:	.block 1		; DATA XREF: MONITOR_PROMPTo
					; MONITOR_sub_135Fo
					; FDC_COMMON_HANDLER+7Eo
					; FDC_SEEK_AND_LOAD_HEAD+3o
		.block 1
FDC_HANDLER_ADDRESS:.block 2		; DATA XREF: FDC_PICK_HANDLER_FROM_VECTOR+22w
					; ROM:16DDr
					; Handler address
FDC_SUBCOMMAND:	.block 1		; DATA XREF: FDC_PICK_HANDLER_FROM_VECTOR+Bw
					; ROM:16CFr
FDC_ZERO:	.block 1		; DATA XREF: FDC_PICK_HANDLER_FROM_VECTOR+Fw
					; ROM:16CCo
FDC_SOME_BUS_BUF3:.block 3		; DATA XREF: FDC_sub_1978+24o
					; FDC_sub_1978+2Do
FDC_3_byte_2687:.block 1		; DATA XREF: HANDLER08_FDC_sub_1547+6w
					; HANDLER08_FDC_sub_1547+11Cw
					; FDC_COMMON_HANDLER+6Eo
					; FDC_sub_1923+5o
FDC_byte_2688:	.block 1		; DATA XREF: HANDLER08_FDC_sub_1547+Dw
					; FDC_COMMON_HANDLER+41r
					; FDC_COMMON_HANDLER+47w
					; FDC_sub_190D+1o
FDC_word_2689:	.block 2		; DATA XREF: HANDLER08_FDC_sub_1547+13w
					; HANDLER08_FDC_sub_1547+40r
FDC_byte_268B:	.block 1		; DATA XREF: HANDLER08_FDC_sub_1547+1Bw
					; HANDLER08_FDC_sub_1547+53w
					; FDC_COMMON_HANDLER+9o
FDC_SUB_COMMAND_BUFFER:.block 1		; DATA XREF: FDC_PICK_HANDLER_FROM_VECTORr
					; FDC_sub_1978+36o
					; === FDC COMMAND BUFFER === 11020
byte_0_268D:	.block 1		; DATA XREF: HANDLER08_FDC_sub_1547+136w
byte_0_268E:	.block 1		; DATA XREF: HANDLER08_FDC_sub_1547+68r
					; FDC_COMMON_HANDLERr
					; FDC_COMMON_HANDLER+Cr
					; FDC_COMMON_HANDLER+6Ar
					; FDC_COMMON_HANDLER+7Br ...
byte_0_268F:	.block 1		; DATA XREF: FDC_SEEK_AND_LOAD_HEAD+Fr
byte_0_2690:	.block 1		; DATA XREF: FDC_COMMON_HANDLER+3Ar
					; FDC_COMMON_HANDLER+4Ar
					; FDC_DMA_sub_183D+11r
					; FDC_DMA_sub_1864+11r
byte_0_2691:	.block 1		; DATA XREF: FDC_DMA_sub_183D+17r
					; FDC_DMA_sub_1864+17r
word_0_2692:	.block 2		; DATA XREF: FDC_sub_189Bo
					; orphan_sub_18F2o FDC_sub_19DC+9r
					; FDC_sub_1A08+9r
byte_0_2694:	.block 1		; DATA XREF: FDC_sub_19DC+Cr
					; FDC_sub_1A08+Cr
		.block 1
ADDRESS_LATCH_SET_VALUE:.block 1	; DATA XREF: SET_BUS_ADDRESS_LATCH+Cw
LAST_CMD_COUNTER:.block	1		; DATA XREF: HANDLER00_sub_1A3D+Bo
byte_0_2698:	.block 1		; DATA XREF: STH_INT_RELATED_PERHAPSo
					; DO_INT_HANDLER+Er
unk_0_2699:	.block 1		; DATA XREF: STH_INT_RELATED_PERHAPS+Do
					; DO_INT_HANDLER+Bo
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
		.block 1
word_0_26CF:	.block 2		; DATA XREF: MONITOR_sub_135F+9w
					; MONITOR_sub_135F+37r
					; MONITOR_sub_135F+4Br
					; MONITOR_sub_135F+4Fw
					; MONITOR_sub_1408+3w
word_0_26D1:	.block 2		; DATA XREF: MONITOR_sub_135F+Dw
					; MONITOR_sub_13EC+10w
					; MONITOR_PRINT_STH+1Br
					; MONITOR_sub_14A1r
					; MONITOR_PRINT_STH+15r
word_0_26D3:	.block 2		; DATA XREF: MONITOR_sub_135F+10w
					; MONITOR_sub_135F+55r
					; MONITOR_sub_135F+59w
					; MONITOR_sub_135F+78r
					; MONITOR_sub_135F+84r	...
_00_FROM_BEGINNING_0:.block 1		; DATA XREF: DO_NMI_HANDLER+29w
					; DO_NMI_HANDLER+5Eo NEXT_BUS_BYTE+8r
					; SET_BUS_ADDRESS_LATCH+1Ar
					; MONITOR_sub_135F+71r	...
byte_0_26D6:	.block 1		; DATA XREF: DO_NMI_HANDLER+64o
					; MONITOR_sub_12A7r
					; MONITOR_sub_12A7+7w
					; MONITOR_sub_12A7+19r
					; MONITOR_sub_1310r ...
BUS_ADDR:	.block 2		; DATA XREF: HOST_MEM_WINDOWo
					; NEXT_BUS_BYTEo ROM:1207w
					; MONITOR_PUTCHAR+1Eo
byte_0_26D9:	.block 1		; DATA XREF: ROM:120Aw
unk_0_26DA:	.block 1		; DATA XREF: ROM:1210w
_0A_FROM_BEGINNING:.block 1		; DATA XREF: DO_NMI_HANDLER+22w
					; sub_0_2C9o
byte_0_26DC:	.block 1		; DATA XREF: sub_0_292+6o sub_0_2E9+Fo
					; orphan_sub_1518+6r ROM:1CB7o
unk_0_26DD:	.block 1		; DATA XREF: orphan_sub_1518+1Fo
word_0_26DE:	.block 2		; DATA XREF: orphan_sub_1518+1w
					; ROM:1CBBo
word_0_26E0:	.block 2		; DATA XREF: orphan_sub_1518+Dw
word_0_26E2:	.block 2		; DATA XREF: orphan_sub_1518+1Aw
					; ROM:1CC1o
word_0_26E4:	.block 2		; DATA XREF: orphan_sub_1518+15w
					; ROM:1CC3o
word_0_26E6:	.block 2		; DATA XREF: orphan_sub_1518+11w
unk_0_26E8:	.block 1		; DATA XREF: ROM:1CBDo
		.block 1
		.block 1
unk_0_26EB:	.block 1		; DATA XREF: ROM:1CC5o
		.block 1
		.block 1
unk_0_26EE:	.block 1		; DATA XREF: ROM:1CBFo
		.block 1
		.block 1
unk_0_26F1:	.block 1		; DATA XREF: ROM:1CC7o
		.block 1
		.block 1
unk_0_26F4:	.block 1		; DATA XREF: ROM:1CC9o
		.block 1
		.block 1
unk_0_26F7:	.block 1		; DATA XREF: ROM:1CB9o
		.block 1
		.block 1
SAVED_TASK_XXX:	.block 2		; DATA XREF: ZERO_SAVED_TASK_sub_028Cr
					; CHECK_STUFF+10r TAIL_sub_02B4+3w
SAVE_DE_ADDR:	.block 2		; DATA XREF: DO_NMI_HANDLER+75w
					; sub_0_2E9r sub_0_2E9+20w
HOST_MEM_byte_26FE:.block 1		; DATA XREF: DO_CHECK_STUFFo
					; sub_0_458+11w
					; HANDLER01_SYS_COMMAND+46w
ARR12_WIPED_FROM_BEGINNING:.block 0Ch	; DATA XREF: DO_NMI_HANDLER+2Co
					; HANDLER_SIO_L0_COMMON+5Bo sub_0_46Fo
					; SIO_L1H_sub_065F+15o
					; SIO_L1H_sub_065F+20o	...
word_0_270B:	.block 2		; DATA XREF: BUS_LATCH_sub_052D+7r
					; BUS_LATCH_sub_052D+14w
					; BUS_LATCH_sub_052D+Ew
unk_0_270D:	.block 1		; DATA XREF: BUS_LATCH_sub_052D+3r
					; BUS_LATCH_sub_052D+Aw
byte_0_270E:	.block 1		; DATA XREF: BUS_LATCH_sub_052Dr
CH0_BUF:	.block 40		; DATA XREF: ROM:0149o
CH1_BUF:	.block 40		; DATA XREF: ROM:0149o
CH2_BUF:	.block 40		; DATA XREF: ROM:0149o
CH3_BUF:	.block 40		; DATA XREF: ROM:0149o
CH4_BUF:	.block 40		; DATA XREF: ROM:0149o
CH5_BUF:	.block 40		; DATA XREF: ROM:0149o
STACK_TOP:	.block 1		; DATA XREF: START+9o
					; DO_NMI_HANDLER+17o
; end of 'RAM'


		.end
