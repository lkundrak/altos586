;------------------------------------------------------------------------
; These are addresses in 8089's I/O space.				:
;------------------------------------------------------------------------

HDD_SRAM_ADDR	EQU 00000H
LOADER_OFFSET	EQU 00400H
HDD_REGS_ADDR	EQU 0FFD0H

;------------------------------------------------------------------------
; Registers at HDD_REGS_ADDR.						:
;------------------------------------------------------------------------

REG_DATA	EQU 00H
REG_DRV_HD	EQU 02H
REG_CYL_SK	EQU 04H	; Write cylinder, read seek status
REG_CMD_STAT	EQU 06H	; Write command, read op status
REG_28H		EQU 28H

;------------------------------------------------------------------------
; Parameter Block							:
;------------------------------------------------------------------------

PB		STRUC
PB_TB:		DS 4
PB_IN1_ADDR:	DS 4	; Offset:Segment of first command block
PB_IN2_ADDR:	DS 4	; Offset:Segment of second command block
PB_OUT1_ADDR:	DS 4	; Offset:Segment of first result block
PB_OUT2_ADDR:	DS 4	; Offset:Segment of second result block
PB		ENDS

;;.bp
;------------------------------------------------------------------------
; Command Block.							:
;------------------------------------------------------------------------

CB		STRUC
CB_OP:		DS 1
CB_STAT:	DS 1
CB_CYL_LO:	DS 1
CB_CYL		EQU CB_CYL_LO
CB_CYL_HI:	DS 1
CB_DRV_HD:	DS 1
CB_SEC:		DS 1
CB_LEN:		DS 2
CB_BUF_ADDR:	DS 4
CB_REG_28H:	DS 1
CB_NUM_SECS:	DS 1
CB_RETRIES:	DS 1
		DS 1
CB_SIZE:
CB		ENDS

;------------------------------------------------------------------------
; Value following the Command Block in the Working Area.		:
;------------------------------------------------------------------------
WA		STRUC
		DS CB_SIZE
WA_CUR_CYL:	DS 2
WA_CB_ADDR:	DS 4	; Original address of this CB
WA_LINK:	DS 4
WA_LINK1:	DS 4
WA_XFER_LEN:	DS 2
WA_TMP_CMD:	DS 1
WA_CUR_DRV_HD:	DS 1
WA_LINK2:	DS 4
WA_ERR_TRIES:	DS 1
WA_ERR_SEC:	DS 1
WA_SIZE:
WA		ENDS

;------------------------------------------------------------------------
; Bits of CB_OP.							:
;------------------------------------------------------------------------

OP_BIT_RD	EQU 0	; Read (0) or write (1)
OP_BIT_FMT	EQU 2	; Format
OP_BIT_ECC	EQU 3	; Include the ECC bits on read
OP_BIT_SEL	EQU 5	; Drive/Head has changed
OP_BIT_UNK6	EQU 6
OP_BIT_UNK7	EQU 7
;;OP_CMD_BITS	EQU 0FH

;; Bits of IOPB_STATUS
;;STATUS_BIT_ERR	EQU 7

;;.bp
;------------------------------------------------------------------------
; The entry point.							:
;------------------------------------------------------------------------

CODE:
		lpd	ga,[pp].PB_IN1_ADDR
		jzb	[ga].CB_OP,CH1_CHECKED
		movi	gb,WA1
		movi	gc,WA1
		lcall	[gc].WA_LINK,COPY_CB
CH1_CHECKED:

		lpd	ga,[pp].PB_IN2_ADDR
		jzb	[ga].CB_OP,CH2_CHECKED
		movi	gb,WA2
		movi	gc,WA2
		lcall	[gc].WA_LINK,COPY_CB
CH2_CHECKED:

		movi	ga,HDD_REGS_ADDR

		movi	gc,WA1
		jzb	[gc].CB_OP,CH1_SEEKED
		lcall	[gc].WA_LINK,SET_TRACK
		jnbt	[gc].CB_OP,OP_BIT_SEL,SEEK_CH1
		lcall	[gc].WA_LINK1,SEL_DRIVE
		jmp	CH1_SEEKED
SEEK_CH1:	lcall	[gc].WA_LINK1,SEEK_TO_CYL
CH1_SEEKED:

		movi	gc,WA2
		jzb	[gc].CB_OP,CH2_SEEKED
		lcall	[gc].WA_LINK,SET_TRACK
		jnbt	[gc].CB_OP,OP_BIT_SEL,SEEK_CH2
		lcall	[gc].WA_LINK1,SEL_DRIVE
		jmp	CH2_SEEKED
