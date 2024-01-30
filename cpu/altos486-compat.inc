; Regular ole monitor system calls
SYS_MONITOR		equ 0
SYS_SIO_GET_STAT	equ 1
SYS_SIO_GETC		equ 2
SYS_SIO_PUTC		equ 3
SYS_SIO_SET_ATTRS	equ 4
SYS_SIO_GET_ATTR	equ 5
SYS_PRINT_CRLF		equ 6
SYS_PUTS		equ 7
SYS_DISK_IO		equ 8
SYS_GET_CONS_AND_MEM	equ 10
SYS_GET_BOOT_DISK	equ 11
SYS_DISK_BOOT		equ 12


struc ACS486_IOPB
.DEVICE_NUM:		resw 1	; Device Number
.COMMAND:		resw 1	; Command
.RESULT:		resw 1	; Result
.DEVICE_RESULT:		resd 1	; Device Result
.DMA_SEGMENT:		resw 1	; DMA Segment
.DMA_OFFSET:		resw 1	; DMA Offset
.CYLINDER:		resw 1	; Cylinder
.DRIVE_NUM:		resb 1	; Drive	Number
.HEAD:			resb 1	; Head Number
.SECTOR:		resb 1	; Beginning Sector Number
.SECTOR_COUNT:		resb 1	; Sector Count Number
.SECTOR_LEN:		resb 1	; Sector length
.RETRIES:		resb 1	; Retries
endstruc


CON_OUT                 equ 2   ; Write one character to the console
CON_STR                 equ 3   ; Write a character string to the ; console
CON_STAT                equ 11  ; Read in the keyboard status
AUTO_REBOOT             equ 12  ; Reboots the system from the device requested
BOOT_NUMBER             equ 13  ; Returns the boot-device number
GENERAL_IO              equ 30  ; Performs the peripheral operation


HARD_DISK               equ 0   ; Hard Disk
FLOPPY_DISK             equ 1   ; Floppy Disk
SCSI                    equ 2   ; SCSI (Not Used)
TAPE                    equ 3   ; Tape
PRINTER                 equ 4   ; Printer
WORKNET                 equ 5   ; WorkNet
ETHERNET                equ 6   ; EtherNet (Not Used)
CONSOLE                 equ 7   ; Console
AUTO_BOOT               equ 8   ; Auto Boot


RECAL                   equ 0   ; Recal
WRITE_SECTOR            equ 1   ; write Sector
READ_SECTOR             equ 2   ; Read Sector
SEEK                    equ 4   ; Seek
FORMAT                  equ 5   ; Format


NO_ERROR                equ 0   ; No Error
GENERAL_ERROR           equ 1   ; General Error
DEVICE_NOT_SUPPORTED    equ 2   ; Device not supported
DEVICE_NOT_PRESENT      equ 3   ; Device not present
INVALID_COMMAND         equ 4   ; Invalid command
TIMEOUT_ERROR           equ 5   ; Timeout error


ACS486_CON_IN:
	xchg cx,dx		; I/O Channel/port from DX to CX
	int3			; This call is untested. Enter monitor.
	mov bx,SYS_SIO_GETC
	call 0FE00h:0		; Result stays in AL
	iret


ACS486_CON_OUT:
	xchg cx,dx		; I/O Channel/port from DX to CX
	xchg dx,ax		; Character from AL to DL
	mov bx,SYS_SIO_PUTC
	call 0FE00h:0
	iret


ACS486_CON_STR:
	xchg cx,dx		; I/O Channel/port from DX to CX
	mov bx,ds		; String pointer from DS:AX to ES:DX
	mov es,bx
	xchg dx,ax
	mov bx,SYS_PUTS
	int3			; This call is untested. Enter monitor.
	call 0FE00h:0
	iret


ACS486_CON_STAT:
	xchg cx,dx		; I/O Channel/port from DX to CX
	mov bx,SYS_SIO_GET_STAT
	int3			; This call is untested. Enter monitor.
	call 0FE00h:0	;	; Result stays in AL
	and al,1		; Turn 0FFh to 1
	iret


