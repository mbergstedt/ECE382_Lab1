;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
program1:	.byte  0x11, 0x11, 0x11, 0x11, 0x11, 0x44, 0x22, 0x22, 0x22, 0x11, 0xCC, 0x55
program2:	.byte  0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0xDD, 0x44, 0x08, 0x22, 0x09, 0x44, 0xFF, 0x22, 0xFD, 0x55
program3:	.byte  0x22, 0x11, 0x22, 0x22, 0x33, 0x33, 0x08, 0x44, 0x08, 0x22, 0x09, 0x44, 0xff, 0x11, 0xff, 0x44, 0xcc, 0x33, 0x02, 0x33, 0x00, 0x44, 0x33, 0x33, 0x08, 0x55
			.data
myResults:  .space 20
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
											; set up comments for the operations
ADD_OP:     .equ    0x11
SUB_OP:     .equ    0x22
MUL_OP:     .equ    0x33
CLR_OP:     .equ    0x44
END_OP:     .equ    0x55
											; set up constants for highest and lowest allowable values
MAX_VAL:	.equ	0xff
MIN_VAL:	.equ	0x00

			mov.w	#program3, r9			; can use #program3 and it stores the value of the memory address
			mov.w	#myResults,r10
			mov.b	0(r9),	   r6			; r6 is used similar to the accumulator
			inc		r9

fillData:
			mov.b	0(r9),	   r7			; r7 holds the operation
			inc		r9
			mov.b	0(r9),	   r8			; r8 holds the operand
			inc		r9
			cmp		#ADD_OP,   r7
			jz		addition
			cmp		#SUB_OP,   r7
			jz		subtraction
			cmp		#CLR_OP,   r7
			jz		clearance
			cmp		#MUL_OP,   r7
			mov.b	r6,		   r5			; use r5 to keep track of original value
			jz		multiplication
			jmp		programEnd

addition:
			add.w	r8,		   r6
			cmp		#MAX_VAL,  r6
			jhs		overMax
			jmp		storage

subtraction:
			sub.b	r8,		   r6
			jn		underMin				; n flag will be set if the result is negative
			jmp		storage

overMax:
			mov.b	#MAX_VAL,  r6
			jmp		storage

underMin:
			mov.b	#MIN_VAL,  r6
			jmp		storage

multiplication:
			dec		r8
			tst		r8
			jz		storage
			jn		clearance				 ; occurs if the multiplier starts at 0
			add.w	r5,		   r6
			cmp		#MAX_VAL,  r6
			jhs		overMax
			jmp		multiplication

clearance:
			clr.b	r6
			jmp		storage
resetR6		mov.b	r8,		   r6
			jmp		fillData

storage:
			mov.b	r6,		   0(r10)
			inc		r10
			cmp		#CLR_OP,   r7
			jz		resetR6
			jmp		fillData

programEnd:
			jmp		programEnd
;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
