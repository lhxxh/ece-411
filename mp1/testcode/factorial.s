factorial.s:
.align 4
.section .text
.globl _start

_start:    
	andi x1, x1, 0   ## clear x1
    addi x1, x1, 5   ## set x1 to 5      current number
    addi x2, x1, 0   ## set x2 to 5      next number
    addi x3, x1, 0   ## set x3 to 5      counter
    xor  x4, x4, x4  ## clear x4 to 0
    xor  x5, x5, x5  ## store result
judge_finish:
    addi x2, x2, -1  ## set to next_number
    add x3, x2, 0    ## load counter
    beq  x2, x4, done  ## if equal done
    blt x2, x4, halt  ## error go to halt
loop:
    add x5, x5, x1  ## store result
    addi x3, x3, -1 ## decrement counter
    bne x3, x4, loop ## calculation loop
    blt x3, x4, halt ## error go to halt
    addi x1, x5, 0  ## refresh current number
    xor x5, x5, x5 ## clear temp result
    beq x4, x4, judge_finish  ## unconditional jump
done:
   addi x1, x5, 0 ## load x1 with final result

halt:
beq x0,x0,halt                ## halt

variable_one: .word 0xFFFFFFFE
variable_two: .fill 0x00000000
