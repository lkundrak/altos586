;------------------------------------------------------------------------
; Program parameters, passed by the user.				:
;------------------------------------------------------------------------

IOPB		STRUC
		DS 4	; Task Block pointer
IOPB_OP:	DS 1
IOPB_STATUS:	DS 1
IOPB_CYL:	DS 2
IOPB_DRV_HD:	DS 1
IOPB_SEC:	DS 1	; Starting sector
IOPB_BYTE_CNT:	DS 2	; The DMA buffer size
IOPB_DMA_BUF:	DS 4	; The DMA buffer address
IOPB_SEC_CNT:	DS 2	; Number of sectors
			; The following members are reserved for use by the IOP.
IOPB_IO_SIZE:	DS 2	; Written by the IOP
IOPB_LAST_CYL:	DS 2	; Last cylinder we've seeked to
IOPB_LINK_REG:	DS 2	; Return address of subroutine calls
IOPB		ENDS

;------------------------------------------------------------------------
; Bits of IOPB_OP.							:
;------------------------------------------------------------------------

OP_BIT_RD	EQU 0	; Read (0) or write (1)
OP_BIT_FORMAT	EQU 2
OP_BIT_ECC	EQU 3	; Include the ECC bits on read
OP_BIT_SEL	EQU 5	; Drive/Head has changed
OP_CMD_BITS	EQU 0FH

;------------------------------------------------------------------------
; Bits of IOPB_STATUS.							:
;------------------------------------------------------------------------

STATUS_BIT_ERR	EQU 7

;------------------------------------------------------------------------
; These are addresses in 8089's I/O space.				:
;------------------------------------------------------------------------

HDD_SRAM_ADDR	EQU 00000H
HDD_REGS_ADDR	EQU 0FFD0H

;------------------------------------------------------------------------
; Registers at HDD_REGS_ADDR.						:
;------------------------------------------------------------------------

PORT_DATA	EQU 00H
PORT_DRV_HD	EQU 02H
PORT_04H	EQU 04H
PORT_CMD_STAT	EQU 06H

;;.bp
;------------------------------------------------------------------------
; The entry point.                                                      :
;------------------------------------------------------------------------

ENTRY:		movi  gc,HDD_REGS_ADDR

		; Is bit 5 set?
		jnbt  [pp].IOPB_OP,OP_BIT_SEL,NO_SEL

		; If bit 5 is set, then drive and head might have
		; Changed and we need ensure correct head is selected.
		movbi [gc].PORT_CMD_STAT,80H
		movb  [gc].PORT_DRV_HD,[pp].IOPB_DRV_HD
B0:		jnbt  [gc].PORT_CMD_STAT,7,B0

		movbi [gc].PORT_CMD_STAT,20H
		movi  [pp].IOPB_LAST_CYL,0
C0:		jbt   [gc].PORT_CMD_STAT,0,C0

		ljnbt [gc].PORT_04H,0,RETURN_81H ; Error?

NO_SEL:		andbi [pp].IOPB_OP,OP_CMD_BITS ; Command bits mask
		ljzb  [pp].IOPB_OP,RETURN_00H ; Command is zero

		; Select head
		movb  [gc].PORT_DRV_HD,[pp].IOPB_DRV_HD
B1:		jnbt  [gc].PORT_CMD_STAT,7,B1

		; Seek to cylinder
		movb  [gc],[pp].IOPB_LAST_CYL ; [gc].PORT_DATA
		movb  [gc],[pp].IOPB_LAST_CYL+1 ; [gc].PORT_DATA
		movb  [gc].PORT_04H,[pp].IOPB_CYL
		movb  [gc].PORT_04H,[pp].IOPB_CYL+1
		movbi [gc].PORT_CMD_STAT,10H
		mov   [pp].IOPB_LAST_CYL,[pp].IOPB_CYL
