;========================================================================
; Altos 586 Firmware							:
;									:
; Reconstructed soruce code from v1.3 firmware				:
; Build with YASM:							:
;									:
;   yasm -o altos586.bin -l altos586.lst altos586.asm			:
;========================================================================

;------------------------------------------------------------------------
; The v1.3 firmware is 8K in size, stored in 2 x 2732 ROM chips.	:
;									:
; The firmware is in the segment starting at FE00:0000.			:
; The CPU board can also take 2764 chips, allowing for 16K firmware	:
; starting at FC00:0000. Switching the ROMLEN macro to 4000h achieves	:
; just that. The SYSCALL_ENTRY still needs to stay at FE00:0000 -- code	:
; could be added or moved before that (see .code_low section).		:
;------------------------------------------------------------------------
;%define ROMLEN 04000h	; 16K image
%define ROMLEN 02000h	; 8K image
%define ROMSEG 10000h-(ROMLEN/16)

; I/O controller command register
IOC_BUSY		equ 80h
IOC_ENABLE		equ 01h

; Serial I/O channel command register
SIO_BUSY		equ 80h
SIO_INIT_CHAN		equ 01h
SIO_START_TX		equ 02h
SIO_ACK_RX		equ 03h
SIO_RESET_ERR		equ 09h

SIO_TX_LEN		equ 10

SIO_0_RX_LEN		equ 10
SIO_1_RX_LEN		equ 1350	; Larger, for hex download
SIO_2_RX_LEN		equ 10
SIO_3_RX_LEN		equ 10
SIO_4_RX_LEN		equ 10
SIO_5_RX_LEN		equ 10

struc SIO_REGS
.PARM:			resw 1		; Channel Parameter Register
.STAT:			resw 1		; Channel Status Register
.CMD:			resb 1		; Channel Command Register
.TX_LO:			resb 1		; Transmit Data Buffer Address Register LO
.TX_HI:			resw 1		; Transmit Data Buffer Address Register HI
.TX_LEN:		resw 1		; Transmit Data Buffer Length Register

; These fields are used only in the bufferred input mode.
; The firmware only uses the buffered mode, not the TTY mode.
.RX_LO:			resw 1		; Receive Data Buffer Address Register LO
.RX_HI:			resb 1		; Receive Data Buffer Address Register HI
.RX_LEN:		resw 1		; Receive Data Buffer Length Register
.RX_IN:			resw 1		; Receive Buffer Input Pointer Register
.RX_OUT:		resw 1		; Receive Buffer Output Pointer Register

.RATE:			resw 1		; Selectable Rate Register
.RESERVED:		resb 1		; Not used
endstruc

; Floppy channel command register
FDC_BUSY		equ 80h
FDC_FLOPPY_PARAMS	equ 07h
FDC_RUN_IO		equ 08h

struc FDC_REGS
.COMMAND:		resb 1
.STATUS:		resb 1
.QUEUE_ADDR_LO:		resw 1
.QUEUE_ADDR_HI:		resb 1
.QUEUE_LEN:		resb 1
.QUEUE_END:		resb 1
.QUEUE_NEXT:		resb 1
.UNUSED1:		resb 1
.UNUSED2:		resb 1
.PARAMS_1:		resb 32
.PARAMS_2:		resb 32
endstruc

; I/O system call Parameter Block
struc IOPB
.MON_RSVD_1:		resw 1
.MON_RSVD_2:		resw 1
.DISK_OPCODE:		resb 1
.DISK_DRIVE_NUM:	resb 1
.DISK_TRACK:		resw 1
.DISK_HEAD:		resb 1
.DISK_SECTOR:		resb 1
.DISK_SECTOR_COUNT:	resb 1
.DISK_OP_STATUS:	resb 1
.UNK:			resb 1
.DISK_RETRIES:		resb 1
.DISK_DMA_OFFSET:	resw 1
.DISK_DMA_SEGMENT:	resw 1
.DISK_SECTOR_LEN:	resw 1
endstruc

struc I8089_SCP
.BUS_TYPE:		resb 1		; 1 = 16-bit, 0 = 8-bit
.UNUSED0:		resb 1
.SCB_OFF:		resw 1		; offset (00000000)
.SCB_SEG:		resw 1
endstruc

struc I8089_SCB
.SOC:			resb 1
.UNUSED1:		resb 1
.CB_OFF:		resw 1
.CB_SEG:		resw 1
endstruc

struc I8089_CB
.CCW:			resb 1
.BUSY:			resb 1
.PB_OFF:		resw 1
.PB_SEG:		resw 1
.UNUSED2:		resw 1
endstruc

struc I8089_PB
.IOP_OFFSET:		resw 1
.IOP_SEGMENT:		resw 1
.HDD_OPCODE:		resb 1
.HDD_STATUS:		resb 1
.HDD_CYLINDER:		resw 1
.HDD_DRIVE_AND_HEAD:	resb 1
.HDD_SECTOR:		resb 1
.HDD_SECTOR_LEN:	resw 1
.HDD_DMA_OFFSET:	resw 1
.HDD_DMA_SEGMENT:	resw 1
.RESVD_0:		resw 1
.RESVD_1:		resw 1
.RESVD_2:		resw 1
.RESVD_3:		resw 1
.RESVD_4:		resw 1
endstruc

struc CPU_REGS
.AX:			resw 1
.BX:			resw 1
.CX:			resw 1
.DX:			resw 1
.SI:			resw 1
.DI:			resw 1
.DS:			resw 1
.ES:			resw 1
.SS:			resw 1
.SP:			resw 1
.BP:			resw 1
.FLAGS:			resw 1
.IP:			resw 1
.CS:			resw 1
endstruc

Z80_CHAN_ATTN		equ 00050h	; Z80A I/O Processor Chan att.
CONTROL_BITS		equ 00058h	; Control Bits Port - Write Only.
MMU_ERROR		equ 00060h	; MMU - Error Address 2 - Read Only.
MMU_MEMV_CLEAR		equ 00070h	; MMU - Clear Violation Port
MMU_MEMV		equ 00078h	; MMU - Violation Port - Read Only.
PIC_2			equ 00080h	; PIC - ICW2, ICW3, ICW4, or OCW1
PIC_1			equ 00082h	; PIC - ICW1, OCW2, or OCW3
PIT_CTRL		equ 00101h	; PIT - Control Word Register - Write Only
PIT_CNT_2		equ 00103h	; PIT - Counter 2
PIT_CNT_1		equ 00105h	; PIT - Counter 1
PIT_CNT_0		equ 00107h	; PIT - Counter 0
MMU_BASE		equ 00200h
IO_HDD			equ 07000h	; Requests hard disk or memory-to-memory operation
IO_FDD			equ 07008h	; Requests floppy disk operation
IO_TAPE			equ 07010h	; Requests tape operation
BUS_RSVD_0		equ 0FF00h	; Reserved for system bus I/O.
BUS_RSVD_1		equ 0FF80h	; Reserved for system bus I/O.

;========================================================================
section .zero nobits vstart=0

times 0*4-($-$$)	db ?
INT0_OFF		dw ?
INT0_SEG		dw ?

times 33*4-($-$$)	db ?
INT33_TIMER_OFF		dw ?
INT33_TIMER_SEG		dw ?

times 380h-($-$$) db ?
IOP1_PTR istruc I8089_CB
	at I8089_CB.CCW,	db ?
	at I8089_CB.BUSY,	db ?
	at I8089_CB.PB_OFF,	dw ?
	at I8089_CB.PB_SEG,	dw ?
	at I8089_CB.UNUSED2,	dw ?
iend
IOP3_PTR istruc I8089_CB
	at I8089_CB.CCW,	db ?
	at I8089_CB.BUSY,	db ?
	at I8089_CB.PB_OFF,	dw ?
	at I8089_CB.PB_SEG,	dw ?
	at I8089_CB.UNUSED2,	dw ?
iend


;========================================================================
; When assembling for 16K ROM image, new code could be added to this	:
; section.								:
;========================================================================
section .code_low align=1


;========================================================================
; This is ABI and needs to be at FE00:0000 no matter what.		:
;========================================================================
section .syscall start=ROMLEN-2000h align=1
SYSCALL_ENTRY:
%if ROMLEN == 02000h
		jmp	DO_SYSCALL_ENTRY
%else
		jmp	ROMSEG:DO_SYSCALL_ENTRY
%endif


;========================================================================
; Main code section.							:
;========================================================================
section .code align=1
POST:
		cli
		in	ax, MMU_MEMV_CLEAR ; MMU - Clear Violation Port
		in	ax, MMU_ERROR	; MMU - Error Address 2 - Read Only.
		and	ax, 200h
		mov	bh, ah
		shr	ax, 1
		out	CONTROL_BITS, ax ; Control Bits Port - Write Only.
		cmp	bh, 2
		jnz	short COLD_BOOT
		jmp	WARM_POST
COLD_BOOT:
		mov	ax, ROMSEG	; Firmware start
		mov	ds, ax
		xor	bx, bx
		xor	al, al
		mov	cx, ROMLEN	; Firmware length
CHECKSUM_NEXT_BYTE:
		add	al, [bx]
		inc	bx
		loop	CHECKSUM_NEXT_BYTE
		and	al, al
		jz	short SUCCESS_TEST_1
		mov	bl, 1		; POST FAIL 1: Bad checksum
		jmp	short POST_CHECK_FAILED_0
SUCCESS_TEST_1:
		mov	cx, 11h
		xor	bx, bx
		mov	dx, MMU_BASE
		stc
CHECK_NEXT_MMU_PORT:
		mov	ax, bx
		out	dx, ax
		in	ax, dx
		and	ax, 0F8FFh
		and	bx, 0F8FFh
		cmp	ax, bx
		jnz	short FAIL_TEST_2
		rcl	bx, 1
		loop	CHECK_NEXT_MMU_PORT
		jmp	short SUCCESS_TEST_2
FAIL_TEST_2:
		mov	bl, 2		; POST FAIL 2: Bad MMU
POST_CHECK_FAILED_0:
		jmp	short POST_CHECK_FAILED_1
SUCCESS_TEST_2:
		mov	cx, 9
		mov	dx, MMU_BASE
		xor	ax, ax
		mov	bx, 1
loc_FE05F:
		out	dx, ax
		rcl	bx, 1
		mov	dx, bx
		add	dx, MMU_BASE
		loop	loc_FE05F
		mov	cx, 9
		mov	dx, MMU_BASE
		mov	bx, 1
loc_FE073:
		in	ax, dx
		and	ax, 0F8FFh
		jnz	short FAIL_TEST_3
		not	ax
		out	dx, ax
		in	ax, dx
		and	ax, 0F8FFh
		cmp	ax, 0F8FFh
		jnz	short FAIL_TEST_3
		rcl	bx, 1
		mov	dx, bx
		add	dx, MMU_BASE
		loop	loc_FE073
		jmp	short SUCCESS_TEST_3
FAIL_TEST_3:
		mov	bl, 3		; POST FAIL 3:
POST_CHECK_FAILED_1:
		jmp	short POST_CHECK_FAILED_2
SUCCESS_TEST_3:
		mov	cx, 100h
		mov	dx, MMU_BASE
		xor	ax, ax
loc_FE09D:
		out	dx, ax
		inc	dx
		inc	dx
		loop	loc_FE09D
		mov	cx, 100h
		mov	dx, MMU_BASE
loc_FE0A8:
		in	ax, dx
		and	ax, 0F8FFh
		jnz	short FAIL_TEST_4
		not	ax
		out	dx, ax
		in	ax, dx
		and	ax, 0F8FFh
		cmp	ax, 0F8FFh
		jnz	short FAIL_TEST_4
		inc	dx
		inc	dx
		loop	loc_FE0A8
		jmp	short SUCCESS_TEST_4
FAIL_TEST_4:
		mov	bl, 4		; POST FAIL 4: MMU test
POST_CHECK_FAILED_2:
		jmp	short POST_CHECK_FAILED_3
SUCCESS_TEST_4:
		lea	di, [loc_FE0CB]
		jmp	MMU_LINEAR_MAPPING
loc_FE0CB:
		xor	ax, ax
		mov	ds, ax
		mov	word [INT0_OFF], ax
		mov	cx, 11h
		mov	dx, ax
		mov	ax, 1
loc_FE0DA:
		mov	word [INT0_OFF], dx
		cmp	word [INT0_OFF], dx
		jz	short SUCCESS_TEST_5
		mov	bl, 5		; POST FAIL 5: MMU interrupt test
POST_CHECK_FAILED_3:
		jmp	short POST_CHECK_FAILED_4
SUCCESS_TEST_5:
		mov	dx, ax
		shl	ax, 1
		loop	loc_FE0DA
loc_FE0EE:
		mov	si, 4
		xor	ax, ax
		lea	di, [loc_FE0F9]
loc_FE0F7:
		jmp	short loc_FE112
loc_FE0F9:
		add	ax, 1000h
		dec	si
		jnz	short loc_FE0F7
loc_FE0FF:
		mov	si, 4
		xor	ax, ax
		lea	di, [loc_FE10A]
loc_FE108:
		jmp	short loc_FE12C
loc_FE10A:
		add	ax, 1000h
		dec	si
		jnz	short loc_FE108
		jmp	short SUCCESS_TEST_6
loc_FE112:
		stc
		mov	cx, 12h
		xor	bx, bx
		mov	ds, ax
		mov	dx, 5555h
loc_FE11D:
		mov	[bx], dx
		rcl	bx, 1
		jnb	short loc_FE128
		add	ax, 1000h
		mov	ds, ax
loc_FE128:
		loop	loc_FE11D
		jmp	di
loc_FE12C:
		stc
		mov	cx, 12h
		xor	bx, bx
		mov	ds, ax
		mov	dx, 5555h
loc_FE137:
		cmp	[bx], dx
		jnz	short FAIL_TEST_6
		not	dx
		mov	[bx], dx
		cmp	[bx], dx
		jnz	short FAIL_TEST_6
		rcl	bx, 1
		jnb	short loc_FE14E
		add	ax, 1000h
		mov	ds, ax
		not	dx
loc_FE14E:
		loop	loc_FE137
		jmp	di
FAIL_TEST_6:
		mov	bl, 6		; POST FAIL 6: Memory error
POST_CHECK_FAILED_4:
		jmp	short POST_CHECK_FAILED_5
SUCCESS_TEST_6:
		cld
		mov	bx, 8
		xor	ax, ax
loc_FE15C:
		mov	es, ax
		mov	ax, 0FFFFh
		xor	di, di
POST_sub_FE163:
		mov	cx, 8000h
		rep stosw
		mov	ax, es
		add	ax, 1000h
		dec	bx
		jnz	short loc_FE15C
		mov	bx, 8
		xor	ax, ax
		mov	dx, 0FFFFh
loc_FE178:
		mov	cx, 8000h
		mov	ds, ax
		xor	di, di
loc_FE17F:
		cmp	[di], dx
		jnz	short FAIL_TEST_7
		not	dx
		mov	[di], dx
		cmp	[di], dx
		jnz	short FAIL_TEST_7
		not	dx
		inc	di
		inc	di
		loop	loc_FE17F
		mov	ax, ds
		add	ax, 1000h
		dec	bx
		jnz	short loc_FE178
		jmp	short SUCCESS_TEST_7
FAIL_TEST_7:
		mov	bl, 7		; POST FAIL 7: Memory error
POST_CHECK_FAILED_5:
		jmp	short POST_CHECK_FAILED_6
SUCCESS_TEST_7:
		mov	al, 70h
		mov	dx, PIT_CTRL	; PIT - Control Word Register - Write Only
		out	dx, al
		mov	ax, 0AAh
		mov	dx, PIT_CNT_1	; PIT - Counter 1
		out	dx, al
		out	dx, al
		mov	cx, ax
loc_FE1AF:
		loop	loc_FE1AF
		in	al, dx
		mov	ah, al
		in	al, dx
		cmp	ax, 0AAAAh
		jnz	short SUCCESS_TEST_8
		mov	bl, 8		; POST FAIL 8: PIT Error
POST_CHECK_FAILED_6:
		jmp	short POST_CHECK_FAILED_7
SUCCESS_TEST_8:
		mov	al, 70h
		mov	dx, PIT_CTRL	; PIT - Control Word Register - Write Only
		out	dx, al
		mov	dx, PIT_CNT_1	; PIT - Counter 1
		out	dx, al
		mov	ax, 1F00h
		mov	ss, ax
		mov	sp, 0FFh
		mov	cx, 100h
		lea	dx, [DEFAULT_INT]
		xor	bx, bx
		mov	ds, bx
