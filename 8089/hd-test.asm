;------------------------------------------------------------------------
; Hardware interface.							:
;------------------------------------------------------------------------

PORT_TO_BLK     EQU 08A28H ; Port GA to memory GB
BLK_TO_PORT     EQU 05628H ; Memory GB to port GA
BLK_TO_BLK      EQU 0C008H ; Memory GA to memory GB

HDD_SRAM_ADDR	EQU 00000H ; In I/O space
HDD_REGS_ADDR	EQU 0FFD0H ; ditto

REG_DATA	EQU 00H
REG_DRV_HD	EQU 02H	; Write Drive & Head select
REG_CYL_ST1	EQU 04H	; Write cylinder, read some status bits
REG_CMD_ST2	EQU 06H	; Write command, read more status bits
REG_28H		EQU 28H

; Write bits of REG_CMD_ST2
CMD_BIT_RD	EQU 0	; Read Sector Data
CMD_BIT_WR	EQU 1	; Write Sector Data
CMD_BIT_FMT	EQU 2	; Format Track
CMD_BIT_LONG	EQU 3	; Include ID field on read

; Read bits of REG_CYL_ST1
ST1_BIT_TR0	EQU 0	; Track 0
ST1_BIT_SC	EQU 1	; Seek Complete

; Read bits of REG_CMD_ST2
ST2_BIT_BSY	EQU 0
ST2_BIT_UNK1	EQU 1	; Recoverable, retry!
ST2_BIT_BAD_SEC	EQU 2	; Sector flagged bad
;ST2_BIT_NO_SEC	EQU 3	; Record Not found
ST2_BIT_CRC_ERR	EQU 4	; CRC Error
ST2_BIT_UNK5	EQU 5
ST2_BIT_WE	EQU 6	; Write Error (signalled from drive, latched)
ST2_BIT_RDY	EQU 7	; Ready (signalled from drive)

;;.bp
;------------------------------------------------------------------------
; Structures.								:
;------------------------------------------------------------------------

; Parameter Block
PB		STRUC
PB_TB:		DS 4
PB_IN1_ADDR:	DS 4	; Offset:Segment of first command block
PB_IN2_ADDR:	DS 4	; Offset:Segment of second command block
PB_OUT1_ADDR:	DS 4	; Offset:Segment of first result block
PB_OUT2_ADDR:	DS 4	; Offset:Segment of second result block
PB		ENDS

; Command Block.
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

; Value following the Command Block in the Working Area.
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

;;.bp
; Bits of CB_OP.
OP_BIT_RD	EQU 0	; Read (0) or write (1)
;OP_BIT_WR	EQU 1	; Diags sets, this, but we don't look
OP_BIT_FMT	EQU 2	; Format
OP_BIT_LONG	EQU 3	; Include ID field in reads
OP_BIT_SEL	EQU 5	; Drive/Head has changed
OP_BIT_NO_RECAL	EQU 6
OP_BIT_UNK7	EQU 7

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
		; Wait for Seek Complete
CH1_WAIT_SEEK:	jnbt	[ga].REG_CYL_ST1,ST1_BIT_SC,CH1_WAIT_SEEK
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
		; Wait for Seek Complete
CH2_WAIT_SEEK:	jnbt	[ga].REG_CYL_ST1,ST1_BIT_SC,CH2_WAIT_SEEK
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
		movbi	[gc].WA_ERR_SEC,0FFH
		movi	gb,HDD_SECTOR_BUF
		movi	[gc].WA_XFER_LEN,512
		jnbt	[gc].CB_OP,OP_BIT_RD,SETUP_WRITE
		movbi	[gc].WA_TMP_CMD,1<<CMD_BIT_RD
		jnbt    [gc].CB_OP,OP_BIT_LONG,SETUP_READ
		movbi	[gc].WA_TMP_CMD,1<<CMD_BIT_LONG|1<<CMD_BIT_RD
		addi	[gc].WA_XFER_LEN,5 ; Include ID field

SETUP_READ:	movi	cc,PORT_TO_BLK
		wid	8,16
		jmp	SETUP_XFER

