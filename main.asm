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
myProgram:  .byte  0x11, 0x11, 0x11, 0x11, 0x11, 0x44, 0x22, 0x22, 0x22, 0x11, 0xCC, 0x55
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

			mov.w	#0xc000, r9
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
			jmp		storage

subtraction:
			sub.b	r8,		 r6
			jmp		storage

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
