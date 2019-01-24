.equ	LAST_RAM_WORD,	0x007FFFFC
.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF

.text
.global _start
.org	0x00000000

_start:
    movia sp, LAST_RAM_WORD
    movia r2, '\n'
    call PrintChar
    movia r2, MSG
    call PrintString
    movia r2, LIST
    ldw r5, N(r0)
    call PrintHexList
    movia r2, '\n'
    call PrintChar

PrintChar:
    subi sp, sp, 8
    stw r3, 4(sp)
    stw r4, 0(sp)
    movia r3, JTAG_UART_BASE
pc_loop:
    ldwio r4, STATUS_OFFSET(r3)
    andhi r4, r4, WSPACE_MASK
    beq r4, r0, pc_loop
    stwio r2, DATA_OFFSET(r3)
    ldw r3, 4(sp)
    ldw r4, 0(sp)
    addi sp, sp, 8
    ret
    
PrintString:
    subi sp, sp, 12
    stw ra, 8(sp)
    stw r3, 4(sp)
    stw r2, 0(sp)
    mov r3, r2
ps_loop:
    ldb r2, 0(r3)
    beq r2, r0, end_ps_loop
    call PrintChar
    addi r3, r3, 1
    br ps_loop
end_ps_loop:
    ldw ra, 8(sp)
    ldw r3, 4(sp)
    ldw r2, 0(sp)
    addi sp, sp, 12
    ret
   
PrintHexDigit:
    subi sp, sp, 16
    stw ra, 12(sp)
    stw r3, 8(sp)
    stw r2, 4(sp)
    stw r4, 0(sp)
    movi r4, 9
    mov r3, r2
IF:
    ldw r2, 0(r3)
    bgt r2, r4, ELSE
THEN:
    addi r2, r2, '0'
    br END_IF
ELSE:
    subi r2, r2, 10
    addi r2, r2, 'A'
END_IF:
    call PrintChar
    ldw ra, 12(sp)
    ldw r3, 8(sp)
    ldw r2, 4(sp)
    ldw r4, 0(sp)
    addi sp, sp, 16
    ret
    
PrintHexList:
    subi sp, sp, 12
    stw ra, 8(sp)
    stw r6, 4(sp)
    stw r5, 0(sp)
psh_loop:
    beq r5, r0, end_psh_loop
    call PrintHexDigit
    subi r5, r5, 1
    addi r2, r2, 4
    mov r6, r2
    movia r2, ','
    call PrintChar
    mov r2, r6
    br psh_loop
end_psh_loop:
    ldw ra, 8(sp)
    ldw r6, 4(sp)
    ldw r5, 0(sp)
    addi sp, sp, 12
    ret
	
 
	.org	0x1000
        
# place word-sized data first to maintain word alignemnt
	LIST: .word 1, 10, 2, 12, 3, 13
	N: .word 6
# place byte sized data and strings after word sized data

    	MSG: .asciz "ELEC274 Lab2\n"

	.end
    
    
	
	