INSTALL_DEFAULT_IRQS:
		mov	[bx], dx
		inc	bx
		inc	bx
		mov	word [bx], cs
		inc	bx
		inc	bx
		loop	INSTALL_DEFAULT_IRQS
		lea	dx, [TIMER_INT]
		mov	word [INT33_TIMER_OFF], dx
		mov	word [INT33_TIMER_SEG], cs
		mov	al, 13h
		out	PIC_1, al	; PIC - ICW1, OCW2, or OCW3
		mov	al, 20h
		mov	dx, PIC_2	; PIC - ICW2, ICW3, ICW4, or OCW1
		out	dx, al
		mov	al, 3
		out	dx, al
		mov	al, 0FDh
		out	dx, al
		sti
		mov	al, 56h
		mov	dx, PIT_CTRL	; PIT - Control Word Register - Write Only
		out	dx, al
		mov	al, 90h
		out	dx, al
		mov	al, 50h
		mov	dx, PIT_CNT_1	; PIT - Counter 1
		out	dx, al
		mov	dx, PIT_CNT_2	; PIT - Counter 2
		out	dx, al
		mov	bh, 0FFh
		mov	cx, 1FFFh
loc_FE21A:
		mul	si
		loop	loc_FE21A
		cli
		cmp	bh, 21h
		jz	short SUCCESS_TEST_9
		mov	bl, 9		; POST FAIL 9: Interrupt test failure
POST_CHECK_FAILED_7:
		jmp	short POST_CHECK_FAILED_8
SUCCESS_TEST_9:
		xor	bl, bl		; POST SUCCESSFUL
POST_CHECK_FAILED_8:
		jmp	short POST_FINISHED ; First part of self-test, tests memory

;------------------------------------------------------------------------
TIMER_INT:
		mov	bh, 21h ; FALLTHROUGH

;------------------------------------------------------------------------
DEFAULT_INT:
		mov	cx, 1
		iret

;------------------------------------------------------------------------
MMU_LINEAR_MAPPING:
		mov	dx, MMU_BASE
		mov	cl, 0
loc_FE237:
		mov	ah, 0DCh
		mov	al, cl
		out	dx, ax
		inc	dx
		inc	dx
		inc	cl
		jnz	short loc_FE237
		jmp	di

;------------------------------------------------------------------------
POST_FINISHED:
		lea	di, [loc_FE24A]
		jmp	short MMU_LINEAR_MAPPING
loc_FE24A:
		xor	ax, ax
		mov	ds, ax
		mov	[POST_RESULT], bl ; FALLTHROUGH

;------------------------------------------------------------------------
WARM_POST:
		lea	di, [loc_FE259]
		jmp	word MMU_LINEAR_MAPPING ; uh
loc_FE259:
		xor	ax, ax
		mov	ds, ax
		mov	dx, 7E00h	; Start the memory test at 7E00:1FFF
		mov	bx, 1FFFh	; That is 7FFFF
loc_FE263:
		mov	es, dx
		mov	al, [es:bx]
		not	byte [es:bx]
		not	al
		cmp	al, [es:bx]
		not	byte [es:bx]
		jnz	short loc_FE27A
		add	dh, 2
		jmp	short loc_FE263
loc_FE27A:
		sub	dh, 2
		mov	word [unk_EC5], dx
		mov	word [MEM_SIZE], bx
		in	ax, MMU_ERROR	; MMU - Error Address 2 - Read Only.
		and	ah, 2
		jnz	short loc_FE2A7
		mov	dx, 8000h
		xor	ax, ax
loc_FE291:
		cmp	dx, [unk_EC5]
		ja	short loc_FE2A5
		mov	es, dx
		mov	di, ax
		mov	cx, 1000h
		rep stosw
		add	dh, 2
		jmp	short loc_FE291
loc_FE2A5:
		jmp	short FINISH_POST
loc_FE2A7:
		mov	byte [POST_RESULT], 0FFh ; FALLTHROUGH

;------------------------------------------------------------------------
FINISH_POST:
		mov	ax, ROMSEG
		mov	ds, ax
		xor	ax, ax
		mov	es, ax
		lea	si, [ROM_DATA]	; From FE00:1C00
		lea	di, [RAM_DATA]	; To	0000:0410
		mov	cx, 504		; 504 Words = 1008 Bytes
		repne movsw		; Copy .data to DRAM
		mov	ax, 100h
		out	CONTROL_BITS, ax ; Control Bits Port - Write Only.
		xor	ax, ax
		mov	ds, ax
		in	ax, MMU_MEMV	; MMU - Violation Port - Read Only.
		and	ah, 10h
		jnz	short loc_FE2E7
		cmp	byte [WHATS_CB_SEG], 7Eh
		jz	short loc_FE2E1
		mov	word [SCB+I8089_SCB.CB_SEG], 0FDFFh
		jmp	short loc_FE2E7
loc_FE2E1:
		mov	word [SCB+I8089_SCB.CB_SEG], 7FFFh
loc_FE2E7:
		lds	di, [INIT_REG_PTR]
		mov	word [di], FW_REG
		inc	di
		inc	di
		xor	ax, ax
		mov	[di], al
		mov	ds, ax
		mov	es, ax
		mov	ss, ax
		mov	sp, 1000h
		mov	word [FW_REG], ax
		out	Z80_CHAN_ATTN, ax ; Z80A I/O Processor Chan att.
		mov	al, IOC_BUSY | IOC_ENABLE
		call	SYS_CMD_WHEN_READY
		mov	cx, 2
		lea	si, [SIO_CHAN_0]
		mov	al, SIO_BUSY | SIO_INIT_CHAN	; Enable channel
loc_FE311:
		call	SIO_COMMAND_WHEN_READY ; AL=command
		add	si, SIO_REGS_size
		loop	loc_FE311
		mov	cx, 25		; 25 newlines
					; 99 luftbaloons
loc_FE31D:
		push	cx
		call	PRINT_CRLF
		pop	cx
		loop	loc_FE31D
		cmp	byte [POST_RESULT], 10h
		ja	short POST_DONE
		mov	bl, [POST_RESULT]
		xor	ax, ax
		cmp	bl, al
		jnz	short POST_FAILED
		lea	dx, [STR_POST_GOOD] ; "\nPASSED POWER-UP TEST"
		push	dx
		call	PUTS
		add	sp, 2
		jmp	short POST_DONE
POST_FAILED:
		lea	dx, [HEX_BUF_FOR_POST_NUMBER]
		push	dx
		push	dx
		push	bx
		call	FMT_HEX
		add	sp, 6
		lea	dx, [STR_POST_FAILED] ; "\nFAILED POWER-UP TEST "
		push	dx
		call	PUTS
		add	sp, 2
POST_DONE:
		xor	ax, ax
		push	ax
		push	ax
		call	FDC_SET_FLOPPY_PARAMS ; Init floppy
		add	sp, 4
		cmp	byte [POST_RESULT], 0FEh
		jz	DO_SYSCALL_RETURN

;------------------------------------------------------------------------
SYSCALL_0_MONITOR:
		xor	ax, ax
		mov	ds, ax
		mov	es, ax
		mov	ss, ax
		mov	sp, 1000h
		lea	di, [SAVED_CPU_REGS]
		mov	cx, 0Eh
		rep stosw
		mov	[SAVED_CPU_REGS+CPU_REGS.SP], sp
		push	word [INIT_REG_PTR]
		call	AUTOBOOT_PROMPT ; FALLTHROUGH

;------------------------------------------------------------------------
DO_SYSCALL_ENTRY:
		push	ds
		xor	ax, ax
		mov	ds, ax
		mov	word [SAVED_ES], es    ; Saved on syscall entry
		mov	es, ax
		mov	word [SAVED_SS], ss
		mov	word [SAVED_SP], sp
		mov	ss, ax
		mov	sp, 1000h
		cmp	bl, 0Fh
		jnz	short loc_FE3B6
		lea	di, [loc_FE3AE]
		jmp	MMU_LINEAR_MAPPING
loc_FE3AE:
		mov	byte [POST_RESULT], 0FEh
		jmp	FINISH_POST
loc_FE3B6:
		shl	bx, 1
		;call	SYSCALL_HANDLERS[cs:bx] ; <--- no CS prefix by yasm!
		cs call	SYSCALL_HANDLERS[bx] ; FALLTHROUGH

;------------------------------------------------------------------------
DO_SYSCALL_RETURN:
		mov	ss, [SAVED_SS]
		mov	sp, [SAVED_SP]
		mov	es, [SAVED_ES]	; Saved on syscall entry
		pop	ds
		retf

SYSCALL_HANDLERS:
		dw SYSCALL_0_MONITOR			; 0
		dw SYSCALL_1_5_SIO_GET_STAT_ATTR	; 1
		dw SYSCALL_2_SIO_GETC			; 2
		dw SYSCALL_3_SIO_PUTC			; 3
		dw SYSCALL_4_SIO_SET_ATTRS		; 4
		dw SYSCALL_1_5_SIO_GET_STAT_ATTR	; 5
		dw SYSCALL_6_PRINT_CRLF			; 6
		dw SYSCALL_7_PUTS			; 7
		dw SYSCALL_8_DISK_IO			; 8
		dw SYSCALL_8_DISK_IO			; 9
		dw SYSCALL_10_GET_CONS_AND_MEM		; 10
		dw SYSCALL_11_GET_BOOT_DISK		; 11
		dw SYSCALL_12_DISK_BOOT			; 12

;------------------------------------------------------------------------
SYSCALL_1_5_SIO_GET_STAT_ATTR:
		push	bx
		push	cx
		mov	ax, 0FFFFh	; Just get the attributes
		push	ax
		push	cx
		call	SIO_RX
		add	sp, 6
		pop	bx
		cmp	bl, 2
		jz	short locret_FE3FA
		mov	ax, dx
locret_FE3FA:
		retn

;------------------------------------------------------------------------
SYSCALL_2_SIO_GETC:
		push	cx
		call	SIO_GETC
		add	sp, 2
		retn

;------------------------------------------------------------------------
SYSCALL_3_SIO_PUTC:
		mov	[POST_RESULT], dl
		lea	dx, [POST_RESULT]
		push	dx
		push	cx		; Character
		call	DO_SYSCALL_3_PUTC
		add	sp, 4
		retn

;------------------------------------------------------------------------
SYSCALL_4_SIO_SET_ATTRS:
		push	dx		; Attributes
		mov	ax, 0FFFFh
		push	ax
		push	cx		; Channel No.
		call	SIO_TX
		add	sp, 6
		retn

;------------------------------------------------------------------------
SYSCALL_6_PRINT_CRLF:
		push	cx		; Channel
		call	DO_PRINT_CRLF
		add	sp, 2
		retn

;------------------------------------------------------------------------
SYSCALL_7_PUTS:
		mov	ax, [SAVED_ES]	; Saved on syscall entry
		push	dx
		push	ax
		push	cx
		call	DO_PUTS
		add	sp, 6
		retn

;------------------------------------------------------------------------
SYSCALL_8_DISK_IO:
		mov	ax, [SAVED_ES]	; Saved on syscall entry
		mov	word [ADDR_OFFSET], cx
		mov	word [ADDR_SEGMENT], ax
		call	DISK_IO
		retn

;------------------------------------------------------------------------
SYSCALL_10_GET_CONS_AND_MEM:
		les	dx, [MEM_SIZE]
		mov	word [SAVED_ES], es    ; Saved on syscall entry
		xor	ax, ax		; Current console is always 0
		retn

;------------------------------------------------------------------------
SYSCALL_11_GET_BOOT_DISK:
		mov	al, [BOOT_DISK_CODE] ; 1 = HDD, 2 = FDD
		retn

;------------------------------------------------------------------------
SYSCALL_12_DISK_BOOT:
		push	cx
		call	DISK_BOOT
		add	sp, 2
		retn

;------------------------------------------------------------------------
SAVE_REGS_AND_BREAK:
		push	bx
		push	ds
		xor	bx, bx
		mov	ds, bx
		mov	bx, SAVED_CPU_REGS
		mov	[bx+CPU_REGS.ES], es
		mov	[bx+CPU_REGS.AX], ax
		mov	[bx+CPU_REGS.CX], cx
		mov	[bx+CPU_REGS.DX], dx
		mov	[bx+CPU_REGS.SI], si
		mov	[bx+CPU_REGS.DI], di
		mov	[bx+CPU_REGS.BP], bp
		mov	[bx+CPU_REGS.SS], ss
		pop	ax
		mov	[bx+CPU_REGS.DS], ax
		pop	ax
		mov	[bx+CPU_REGS.BX], ax
		pop	ax
		mov	[bx+CPU_REGS.IP], ax
		pop	ax
		mov	[bx+CPU_REGS.CS], ax
		pop	ax
		mov	[bx+CPU_REGS.FLAGS], ax
		mov	[bx+CPU_REGS.SP], sp
		xor	ax, ax
		mov	ds, ax
		mov	es, ax
		mov	ss, ax
		mov	sp, 1000h
		test	word [bx+CPU_REGS.FLAGS], 100h
		jz	short loc_FE4B3
		and	word [bx+CPU_REGS.FLAGS], 0FEFFh
loc_FE4AA:
		call	PRINT_REGS
		xor	ax, ax
		push	ax
		call	AUTOBOOT_PROMPT
loc_FE4B3:
		dec	word [bx+CPU_REGS.IP]
		call	INT3_sub_FEC38

;------------------------------------------------------------------------
I8089_DO_IO:
		push	es
		lea	si, [IOP_BLOCK]
		mov	word [si], 6CAh
		add	word [si], 17F0h
		mov	word [si+2], ROMSEG
		mov	ax, [SCB+I8089_SCB.CB_SEG]
		mov	es, ax
		mov	al, 3
		mov	[es:I8089_CB.CCW], al ; 40:0 -- 0:400
		mov	[es:I8089_CB.PB_OFF], si ; 40:2 -- 0:402
		mov	[es:I8089_CB.PB_SEG], ds ; 40:4 -- 0:404
		mov	byte [es:I8089_CB.BUSY], 1 ; 40:1 -- 0:401   Busy?
		mov	dx, BUS_RSVD_0	; Reserved for system bus I/O.
		out	dx, al
		mov	cx, 6000
WAIT_IOP_NOT_BUSY:
		cmp	byte [es:I8089_CB.BUSY], 0 ; 40:1 -- 0:401   Busy no more?
		jz	short IOP_NOT_BUSY
		mov	ax, 1
		push	ax
		call	DELAY
		add	sp, 2
		loop	WAIT_IOP_NOT_BUSY
IOP_NOT_BUSY:
		pop	es
		retn

;------------------------------------------------------------------------
SIO_GETC:
%define CHARACTER	-6 ; = word ptr -6
%define CHANNEL		4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		lea	di, [bp+CHARACTER]
		push	di
		mov	di, 1		; Length
		push	di
		mov	al, [bp+CHANNEL]
		cbw
		push	ax
		call	SIO_RX
		add	sp, 6
		mov	byte [bp+CHARACTER], al
		mov	al, byte [bp+CHARACTER]
		cbw
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
DO_SYSCALL_3_PUTC:
%define CHARACTER	4 ; = byte ptr	4
%define arg_2		6 ; = word ptr	6
		push	bp
		mov	bp, sp
		push	di
		push	si
		push	word [bp+arg_2]
		mov	di, 1		; Length
		push	di
		mov	al, [bp+CHARACTER]
		cbw
		push	ax
		call	PRINT_BUF
		add	sp, 6
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
FMT_HEX:
%define arg_0		4 ; = byte ptr	4
%define arg_2		6 ; = word ptr	6
%define arg_4		8 ; = word ptr	8
		push	bp
		mov	bp, sp
		push	di
		push	si
		push	word [bp+arg_2]
		mov	bl, [bp+arg_0]
		and	bx, 0F0h
		mov	cx, 4
		sar	bx, cl
		mov	dl, HEX_NUMS[bx]
		pop	bx
		mov	[bx], dl
		push	word [bp+arg_4]
		mov	bl, [bp+arg_0]
		and	bx, 0Fh
		mov	dl, HEX_NUMS[bx]
		pop	bx
		mov	[bx], dl
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
DELAY:
		push	bx
		mov	bx, sp
		push	cx
		mov	ax, [bx+4]
		or	ax, ax
		jz	short ZERO_WAIT
OUTER_LOOP:
		mov	bx, 10
INNER_LOOP:
		mov	cl, 120
		shr	cl, cl
		dec	bx
		jnz	short INNER_LOOP
		dec	ax
		jnz	short OUTER_LOOP
ZERO_WAIT:
		pop	cx
		pop	bx
		retn

;------------------------------------------------------------------------
DISK_BOOT:
%define LEN		-0Eh ; = word ptr -0Eh
%define DEST		-0Ch ; = word ptr -0Ch
%define var_A		-0Ah ; = word ptr -0Ah
%define SRC		-8 ; = word ptr -8
%define var_6		-6 ; = word ptr -6
%define DISK_NUMBER	4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 0Ah
		cmp	word [bp+DISK_NUMBER], 3
		jbe	short FLOPPY_DISK
		mov	dx, 1
		jmp	short HARD_DISK