SEEK_CH2:	lcall	[gc].WA_LINK1,SEEK_TO_CYL
CH2_SEEKED:

		movi	gc,WA1
		jzb	[gc].CB_OP,CH1_DONE
		jbt	[gc].CB_OP,OP_BIT_SEL,CH1_OP_DONE
		lcall	[gc].WA_LINK,SET_TRACK
		jbt	[gc].CB_OP,OP_BIT_RD,CH1_WAIT_SEEK
		lcall	[gc].WA_LINK,COPY_FROM_DMA
CH1_WAIT_SEEK:	jnbt	[ga].REG_CYL_SK,1,CH1_WAIT_SEEK
		lcall	[gc].WA_LINK2,DO_DISK_CMD
		jnbt	[gc].CB_OP,OP_BIT_RD,CH1_OP_DONE
		lcall	[gc].WA_LINK,COPY_TO_DMA
CH1_OP_DONE:	movi	ga,WA1
		lpd	gb,[pp].PB_OUT1_ADDR
		lcall	[gc].WA_LINK,COPY_CB
CH1_DONE:

		movi	gc,WA2
		jzb	[gc].CB_OP,CH2_DONE
		jbt	[gc].CB_OP,OP_BIT_SEL,CH2_OP_DONE
		lcall	[gc].WA_LINK,SET_TRACK
		jbt	[gc].CB_OP,OP_BIT_RD,CH2_WAIT_SEEK
		lcall	[gc].WA_LINK,COPY_FROM_DMA
CH2_WAIT_SEEK:	jnbt	[ga].REG_CYL_SK,1,CH2_WAIT_SEEK
		lcall	[gc].WA_LINK2,DO_DISK_CMD
		jnbt	[gc].CB_OP,OP_BIT_RD,CH2_OP_DONE
		lcall	[gc].WA_LINK,COPY_TO_DMA
CH2_OP_DONE:	movi	ga,WA2
		lpd	gb,[pp].PB_OUT2_ADDR
		lcall	[gc].WA_LINK,COPY_CB
CH2_DONE:

		sintr
		hlt

;------------------------------------------------------------------------
; Transfer data between the controller SRAM buffer and the controller.	:
; Handles the situations when the transfer crosses track boundary too.	:
;------------------------------------------------------------------------

DO_DISK_CMD:	ljzb	[gc].CB_NUM_SECS,DISK_CMD_DONE
		movb	ix,[gc].CB_OP
		andi	ix,7h
		ljz	ix,DISK_CMD_DONE
		movbi	[gc].WA_ERR_SEC,0ffh
		movi	gb,HDD_SECTOR_BUF
		movi	[gc].WA_XFER_LEN,512
		jnbt	[gc].CB_OP,OP_BIT_RD,SETUP_WRITE
		movbi	[gc].WA_TMP_CMD,1h
		jnbt	[gc].CB_OP,OP_BIT_ECC,SETUP_READ
		movbi	[gc].WA_TMP_CMD,9h
		addi	[gc].WA_XFER_LEN,5h ; ECC

SETUP_READ:	movi	cc,8a28h
		wid	8,16
		jmp	SETUP_XFER

SETUP_WRITE:	movbi	[gc].WA_TMP_CMD,2h
		movi	cc,5628h
		wid	16,8
		jnbt	[gc].CB_OP,OP_BIT_FMT,SETUP_XFER
		movbi	[gc].WA_TMP_CMD,4h
		movi	[gc].WA_XFER_LEN,4h

SETUP_XFER:	movi	mc,0fe80h
DO_XFER:	movb	[ga],[gc].CB_SEC
		movp	[gc].WA_CB_ADDR,gb
		mov	bc,[gc].WA_XFER_LEN
		xfer
		movb	[ga].REG_CMD_STAT,[gc].WA_TMP_CMD
		jmcne	[ga].REG_CMD_STAT,DISK_OP_ERROR
		decb	[gc].CB_NUM_SECS
		jzb	[gc].CB_NUM_SECS,DISK_CMD_DONE

		; Next sector on same track
		incb	[gc].CB_SEC
		jnbt	[gc].CB_SEC,4,DO_XFER

		; Next head
		incb	[gc].CB_DRV_HD
		movb	mc,[gc].WA_CUR_DRV_HD
		ori	mc,0f00h
		jmce	[gc].CB_DRV_HD,NEXT_CYL
SECTOR_ZERO:	movb	[ga].REG_DRV_HD,[gc].CB_DRV_HD
		movbi	[gc].CB_SEC,0h
		jmp	SETUP_XFER

		; Next cylinder
NEXT_CYL:	inc	[gc].CB_CYL
		lcall	[gc].WA_LINK1,SEEK_TO_CYL
		andbi	[gc].CB_DRV_HD,0f0h
POLL_OP_SEEK:	jnbt	[ga].REG_CYL_SK,1,POLL_OP_SEEK
		jmp	SECTOR_ZERO
DISK_CMD_DONE:	jbt	[ga].REG_CMD_STAT,0,DISK_CMD_DONE
		movp	tp,[gc].WA_LINK2