C1:		jbt   [gc].PORT_CMD_STAT,0,C1
D0:		jnbt  [gc].PORT_04H,1,D0

		; Zero sectors? Nothing to do.
		jzb   [pp].IOPB_SEC_CNT,RETURN_00H

		; A read?
		jbt   [pp].IOPB_OP,OP_BIT_RD,HDD_SRAM_XFER

		; Whis is a write. Transfer the data from main memory
		; DMA buffer to controller board SRAM first
		lpd   ga,[pp].IOPB_DMA_BUF
		movi  gb,PORT_DATA
		mov   bc,[pp].IOPB_BYTE_CNT
		call  [pp].IOPB_LINK_REG,MEM_SRAM_XFER

;;.bp
;------------------------------------------------------------------------
; Transfer between SRAM and the HDD's data register.			:
; Common to read and write.						:
;------------------------------------------------------------------------

HDD_SRAM_XFER:	movi  gb,HDD_SRAM_ADDR
		movi  mc,0FE80H ; Why?
		movi  ga,HDD_REGS_ADDR+PORT_DATA
		movi  [pp].IOPB_IO_SIZE,512

		; A read or write?
		jnbt  [pp].IOPB_OP,OP_BIT_RD,XFER_WR
		movi  cc,8A28H ; A read. Setup for SRAM to HDD transfer.
		wid   8,16

		; Add 5 bytes if ECC requested.
		jnbt  [pp].IOPB_OP,OP_BIT_ECC,XFER_SEC
		movi  [pp].IOPB_IO_SIZE,512+5
		jmp   XFER_SEC

		; A write. Setup for transfer from SRAM to HDD.
XFER_WR:	movi  cc,5628H
		wid   16,8
		jnbt  [pp].IOPB_OP,OP_BIT_FORMAT,XFER_SEC
		movi  [pp].IOPB_IO_SIZE,4 ; Sector header

		; Transfer one sector
XFER_SEC:	mov   bc,[pp].IOPB_IO_SIZE
		movb  [gc],[pp].IOPB_SEC ; [gc].PORT_DATA
		xfer

		; Check for errors
		movb  [gc].PORT_CMD_STAT,[pp].IOPB_OP
		jmcne [gc].PORT_CMD_STAT,RETURN_ERR

		; Are we done or there's more?
		decb  [pp].IOPB_SEC_CNT
		jzb   [pp].IOPB_SEC_CNT,XFER_DONE
		incb  [pp].IOPB_SEC ; There's more.
		jmp   XFER_SEC

		; HDD - SRAM transfer done. We're done if it was a write.
XFER_DONE:	jnbt  [pp].IOPB_OP,OP_BIT_RD,RETURN_00H

		; This was a read. We need to transfer from SRAM to DMA buffer.
		lpd   gb,[pp].IOPB_DMA_BUF
		movi  ga,PORT_DATA
		mov   bc,[pp].IOPB_BYTE_CNT
		call  [pp].IOPB_LINK_REG,MEM_SRAM_XFER

		; Successful return.
RETURN_00H:	movbi [pp].IOPB_STATUS,0
		jmp   DONE

;------------------------------------------------------------------------
; A subroutine that does a memory-to memory transfer.			:
; Used to copy data between the controller SRAM and the DMA buffer in	:
; main memory, in either direction.					:
;------------------------------------------------------------------------

MEM_SRAM_XFER:	wid   16,16
		movi  cc,0C208H
		xfer
		nop
		movp  tp,[pp].IOPB_LINK_REG

;------------------------------------------------------------------------
; Error return. Communicate the error from the status.			:
; register to the IOPB.							:
;------------------------------------------------------------------------

RETURN_ERR:	movb  [pp].IOPB_STATUS,[gc].PORT_CMD_STAT
		andbi [pp].IOPB_STATUS,7EH
		setb  [pp].IOPB_STATUS,STATUS_BIT_ERR
		movbi [gc].PORT_CMD_STAT,00H
		jmp   DONE

		; Error 1.
RETURN_81H:	movi  [pp].IOPB_STATUS,(1<<STATUS_BIT_ERR)+1

DONE:		sintr
		hlt