FLOPPY_DISK:
		mov	dx, 2
HARD_DISK:
		mov	[BOOT_DISK_CODE], dl ; 1 = HDD, 2 = FDD
		mov	dx, word [bp+DISK_NUMBER]
		mov	[DISK_IOPB+IOPB.DISK_DRIVE_NUM], dl
		cmp	word [bp+DISK_NUMBER], 3
		jbe	short loc_FE5BC
		mov	dx, 21h
		jmp	short loc_FE5BF
loc_FE5BC:
		mov	dx, 20h
loc_FE5BF:
		mov	byte [DISK_IOPB+IOPB.DISK_OPCODE], dl
		mov	word [DISK_IOPB+IOPB.DISK_TRACK], 0
		mov	byte [DISK_IOPB+IOPB.DISK_HEAD], 0
		cmp	word [bp+DISK_NUMBER], 3
		jbe	short loc_FE5D8
		sub	dx, dx
		jmp	short loc_FE5DB
loc_FE5D8:
		mov	dx, 1
loc_FE5DB:
		mov	byte [DISK_IOPB+IOPB.DISK_SECTOR], dl
		mov	byte [DISK_IOPB+IOPB.DISK_SECTOR_COUNT], 1
		mov	byte [DISK_IOPB+IOPB.DISK_RETRIES], 10
		mov	word [DISK_IOPB+IOPB.DISK_DMA_OFFSET], DISK_DATA_BUF
		mov	word [DISK_IOPB+IOPB.DISK_DMA_SEGMENT], 0
		mov	word [DISK_IOPB+IOPB.DISK_SECTOR_LEN], 512
		call	DISK_READ
		cmp	byte [DISK_IOPB+IOPB.DISK_OP_STATUS], 0
		jz	short READ_GOOD
BOOT_FAILED:
		call	BOOT_FAILED_ERR
		jmp	loc_FE730
READ_GOOD:
		mov	dl, [DISK_DATA_BUF+3]
		sub	dh, dh
		mov	al, [DISK_DATA_BUF+4]
		cbw
		mov	cx, 8
		shl	ax, cl
		add	dx, ax
		mov	[bp+var_A], dx
		mov	word [bp+DEST], 0
		mov	[SAVED_CPU_REGS+CPU_REGS.CS], dx
		mov	di, [bp+DEST]
		mov	[SAVED_CPU_REGS+CPU_REGS.IP], di
		mov	word [bp+var_6], 0
		mov	di, [bp+var_A]
		mov	word [DISK_IOPB+IOPB.DISK_DMA_SEGMENT], di
		inc	byte [DISK_IOPB+IOPB.DISK_SECTOR]
		mov	al, [DISK_DATA_BUF+9]
		cbw
		cmp	ax, 2
		ja	short BOOT_FAILED
		shl	ax, 1
		xchg	ax, bx
		;jmp	off_FE714[cs:bx]	; <-- yasm: no CS prefix!!!
		cs jmp	off_FE714[bx]	; <-- yasm: no CS prefix!!!
BOOT_TYPE_0_loc_FE650:
		mov	word [bp+SRC], DISK_DATA_BUF+128
		mov	di, 180h	; Length
		push	di
		lea	di, [bp+DEST]
		push	di
		lea	di, [bp+SRC]
		push	di
		call	MEMCPY
		add	sp, 6
		mov	di, [bp+DEST]
		add	di, 180h
		mov	[DISK_IOPB+IOPB.DISK_DMA_OFFSET], di
		cmp	word [bp+DISK_NUMBER], 3
		ja	short loc_FE6E4
		mov	byte [DISK_IOPB+IOPB.DISK_SECTOR_COUNT], 8
		call	FDC_READ
		mov	al, [DISK_IOPB+IOPB.DISK_SECTOR_COUNT]
		cbw
		mov	cx, 9
		shl	ax, cl
		add	[DISK_IOPB+IOPB.DISK_DMA_OFFSET], ax
		mov	byte [DISK_IOPB+IOPB.DISK_HEAD], 1
		mov	byte [DISK_IOPB+IOPB.DISK_SECTOR], 1
		mov	byte [DISK_IOPB+IOPB.DISK_SECTOR_COUNT], 9
		jmp	word BOOT_TYPE_PARAMS_SET ; hhh
BOOT_TYPE_1_loc_FE69F:
		mov	word [bp+LEN], 502
		cmp	word [bp+DISK_NUMBER], 3
		ja	short loc_FE6C4
		mov	di, 1
		push	di
		mov	al, [DISK_IOPB+IOPB.DISK_DRIVE_NUM]
		cbw
		push	ax
		call	FDC_SET_FLOPPY_PARAMS
		add	sp, 4
		mov	word [DISK_IOPB+IOPB.DISK_SECTOR_LEN], 256
		mov	word [bp+LEN], 246
loc_FE6C4:
		mov	word [bp+SRC], DISK_DATA_BUF+10
		push	word [bp+LEN]
		lea	di, [bp+DEST]
		push	di
		lea	di, [bp+SRC]
		push	di
		call	MEMCPY
		add	sp, 6
		mov	di, [bp+DEST]
		add	di, [bp+LEN]
		mov	[DISK_IOPB+IOPB.DISK_DMA_OFFSET], di
loc_FE6E4:
		mov	byte [DISK_IOPB+IOPB.DISK_SECTOR_COUNT], 15
		jmp	short BOOT_TYPE_PARAMS_SET
BOOT_TYPE_2_loc_FE6EB:
		mov	word [bp+SRC], DISK_DATA_BUF
		mov	di, 512
		push	di
		lea	di, [bp+DEST]
		push	di
		lea	di, [bp+SRC]
		push	di
		call	MEMCPY
		add	sp, 6
		mov	di, [bp+DEST]
		add	di, 512
		mov	[DISK_IOPB+IOPB.DISK_DMA_OFFSET], di
		mov	byte [DISK_IOPB+IOPB.DISK_SECTOR_COUNT], 2
		jmp	short BOOT_TYPE_PARAMS_SET
off_FE714	dw BOOT_TYPE_0_loc_FE650
		dw BOOT_TYPE_1_loc_FE69F
		dw BOOT_TYPE_2_loc_FE6EB
BOOT_TYPE_PARAMS_SET:
		call	DISK_READ
		cmp	byte [DISK_IOPB+IOPB.DISK_OP_STATUS], 0
		jz	short BOOT_GOOD
		jmp	BOOT_FAILED
BOOT_GOOD:
		call	PRINT_CRLF
		call	sub_FEBD6
		call	near RESTORE_REGS_AND_IRET
loc_FE730:
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
BOOT_FAILED_ERR:
		push	bp
		mov	bp, sp
		push	di
		push	si
		mov	di, STR_BOOT_FAILED ; "\nBoot Failed, Status="
		push	di
		call	PUTS
		add	sp, 2
		mov	al, [DISK_IOPB+IOPB.DISK_OP_STATUS]
		cbw
		push	ax
		call	PRINTHEX8
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
M_DISK_IO:
		push	bp
		mov	bp, sp
		push	di
		push	si
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], 0Dh
		jnz	short loc_FE774
		call	ERR_BEEP
loc_FE771:
		jmp	FUNCTION_RETURN
loc_FE774:
		call	PARSE_ADDR_sub_FE96E
		test	ax, ax
		jz	short loc_FE771
		call	DISK_IO
		jmp	short loc_FE771

;------------------------------------------------------------------------
DISK_IO:
%define COUNTER		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	word [bp+COUNTER], 0
COPY_IOPB_BYTE:
		push	word [bp+COUNTER]
		call	MEM_READ8
		pop	bx
		mov	DISK_IOPB[bx], al
		inc	word [ADDR_OFFSET]
		inc	word [bp+COUNTER]
		cmp	word [bp+COUNTER], IOPB_size
		jb	short COPY_IOPB_BYTE
		sub	word [ADDR_OFFSET], 20
		call	DISK_READ
		add	word [ADDR_OFFSET], 11
		mov	al, [DISK_IOPB+IOPB.DISK_OP_STATUS]
		cbw
		push	ax
		call	MEM_WRITE8
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
DISK_READ:
		push	bp
		mov	bp, sp
		push	di
		push	si
		cmp	byte [DISK_IOPB+IOPB.DISK_DRIVE_NUM], 3
		jle	short DO_FLOPPY
		call	HDD_READ
ALL_DONE:
		jmp	FUNCTION_RETURN
DO_FLOPPY:
		call	FDC_READ
		jmp	short ALL_DONE

;------------------------------------------------------------------------
ERR_BEEP:
		push	bp
		mov	bp, sp
		push	di
		push	si
		mov	di, STR_ERR_BEEP ; "*\a "
		push	di
		mov	di, 3
		push	di
		sub	di, di
		push	di
		call	PRINT_BUF
		add	sp, 6
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
FDC_SET_FLOPPY_PARAMS:
%define arg_0		4 ; = byte ptr	4
%define SECTOR_SIZE	6 ; = byte ptr	6
		push	bp
		mov	bp, sp
		push	di
		push	si
		cmp	byte [bp+SECTOR_SIZE], 1
		jnz	short SECTOR_512
		mov	di, 256
		jmp	short SECTOR_256
SECTOR_512:
		mov	di, 512
SECTOR_256:
		mov	al, [bp+arg_0]
		cbw
		mov	cx, 5
		shl	ax, cl
		mov	si, ax
		mov	(FDC_CHAN+FDC_REGS.PARAMS_1+2)[si], di
		mov	word [FDC_CHAN+FDC_REGS.QUEUE_ADDR_LO], FDC_QUEUE
		mov	byte [FDC_CHAN+FDC_REGS.COMMAND], FDC_BUSY | FDC_FLOPPY_PARAMS
		inc	byte [NEW_CMD_REG]
WAIT_FDC_BUSY:
		mov	dl, [FDC_CHAN+FDC_REGS.COMMAND]
		and	dx, FDC_BUSY
		cmp	dx, FDC_BUSY
		jz	short WAIT_FDC_BUSY
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
FDC_READ:
%define DMA_SEGMENT	-16h ; = word ptr -16h
%define DMA_OFFSET	-14h ; = word ptr -14h
%define SECTORS_READ	-12h ; = word ptr -12h
%define DMA_ADDRESS	-10h ; = word ptr -10h
%define COMMAND		-0Eh ; = byte ptr -0Eh
%define STATUS		-0Dh ; = byte ptr -0Dh
%define DRIVE_NUM	-0Ch ; = byte ptr -0Ch
%define TRACK		-0Bh ; = byte ptr -0Bh
%define HEAD		-0Ah ; = byte ptr -0Ah
%define SECTOR		-9 ; = byte ptr -9
%define DATA_BUF_LO	-8 ; = byte ptr -8
%define DATA_BUF_MID	-7 ; = byte ptr -7
%define DATA_BUF_HI	-6 ; = byte ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 12h
		mov	dl, [DISK_IOPB+IOPB.DISK_OPCODE]
		and	dx, 0F0h
		mov	di, dx
		mov	dl, [DISK_IOPB+IOPB.DISK_RETRIES]
		and	dx, 0Fh
		add	di, dx
		mov	dx, di
		mov	[bp+COMMAND], dl
		mov	byte [bp+STATUS], 0
		mov	dl, [DISK_IOPB+IOPB.DISK_DRIVE_NUM]
		mov	[bp+DRIVE_NUM], dl
		mov	dx, [DISK_IOPB+IOPB.DISK_TRACK]
		mov	[bp+TRACK], dl
		mov	dl, [DISK_IOPB+IOPB.DISK_HEAD]
		mov	[bp+HEAD], dl
		mov	dl, [DISK_IOPB+IOPB.DISK_SECTOR]
		mov	[bp+SECTOR], dl
		mov	al, [bp+DRIVE_NUM]
		cbw
		mov	cx, 5
		shl	ax, cl
		mov	bx, ax
		mov	ax, (FDC_CHAN+FDC_REGS.PARAMS_1+2)[si]
		cmp	ax, [DISK_IOPB+IOPB.DISK_SECTOR_LEN]
		jz	short loc_FE8AB
		cmp	word [DISK_IOPB+IOPB.DISK_SECTOR_LEN], 256
		jz	short SECTOR_LEN_256
		sub	di, di
		push	di
		mov	al, [bp+DRIVE_NUM]
		cbw
		push	ax
		jmp	short loc_FE8A5
SECTOR_LEN_256:
		mov	di, 1
		push	di
		mov	al, [bp+DRIVE_NUM]
		cbw
		push	ax
loc_FE8A5:
		call	FDC_SET_FLOPPY_PARAMS
		add	sp, 4
loc_FE8AB:
		mov	di, [DISK_IOPB+IOPB.DISK_DMA_OFFSET]
		mov	[bp+DMA_OFFSET], di
		mov	di, [DISK_IOPB+IOPB.DISK_DMA_SEGMENT]
		mov	[bp+DMA_SEGMENT], di
		mov	word [bp+SECTORS_READ], 0
		jmp	loc_FE943
READ_SECTORS:
		mov	dx, [bp+DMA_SEGMENT]
		mov	[bp+DMA_ADDRESS], dx
		mov	cx, 0Ch
		shr	dx, cl
		mov	[bp+DATA_BUF_HI], dl
		mov	dx, [bp+DMA_ADDRESS]
		mov	cx, 4
		shl	dx, cl
		add	dx, [bp+DMA_OFFSET]
		mov	[bp+DMA_ADDRESS], dx
		sub	dh, dh
		mov	[bp+DATA_BUF_LO], dl
		mov	dx, [bp+DMA_ADDRESS]
		and	dx, 0FF00h
		mov	cx, 8
		shr	dx, cl
		mov	[bp+DATA_BUF_MID], dl
		lea	di, [bp+COMMAND]
		push	di
		call	FDC_ENQUEUE_CMD
		add	sp, 2
		mov	byte [FDC_CHAN+FDC_REGS.QUEUE_END], 1
		mov	byte [FDC_CHAN+FDC_REGS.QUEUE_NEXT], 0
		mov	byte [FDC_CHAN+FDC_REGS.COMMAND], FDC_BUSY | FDC_RUN_IO
		inc	byte [NEW_CMD_REG]
WAIT_FDC_NOT_BUSY:
		mov	dl, [FDC_CHAN+FDC_REGS.COMMAND]
		and	dx, FDC_BUSY
		cmp	dx, FDC_BUSY
		jz	short WAIT_FDC_NOT_BUSY
WAIT_FOR_FDC_READY:
		mov	dl, [FDC_CHAN+FDC_REGS.STATUS]
		and	dx, 0Fh
		jnz	short WAIT_FOR_FDC_READY
WAIT_FOR_QUEUE_DRAIN:
		mov	dl, [FDC_CHAN+FDC_REGS.QUEUE_END]
		cmp	[FDC_CHAN+FDC_REGS.QUEUE_NEXT], dl
		jnz	short WAIT_FOR_QUEUE_DRAIN
		cmp	byte [bp+STATUS], 0
		jnz	short FDC_READ_FINISHED ; Error?
		mov	di, [DISK_IOPB+IOPB.DISK_SECTOR_LEN]
		add	[bp+DMA_OFFSET], di
		inc	byte [bp+SECTOR]
		inc	word [bp+SECTORS_READ]
loc_FE943:
		mov	al, [DISK_IOPB+IOPB.DISK_SECTOR_COUNT]
		cbw
		cmp	ax, [bp+SECTORS_READ]
		jbe	short FDC_READ_FINISHED ; All done?
		jmp	READ_SECTORS
FDC_READ_FINISHED:
		mov	dl, [bp+STATUS]
		mov	[DISK_IOPB+IOPB.DISK_OP_STATUS], dl
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
FDC_ENQUEUE_CMD:
%define FDC_CMD		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	si
		push	di
		mov	si, [bp+FDC_CMD]
		lea	di, [FDC_QUEUE]
		call	FDC_sub_FF6A2	; DI=FDC_QUEUE
		pop	di
		pop	si
		pop	bp
		retn

;------------------------------------------------------------------------
PARSE_ADDR_sub_FE96E:
%define var_6		-6 ; = byte ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	byte [bp+var_6], 1
		mov	word [ADDR_SEGMENT], 0
		mov	di, ADDR_OFFSET
		push	di
		call	READ_MEM_ADDR_sub_FE9D8
		add	sp, 2
		test	ax, ax
		jz	short loc_FE9B1
		cmp	byte [CHAR_BUF], ':'
		jnz	short loc_FE9B5
		mov	di, [ADDR_OFFSET]
		mov	word [ADDR_SEGMENT], di
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		mov	di, ADDR_OFFSET
		push	di
		call	READ_MEM_ADDR_sub_FE9D8
		add	sp, 2
		test	ax, ax
		jnz	short loc_FE9B5