;------------------------------------------------------------------------
; Retry on errors.							:
;------------------------------------------------------------------------

DISK_OP_ERROR:	jbt	[ga].REG_CMD_STAT,5,ERR_STATUS
		jbt	[ga].REG_CMD_STAT,1,ERR_STATUS
		jbt	[gc].CB_OP,OP_BIT_UNK6,NO_NEED_RECAL
		movb	mc,[gc].CB_SEC
		ori	mc,0ff00h
		jmce	[gc].WA_ERR_SEC,ERR_SEC_SET
		movb	[gc].WA_ERR_SEC,[gc].CB_SEC
		movbi	[gc].WA_ERR_TRIES,0h
ERR_SEC_SET:	jbt	[ga].REG_CMD_STAT,2,SKIP_RECAL
		jbt	[ga].REG_CMD_STAT,4,SKIP_RECAL
		jnzb	[gc].WA_ERR_TRIES,GIVE_UP

		; Seek to cylinder zero	to recalibrate
		movbi	[ga].REG_CYL_SK,0
		lcall	[gc].WA_LINK1,SEL_DRIVE
		lcall	[gc].WA_LINK1,SEEK_TO_CYL
POLL_RECAL:	jnbt	[ga].REG_CYL_SK,1,POLL_RECAL

		jmp	RECAL_DONE
SKIP_RECAL:	jbt	[gc].WA_ERR_TRIES,4,GIVE_UP
RECAL_DONE:	incb	[gc].CB_RETRIES
		incb	[gc].WA_ERR_TRIES
NO_NEED_RECAL:	movb	[gc].CB_STAT,[ga].REG_CMD_STAT
		andbi	[gc].CB_STAT,7eh
		movbi	[ga].REG_CMD_STAT,0h

		; Try again
		ljnbt	[gc].CB_OP,OP_BIT_UNK6,SETUP_XFER
GIVE_UP:	setb	[gc].CB_STAT,7
		movp	tp,[gc].WA_LINK2

;------------------------------------------------------------------------
; Communicate the error and cancel both channels.			:
;------------------------------------------------------------------------

ERR_STATUS:	movb	[gc].CB_STAT,[ga].REG_CMD_STAT
		ljmp	ERR_FINISH

;------------------------------------------------------------------------
; Copy the Command Block between the controller SRAM and main memory.	:
;------------------------------------------------------------------------

COPY_CB:	movp	[gc].WA_CB_ADDR,ga
		movi	bc,CB_SIZE
		call	[gc].WA_LINK1,MEMCPY_16
		movp	ga,[gc].WA_CB_ADDR
		movbi	[ga].CB_OP,0h
		movi	ga,HDD_REGS_ADDR
		jbt	[ga].REG_CMD_STAT,1,ERR_STATUS
		movp	tp,[gc].WA_LINK

;------------------------------------------------------------------------
; Copy a block of data (sector, CB) between main memory and SRAM.	:
;------------------------------------------------------------------------

MEMCPY_16:	wid	16,16
		movi	cc,0c008h
		xfer
		nop
		movp	tp,[gc].WA_LINK1

;------------------------------------------------------------------------
; Set head and a cylinder.						:
;------------------------------------------------------------------------

SET_TRACK:	movb	[ga].REG_DRV_HD,[gc].CB_DRV_HD
		movb	[ga].REG_CYL_SK,[gc].WA_CUR_CYL+0
		movb	[ga].REG_CYL_SK,[gc].WA_CUR_CYL+1
		movbi	[gc].CB_STAT,0h

		; Wait for bit 7 to come up for up to FFh attempts
		movi	bc,0h
POLL_TRK_SET:	dec	bc
		jz	bc,ERR_FINISH
		jnbt	[ga].REG_CMD_STAT,7,POLL_TRK_SET

		movp	tp,[gc].WA_LINK

;;.bp
;------------------------------------------------------------------------
; Seek to a cylinder.							:
;------------------------------------------------------------------------

SEEK_TO_CYL:	movb	[ga],[gc].WA_CUR_CYL+0
		movb	[ga],[gc].WA_CUR_CYL+1
		movb	[ga].REG_CYL_SK,[gc].CB_CYL_LO
		movb	[ga].REG_CYL_SK,[gc].CB_CYL_HI
		movbi	[ga].REG_CMD_STAT,10h
		mov	[gc].WA_CUR_CYL,[gc].CB_CYL
POLL_SEEK:	jbt	[ga].REG_CMD_STAT,0,POLL_SEEK
		movp	tp,[gc].WA_LINK1

;------------------------------------------------------------------------
; Select a disk drive unit.						:
;------------------------------------------------------------------------

