.data
.align 2
# random garbage
queue:
.half 111
.half 200
.byte 14 69 23 197 105 69 28 215 231 224 10 98 138 144 86 88 219 14 41 35 87 144 86 180 63 42 1 232 112 199 23 225 153 97 18 2 81 188 115 27 232 12 24 171 37 33 203 233
max_size: .word 6

.text
.globl main
main:
la $a0, queue
lw $a1, max_size
jal init_queue

move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "proj4.asm"