loc_FE9B1:
		mov	byte [bp+var_6], 0
loc_FE9B5:
		mov	al, [bp+var_6]
		cbw
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
GETCHAR_ECHO:
		push	bp
		mov	bp, sp
		push	di
		push	si
		call	GETCHAR
		mov	word [GETCHAR_ECHO_BUF], ax
		mov	di, GETCHAR_ECHO_BUF
		push	di
		call	PUTCHAR
		add	sp, 2
		mov	ax, [GETCHAR_ECHO_BUF]
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
READ_MEM_ADDR_sub_FE9D8:
%define var_A		-0Ah ; = word ptr -0Ah
%define var_8		-8 ; = byte ptr -8
%define var_6		-6 ; = word ptr -6
%define arg_0		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		mov	byte [bp+var_8], '+'
		mov	word [bp+var_A], 0
		mov	di, [bp+arg_0]
		mov	word [di], 0
		jmp	short loc_FEA1A
loc_FE9F2:
		mov	di, [bp+var_A]
		mov	cx, 4
		shl	di, cl
		mov	al, byte [bp+var_6]
		cbw
		add	di, ax
		mov	[bp+var_A], di
		call	GETCHAR
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], 0Dh ; END_OF_LINE
		jz	short GOT_CRLF
		mov	di, CHAR_BUF
		push	di
		call	PUTCHAR
		add	sp, 2
loc_FEA1A:
		lea	di, [bp+var_6]
		push	di
		mov	al, [CHAR_BUF]
		cbw
		push	ax
		call	PARSE_HEX_sub_FF6BA
		add	sp, 4
		test	ax, ax
		jnz	short loc_FE9F2
GOT_CRLF:
		cmp	byte [bp+var_8], '+'
		jnz	short loc_FEA3D
		mov	bx, [bp+arg_0]
		mov	di, [bp+var_A]
		add	[bx], di
		jmp	short loc_FEA45
loc_FEA3D:
		mov	bx, [bp+arg_0]
		mov	di, [bp+var_A]
		sub	[bx], di
loc_FEA45:
		cmp	byte [CHAR_BUF], 0Dh
		jz	short loc_FEA61
		cmp	byte [CHAR_BUF], ':'
		jz	short loc_FEA61
		cmp	byte [CHAR_BUF], ','
		jz	short loc_FEA61
		cmp	byte [CHAR_BUF], ' '
		jnz	short loc_FEA69
loc_FEA61:
		mov	di, 1
loc_FEA64:
		mov	ax, di
		jmp	FUNCTION_RETURN
loc_FEA69:
		cmp	byte [CHAR_BUF], '+'
		jz	short loc_FEA77
		cmp	byte [CHAR_BUF], '-'
		jnz	short loc_FEA8C
loc_FEA77:
		mov	dl, [CHAR_BUF]
		mov	[bp+var_8], dl
		mov	word [bp+var_A], 0
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		jmp	loc_FEA1A
loc_FEA8C:
		call	ERR_BEEP
		sub	di, di
		jmp	short loc_FEA64

;------------------------------------------------------------------------
sub_FEA94:
%define var_6		-6 ; = word ptr -6
%define arg_0		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	bx, [bp+arg_0]
		mov	byte [bx], 0
		jmp	short loc_FEAD0
loc_FEAA4:
		mov	bx, [bp+arg_0]
		mov	al, [bx]
		cbw
		mov	cx, 4
		shl	ax, cl
		mov	dx, ax
		mov	al, byte [bp+var_6]
		cbw
		add	dx, ax
		mov	[bx], dl
		call	GETCHAR
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], 0Dh ; CRLF
		jz	short GOT_END_OF_LINE
		mov	di, CHAR_BUF
		push	di
		call	PUTCHAR
		add	sp, 2
loc_FEAD0:
		lea	di, [bp+var_6]
		push	di
		mov	al, [CHAR_BUF]
		cbw
		push	ax
		call	PARSE_HEX_sub_FF6BA
		add	sp, 4
		test	ax, ax
		jnz	short loc_FEAA4
GOT_END_OF_LINE:
		cmp	byte [CHAR_BUF], 0Dh
		jz	short loc_FEB02
		cmp	byte [CHAR_BUF], ' '
		jz	short loc_FEB02
		cmp	byte [CHAR_BUF], ','
		jz	short loc_FEB02
		call	ERR_BEEP
		sub	di, di
loc_FEAFD:
		mov	ax, di
		jmp	FUNCTION_RETURN
loc_FEB02:
		mov	di, 1
		jmp	short loc_FEAFD

;------------------------------------------------------------------------
RESTORE_REGS_AND_IRET:
		mov	ax, SAVE_REGS_AND_BREAK
		mov	bx, 4
		mov	[bx], ax
		mov	[bx+CPU_REGS.BX], cs
		mov	bx, 0Ch
		mov	[bx], ax
		mov	[bx+CPU_REGS.BX], cs
		mov	bx, SAVED_CPU_REGS
		cli
		mov	di, [bx+CPU_REGS.DI]
		mov	si, [bx+CPU_REGS.SI]
		mov	dx, [bx+CPU_REGS.DX]
		mov	cx, [bx+CPU_REGS.CX]
		mov	ax, [bx+CPU_REGS.AX]
		mov	es, [bx+CPU_REGS.ES]
		mov	ss, [bx+CPU_REGS.SS]
		mov	sp, [bx+CPU_REGS.SP]
		mov	bp, [bx+CPU_REGS.BP]
		push	word [bx+CPU_REGS.FLAGS]
		push	word [bx+CPU_REGS.CS]
		push	word [bx+CPU_REGS.IP]
		push	word [bx+CPU_REGS.DS]
		mov	bx, [bx+CPU_REGS.BX]
		pop	ds
		iret

;------------------------------------------------------------------------
M_GOTO:
		push	bp
		mov	bp, sp
		push	di
		push	si
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], 0Dh
		jnz	short loc_FEB6E
		call	sub_FEBD6
		call	near RESTORE_REGS_AND_IRET
loc_FEB6E:
		call	PARSE_ADDR_sub_FE96E
		test	ax, ax
		jz	short loc_FEB8B
		mov	di, [ADDR_SEGMENT]
		mov	[SAVED_CPU_REGS+CPU_REGS.CS], di
		mov	di, [ADDR_OFFSET]
		mov	[SAVED_CPU_REGS+CPU_REGS.IP], di
		call	sub_FEBD6
		call	near RESTORE_REGS_AND_IRET
loc_FEB8B:
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
M_SINGLE_STEP:
		push	bp
		mov	bp, sp
		push	di
		push	si
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], 0Dh
		jnz	short loc_FEBB3
		or	word [SAVED_CPU_REGS+CPU_REGS.FLAGS], 100h
		call	near RESTORE_REGS_AND_IRET
loc_FEBB3:
		call	PARSE_ADDR_sub_FE96E
		test	ax, ax
		jz	short loc_FEBD3
		mov	di, [ADDR_SEGMENT]
		mov	[SAVED_CPU_REGS+CPU_REGS.CS], di
		mov	di, [ADDR_OFFSET]
		mov	[SAVED_CPU_REGS+CPU_REGS.IP], di
		or	word [SAVED_CPU_REGS+CPU_REGS.FLAGS], 100h
		call	near RESTORE_REGS_AND_IRET
loc_FEBD3:
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
sub_FEBD6:
%define COUNTER		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	word [bp+COUNTER], 0
loc_FEBE3:
		mov	ax, [bp+COUNTER]
		mov	cx, 6
		imul	cx
		mov	bx, ax
		mov	al, byte_8CA[bx]
		test	al, al
		jz	short loc_FEC2C
		mov	ax, [bp+COUNTER]
		mov	cx, 6
		imul	cx
		mov	bx, ax
		mov	ax, word_8CC[bx]
		mov	word [ADDR_SEGMENT], ax
		mov	ax, [bp+COUNTER]
		imul	cx
		mov	bx, ax
		mov	ax, word_8CE[bx]
		mov	word [ADDR_OFFSET], ax
		mov	ax, [bp+COUNTER]
		imul	cx
		push	ax
		call	MEM_READ8
		pop	bx
		mov	byte_8CB[bx], al
		mov	di, 0CCh
		push	di
		call	MEM_WRITE8
		add	sp, 2
loc_FEC2C:
		inc	word [bp+COUNTER]
		cmp	word [bp+COUNTER], 8
		jb	short loc_FEBE3
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
INT3_sub_FEC38:
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	di, STR_BREAK ; "\nBreak ...."
		push	di
		call	PUTS
		add	sp, 2
		mov	word [bp+var_6], 0
loc_FEC4F:
		mov	ax, [bp+var_6]
		mov	cx, 6
		imul	cx
		mov	bx, ax
		mov	al, byte_8CA[bx]
		test	al, al
		jz	short loc_FEC93
		mov	ax, [bp+var_6]
		mov	cx, 6
		imul	cx
		mov	bx, ax
		mov	ax, word_8CC[bx]
		mov	word [ADDR_SEGMENT], ax
		mov	ax, [bp+var_6]
		imul	cx
		mov	bx, ax
		mov	ax, word_8CE[bx]
		mov	word [ADDR_OFFSET], ax
		mov	ax, [bp+var_6]
		imul	cx
		mov	di, ax
		mov	al, byte_8CB[di]
		cbw
		push	ax
		call	MEM_WRITE8
		add	sp, 2
loc_FEC93:
		inc	word [bp+var_6]
		cmp	word [bp+var_6], 8
		jb	short loc_FEC4F
		or	word [SAVED_CPU_REGS+CPU_REGS.FLAGS], 100h
		call	near RESTORE_REGS_AND_IRET
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
HDD_READ:
%define HDD_RETRIES	-0Ah ; = byte ptr -0Ah
%define HDD_SECTORS_READ  -8 ; = word ptr -8
%define RETRIES_DONE	-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		mov	dl, [DISK_IOPB+IOPB.DISK_OPCODE]
		mov	[DISK_IOPB+I8089_PB.HDD_OPCODE], dl
		mov	byte [DISK_IOPB+I8089_PB.HDD_STATUS], 0FFh
		mov	di, [DISK_IOPB+IOPB.DISK_TRACK]
		mov	[DISK_IOPB+I8089_PB.HDD_CYLINDER], di
		mov	word [bp+HDD_SECTORS_READ], 1
		mov	dx, [bp+HDD_SECTORS_READ]
		mov	al, [DISK_IOPB+IOPB.DISK_DRIVE_NUM]
		cbw
		mov	cx, ax
		shl	dx, cl
		mov	al, [DISK_IOPB+IOPB.DISK_HEAD]
		cbw
		add	dx, ax
		mov	[DISK_IOPB+I8089_PB.HDD_DRIVE_AND_HEAD], dl
		mov	dl, [DISK_IOPB+IOPB.DISK_SECTOR]
		mov	[DISK_IOPB+I8089_PB.HDD_SECTOR], dl
		mov	di, [DISK_IOPB+IOPB.DISK_DMA_OFFSET]
		mov	[DISK_IOPB+I8089_PB.HDD_DMA_OFFSET], di
		mov	di, [DISK_IOPB+IOPB.DISK_DMA_SEGMENT]
		mov	[DISK_IOPB+I8089_PB.HDD_DMA_SEGMENT], di
		mov	di, [DISK_IOPB+IOPB.DISK_SECTOR_LEN]
		mov	[DISK_IOPB+I8089_PB.HDD_SECTOR_LEN], di
		mov	dl, [DISK_IOPB+IOPB.DISK_RETRIES]
		mov	[bp+HDD_RETRIES], dl
		cmp	byte [bp+HDD_RETRIES], 0
		jg	short RETRIES_NOW_NONZERO
		mov	byte [bp+HDD_RETRIES], 1
RETRIES_NOW_NONZERO:
		mov	word [bp+HDD_SECTORS_READ], 0
		jmp	short loc_FED48
HDD_READ_SECTORS:
		mov	byte [IOP_BLOCK+I8089_PB.RESVD_0], 1
		mov	word [bp+RETRIES_DONE], 1
		jmp	short loc_FED30
loc_FED23:
		call	I8089_DO_IO
		cmp	byte [IOP_BLOCK+I8089_PB.HDD_STATUS], 0
		jz	short NO_LONGER_BUSY
		inc	word [bp+RETRIES_DONE]
loc_FED30:
		mov	al, [bp+HDD_RETRIES]
		cbw
		cmp	ax, [bp+RETRIES_DONE]
		jnb	short loc_FED23
NO_LONGER_BUSY:
		mov	di, [DISK_IOPB+IOPB.DISK_SECTOR_LEN]
		add	[IOP_BLOCK+I8089_PB.HDD_DMA_OFFSET], di
		inc	byte [IOP_BLOCK+I8089_PB.HDD_SECTOR]
		inc	word [bp+HDD_SECTORS_READ]
loc_FED48:
		mov	al, [DISK_IOPB+IOPB.DISK_SECTOR_COUNT]
		cbw
		cmp	ax, [bp+HDD_SECTORS_READ]
		ja	short HDD_READ_SECTORS
		mov	dl, [IOP_BLOCK+I8089_PB.HDD_STATUS]
		mov	[DISK_IOPB+IOPB.DISK_OP_STATUS], dl
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
AUTOBOOT_PROMPT:
%define DO_AUTO_BOOT	-8 ; = byte ptr -8
%define var_6		-6 ; = word ptr -6
%define INIT_REG	4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 4
		cmp	word [bp+INIT_REG], 0
		jnz	short DO_SETUP
		jmp	MONITOR_PROMPT; eh
DO_SETUP:
		mov	di, STR_VERSION_BANNER ; "			\nMonitor V"...
		push	di
		call	PUTS
		add	sp, 2
		mov	di, STR_BOOT_INTERRUPT ; "\nPress any key to interrupt boot\n"
		push	di
		call	PUTS
		add	sp, 2
		mov	word [bp+var_6], 1
CHECK_KEY_INPUT:
		mov	di, 100
		push	di
		call	DELAY
		add	sp, 2
		mov	al, [CHAR_BUF]
		cbw
		push	ax
		mov	di, 0FFFFh
		push	di
		sub	di, di
		push	di
		call	SIO_RX
		add	sp, 6
		test	ax, ax
		jnz	short loc_FEDAA
		sub	di, di
		jmp	short loc_FEDAD
loc_FEDAA:
		mov	di, 1
loc_FEDAD:
		mov	dx, di
		mov	[bp+DO_AUTO_BOOT], dl
		test	dl, dl
		jnz	short loc_FEDBF
		inc	word [bp+var_6]
		cmp	word [bp+var_6], 80
		jbe	short CHECK_KEY_INPUT
loc_FEDBF:
		cmp	byte [bp+DO_AUTO_BOOT], 0
		jnz	short NO_AUTO_BOOT
		mov	di, STR_BOOT_HDD ; "\nBooting from Hard Disk"
		push	di
		call	PUTS
		add	sp, 2
KEY_1_HD_BOOT:
		call	I8089_DO_IO
		mov	di, 4
		push	di
		call	DISK_BOOT
		add	sp, 2
		jmp	short BOOT_ERR
NO_AUTO_BOOT:
		call	GETCHAR
		mov	[CHAR_BUF], al
		jmp	short BOOT_MENU
NOT_KEY_2_FD_BOOT:
		cmp	ax, '3'
		jz	short loc_FEE2A
		cmp	ax, '?'
		jnz	short BOOT_ERR
		jmp	word MONITOR_PROMPT ; eh
BOOT_ERR:
		call	ERR_BEEP
BOOT_MENU:
		mov	di, STR_BOOT_PROMPT ; "\nEnter [1] to boot from Hard Disk\nEnter"...
		push	di
		call	PUTS
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		mov	al, [CHAR_BUF]
		cbw
		cmp	ax, '1'
		jz	short KEY_1_HD_BOOT
		cmp	ax, '2'
		jnz	short NOT_KEY_2_FD_BOOT
		call	I8089_DO_IO
		sub	di, di
		push	di		; 0 = FLOPPY
		call	DISK_BOOT	; FALLTHROUGH
DO_MONITOR:
		add	sp, 2
		jmp	short MONITOR_PROMPT
DISPATCH_COMMAND:
		shl	ax, 1
		xchg	ax, bx
		;jmp	MONITOR_CMDS[cs:bx]  ; <-- yasm: no CS prefix!
		cs jmp	MONITOR_CMDS[bx]
loc_FEE2A:
		call	I8089_DO_IO
		jmp	short MONITOR_PROMPT

MON_A_LTER_MEM	call    M_ALTER_MEMORY
		jmp     short MONITOR_PROMPT
MON_B_REAKPOINT	call    M_BREAKPOINT
		jmp     short MONITOR_PROMPT