SEL_DRIVE:	movbi	[ga].REG_CMD_STAT,80h
		movbi	[gc].CB_STAT,0h
		jnbt	[gc].CB_OP,OP_BIT_UNK7,NO_BIT_7
		movb	[gc].WA_CUR_DRV_HD,[gc].CB_DRV_HD
NO_BIT_7:	movb	[ga].REG_DRV_HD,[gc].CB_DRV_HD

		; Wait for bit 7 to come up for up to FFh attempts
		movi	bc,0h
POLL_STAT_7:	dec	bc
		jz	bc,ERR_FINISH
		jnbt	[ga].REG_CMD_STAT,7,POLL_STAT_7

		movbi	[ga].REG_CMD_STAT,20h
		movi	[gc].WA_CUR_CYL,0h
POLL_SEL:	jbt	[ga].REG_CMD_STAT,0,POLL_SEL
		movp	tp,[gc].WA_LINK1

;------------------------------------------------------------------------
; Indicate errors in both channels.					:
;------------------------------------------------------------------------

ERR_FINISH:	movi	ga,WA1
		orbi	[ga].CB_STAT,81h
		lpd	gb,[pp].PB_OUT1_ADDR
		lcall	[gc].WA_LINK,COPY_CB

		movi	ga,WA2
		orbi	[ga].CB_STAT,81h
		lpd	gb,[pp].PB_OUT2_ADDR
		lcall	[gc].WA_LINK,COPY_CB

		sintr
		hlt

;;.bp
;------------------------------------------------------------------------
; Copy data indicated by CB from main memory to controller SRAM.	:
;------------------------------------------------------------------------

COPY_FROM_DMA:	jz	[gc].CB_LEN,COPIED_IN
		setb	[gc].CB_REG_28H,4
		movb	[ga].REG_28H,[gc].CB_REG_28H

		; Copy from DMA buffer to sector buf
		lpd	ga,[gc].CB_BUF_ADDR
		movi	gb,HDD_SECTOR_BUF
		mov	bc,[gc].CB_LEN
		lcall	[gc].WA_LINK1,MEMCPY_16

		movi	ga,HDD_REGS_ADDR
		movbi	[ga].REG_28H,10h
		ljbt	[ga].REG_CMD_STAT,1,ERR_STATUS
COPIED_IN:	movp	tp,[gc].WA_LINK

;------------------------------------------------------------------------
; Copy data indicated by CB to main memory from controller SRAM.	:
;------------------------------------------------------------------------

COPY_TO_DMA:	jz	[gc].CB_LEN,COPIED_OUT
		setb	[gc].CB_REG_28H,4
		movb	[ga].REG_28H,[gc].CB_REG_28H

		; Copy sector buf to DMA buffer
		lpd	gb,[gc].CB_BUF_ADDR
		movi	ga,HDD_SECTOR_BUF
		mov	bc,[gc].CB_LEN
		lcall	[gc].WA_LINK1,MEMCPY_16

		movi	ga,HDD_REGS_ADDR
		movbi	[ga].REG_28H,10h
COPIED_OUT:	movp	tp,[gc].WA_LINK

;------------------------------------------------------------------------
; Command block copies and sector data copies in controller SRAM.	:
;------------------------------------------------------------------------

WA1:		DS WA_SIZE
WA2:		DS WA_SIZE
HDD_SECTOR_BUF:

;;.bp
		; Pad the loader to 0400h
		DS LOADER_OFFSET-HDD_SECTOR_BUF

;------------------------------------------------------------------------
; The bootstrap routine. Copies the IOP to controller SRAM so that it	:
; can be executed without main memory contention.			:
;------------------------------------------------------------------------

LOADER:
		lpd	gc,[pp] ; [pp].PB_TB
		lpd	ga,[pp] ; [pp].PB_TB
		movi	gb,HDD_SRAM_ADDR

		; Move 400 bytes back to set BC=IOP base
		movi	bc,LOADER
		not	bc
		inc	bc

		; Initialize CH2 area
		mov	[gb],bc
		add	ga,[gb]
		add	gc,[gb]
		addi	gc,WA2
		lpd	gb,[pp].PB_IN2_ADDR
		movb	[gc].WA_CUR_DRV_HD,[gb].CB_DRV_HD
		movi	gb,HDD_SRAM_ADDR

		; Initialize CH1 area
		movp	[gb],ga
		movp	gc,[gb]
		addi	gc,WA1
		lpd	gb,[pp].PB_IN1_ADDR
		movb	[gc].WA_CUR_DRV_HD,[gb].CB_DRV_HD
		movi	gb,HDD_SRAM_ADDR

		; Relocate the IOP
		movi	bc,HDD_SECTOR_BUF
		lcall	[gc].WA_LINK1,MEMCPY_16

		movi	ga,HDD_REGS_ADDR
		movbi	[ga].REG_28H,10h

		sintr
		hlt
