.data
.align 2
n: .word 3
src: .asciiz "ABCDEFG"
dest: .asciiz "xxxxxxxxx"

.text
.globl main
main:
la $a0, src
la $a1, dest
lw $a2, n
jal memcpy


la $a0, dest
li $v0, 4
syscall

li $v0, 10
syscall

.include "proj4.asm"