MON_D_ISP_MEM	call    M_DISPLAY_MEMORY
		jmp     short MONITOR_PROMPT
MON_G_O_TO	call    M_GOTO
		jmp     short MONITOR_PROMPT
MON_I_NPUT_PORT	mov     di, 1
		push    di
DO_PORT_IO:	call    M_PORT_IO
		jmp     short DO_MONITOR
MON_K_DISK_IO	call    M_DISK_IO
		jmp     short MONITOR_PROMPT
MON_L_OAD_BOOT	call    M_LOAD_BOOT
		jmp     short MONITOR_PROMPT
MON_M_EMCPY	call    M_MEMCPY
		jmp     short MONITOR_PROMPT
MON_O_UT_PORT	sub     di, di
		push    di
		jmp     short DO_PORT_IO
MON_R_EGISTERS	call    M_REGISTER
		jmp     short MONITOR_PROMPT
MON_S_INGLE_STP	call    M_SINGLE_STEP
		jmp     short MONITOR_PROMPT
MON_X_HEX_DNLD	call    M_HEX_DOWNLOAD

MONITOR_PROMPT:	mov	di, STR_MONITOR_PROMPT ; "\n< A, B, D, G, I, K, L, M, O, R, S, X >"...
		push	di
		call	PUTS
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		mov	al, [CHAR_BUF]
		cbw
		sub	ax, 'A'
		cmp	ax, 23		; Num of letters of alphabet (sort of)
		jbe	short DISPATCH_COMMAND

MON___NO_CMD	call	ERR_BEEP
		jmp	short MONITOR_PROMPT

MONITOR_CMDS	dw MON_A_LTER_MEM	; 0
		dw MON_B_REAKPOINT	; 1
		dw MON___NO_CMD		; 2
		dw MON_D_ISP_MEM	; 3
		dw MON___NO_CMD		; 4
		dw MON___NO_CMD		; 5
		dw MON_G_O_TO		; 6
		dw MON___NO_CMD		; 7
		dw MON_I_NPUT_PORT	; 8
		dw MON___NO_CMD		; 9
		dw MON_K_DISK_IO	; 10
		dw MON_L_OAD_BOOT	; 11
		dw MON_M_EMCPY		; 12
		dw MON___NO_CMD		; 13
		dw MON_O_UT_PORT	; 14
		dw MON___NO_CMD		; 15
		dw MON___NO_CMD		; 16
		dw MON_R_EGISTERS	; 17
		dw MON_S_INGLE_STP	; 18
		dw MON___NO_CMD		; 19
		dw MON___NO_CMD		; 20
		dw MON___NO_CMD		; 21
		dw MON___NO_CMD		; 22
MON_DNLD_CMD	dw MON_X_HEX_DNLD	; 23

		; Why is this here..
		jmp	MONITOR_PROMPT

;------------------------------------------------------------------------
M_MEMCPY:
%define var_E		-0Eh ; = word ptr -0Eh
%define var_C		-0Ch ; = word ptr -0Ch
%define var_A		-0Ah ; = word ptr -0Ah
%define var_8		-8 ; = word ptr -8
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
loc_FEEC7:
		sub	sp, 0Ah
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	sub_FF8DC
		test	ax, ax
		jz	short loc_FEF30
		cmp	byte [CHAR_BUF], 0Dh
		jnz	short loc_FEEE7
loc_FEEE2:
		call	ERR_BEEP
		jmp	short loc_FEF30
loc_FEEE7:
		mov	di, [ADDR_OFFSET]
		mov	[bp+var_8], di
		mov	di, [ADDR_SEGMENT]
		mov	[bp+var_6], di
		call	sub_FF8DC
		test	ax, ax
		jz	short loc_FEF30
		cmp	byte [CHAR_BUF], 0Dh
		jz	short loc_FEEE2
loc_FEF03:
		mov	di, [ADDR_OFFSET]
		mov	[bp+var_C], di
		mov	di, [ADDR_SEGMENT]
		mov	[bp+var_A], di
		lea	di, [bp+var_E]
		push	di
		call	sub_FF8EE
		add	sp, 2
		test	ax, ax
		jz	short loc_FEF30
		push	word [bp+var_E]
		lea	di, [bp+var_C]
		push	di
		lea	di, [bp+var_8]
		push	di
		call	MEMCPY
		add	sp, 6
loc_FEF30:
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
MEMCPY:
%define SRC		4 ; = word ptr	4
%define DEST		6 ; = word ptr	6
%define LEN		8 ; = byte ptr	8
		push	bp
		mov	bp, sp
		push	ds
		push	di
		push	si
		push	es
		mov	di, [bp+DEST]
		mov	es, word [di+2]
		mov	di, [di]
		mov	bx, [bp+SRC]
		mov	si, [bx]
		mov	ds, word [bx+2]
		mov	cx, word [bp+LEN]
		cld
		rep movsb
		pop	es
		pop	si
		pop	di
		pop	ds
		pop	bp
		retn

;------------------------------------------------------------------------
M_PORT_IO:
%define IO_VAL16	-0Ah ; = word ptr -0Ah
%define IO_PORT		-8 ; = word ptr -8
%define PORT_WIDTH	-6 ; = byte ptr -6
%define DIRECTION_INPUT	4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		mov	byte [bp+PORT_WIDTH], 1
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], 'B'
		jnz	short NOT_BYTE
		mov	byte [bp+PORT_WIDTH], 0
GOT_WIDTH:
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		lea	di, [bp+IO_PORT]
		push	di
		call	sub_FF8EE
		add	sp, 2
		test	ax, ax
		jz	short loc_FEFC9
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		cmp	byte [bp+DIRECTION_INPUT], 0
		jz	short loc_FEFDB
		cmp	byte [bp+PORT_WIDTH], 0
		jz	short loc_FEFCC
		push	word [bp+IO_PORT]
		call	IN16
		add	sp, 2
		push	ax
		call	PRINTHEX16
loc_FEFBA:
		add	sp, 2
		jmp	short loc_FEFC9
NOT_BYTE:
		cmp	byte [CHAR_BUF], 'W'
		jz	short GOT_WIDTH
		call	ERR_BEEP
loc_FEFC9:
		jmp	FUNCTION_RETURN
loc_FEFCC:
		push	word [bp+IO_PORT]
		call	IN8
		add	sp, 2
		push	ax
		call	PRINTHEX8
		jmp	short loc_FEFBA
loc_FEFDB:
		lea	di, [bp+IO_VAL16]
		push	di
		call	sub_FF8EE
		add	sp, 2
		test	ax, ax
		jz	short loc_FEFC9
		cmp	byte [bp+PORT_WIDTH], 0
		jz	short loc_FEFFD
		push	word [bp+IO_VAL16]
		push	word [bp+IO_PORT]
		call	OUT16
loc_FEFF8:
		add	sp, 4
		jmp	short loc_FEFC9
loc_FEFFD:
		push	word [bp+IO_VAL16]
		push	word [bp+IO_PORT]
		call	OUT8
		jmp	short loc_FEFF8

;------------------------------------------------------------------------
PUTS:
%define BUFFER		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		push	word [bp+BUFFER]
		sub	di, di
		push	di		; Attrs
		push	di		; Channel = 0
		call	DO_PUTS
		add	sp, 6
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
DO_PUTS:
%define var_8		-8 ; = byte ptr -8
%define LEN		-6 ; = word ptr -6
%define CHANNEL		4 ; = word ptr	4
%define ATTRS		6 ; = word ptr	6
%define BUFFER		8 ; = word ptr	8
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 4
		mov	word [bp+LEN], 0
		mov	di, [bp+ATTRS]
		mov	word [ADDR_SEGMENT], di
		mov	di, [bp+BUFFER]
		mov	word [ADDR_OFFSET], di
		jmp	short loc_FF081
loc_FF03B:
		push	word [bp+BUFFER]
		push	word [bp+ATTRS]
		push	word [bp+LEN]
		push	word [bp+CHANNEL]
		call	SIO_TX
		add	sp, 8
		cmp	byte [bp+var_8], 0Ah
		jnz	short loc_FF060
		push	word [bp+CHANNEL]
		call	DO_PRINT_CRLF
		add	sp, 2
		inc	word [ADDR_OFFSET]
loc_FF060:
		mov	di, [ADDR_OFFSET]
		mov	[bp+BUFFER], di
		mov	word [bp+LEN], 0
		jmp	short loc_FF081
loc_FF06E:
		cmp	byte [bp+var_8], 0Ah
		jz	short loc_FF03B
		cmp	word [bp+LEN], 0Ah
		jge	short loc_FF03B
		inc	word [bp+LEN]
		inc	word [ADDR_OFFSET]
loc_FF081:
		call	MEM_READ8
		mov	[bp+var_8], al
		test	al, al
		jnz	short loc_FF06E
		push	word [bp+BUFFER]
		push	word [bp+ATTRS]
		push	word [bp+LEN]
		push	word [bp+CHANNEL]
		call	SIO_TX
		add	sp, 8
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
PRINT_CRLF:
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	di, di
		push	di
		call	DO_PRINT_CRLF
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
DO_PRINT_CRLF:
%define var_6		-6 ; = byte ptr -6
%define var_5		-5 ; = byte ptr -5
%define CHANNEL		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	byte [bp+var_6], 0Dh
		mov	byte [bp+var_5], 0Ah
		lea	di, [bp+var_6]
		push	di
		sub	di, di
		push	di
		mov	di, 2
		push	di
		push	word [bp+CHANNEL]
		call	SIO_TX
		add	sp, 8
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
PRINTHEX16:
%define ARG16		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		mov	di, [bp+ARG16]
		and	di, 0FF00h
		mov	cx, 8
		sar	di, cl
		push	di
		call	PRINTHEX8
		add	sp, 2
		mov	di, [bp+ARG16]
		and	di, 0FFh
		push	di
		call	PRINTHEX8
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
PRINTHEX8:
%define ARG8		4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		mov	di, PRINTHEX_unk_F1C
		push	di
		mov	di, PRINTHEX_unk_F1A
		push	di
		mov	al, [bp+ARG8]
		cbw
		push	ax
		call	FMT_HEX
		add	sp, 6
		mov	di, PRINTHEX_unk_F1A
		push	di
		call	PUTCHAR
		add	sp, 2
		mov	di, PRINTHEX_unk_F1C
		push	di
		call	PUTCHAR
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
sub_FF134:
		push	bp
		mov	bp, sp
		push	di
		push	si
		call	PRINT_CRLF
		mov	di, 2
		push	di
		call	sub_FF14A
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
sub_FF14A:
%define var_6		-6 ; = word ptr -6
%define arg_0		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	word [bp+var_6], 1
		jmp	short loc_FF166
loc_FF159:
		mov	di, CHR_SPACE ; " "
		push	di
		call	PUTCHAR
		add	sp, 2
		inc	word [bp+var_6]
loc_FF166:
		mov	di, [bp+arg_0]
		cmp	[bp+var_6], di
		jle	short loc_FF159
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
SIO_RX:
%define CHANNEL		4 ; = byte ptr	4
%define LEN		6 ; = word ptr	6
%define BUFFER		8 ; = word ptr	8
		push	bp
		mov	bp, sp
		push	si
		push	di
		mov	bx, [bp+BUFFER]
		mov	al, SIO_REGS_size
		mul	byte [bp+CHANNEL]
		lea	si, [SIO_CHAN_0]
		add	si, ax
		cmp	word [bp+LEN], 0FFFFh ; Just the attributes?
		jz	short SET_ATTRS
		xor	cx, cx
		cmp	cx, [bp+LEN]
		jnb	short loc_FF1F1
		mov	dx, [si+SIO_REGS.RX_LEN] ; Receive Data Buffer Length Register
		mov	ax, [si+SIO_REGS.RX_OUT] ; Receive Buffer Output Pointer Register
		mov	di, word [si+SIO_REGS.RX_LO] ; Receive Data Buffer Address Register LO
		add	di, ax
WAIT_FOR_IO:
		call	SIO_WAIT_READY
		mov	ax, [si+SIO_REGS.RX_IN] ; Receive Buffer Input Pointer Register
		test	ax, ax
		js	short WAIT_FOR_IO
		cmp	ax, [si+SIO_REGS.RX_OUT] ; Receive Buffer Output Pointer Register
		jz	short WAIT_FOR_IO
		mov	ax, [si+SIO_REGS.STAT] ; Channel Status Register
		and	ax, 0F0h
		jz	short loc_FF1C0
		mov	byte [si+SIO_REGS.CMD], SIO_BUSY | SIO_RESET_ERR	; Channel Command Register
		call	NEW_COMMAND
		mov	al, 0
		jmp	short SIO_RX_DONE
loc_FF1C0:
		mov	al, [di]
		inc	word [si+SIO_REGS.RX_OUT] ; Receive Buffer Output Pointer Register
		inc	di
		cmp	[si+SIO_REGS.RX_OUT], dx ; Receive Buffer Output Pointer Register
		jb	short loc_FF1D3
		mov	word [si+SIO_REGS.RX_OUT], 0 ; Receive Buffer Output Pointer Register
		mov	di, word [si+SIO_REGS.RX_LO] ; Receive Data Buffer Address Register LO
loc_FF1D3:
		mov	[bx], al
		inc	bx
		inc	cx
		cmp	cx, [bp+LEN]
		jnb	short loc_FF1F1
loc_FF1DC:
		mov	ax, [si+SIO_REGS.RX_IN] ; Receive Buffer Input Pointer Register
		test	ax, ax
		js	short loc_FF1DC
		cmp	ax, [si+SIO_REGS.RX_OUT] ; Receive Buffer Output Pointer Register
		jnz	short loc_FF1C0
		mov	byte [si+SIO_REGS.CMD], SIO_BUSY | SIO_ACK_RX	; Channel Command Register
		call	NEW_COMMAND
		jmp	short WAIT_FOR_IO
loc_FF1F1:
		mov	byte [si+SIO_REGS.CMD], SIO_BUSY | SIO_ACK_RX	; Channel Command Register
		call	NEW_COMMAND
		jmp	short SIO_RX_DONE
SET_ATTRS:
		mov	dx, [si+SIO_REGS.PARM] ; Channel Parameter Register
		mov	al, 0FFh
loc_FF1FF:
		mov	bx, [si+SIO_REGS.RX_IN] ; Receive Buffer Input Pointer Register
		test	bx, bx
		js	short loc_FF1FF
		cmp	bx, [si+SIO_REGS.RX_OUT] ; Receive Buffer Output Pointer Register
		jnz	short SIO_RX_DONE
		xor	al, al
SIO_RX_DONE:
		pop	di
		pop	si
		pop	bp
		retn

;------------------------------------------------------------------------
SIO_TX:
%define CHANNEL		4 ; = byte ptr	4
%define LEN		6 ; = word ptr	6	; 0FFFFh = only set attrs
%define OFFSET_OR_ATTRS	8 ; = word ptr	8
%define BUFFER		0Ah ; = word ptr  0Ah	; Not used if LENGTH=0FFFFh
		push	bp
		mov	bp, sp
		push	si
		push	di
		mov	al, 16h
		mul	byte [bp+CHANNEL]
		lea	si, [SIO_CHAN_0]
		add	si, ax
		cmp	word [bp+LEN], 0FFFFh
		jz	short JUST_SET_ATTR
		cmp	word [bp+LEN], 0
		jle	short SIO_TX_DONE ; Zero length write
		call	SIO_WAIT_READY
WAIT_CHAN_READY:
		mov	cx, [si+SIO_REGS.STAT] ; Channel Status Register
		and	cx, 1000h
		cmp	cx, 1000h
		jnz	short WAIT_CHAN_READY
		mov	al, SIO_TX_LEN
		mul	byte [bp+CHANNEL]
		mov	cl, 8
		lea	di, [SIO_TX_BUFS]
		add	di, ax
		mov	dx, di
		and	dx, 0FFh
		mov	[si+SIO_REGS.TX_LO], dl ; Transmit Data Buffer Address Register LO
		mov	dx, di
		and	dx, 0FF00h
		shr	dx, cl
		mov	word [si+SIO_REGS.TX_HI], dx ; Transmit Data Buffer Address Register MID
		mov	cx, [bp+LEN]
		cmp	cx, SIO_TX_LEN
		jbe	short LENGTH_NOW_LESS_THAN_10
		mov	cx, SIO_TX_LEN
LENGTH_NOW_LESS_THAN_10:
		mov	[si+SIO_REGS.TX_LEN], cx ; Transmit Data Buffer Length Register
		push	si
		mov	ds, [bp+OFFSET_OR_ATTRS]
		mov	si, [bp+BUFFER]
		rep movsb		; Copy data to TX buffer
		pop	si
		mov	ax, 0
		mov	ds, ax
		mov	byte [si+SIO_REGS.CMD], SIO_BUSY | SIO_START_TX	; Channel Command Register
		call	NEW_COMMAND
		jmp	short SIO_TX_DONE