SETUP_WRITE:	movbi	[gc].WA_TMP_CMD,1<<CMD_BIT_WR
		movi	cc,BLK_TO_PORT
		wid	16,8
		jnbt	[gc].CB_OP,OP_BIT_FMT,SETUP_XFER
		movbi	[gc].WA_TMP_CMD,1<<CMD_BIT_FMT
		movi	[gc].WA_XFER_LEN,4h

SETUP_XFER:	movi	mc,0FE80H
DO_XFER:	movb	[ga],[gc].CB_SEC
		movp	[gc].WA_CB_ADDR,gb
		mov	bc,[gc].WA_XFER_LEN
		xfer
		movb	[ga].REG_CMD_ST2,[gc].WA_TMP_CMD
		jmcne	[ga].REG_CMD_ST2,DISK_OP_ERROR
		decb	[gc].CB_NUM_SECS
		jzb	[gc].CB_NUM_SECS,DISK_CMD_DONE

		; Next sector on same track
		incb	[gc].CB_SEC
		jnbt	[gc].CB_SEC,4,DO_XFER

		; Next head
		incb	[gc].CB_DRV_HD
		movb	mc,[gc].WA_CUR_DRV_HD
		ori	mc,0F00H
		jmce	[gc].CB_DRV_HD,NEXT_CYL
SECTOR_ZERO:	movb	[ga].REG_DRV_HD,[gc].CB_DRV_HD
		movbi	[gc].CB_SEC,0h
		jmp	SETUP_XFER

		; Next cylinder
NEXT_CYL:	inc	[gc].CB_CYL
		lcall	[gc].WA_LINK1,SEEK_TO_CYL
		andbi	[gc].CB_DRV_HD,0F0H
		; Wait for Seek Complete
POLL_OP_SEEK:	jnbt	[ga].REG_CYL_ST1,ST1_BIT_SC,POLL_OP_SEEK
		jmp	SECTOR_ZERO
DISK_CMD_DONE:	jbt	[ga].REG_CMD_ST2,ST2_BIT_BSY,DISK_CMD_DONE
		movp	tp,[gc].WA_LINK2

;------------------------------------------------------------------------
; Retry on errors.							:
;------------------------------------------------------------------------

DISK_OP_ERROR:	jbt	[ga].REG_CMD_ST2,5,ERR_STATUS
		jbt	[ga].REG_CMD_ST2,1,ERR_STATUS ; Retry!
		jbt	[gc].CB_OP,OP_BIT_NO_RECAL,NO_NEED_RECAL
		movb	mc,[gc].CB_SEC
		ori	mc,0FF00H
		jmce	[gc].WA_ERR_SEC,ERR_SEC_SET
		movb	[gc].WA_ERR_SEC,[gc].CB_SEC
		movbi	[gc].WA_ERR_TRIES,0h
ERR_SEC_SET:	jbt	[ga].REG_CMD_ST2,ST2_BIT_BAD_SEC,SKIP_RECAL
		jbt	[ga].REG_CMD_ST2,ST2_BIT_CRC_ERR,SKIP_RECAL
		jnzb	[gc].WA_ERR_TRIES,GIVE_UP
;;.bp
		; Seek to cylinder zero	to recalibrate
		movbi	[ga].REG_CYL_ST1,0
		lcall	[gc].WA_LINK1,SEL_DRIVE
		lcall	[gc].WA_LINK1,SEEK_TO_CYL
		; Wait for Seek Complete
POLL_RECAL:	jnbt	[ga].REG_CYL_ST1,ST1_BIT_SC,POLL_RECAL
		jmp	RECAL_DONE
SKIP_RECAL:	jbt	[gc].WA_ERR_TRIES,4,GIVE_UP
RECAL_DONE:	incb	[gc].CB_RETRIES
		incb	[gc].WA_ERR_TRIES
NO_NEED_RECAL:	movb	[gc].CB_STAT,[ga].REG_CMD_ST2
		andbi	[gc].CB_STAT,7EH
		movbi	[ga].REG_CMD_ST2,0h

		; Try again
		ljnbt	[gc].CB_OP,OP_BIT_NO_RECAL,SETUP_XFER
GIVE_UP:	setb	[gc].CB_STAT,7
		movp	tp,[gc].WA_LINK2

;------------------------------------------------------------------------
; Communicate the error and cancel both channels.			:
;------------------------------------------------------------------------

