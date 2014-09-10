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
ADD_OP:     .equ    0x11
SUB_OP:     .equ    0x22
;MUL_OP:     .equ    0x33
CLR_OP:     .equ    0x44
END_OP:     .equ    0x55
; set up constants for highest and lowest allowable values
MAX_VAL:	.equ	0xff
MIN_VAL:	.equ	0x00

			mov.w	#0xc00c, r9
			mov.w	#0x0200, r10
			mov.b	0(r9),	 r6
			inc		r9

fillData:
			mov.b	0(r9),	 r7
			inc		r9
			mov.b	0(r9),	 r8
			inc		r9
			cmp		#ADD_OP, r7
			jz		addition
			cmp		#SUB_OP, r7
			jz		subtraction
			;cmp		#MUL_OP, r7
			;jz		multiplication
			cmp		#CLR_OP, r7
			jz		clearance
			jmp		programEnd

addition:
			add.w	r8,		 r6
			cmp		#MAX_VAL,r6
			jhs		overMax
			jmp		storage

subtraction:
			sub.b	r8,		 r6
			jmp		storage

overMax:
			mov.b	#MAX_VAL,r6
			jmp		storage

underMin:


;multiplication:
;			add.w	r6,		 r6
;			dec		r8
;			tst		r8
;			jnz		multiplication
;			jmp		storage

clearance:
			clr.b	r6
			jmp		storage
resetR6		mov.b	r8,		 r6
			jmp		fillData

storage:
			mov.b	r6,		 0(r10)
			inc		r10
			cmp		#CLR_OP, r7
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