JUST_SET_ATTR:
		mov	ax, [bp+OFFSET_OR_ATTRS]
		mov	[si+0], ax
		mov	al, SIO_BUSY | SIO_INIT_CHAN
		call	SIO_COMMAND_WHEN_READY ; AL=command
SIO_TX_DONE:
		pop	di
		pop	si
		pop	bp
		retn

;------------------------------------------------------------------------
M_REGISTER:
%define var_A		-0Ah ; = byte ptr -0Ah
%define var_8		-8 ; = byte ptr -8
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[bp+var_8], al
		cmp	byte [bp+var_8], 0Dh
		jnz	short loc_FF311
		call	PRINT_REGS
		jmp	short loc_FF30E
loc_FF2B9:
		mov	bx, [bp+var_6]
		shl	bx, 1
		mov	dl, (REG_NAMES+1)[bx]
		cmp	dl, [bp+var_A]
		jnz	short loc_FF32D
		mov	di, 2
		push	di
		call	sub_FF14A
		add	sp, 2
		mov	di, [bp+var_6]
		shl	di, 1
		push	word SAVED_CPU_REGS+CPU_REGS.AX[di]
		call	PRINTHEX16
		add	sp, 2
		mov	di, CHR_DASH_0 ; "-"
		push	di
		call	PUTCHAR
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], ' '
		jz	short loc_FF30E
		cmp	byte [CHAR_BUF], 0Dh
		jz	short loc_FF30E
		mov	di, [bp+var_6]
		shl	di, 1
		add	di, SAVED_CPU_REGS
		push	di
		call	READ_MEM_ADDR_sub_FE9D8
		add	sp, 2
loc_FF30E:
		jmp	FUNCTION_RETURN
loc_FF311:
		call	GETCHAR_ECHO
		mov	[bp+var_A], al
		mov	word [bp+var_6], 0
loc_FF31C:
		mov	bx, [bp+var_6]
		shl	bx, 1
		mov	dl, REG_NAMES[bx] ; "AX"
		cmp	dl, [bp+var_8]
		jnz	short loc_FF32D
		jmp	word loc_FF2B9
loc_FF32D:
		inc	word [bp+var_6]
		cmp	word [bp+var_6], 0Bh
		jbe	short loc_FF31C
		call	ERR_BEEP
		jmp	short loc_FF30E

;------------------------------------------------------------------------
M_BREAKPOINT:
%define var_A		-0Ah ; = word ptr -0Ah
%define var_8		-8 ; = word ptr -8
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		mov	byte [bp+var_6], ':'
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], 0Dh
		jnz	short loc_FF3CC
		mov	word [bp+var_A], 0
loc_FF364:
		cmp	word [bp+var_A], 8
		jb	short loc_FF36D
		jmp	loc_FF3F7
loc_FF36D:
		mov	ax, [bp+var_A]
		mov	cx, 6
		imul	cx
		mov	bx, ax
		mov	al, byte_8CA[bx]
		test	al, al
		jz	short loc_FF3C7
		call	sub_FF134
		push	word [bp+var_A]
		call	PRINTHEX8
		add	sp, 2
		mov	di, 2
		push	di
		call	sub_FF14A
		add	sp, 2
		mov	ax, [bp+var_A]
		mov	cx, 6
		imul	cx
		mov	bx, ax
		push	word word_8CC[bx]
		call	PRINTHEX16
		add	sp, 2
		lea	di, [bp+var_6]
		push	di
		call	PUTCHAR
		add	sp, 2
		mov	ax, [bp+var_A]
		mov	cx, 6
		imul	cx
		mov	bx, ax
		push	word word_8CE[bx]
		call	PRINTHEX16
		add	sp, 2
loc_FF3C7:
		inc	word [bp+var_A]
		jmp	short loc_FF364
loc_FF3CC:
		cmp	byte [CHAR_BUF], '-'
		jnz	short loc_FF402
		lea	di, [bp+var_8]
		push	di
		call	sub_FF906
		add	sp, 2
		test	ax, ax
		jz	short loc_FF3FA
		cmp	byte [bp+var_8], 8
		jge	short loc_FF3FA
		mov	al, byte [bp+var_8]
		cbw
		mov	cx, 6
		imul	cx
		mov	di, ax
		mov	byte byte_8CA[di], 0
loc_FF3F7:
		jmp	FUNCTION_RETURN
loc_FF3FA:
		call	sub_FF134
loc_FF3FD:
		call	ERR_BEEP
		jmp	short loc_FF3F7
loc_FF402:
		mov	word [bp+var_A], 0
loc_FF407:
		mov	ax, [bp+var_A]
		mov	cx, 6
		imul	cx
		mov	bx, ax
		mov	al, byte_8CA[bx]
		test	al, al
		jnz	short loc_FF456
		call	PARSE_ADDR_sub_FE96E
		test	ax, ax
		jz	short loc_FF3FD
		cmp	byte [CHAR_BUF], 0Dh
		jnz	short loc_FF3FD
		mov	di, [ADDR_SEGMENT]
		mov	ax, [bp+var_A]
		mov	cx, 6
		imul	cx
		mov	si, ax
		mov	word_8CC[si], di
		mov	di, [ADDR_OFFSET]
		mov	ax, [bp+var_A]
		imul	cx
		mov	si, ax
		mov	word_8CE[si], di
		mov	ax, [bp+var_A]
		imul	cx
		mov	di, ax
		mov	byte byte_8CA[di], 1
		jmp	short loc_FF3F7
loc_FF456:
		inc	word [bp+var_A]
		cmp	word [bp+var_A], 8
		jb	short loc_FF407
		jmp	short loc_FF3FD

;------------------------------------------------------------------------
PRINT_REGS:
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	di, STR_REG_CS_IP ; "\nCS:IP "
		push	di
		call	PUTS
		add	sp, 2
		push	word [SAVED_CPU_REGS+CPU_REGS.CS]
		call	PRINTHEX16
		add	sp, 2
		mov	di, CHR_COLON ; ":"
		push	di
		call	PUTCHAR
		add	sp, 2
		push	word [SAVED_CPU_REGS+CPU_REGS.IP]
		call	PRINTHEX16
		add	sp, 2
		mov	di, STR_REG_FLAGS ; "  Flags  "
		push	di
		call	PUTS
		add	sp, 2
		call	PRINT_FLAGS_REG
		call	sub_FF134
		mov	word [bp+var_6], 0
loc_FF4A7:
		mov	di, [bp+var_6]
		shl	di, 1
		add	di, REG_NAMES ; "AX"
		push	di
		mov	di, 2
		push	di
		sub	di, di
		push	di
		call	PRINT_BUF
		add	sp, 6
		mov	di, 5
		push	di
		call	sub_FF14A
		add	sp, 2
		inc	word [bp+var_6]
		cmp	word [bp+var_6], 0Bh
		jb	short loc_FF4A7
		call	sub_FF134
		mov	word [bp+var_6], 0
loc_FF4D9:
		mov	di, [bp+var_6]
		shl	di, 1
		push	word SAVED_CPU_REGS+CPU_REGS.AX[di]
		call	PRINTHEX16
		add	sp, 2
		mov	di, 3
		push	di
		call	sub_FF14A
		add	sp, 2
		inc	word [bp+var_6]
		cmp	word [bp+var_6], 0Bh
		jb	short loc_FF4D9
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
PRINT_FLAGS_REG:
%define FLAG_NUMBER	-8 ; = word ptr -8
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 4
		mov	di, [SAVED_CPU_REGS+CPU_REGS.FLAGS]
		mov	[bp+var_6], di
		mov	word [bp+FLAG_NUMBER], 0
PRINT_FLAG:
		mov	dx, [bp+FLAG_NUMBER]
		mov	bx, dx
		cmp	byte STR_FLAG_NAMES[bx], ' ' ; "    ODITSZ A P C"
		jz	short loc_FF540
		cmp	word [bp+var_6], 8000h
		jb	short loc_FF52C
		add	dx, STR_FLAG_NAMES ; "	ODITSZ A P C"
		push	dx
		jmp	short loc_FF530
loc_FF52C:
		mov	di, CHR_DASH_1 ; "-"
		push	di
loc_FF530:
		call	PUTCHAR
		add	sp, 2
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
loc_FF540:
		mov	di, [bp+var_6]
		shl	di, 1
		mov	[bp+var_6], di
		inc	word [bp+FLAG_NUMBER]
		cmp	word [bp+FLAG_NUMBER], 16 ; Bits in FLAGS register
		jb	short PRINT_FLAG
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
SIO_COMMAND_WHEN_READY:
		call	SIO_WAIT_READY
		mov	[si+SIO_REGS.CMD], al ; Channel Command Register
		call	NEW_COMMAND
		retn

;------------------------------------------------------------------------
SYS_CMD_WHEN_READY:
		push	dx
WAIT_READY:
		mov	dh, [SYS_CMD_REG]
		and	dh, 80h
		jnz	short WAIT_READY
		mov	[SYS_CMD_REG], al
		call	NEW_COMMAND
		pop	dx
		retn

;------------------------------------------------------------------------
MEM_WRITE8:
%define DATA8		4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		push	ds
		mov	bx, [ADDR_OFFSET]
		mov	ds, [ADDR_SEGMENT]
		mov	al, [bp+DATA8]
		mov	[bx], al
		pop	ds
		pop	bp
		retn

;------------------------------------------------------------------------
MEM_READ8:
		push	ds
		mov	bx, [ADDR_OFFSET]
		mov	ds, [ADDR_SEGMENT]
		mov	al, [bx]
		pop	ds
		retn

;------------------------------------------------------------------------
SIO_WAIT_READY:
		push	dx
WAIT_SIO_READY:
		mov	dh, [si+4]
		and	dh, 80h
		jnz	short WAIT_SIO_READY
		pop	dx
		retn

;------------------------------------------------------------------------
PRINT_BUF:
%define AUTOLEN		4 ; = word ptr	4
%define LEN		6 ; = word ptr	6
%define BUF		8 ; = byte ptr	8
		push	bp
		mov	bp, sp
		push	di
		push	si
		push	word [bp+BUF]
		sub	di, di
		push	di
		push	word [bp+LEN]
		push	word [bp+AUTOLEN]
		call	SIO_TX
		add	sp, 8
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
M_ALTER_MEMORY:
%define var_A		-0Ah ; = byte ptr -0Ah
%define var_8		-8 ; = word ptr -8
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		mov	byte [bp+var_8], '-'
		mov	byte [bp+var_A], 1
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	sub_FF8DC
		test	ax, ax
		jz	short loc_FF5E3
		cmp	byte [CHAR_BUF], 0Dh
		jz	short loc_FF5EE
		call	ERR_BEEP
loc_FF5E3:
		jmp	FUNCTION_RETURN
loc_FF5E6:
		mov	byte [bp+var_A], 0
loc_FF5EA:
	inc     word [ADDR_OFFSET]
loc_FF5EE:
		cmp	byte [bp+var_A], 0
		jz	short loc_FF5E3
		call	PRINT_MEM_ADDR_sub_FF8A2
		call	MEM_READ8
		mov	byte [bp+var_6], al
		mov	al, byte [bp+var_6]
		cbw
		push	ax
		call	PRINTHEX8
		add	sp, 2
		lea	di, [bp+var_8]
		push	di
		call	PUTCHAR
		add	sp, 2
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		cmp	byte [CHAR_BUF], ' '
		jz	short loc_FF5EA
		cmp	byte [CHAR_BUF], 0Dh
		jz	short loc_FF5EA
		lea	di, [bp+var_6]
		push	di
		mov	al, [CHAR_BUF]
		cbw
		push	ax
		call	PARSE_HEX_sub_FF6BA
		add	sp, 4
		test	ax, ax
		jz	short loc_FF5E6
		lea	di, [bp+var_6]
		push	di
		call	sub_FEA94
		add	sp, 2
		test	ax, ax
		jz	short loc_FF5E6
		mov	al, byte [bp+var_6]
		cbw
		push	ax
		call	MEM_WRITE8
		add	sp, 2
		call	MEM_READ8
		mov	di, ax
		mov	al, byte [bp+var_6]
		cbw
		cmp	di, ax
		jz	short loc_FF5EA
		call	ERR_BEEP
		jmp	short loc_FF5EA

;------------------------------------------------------------------------
M_LOAD_BOOT:
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		lea	di, [bp+var_6]
		push	di
		call	sub_FF906
		add	sp, 2
		test	ax, ax
		jz	short loc_FF69B
		cmp	byte [bp+var_6], 0
		jl	short loc_FF69B
		cmp	byte [bp+var_6], 5
		jg	short loc_FF69B
		mov	al, byte [bp+var_6]
		cbw
		push	ax
		call	DISK_BOOT
		add	sp, 2
loc_FF69B:
		call	ERR_BEEP
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
FDC_sub_FF6A2:
		push	cx
		mov	ax, ds
		mov	cl, 4
		rol	ax, cl
		mov	ch, al
		and	ch, 0Fh
		mov	[di+2], ch
		and	al, 0F0h
		add	ax, si
		mov	[di], ax
		pop	cx
		retn

;------------------------------------------------------------------------
PARSE_HEX_sub_FF6BA:
%define var_6		-6 ; = byte ptr -6
%define arg_0		4 ; = byte ptr	4
%define arg_2		6 ; = word ptr	6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	byte [bp+var_6], 1
		cmp	byte [bp+arg_0], 'f'
		jg	short loc_FF704
		cmp	byte [bp+arg_0], 'a'
		jl	short loc_FF704
		mov	bx, [bp+arg_2]
		mov	al, [bp+arg_0]
		cbw
		add	ax, -57h
		jmp	short loc_FF700
loc_FF6DE:
		cmp	byte [bp+arg_0], 'A'
		jl	short loc_FF70A
		mov	bx, [bp+arg_2]
		mov	al, [bp+arg_0]
		cbw
		add	ax, -37h
		jmp	short loc_FF700
loc_FF6F0:
		cmp	byte [bp+arg_0], '0'
		jl	short loc_FF710
		mov	bx, [bp+arg_2]
		mov	al, [bp+arg_0]
		cbw
		add	ax, -30h
loc_FF700:
		mov	[bx], al
		jmp	short loc_FF714
loc_FF704:
		cmp	byte [bp+arg_0], 'F'
		jle	short loc_FF6DE
loc_FF70A:
		cmp	byte [bp+arg_0], '9'
		jle	short loc_FF6F0
loc_FF710:
		mov	byte [bp+var_6], 0
loc_FF714:
		mov	al, [bp+var_6]
		cbw
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
GETCHAR:
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		lea	di, [bp+var_6]
		push	di
		mov	di, 1
		push	di
		sub	di, di
		push	di
		call	SIO_RX
		add	sp, 6
		mov	al, byte [bp+var_6]
		cbw
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
PUTCHAR:
%define CHAR		4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		push	word [bp+CHAR]
		mov	di, 1
		push	di
		sub	di, di
		push	di
		call	PRINT_BUF
		add	sp, 6
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
M_DISPLAY_MEMORY:
%define var_8		-8 ; = word ptr -8
%define var_6		-6 ; = byte ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 4
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
		call	sub_FF8DC
		test	ax, ax
		jnz	short loc_FF770
		jmp	loc_FF831
loc_FF770:
		cmp	byte [CHAR_BUF], 0Dh
		jnz	short loc_FF77E
		mov	word [bp+var_8], 1
		jmp	short loc_FF78F
loc_FF77E:
		lea	di, [bp+var_8]
		push	di
		call	sub_FF8EE
		add	sp, 2
		test	ax, ax
		jnz	short loc_FF78F
		jmp	loc_FF831
loc_FF78F:
		call	PRINT_MEM_ADDR_sub_FF8A2
		mov	di, [ADDR_OFFSET]
		and	di, 0Fh
		mov	al, REG_DISP_OFFSETS[di]
		cbw
		push	ax
		call	sub_FF14A
		add	sp, 2
loc_FF7A6:
		cmp	word [bp+var_8], 0
		jz	short loc_FF807
		call	MEM_READ8
		mov	[bp+var_6], al
		mov	al, [bp+var_6]
		cbw
		push	ax
		call	PRINTHEX8
		add	sp, 2
		inc	word [ADDR_OFFSET]
		dec	word [bp+var_8]
		test	word [ADDR_OFFSET], 3
		jnz	short loc_FF7D6
		mov	di, 1
		push	di
		call	sub_FF14A
		add	sp, 2
loc_FF7D6:
		test	word [ADDR_OFFSET], 0Fh
		jnz	short loc_FF7EE
		dec	word [ADDR_OFFSET]
		call	DISPMEM_sub_FF834
		cmp	word [bp+var_8], 0
		jz	short loc_FF7EE
		call	PRINT_MEM_ADDR_sub_FF8A2
