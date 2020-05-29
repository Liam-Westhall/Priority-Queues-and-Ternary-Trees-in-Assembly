.data
num_admitted: .word 6
budget: .word 17
admitted:
.word 324  # id number
.half 730  # fame
.half 19  # wait_time
.word 643  # id number
.half 661  # fame
.half 4  # wait_time
.word 142  # id number
.half 348  # fame
.half 28  # wait_time
.word 353  # id number
.half 525  # fame
.half 9  # wait_time
.word 554  # id number
.half 411  # fame
.half 20  # wait_time
.word 43  # id number
.half 36  # fame
.half 17  # wait_time


.text
.globl main
main:
la $a0, admitted
lw $a1, num_admitted
lw $a2, budget
jal seat_customers

move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "proj4.asm"