ACS486_AUTO_REBOOT:
	mov bl,SYS_DISK_BOOT
	mov cl,bh
	xor ch,ch
	int3			; This call is untested. Enter monitor.
	call 0FE00h:0
	iret


ACS486_BOOT_NUMBER:
	mov bx,SYS_GET_BOOT_DISK
	int3			; This call is untested. Enter monitor.
	call 0FE00h:0
	mov bh,al		; Not clear where the result should be...
	iret


ACS486_GENERAL_IO:
	xor	bx,bx
	mov	es,bx

	mov	bx,ax

	; Translate device/drive pair to a single drive number
	mov	word [bx+ACS486_IOPB.RESULT],DEVICE_NOT_SUPPORTED
	mov	al,[bx+ACS486_IOPB.DRIVE_NUM]
	cmp	word [bx+ACS486_IOPB.DEVICE_NUM],FLOPPY_DISK
	jg	IO_DONE
	je	DEV_NUM_SET
	add	al,4
DEV_NUM_SET:
	es mov	byte [DISK_IOPB+IOPB.DRIVE_NUM], al
	es mov	byte [DISK_IOPB+IOPB.OP_STATUS],GENERAL_ERROR

	es mov	byte [DISK_IOPB+IOPB.OP_STATUS_MASK], 0FFh

	; Map the command
	mov	ax,[bx+ACS486_IOPB.COMMAND]
	shl	ax,1
	shl	ax,1
	shl	ax,1
	shl	ax,1
	es mov	byte [DISK_IOPB+IOPB.OPCODE], al

	mov	ax,[bx+ACS486_IOPB.CYLINDER]
	es mov	word [DISK_IOPB+IOPB.TRACK], ax
	mov	al,[bx+ACS486_IOPB.HEAD]
	es mov	byte [DISK_IOPB+IOPB.HEAD], al

	; 0-based to 1-based
	mov	al,[bx+ACS486_IOPB.SECTOR]
	inc	al
	es mov	byte [DISK_IOPB+IOPB.SECTOR], al

	mov	al,[bx+ACS486_IOPB.SECTOR_COUNT]
	es mov	byte [DISK_IOPB+IOPB.SECTOR_COUNT], al
	mov	al,[bx+ACS486_IOPB.RETRIES]
	es mov	byte [DISK_IOPB+IOPB.RETRIES], al

	mov	ax,[bx+ACS486_IOPB.DMA_OFFSET]
	es mov	word [DISK_IOPB+IOPB.DMA_OFFSET], ax

	mov	ax,[bx+ACS486_IOPB.DMA_SEGMENT]
	es mov	word [DISK_IOPB+IOPB.DMA_SEGMENT], ax

	; Translate encoded sector length to length in bytes
	mov	ah,[bx+ACS486_IOPB.SECTOR_LEN]
	xor	al,al
	es mov	word [DISK_IOPB+IOPB.SECTOR_LEN], ax

	; Do the I/O call
	mov cx,DISK_IOPB
	push bx
	mov bx,SYS_DISK_IO
	call 0fe00h:0000h
	pop bx

	es mov	al,byte [DISK_IOPB+IOPB.OP_STATUS]
	xor	ah,ah
	mov	[bx+ACS486_IOPB.RESULT],ax
IO_DONE:
	iret

INT20_ACS486_CALL:
	cmp bl,01
	jne NOT_01
	jmp ACS486_CON_IN
NOT_01:
	cmp bl,02
	jne NOT_02
	jmp ACS486_CON_OUT
NOT_02:
	cmp bl,03
	jne NOT_03
	jmp ACS486_CON_STR
NOT_03:
	cmp bl,11
	jne NOT_11
	jmp ACS486_CON_STAT
NOT_11:
	cmp bl,12
	jne NOT_12
	jmp ACS486_AUTO_REBOOT
NOT_12:
	cmp bl,13
	jne NOT_13
	jmp ACS486_BOOT_NUMBER
NOT_13:
	cmp bl,30
	jne NOT_30
	jmp ACS486_GENERAL_IO
NOT_30:
	int3
	iret