loc_FF7EE:
		mov	al, [MON_DNLD_CMD] ; WUT ; no ds:
		cbw
		push	ax
		mov	di, 0FFFFh
		push	di
		sub	di, di
		push	di
		call	SIO_RX
		add	sp, 6
		test	ax, ax
		jz	short loc_FF7A6
		call	GETCHAR
loc_FF807:
		test	word [ADDR_OFFSET], 0Fh
		jz	short loc_FF831
		mov	di, '$'
		mov	si, [ADDR_OFFSET]
		and	si, 0Fh
		mov	al, REG_DISP_OFFSETS[si]
		cbw
		sub	di, ax
		push	di
		call	sub_FF14A
		add	sp, 2
		and	word [ADDR_OFFSET], 0FFF0h
		call	DISPMEM_sub_FF834
loc_FF831:
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
DISPMEM_sub_FF834:
%define var_C		-0Ch ; = word ptr -0Ch
%define var_A		-0Ah ; = word ptr -0Ah
%define var_8		-8 ; = word ptr -8
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 8
		mov	byte [bp+var_6], '*'
		mov	byte [bp+var_8], '.'
		mov	di, 2
		push	di
		call	sub_FF14A
		add	sp, 2
		lea	di, [bp+var_6]
		push	di
		call	PUTCHAR
		add	sp, 2
		and	word [ADDR_OFFSET], 0FFF0h
		mov	word [bp+var_C], 0
loc_FF863:
		call	MEM_READ8
		and	ax, 7Fh
		mov	byte [bp+var_A], al
		cmp	byte [bp+var_A], ' '
		jl	short loc_FF878
		cmp	byte [bp+var_A], '~'
		jle	short loc_FF87E
loc_FF878:
		lea	di, [bp+var_8]
		push	di
		jmp	short loc_FF882
loc_FF87E:
		lea	di, [bp+var_A]
		push	di
loc_FF882:
		call	PUTCHAR
		add	sp, 2
		inc	word [ADDR_OFFSET]
		inc	word [bp+var_C]
		cmp	word [bp+var_C], 0Fh
		jle	short loc_FF863
		lea	di, [bp+var_6]
		push	di
		call	PUTCHAR
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
PRINT_MEM_ADDR_sub_FF8A2:
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		mov	byte [bp+var_6], ':'
		call	sub_FF134
		push	word [ADDR_SEGMENT]
		call	PRINTHEX16
		add	sp, 2
		lea	di, [bp+var_6]
		push	di
		call	PUTCHAR
		add	sp, 2
		push	word [ADDR_OFFSET]
		call	PRINTHEX16
		add	sp, 2
		mov	di, 2
		push	di
		call	sub_FF14A
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
sub_FF8DC:
		push	bp
		mov	bp, sp
		push	di
		push	si
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		call	PARSE_ADDR_sub_FE96E
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
sub_FF8EE:
%define arg_0		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		push	word [bp+arg_0]
		call	READ_MEM_ADDR_sub_FE9D8
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
sub_FF906:
%define arg_0		4 ; = word ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		call	GETCHAR_ECHO
		mov	[CHAR_BUF], al
		push	word [bp+arg_0]
		call	sub_FEA94
		add	sp, 2
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
M_HEX_DOWNLOAD:
%define var_16		-16h ; = byte ptr -16h
%define var_14		-14h ; = word ptr -14h
%define var_12		-12h ; = byte ptr -12h
%define var_10		-10h ; = byte ptr -10h
%define var_E		-0Eh ; = word ptr -0Eh
%define var_C		-0Ch ; = word ptr -0Ch
%define var_A		-0Ah ; = word ptr -0Ah
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 12h
		mov	byte [bp+var_A], ':'
		mov	byte [bp+var_C], 'E'
		mov	byte [bp+var_E], 'B'
		mov	byte [bp+var_10], 1
		mov	byte [bp+var_12], 0
		mov	byte [bp+var_16], 0
		mov	word [ADDR_SEGMENT], 0
		mov	word [ADDR_OFFSET], 0
		mov	al, [HEX_byte_4F8]
		cbw
		push	ax
		call	HEX_sub_FFA68
		add	sp, 2
		mov	di, STR_READY ; " Ready- "
		push	di
		call	PUTS
		add	sp, 2
		mov	word [HEX_word_EB8], 0Bh
		mov	di, DISK_DATA_BUF
		push	di
		push	word [HEX_word_EB8]
		mov	al, [HEX_byte_4F8]
		cbw
		push	ax
		call	SIO_RX
		add	sp, 6
		mov	word [HEX_word_EB4], 0
		mov	word [HEX_word_EB6], 0
		jmp	loc_FFA4E
loc_FF987:
		inc	word [HEX_word_EB6]
loc_FF98B:
		call	HEX_sub_FFB20
		mov	di, ax
		mov	al, byte [bp+var_A]
		cbw
		cmp	di, ax
		jnz	short loc_FF987
		lea	di, [bp+var_A]
		push	di
		call	PUTCHAR
		add	sp, 2
		mov	word [HEX_word_EBA], 0
		call	HEX_sub_FFAC6
		mov	[bp+var_12], al
		call	HEX_sub_FFB02
		mov	word [ADDR_OFFSET], ax
		call	HEX_sub_FFAC6
		mov	[bp+var_16], al
		cmp	byte [bp+var_16], 0
		jge	short loc_FF9C4
		mov	byte [bp+var_16], 0
loc_FF9C4:
		mov	al, [bp+var_12]
		cbw
		mov	di, ax
		mov	al, [bp+var_12]
		cbw
		add	di, ax
		add	di, 0Bh
		add	word [HEX_word_EB6], di
		mov	al, [bp+var_16]
		cbw
		cmp	ax, 3
		ja	short loc_FFA25
		shl	ax, 1
		xchg	ax, bx
		; jmp	off_FFA31[cs:bx] ; <--- bad yasm CS
		cs jmp	off_FFA31[bx]
loc_FF9E8:
		mov	word [bp+var_14], 1
loc_FF9ED:
		mov	al, [bp+var_12]
		cbw
		cmp	ax, [bp+var_14]
		jl	short loc_FFA39
		call	HEX_sub_FFAC6
		push	ax
		call	MEM_WRITE8
		add	sp, 2
		inc	word [ADDR_OFFSET]
		inc	word [bp+var_14]
		jmp	short loc_FF9ED
loc_FFA09:
		mov	byte [bp+var_10], 0
		jmp	short loc_FFA39
loc_FFA0F:
		call	HEX_sub_FFB02
		mov	word [ADDR_SEGMENT], ax
		jmp	short loc_FFA39
loc_FFA17:
		call	HEX_sub_FFB02
		mov	[SAVED_CPU_REGS+CPU_REGS.CS], ax
		call	HEX_sub_FFB02
		mov	[SAVED_CPU_REGS+CPU_REGS.IP], ax
		jmp	short loc_FFA39
loc_FFA25:
		lea	di, [bp+var_E]
		push	di
		call	PUTCHAR
		add	sp, 2
		jmp	short loc_FFA39
off_FFA31	dw loc_FF9E8
		dw loc_FFA09
		dw loc_FFA0F
		dw loc_FFA17
loc_FFA39:
		call	HEX_sub_FFAC6
		test	word [HEX_word_EBA], 0FFh
		jz	short loc_FFA4E
		lea	di, [bp+var_C]
		push	di
		call	PUTCHAR
		add	sp, 2
loc_FFA4E:
		cmp	byte [bp+var_10], 0
		jz	short loc_FFA57
		jmp	loc_FF98B
loc_FFA57:
		mov	di, STR_DONE ; " -Done"
		push	di
		call	PUTS
		add	sp, 2
		call	PRINT_REGS
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
HEX_sub_FFA68:
%define arg_0		4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		push	di
		push	si
		jmp	short loc_FFA7A
loc_FFA6F:
		mov	al, [bp+arg_0]
		cbw
		push	ax
		call	SIO_GETC
		add	sp, 2
loc_FFA7A:
		mov	al, [CHAR_BUF]
		cbw
		push	ax
		mov	di, 0FFFFh
		push	di
		mov	al, [bp+arg_0]
		cbw
		push	ax
		call	SIO_RX
		add	sp, 6
		test	ax, ax
		jnz	short loc_FFA6F
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
IN8:
%define IO_PORT		4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		mov	dx, word [bp+IO_PORT]
		in	al, dx
		pop	bp
		retn

;------------------------------------------------------------------------
IN16:
%define IO_PORT		4 ; = byte ptr	4
		push	bp
		mov	bp, sp
		mov	dx, word [bp+IO_PORT]
		in	ax, dx
		pop	bp
		retn

;------------------------------------------------------------------------
OUT8:
%define IO_PORT		4 ; = word ptr	4
%define IO_VAL		6 ; = byte ptr	6
		push	bp
		mov	bp, sp
		mov	dx, [bp+IO_PORT]
		mov	al, [bp+IO_VAL]
		out	dx, al
		pop	bp
		retn

;------------------------------------------------------------------------
OUT16:
%define IO_PORT		4 ; = word ptr	4
%define IO_VAL		6 ; = byte ptr	6
		push	bp
		mov	bp, sp
		mov	dx, [bp+IO_PORT]
		mov	ax, word [bp+IO_VAL]
		out	dx, ax
		pop	bp
		retn

;------------------------------------------------------------------------
NEW_COMMAND:
		inc	byte [NEW_CMD_REG]
		retn

;------------------------------------------------------------------------
HEX_sub_FFAC6:
%define var_A		-0Ah ; = word ptr -0Ah
%define var_8		-8 ; = word ptr -8
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		call	HEX_sub_FFB20
		mov	[bp+var_8], ax
		call	HEX_sub_FFB20
		mov	[bp+var_A], ax
		lea	di, [bp+var_6]
		push	di
		push	ax
		push	word [bp+var_8]
		call	HEX_sub_FFB84
		add	sp, 6
		test	ax, ax
		jz	short loc_FFAF9
		mov	di, [bp+var_6]
		and	di, 0FFh
		add	word [HEX_word_EBA], di
		jmp	short loc_FFAFC
loc_FFAF9:
		call	ERR_BEEP
loc_FFAFC:
		mov	ax, [bp+var_6]
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
HEX_sub_FFB02:
%define var_6		-6 ; = word ptr -6
%define var_6 -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 2
		call	HEX_sub_FFAC6
		mov	cx, 8
		shl	ax, cl
		push	ax
		call	HEX_sub_FFAC6
		pop	bx
		add	ax, bx
		mov	[bp+var_6], ax
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
HEX_sub_FFB20:
%define var_6		-6 ; = word ptr -6
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		mov	di, [HEX_word_EB8]
		cmp	word [HEX_word_EB4], di
		jb	short loc_FFB6F
		cmp	word [HEX_word_EB6], 300
		jbe	short loc_FFB48
		mov	word [HEX_word_EB8], 300
		sub	word [HEX_word_EB6], 300
		jmp	short loc_FFB56
loc_FFB48:
		mov	di, [HEX_word_EB6]
		mov	word [HEX_word_EB8], di
		mov	word [HEX_word_EB6], 0
loc_FFB56:
		mov	di, DISK_DATA_BUF
		push	di
		push	word [HEX_word_EB8]
		mov	al, [HEX_byte_4F8]
		cbw
		push	ax
		call	SIO_RX
		add	sp, 6
		mov	word [HEX_word_EB4], 0
loc_FFB6F:
		mov	bx, [HEX_word_EB4]
		mov	al, DISK_DATA_BUF[bx]
		and	ax, 7Fh
		mov	[bp+var_6], ax
		inc	word [HEX_word_EB4]
		jmp	word FUNCTION_RETURN ; eh

;------------------------------------------------------------------------
HEX_sub_FFB84:
%define var_A		-0Ah ; = word ptr -0Ah
%define var_8		-8 ; = word ptr -8
%define var_6		-6 ; = byte ptr -6
%define arg_0		4 ; = byte ptr	4
%define arg_2		6 ; = byte ptr	6
%define arg_4		8 ; = word ptr	8
		push	bp
		mov	bp, sp
		push	di
		push	si
		sub	sp, 6
		mov	byte [bp+var_6], 1
		lea	di, [bp+var_8]
		push	di
		mov	al, [bp+arg_0]
		cbw
		push	ax
		call	PARSE_HEX_sub_FF6BA
		add	sp, 4
		mov	[bp+var_6], al
		cmp	byte [bp+var_6], 0
		jz	short loc_FFBBB
		lea	di, [bp+var_A]
		push	di
		mov	al, [bp+arg_2]
		cbw
		push	ax
		call	PARSE_HEX_sub_FF6BA
		add	sp, 4
		test	ax, ax
		jnz	short loc_FFBBF
loc_FFBBB:
		sub	di, di
		jmp	short loc_FFBC2
loc_FFBBF:
		mov	di, 1
loc_FFBC2:
		mov	dx, di
		mov	[bp+var_6], dl
		mov	bx, [bp+arg_4]
		mov	al, byte [bp+var_8]
		cbw
		mov	cx, 4
		shl	ax, cl
		mov	dx, ax
		mov	al, byte [bp+var_A]
		cbw
		add	dx, ax
		mov	[bx], dl
		mov	al, [bp+var_6]
		cbw
		jmp	FUNCTION_RETURN

;------------------------------------------------------------------------
; Restore previous stack frame.						:
;------------------------------------------------------------------------
FUNCTION_RETURN:
		lea	sp, [bp-4]
		pop	si
		pop	di
		pop	bp
		retn

;------------------------------------------------------------------------
; Not used anywhere.							:
;------------------------------------------------------------------------
NOTHING:
		push	bp
		mov	bp, sp
		push	di
		push	si
		jmp	word FUNCTION_RETURN

		dw 0FEEBh
		dw 0FEEBh
		dw 0FEEBh
ROM_DATA:

;========================================================================
section .data vstart=410h align=1
RAM_DATA:

SCB istruc I8089_SCB
	at I8089_SCB.SOC,	db 1
	at I8089_SCB.UNUSED1,	db 0
	at I8089_SCB.CB_OFF,	dw 0
	at I8089_SCB.CB_SEG,	dw 40h
iend

FW_REG		db 0	; SYS - Firmware Version Register
SYS_CMD_REG	db 0	; SYS - Firmware Version Register
SYS_STAT_REG	db 0	; SYS - System Status Register
INT_VECTOR_REG	dw 0	; SYS - Interrupt Vector Register
NEW_CMD_REG	db 0	; SYS - New Command Register

SIO_CHAN_0 istruc SIO_REGS
	at SIO_REGS.PARM,	dw 0FEB4h
	at SIO_REGS.STAT,	dw 0
	at SIO_REGS.CMD,	db 0
	at SIO_REGS.TX_LO,	db 0
	at SIO_REGS.TX_HI,	dw 0
	at SIO_REGS.TX_LEN,	dw 0
	at SIO_REGS.RX_LO,	dw SIO_0_RX_BUF
	at SIO_REGS.RX_HI,	db 0
	at SIO_REGS.RX_LEN,	dw SIO_0_RX_LEN
	at SIO_REGS.RX_IN,	dw 0
	at SIO_REGS.RX_OUT,	dw 0
	at SIO_REGS.RATE,	dw 0
	at SIO_REGS.RESERVED,	db 0
iend

SIO_CHAN_1 istruc SIO_REGS
	at SIO_REGS.PARM,	dw 0FEB4h
	at SIO_REGS.STAT,	dw 0
	at SIO_REGS.CMD,	db 0
	at SIO_REGS.TX_LO,	db 0
	at SIO_REGS.TX_HI,	dw 0
	at SIO_REGS.TX_LEN,	dw 0
	at SIO_REGS.RX_LO,	dw SIO_1_RX_BUF
	at SIO_REGS.RX_HI,	db 0
	at SIO_REGS.RX_LEN,	dw SIO_1_RX_LEN
	at SIO_REGS.RX_IN,	dw 0
	at SIO_REGS.RX_OUT,	dw 0
	at SIO_REGS.RATE,	dw 0
	at SIO_REGS.RESERVED,	db 0
iend

SIO_CHAN_2 istruc SIO_REGS
	at SIO_REGS.PARM,	dw 0F7B4h
	at SIO_REGS.STAT,	dw 0
	at SIO_REGS.CMD,	db 0
	at SIO_REGS.TX_LO,	db 0
	at SIO_REGS.TX_HI,	dw 0
	at SIO_REGS.TX_LEN,	dw 0
	at SIO_REGS.RX_LO,	dw SIO_2_RX_BUF
	at SIO_REGS.RX_HI,	db 0
	at SIO_REGS.RX_LEN,	dw SIO_2_RX_LEN
	at SIO_REGS.RX_IN,	dw 0
	at SIO_REGS.RX_OUT,	dw 0
	at SIO_REGS.RATE,	dw 0
	at SIO_REGS.RESERVED,	db 0