ERR_STATUS:	movb	[gc].CB_STAT,[ga].REG_CMD_ST2
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
		jbt	[ga].REG_CMD_ST2,1,ERR_STATUS
		movp	tp,[gc].WA_LINK

;------------------------------------------------------------------------
; Copy a block of data (sector, CB) between main memory and SRAM.	:
;------------------------------------------------------------------------

MEMCPY_16:	wid	16,16
		movi	cc,BLK_TO_BLK
		xfer
		nop
		movp	tp,[gc].WA_LINK1

;------------------------------------------------------------------------
; Set head and a cylinder.						:
;------------------------------------------------------------------------

SET_TRACK:	movb	[ga].REG_DRV_HD,[gc].CB_DRV_HD
		movb	[ga].REG_CYL_ST1,[gc].WA_CUR_CYL+0
		movb	[ga].REG_CYL_ST1,[gc].WA_CUR_CYL+1
		movbi	[gc].CB_STAT,0h

		; Wait for bit 7 to come up for up to FFh attempts
		movi	bc,0h
POLL_DRV_RDY:	dec	bc
		jz	bc,ERR_FINISH
		jnbt	[ga].REG_CMD_ST2,ST2_BIT_RDY,POLL_DRV_RDY
		movp	tp,[gc].WA_LINK

;------------------------------------------------------------------------
; Seek to a cylinder.							:
;------------------------------------------------------------------------

SEEK_TO_CYL:	movb	[ga],[gc].WA_CUR_CYL+0
		movb	[ga],[gc].WA_CUR_CYL+1
		movb	[ga].REG_CYL_ST1,[gc].CB_CYL_LO
		movb	[ga].REG_CYL_ST1,[gc].CB_CYL_HI
		movbi	[ga].REG_CMD_ST2,10H
		mov	[gc].WA_CUR_CYL,[gc].CB_CYL
POLL_SEEK:	jbt	[ga].REG_CMD_ST2,ST2_BIT_BSY,POLL_SEEK
		movp	tp,[gc].WA_LINK1

;------------------------------------------------------------------------
; Select a disk drive unit.						:
;------------------------------------------------------------------------

SEL_DRIVE:	movbi	[ga].REG_CMD_ST2,80H
		movbi	[gc].CB_STAT,0h
		jnbt	[gc].CB_OP,OP_BIT_UNK7,NO_BIT_7
		movb	[gc].WA_CUR_DRV_HD,[gc].CB_DRV_HD
NO_BIT_7:	movb	[ga].REG_DRV_HD,[gc].CB_DRV_HD

		; Wait for drive to become ready for up to FFh attempts
		movi	bc,0h
POLL_READY:	dec	bc
		jz	bc,ERR_FINISH
		jnbt	[ga].REG_CMD_ST2,ST2_BIT_RDY,POLL_READY

		movbi	[ga].REG_CMD_ST2,20H
		movi	[gc].WA_CUR_CYL,0h
POLL_SEL:	jbt	[ga].REG_CMD_ST2,ST2_BIT_BSY,POLL_SEL
		movp	tp,[gc].WA_LINK1

;------------------------------------------------------------------------
; Indicate errors in both channels.					:
;------------------------------------------------------------------------

ERR_FINISH:	movi	ga,WA1
		orbi	[ga].CB_STAT,81H
		lpd	gb,[pp].PB_OUT1_ADDR
		lcall	[gc].WA_LINK,COPY_CB
		movi	ga,WA2
		orbi	[ga].CB_STAT,81H
		lpd	gb,[pp].PB_OUT2_ADDR
		lcall	[gc].WA_LINK,COPY_CB

		sintr
		hlt

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
		movbi	[ga].REG_28H,10H
		ljbt	[ga].REG_CMD_ST2,1,ERR_STATUS
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
		movbi	[ga].REG_28H,10H
COPIED_OUT:	movp	tp,[gc].WA_LINK

;------------------------------------------------------------------------
; Command block copies and sector data copies in controller SRAM.	:
;------------------------------------------------------------------------

WA1:		DS WA_SIZE
WA2:		DS WA_SIZE
HDD_SECTOR_BUF:

;;.bp
LOADER_OFFSET	EQU 00400H ; In main memory

		; Pad the loader to 0400H
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
		movbi	[ga].REG_28H,10H

		sintr
		hlt