iend

istruc SIO_REGS
	at SIO_REGS.PARM,	dw 0FAB4h
	at SIO_REGS.STAT,	dw 0
	at SIO_REGS.CMD,	db 0
	at SIO_REGS.TX_LO,	db 0
	at SIO_REGS.TX_HI,	dw 0
	at SIO_REGS.TX_LEN,	dw 0
	at SIO_REGS.RX_LO,	dw SIO_3_RX_BUF
	at SIO_REGS.RX_HI,	db 0
	at SIO_REGS.RX_LEN,	dw SIO_3_RX_LEN
	at SIO_REGS.RX_IN,	dw 0
	at SIO_REGS.RX_OUT,	dw 0
	at SIO_REGS.RATE,	dw 0
	at SIO_REGS.RESERVED,	db 0
iend

istruc SIO_REGS
	at SIO_REGS.PARM,	dw 0F796h
	at SIO_REGS.STAT,	dw 0
	at SIO_REGS.CMD,	db 0
	at SIO_REGS.TX_LO,	db 0
	at SIO_REGS.TX_HI,	dw 0
	at SIO_REGS.TX_LEN,	dw 0
	at SIO_REGS.RX_LO,	dw SIO_4_RX_BUF
	at SIO_REGS.RX_HI,	db 0
	at SIO_REGS.RX_LEN,	dw SIO_4_RX_LEN
	at SIO_REGS.RX_IN,	dw 0
	at SIO_REGS.RX_OUT,	dw 0
	at SIO_REGS.RATE,	dw 0
	at SIO_REGS.RESERVED,	db 0
iend

istruc SIO_REGS
	at SIO_REGS.PARM,	dw 0FEB4h
	at SIO_REGS.STAT,	dw 0
	at SIO_REGS.CMD,	db 0
	at SIO_REGS.TX_LO,	db 0
	at SIO_REGS.TX_HI,	dw 0
	at SIO_REGS.TX_LEN,	dw 0
	at SIO_REGS.RX_LO,	dw SIO_5_RX_BUF
	at SIO_REGS.RX_HI,	db 0
	at SIO_REGS.RX_LEN,	dw SIO_5_RX_LEN
	at SIO_REGS.RX_IN,	dw 0
	at SIO_REGS.RX_OUT,	dw 0
	at SIO_REGS.RATE,	dw 0
	at SIO_REGS.RESERVED,	db 0
iend

FDC_CHAN istruc FDC_REGS
	at FDC_REGS.COMMAND,		db 0
	at FDC_REGS.STATUS,		db 0
	at FDC_REGS.QUEUE_ADDR_LO,	dw 0
	at FDC_REGS.QUEUE_ADDR_HI,	db 0
	at FDC_REGS.QUEUE_LEN,		db 2
	at FDC_REGS.QUEUE_END,		db 0
	at FDC_REGS.QUEUE_NEXT,		db 0
	at FDC_REGS.UNUSED1,		db 0
	at FDC_REGS.UNUSED2,		db 0
	at FDC_REGS.PARAMS_1
		db 0, 2, 0, 2, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	at FDC_REGS.PARAMS_2
		db 0, 2, 0, 2, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
iend

; What is this? Nobody knows.
db 11h, 11h, 11h, 11h
db 22h, 22h, 22h, 22h, 22h, 22h

INIT_REG_PTR		dd 1FFF000Ch
HEX_byte_4F8		db 1
STR_VERSION_BANNER	db "                             ",0Ah
			db "Monitor Version V1.3",0
STR_POST_GOOD		db 0Ah,"PASSED POWER-UP TEST",0
STR_POST_FAILED		db 0Ah,"FAILED POWER-UP TEST "
HEX_BUF_FOR_POST_NUMBER	db    0
			db    0
HEX_NUMS		db "0", "1", "2", "3", "4", "5", "6", "7"
			db "8", "9", "A", "B", "C", "D", "E", "F",0
			db    0
STR_BOOT_FAILED		db 0Ah,"Boot Failed, Status=",0
STR_ERR_BEEP		db "*",7," ",0
STR_BREAK		db 0Ah
			db "Break ....",0
REG_NAMES		db "AX", "BX", "CX", "DX", "SI", "DI"
			db "DS", "ES", "SS", "SP", "BP", "FL"
STR_BOOT_INTERRUPT	db 0Ah,"Press any key to interrupt boot",0Ah,0
STR_BOOT_HDD		db 0Ah,"Booting from Hard Disk",0
STR_BOOT_PROMPT		db 0Ah
			db "Enter [1] to boot from Hard Disk",0Ah
			db "Enter [2] to boot from Floppy Disk",0Ah
			db "Enter [3] to enter Monitor",0Ah
			db 0Ah
			db "Enter option: ",0
STR_MONITOR_PROMPT	db 0Ah,"< A, B, D, G, I, K, L, M, O, R, S, X > ",0
			db    0
CHR_SPACE		db " ",0
CHR_DASH_0		db "-",0
CHR_COLON		db ":",0
CHR_DASH_1		db "-",0
STR_FLAG_NAMES		db "    ODITSZ A P C",0
			db    0
STR_REG_CS_IP		db 0Ah,"CS:IP ",0
STR_REG_FLAGS		db "  Flags  ",0
REG_DISP_OFFSETS	db 0, 2, 4, 6, 9, 11, 13, 15, 18
			db 20, 22, 24, 27, 29, 31, 33
STR_READY		db " Ready- ",0
STR_DONE		db " -Done",0

;========================================================================
section .bss vfollows=.data align=1

DISK_DATA_BUF	times 512 db ?
byte_8CA	db ?
byte_8CB	db ?
word_8CC	dw ?
word_8CE	times 17h dw ?
FDC_QUEUE	dw ?
		dw ?

SIO_TX_BUFS:
	times SIO_TX_LEN*6 db ?
SIO_0_RX_BUF:
	times SIO_0_RX_LEN db ?
SIO_1_RX_BUF:
	times SIO_1_RX_LEN db ?
SIO_2_RX_BUF:
	times SIO_2_RX_LEN db ?
SIO_3_RX_BUF:
	times SIO_3_RX_LEN db ?
SIO_4_RX_BUF:
	times SIO_4_RX_LEN db ?
SIO_5_RX_BUF:
	times SIO_5_RX_LEN db ?

HEX_word_EB4	dw ?
HEX_word_EB6	dw ?
HEX_word_EB8	dw ?
HEX_word_EBA	dw ?
CHAR_BUF	db ?
SAVED_SS	dw ?
SAVED_SP	dw ?
SAVED_ES	dw ?	; Saved on syscall entry
MEM_SIZE	dw ?
unk_EC5		db ?
WHATS_CB_SEG	db ?
POST_RESULT	db ?
BOOT_DISK_CODE	db ?	; 1 = HDD, 2 = FDD

SAVED_CPU_REGS istruc CPU_REGS
	at CPU_REGS.AX,		dw ?
	at CPU_REGS.BX,		dw ?
	at CPU_REGS.CX,		dw ?
	at CPU_REGS.DX,		dw ?
	at CPU_REGS.SI,		dw ?
	at CPU_REGS.DI,		dw ?
	at CPU_REGS.DS,		dw ?
	at CPU_REGS.ES,		dw ?
	at CPU_REGS.SS,		dw ?
	at CPU_REGS.SP,		dw ?
	at CPU_REGS.BP,		dw ?
	at CPU_REGS.FLAGS,	dw ?
	at CPU_REGS.IP,		dw ?
	at CPU_REGS.CS,		dw ?
iend

ADDR_SEGMENT	dw ?
ADDR_OFFSET	dw ?

IOP_BLOCK istruc I8089_PB
	at I8089_PB.IOP_OFFSET,		dw ?
	at I8089_PB.IOP_SEGMENT,	dw ?
	at I8089_PB.HDD_OPCODE,		db ?
	at I8089_PB.HDD_STATUS,		db ?
	at I8089_PB.HDD_CYLINDER,	dw ?
	at I8089_PB.HDD_DRIVE_AND_HEAD,	db ?
	at I8089_PB.HDD_SECTOR,		db ?
	at I8089_PB.HDD_SECTOR_LEN,	dw ?
	at I8089_PB.HDD_DMA_OFFSET,	dw ?
	at I8089_PB.HDD_DMA_SEGMENT,	dw ?
	at I8089_PB.RESVD_0,		dw ?
	at I8089_PB.RESVD_1,		dw ?
	at I8089_PB.RESVD_2,		dw ?
	at I8089_PB.RESVD_3,		dw ?
	at I8089_PB.RESVD_4,		dw ?
iend

DISK_IOPB istruc IOPB
	at IOPB.MON_RSVD_1,		dw ?
	at IOPB.MON_RSVD_2,		dw ?
	at IOPB.DISK_OPCODE,		db ?
	at IOPB.DISK_DRIVE_NUM,		db ?
	at IOPB.DISK_TRACK,		dw ?
	at IOPB.DISK_HEAD,		db ?
	at IOPB.DISK_SECTOR,		db ?
	at IOPB.DISK_SECTOR_COUNT,	db ?
	at IOPB.DISK_OP_STATUS,		db ?
	at IOPB.UNK,			db ?
	at IOPB.DISK_RETRIES,		db ?
	at IOPB.DISK_DMA_OFFSET,	dw ?
	at IOPB.DISK_DMA_SEGMENT,	dw ?
	at IOPB.DISK_SECTOR_LEN,	dw ?
iend
			db ?
GETCHAR_ECHO_BUF	dw ?
PRINTHEX_unk_F1A	db ?
			db ?
PRINTHEX_unk_F1C	db ?

;========================================================================
section .iop follows=.data align=1
IOPB_BLOCK:
db 051h, 030h, 0D0h, 0FFh		;         movi	gc,0ffd0h
db 0AAh, 0BBh, 004h, 020h		;         jnbt	[pp].4h,5,x1ee2
db 00Ah, 04Eh, 006h, 080h		;         movbi	[gc].6h,80h
db 002h, 093h, 008h, 002h, 0CEh, 002h	;         movb	[gc].2h,[pp].8h
db 0EAh, 0BAh, 006h, 0FCh		; x1ecc:  jnbt	[gc].6h,7,x1ecc
db 00Ah, 04Eh, 006h, 020h		;         movbi	[gc].6h,20h
db 013h, 04Fh, 014h, 000h, 000h		;         movi	[pp].14h,0h
db 00Ah, 0BEh, 006h, 0FCh		; x1ed9:  jbt	[gc].6h,0,x1ed9
db 012h, 0BAh, 004h, 0E2h, 000h		;         ljnbt [gc].4h,0,x1fc4
db 00Ah, 0CBh, 004h, 00Fh		; x1ee2:  andbi	[pp].4h,0fh
db 012h, 0E7h, 004h, 0B1h, 000h		;         ljzb	[pp].4h,x1f9c
db 002h, 093h, 008h, 002h, 0CEh, 002h	;         movb	[gc].2h,[pp].8h
db 0EAh, 0BAh, 006h, 0FCh		; x1ef1:  jnbt	[gc].6h,7,x1ef1
db 002h, 093h, 014h, 000h, 0CEh		;         movb	[gc],[pp].14h
db 002h, 093h, 015h, 000h, 0CEh		;         movb	[gc],[pp].15h
db 002h, 093h, 006h, 002h, 0CEh, 004h	;         movb	[gc].4h,[pp].6h
db 002h, 093h, 007h, 002h, 0CEh, 004h	;         movb	[gc].4h,[pp].7h
db 00Ah, 04Eh, 006h, 010h		;         movbi	[gc].6h,10h
db 003h, 093h, 006h, 003h, 0CFh, 014h	;         mov   [pp].14h,[pp].6h
db 00Ah, 0BEh, 006h, 0FCh		; x1f15:  jbt	[gc].6h,0,x1f15
db 02Ah, 0BAh, 004h, 0FCh		; x1f19:  jnbt	[gc].4h,1,x1f19
db 00Ah, 0E7h, 010h, 07Bh		;         jzb	[pp].10h,x1f9c
db 00Ah, 0BFh, 004h, 00Eh		;         jbt	[pp].4h,0,x1f33
db 003h, 08Bh, 00Ch			;         lpd	ga,[pp].0ch
db 031h, 030h, 000h, 000h 		;         movi  gb,0h
db 063h, 083h, 00Ah			;         mov	bc,[pp].0ah
db 08Bh, 09Fh, 016h, 070h		;         call	[pp].16h,x1fa3
db 031h, 030h, 000h, 000h 		; x1f33:  movi  gb,0h
db 0F1h, 030h, 080h, 0FEh		;         movi	mc,0fe80h
db 011h, 030h, 0D0h, 0FFh		;         movi	ga,0ffd0h
db 013h, 04Fh, 012h, 000h, 002h		;         movi	[pp].12h,200h
db 00Ah, 0BBh, 004h, 012h		;         jnbt	[pp].4h,0,x1f5a
db 0D1h, 030h, 028h, 08Ah		;         movi	cc,8a28h
db 0A0h, 000h				;         wid	8,16
db 06Ah, 0BBh, 004h, 017h		;         jnbt	[pp].4h,3,x1f69
db 013h, 04Fh, 012h, 005h, 002h		;         movi	[pp].12h,205h
db 088h, 020h, 00Fh			;         jmp	x1f69
db 0D1h, 030h, 028h, 056h		; x1f5a:  movi	cc,5628h
db 0C0h, 000h				;         wid	16,8
db 04Ah, 0BBh, 004h, 005h		;         jnbt	[pp].4h,2,x1f69
db 013h, 04Fh, 012h, 004h, 000h		;         movi	[pp].12h,4h
db 063h, 083h, 012h			; x1f69:  mov	bc,[pp].12h
db 002h, 093h, 009h, 000h, 0CEh		;         movb	[gc],[pp].9h
db 060h, 000h				;         xfer
db 002h, 093h, 004h, 002h, 0CEh, 006h	;         movb	[gc].6h,[pp].4h
db 00Ah, 0B6h, 006h, 033h		;         jmcne	[gc].6h,x1fb0
db 002h, 0EFh, 010h			;         decb	[pp].10h
db 00Ah, 0E7h, 010h, 006h		;         jzb	[pp].10h,x1f8a
db 002h, 0EBh, 009h			;         incb	[pp].9h
db 088h, 020h, 0DFh			;         jmp	x1f69
db 00Ah, 0BBh, 004h, 00Eh		; x1f8a:  jnbt	[pp].4h,0,x1f9c
db 023h, 08Bh, 00Ch			;         lpd	gb,[pp].0ch
db 011h, 030h, 000h, 000h 		;         movi  ga,0h
db 063h, 083h, 00Ah			;         mov	bc,[pp].0ah
db 08Bh, 09Fh, 016h, 007h		;         call	[pp].16h,x1fa3
db 00Ah, 04Fh, 005h, 000h		; x1f9c:  movbi	[pp].5h,0h
db 088h, 020h, 026h			;         jmp	x1fc9
db 0E0h, 000h				; x1fa3:  wid	16,16
db 0D1h, 030h, 008h, 0C2h		;         movi	cc,0c208h
db 060h, 000h				;         xfer
db 000h, 000h				;         nop
db 083h, 08Fh, 016h			;         movp	tp,[pp].16h
db 002h, 092h, 006h, 002h, 0CFh, 005h	; x1fb0:  movb	[pp].5h,[gc].6h
db 00Ah, 0CBh, 005h, 07Eh		;         andbi	[pp].5h,7eh
db 0E2h, 0F7h, 005h			;         setb	[pp].5h,7
db 00Ah, 04Eh, 006h, 000h		;         movbi	[gc].6h,0h
db 088h, 020h, 005h			;         jmp	x1fc9
db 013h, 04Fh, 005h, 081h, 000h		; x1fc4:  movi	[pp].5h,81h
db 040h, 000h				; x1fc9:  sintr
db 020h, 048h				;         hlt

;========================================================================
section .tail start=ROMLEN-22 align=1
		dw 1EC8h
		dw ROMSEG

;========================================================================
section .entry vstart=0fff0h start=ROMLEN-16
ENTRY		jmp    ROMSEG:POST

		times 6-($-$$) db 0
SCP		istruc I8089_SCP
			at I8089_SCP.BUS_TYPE,	db 1 ; 1 = 16-bit, 0 = 8-bit
			at I8089_SCP.UNUSED0,	db 0FFh,
			at I8089_SCP.SCB_OFF,	dw SCB
			at I8089_SCP.SCB_SEG,	dw 0
		iend

		times 0eh-($-$$) db 0
		db 0FFh
CHECKSUM	db 0C4h
