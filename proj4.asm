#Liam Westhall
#lwesthall
#111403927

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# Part I
compare_to:
addi $sp, $sp, -32
sw $s0, 0($sp) #pointer to c1
sw $s1, 4($sp) #pointer to c2
sw $s2, 8($sp) #fame for c1
sw $s3, 12($sp) #wait_time for c1
sw $s4, 16($sp)# fame for c2
sw $s5, 20($sp) #wait time for c2
sw $s6, 24($sp) #value of c1's priority
sw $s7, 28($sp) #value of c2's priority


move $s0, $a0
move $s1, $a1

addi $a0, $a0, 4
addi $a1, $a1, 4




lh $s2, 0($a0)
lh $s4, 0($a1)

addi $a0, $a0, 2
addi $a1, $a1, 2

lh $s3, 0($a0)
lh $s5, 0($a1)

li $t0, 10

mul $s3, $s3, $t0
mul $s5, $s5, $t0

add $s6, $s2, $s3
add $s7, $s4, $s5


blt $s6, $s7, c1_less
beq $s6, $s7, c1_equal1
bge $s6, $s7, c1_greater

c1_less:
li $v0, -1
j compare_to_exit

c1_equal1:
bgt $s2, $s4, c1_greater
blt $s2, $s4, c1_less
j c1_equal2

c1_equal2:
li $v0, 0
j compare_to_exit

c1_greater:
li $v0, 1
j compare_to_exit

compare_to_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
addi $sp, $sp, 32
jr $ra

# Part II
init_queue:
addi $sp, $sp, -8
sw $s0, 0($sp) #counter in the loop
li $s0, 0
li $t0, 8
blez $a1, init_queue_fail
sh $zero ($a0)
sh $a1, 2($a0)
addi $a0, $a0, 4 #increment past size


init_queue_loop:
beq $s0, $a1, init_queue_exit
sw $zero, ($a0)
sh $zero, 4($a0)
sh $zero, 6($a0)
addi $a0, $a0, 8
addi $s0, $s0, 1
j init_queue_loop

init_queue_fail:
li $v0, -1



init_queue_exit:
move $v0, $a1
lw $s0, 0($sp)
addi $sp, $sp, 4
jr $ra

# Part III
memcpy:
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

li $s4, 0
move $s0, $a0
move $s1, $a1
move $s2, $a2

memcpyloop:
beq $s4, $s2, memcpy_exit1
lb $s3, ($s0)
sb $s3, ($s1)
addi $s0, $s0, 1
addi $s1, $s1, 1
addi $s4, $s4, 1
j memcpyloop

memcpy_invalid:
li $v0, -1
j memcpy_exit2

memcpy_exit1:
move $v0, $s2
memcpy_exit2:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
addi $sp, $sp, 20
jr $ra

# Part IV
contains:
addi $sp, $sp, -24
sw $s0, 0($sp) # the address of the queue
sw $s1, 4($sp) # the word id of the customer
sw $s2, 8($sp) #the  level where customer is located if found
sw $s3, 12($sp) #size of the queue
sw $s4, 16($sp) #id we are comparing to
sw $s5, 20($sp) #counter where we are in array

move $s0, $a0
move $s1, $a1

lh $s3, 0($s0)
addi $s0, $s0, 4

li $s2, 0
li $s5, 0

contains_loop:
beq $s5, $s3, not_found
lw $s4, 0($s0)
beq $s4, $s1, found_customer
addi $s5, $s5, 1 #index of customer
addi $s0, $s0, 8 #increment by 8 because each element is eight bytes
j contains_loop

found_customer:
li $t0, 3
addi $s5, $s5, -1
div $s5, $t0
mfhi $s4
addi $s2, $s2, 1
move $s5, $s4
bgtz $s4, found_customer
beqz $s4, contains_done
move $v0, $s4
j contains_exit

contains_done:
move $v0, $s2
j contains_exit
not_found:
li $v0, -1
j contains_exit

contains_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
addi $sp, $sp, 24
jr $ra

# Part V
enqueue:
addi $sp, $sp, -36
sw $s0, 0($sp)# the queue
sw $s1, 4($sp) #the customer
sw $s2, 8($sp) #customer id and then holder of address of last known spot of customer
sw $s3, 12($sp)#size of the queue
sw $s4, 16($sp) #the new queue size
sw $s5, 20($sp) #index of the parent node
sw $s6, 24($sp) #address of the spot in memory we want for new customer
sw $s7, 28($sp) #holds originl address of queue too but forever
sw $ra, 32($sp)

move $s0, $a0
move $s7, $a0
move $s1, $a1

li $a2, 8 #for memcpy its always eight bytes

lw $s2, 0($s1) #load id of the customer

move $a1, $s2 #put the customer id in contains argument 2
jal contains

bgez $v0, enqueue_fail

move $a0, $s0
move $a1, $s1

lh $s3, 0($s0)#size
lh $s4, 2($s0)#max size

beq $s3, $s4, enqueue_fail


li $s4, 0

addi $v1, $s3, 1
sb $v1, 0($s0)



mul $s6, $s3, $a2 #multiply size by eight to get the index to store customer temp

add $a0, $a0, $s6 # increment the queue destintion argument with the size multiiplied by eight
addi $a0, $a0, 4

move $s2, $a0 #putting the address of the last size in here

move $a1, $a0
move $a0, $s1

jal memcpy



move $a0, $s7 #reset that nigga shit
move $a1, $s1

li $t0, 3

#works up to here

enqueue_loop:
addi $s3, $s3, -1 
div $s3, $t0
mflo $s5
mul $s5, $s5, $a2  #index of parent * 8
add $a0, $a0, $s5 #increment the address
addi $a0, $a0, 4 #also add by this to get rid of that fuck shit at the beginning
move $a1, $s1
jal compare_to
move $a0, $s7
add $a0, $a0, $s5 #increment the address
addi $a0, $a0, 4 #also add by this to get rid of that fuck shit at the beginning 
blez $v0, swap_parent
j enqueue_done

#works up to here
swap_parent:
move $a1, $s2 #destination is the last node where customer was at
lw $t7 0($a0)
lh $t8, 4($a0)
lh $t9, 6($a0)

sw $t7, 0($a1)
sh $t8, 4($a1)
sh $t9, 6($a1)

lw $t7, 0($s1)
lh $t8, 4($s1)
lh $t9, 6($s1)

sw $t7, 0($a0)
sh $t8, 4($a0)
sh $t9, 6($a0)


j enqueue_loop

enqueue_done:
li $v0, 1
j enqueue_exit


enqueue_fail:
li $v0, -1
j enqueue_exit

enqueue_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
addi $sp, $sp, 36
jr $ra

# Part VI
heapify_down:
addi $sp, $sp, -36
sw $s0, 0($sp) 
sw $s1, 4($sp) 
sw $s2, 8($sp) #store left index
sw $s3, 12($sp) #store mid index
sw $s4, 16($sp) #store right index
sw $s5, 20($sp) #store largest index
sw $s6, 24($sp) #address value 1
sw $s7, 28($sp) #address value 2
sw $ra, 32($sp)

move $s0, $a0 #the queue
move $s1, $a1 #the index

bltz $s1, heapify_fail

lh $t5, ($a0)
bge $s1, $t5, heapify_fail

li $a2, 8
li $t6, 3
li $t8, 0
li $t9, 0
li $s5, 0
li $s6, 0
li $s7, 0

heapify_down_loop:
beq $s1, $t5, heapify_done
mul $s2, $t6, $s1 #left = 3*index + 1
addi $s2, $s2, 1
bge $s1, $t5, heapify_done
mul $s3, $t6, $s1 # mid = 3*index + 2
addi $s3, $s3, 2
bgt $s3, $t5, heapify_done
mul $s4, $t6, $s1 #right = 3*index + 3
addi $s4, $s4, 3
bgt $s4, $t5, heapify_done
move $s5, $s1  #largest = index

ble $s2, $s5, swap_left1

swap_left1:
mul $s2, $s2, $a2 #multiply left by eight for address
mul $s5, $s5, $a2 #multiply largest by eight for address
add $s6, $a0, $s2
addi $s6, $s6, 4
move $a0, $s0
add $s7, $a0, $s5
addi $s7, $s7, 4
div $s2, $a2
mflo $s2
div $s5, $a2
mflo $s5
move $a0, $s6 #move left into first arg
move $a1, $s7 #move largest into second arg
jal compare_to
bgtz $v0, swap_left2
j left_swap_done
swap_left2:
move $s5, $s2
left_swap_done:
move $a0, $s0
move $a1, $s1
ble $s3, $s5, swap_mid1
swap_mid1:
mul $s3, $s3, $a2
mul $s5, $s5, $a2
add $s6, $a0, $s3
addi $s6, $s6, 4
move $a0, $s0
add $s7, $a0 $s5
addi $s7, $s7, 4
div $s3, $a2
mflo $s3
div $s5, $a2
mflo $s5
move $a0, $s6 #move mid into first arg
move $a1, $s7 #move largest into second arg
jal compare_to
bgtz $v0, swap_mid2
j mid_swap_done
swap_mid2:
move $s5, $s3 #largest = mid
mid_swap_done:
move $a0, $s0
move $a1, $s1
ble $s4, $s5, swap_right1
swap_right1:
mul $s4, $s4, $a2
mul $s5, $s5, $a2
add $s6, $a0, $s4
addi $s6, $s6, 4
move $a0, $s0
add $s7, $a0, $s5
addi $s7, $s7, 4
div $s4, $a2
mflo $s4
div $s5, $a2
mflo $s5
move $a0, $s6 #move right into first arg
move $a1, $s7 #move largest into second arg
jal compare_to
bgtz $v0, swap_right2
j right_swap_done
swap_right2:
move $s5, $s4 #largest = right
right_swap_done:
move $a0, $s0
move $a1, $s1
bne $s5, $s1, swap_largest
j heapify_done

swap_largest:
mul $s6, $s1, $a2 #address of index in the queue
mul $s7, $s5, $a2 #address of largest in the queue
add $s6, $a0, $s6
add $s7, $a0, $s7
addi $s6, $s6, 4
addi $s7, $s7, 4
lw $s2, 0($s6) #id of one
lw $s3, 0($s7) #id of two
sw $s2, 0($s7)
sw $s3, 0($s6)
lh $s2, 4($s6)
lh $s3, 4($s7)
sh $s2, 4($s7)
sh $s3, 4($s6)
lh $s2, 6($s6)
lh $s3, 6($s7)
sh $s2, 6($s7)
sh $s3, 6($s6)
move $s1, $s5
addi $t9, $t9, 1
j heapify_down_loop

heapify_done:

move $v0, $t9
j heapify_exit


heapify_fail:
li $v0, -1
j heapify_exit

heapify_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
addi $sp, $sp, 36
jr $ra

# Part VII

dequeue:
addi $sp, $sp, -36
sw $s0, 0($sp) 
sw $s1, 4($sp) #the size of the queue 
sw $s2, 8($sp) 
sw $s3, 12($sp)#address of the first node which is going to be dequeued
sw $s4, 16($sp) # id of size -1 
sw $s5, 20($sp) # fame of size -1 
sw $s6, 24($sp) # wait time of size -1
sw $s7, 28($sp) #address of size -1
sw $ra, 32($sp)

li $a2, 8 #argument 3 for memcpy is always 8
move $s0, $a0

lw $s2, 4($s0)

beqz $s2, dequeue_fail

move $s2, $a1

lh $s1, 0($s0) #the size
addi $s1, $s1, -1


addi $s0, $s0, 4
move $s3, $s0
addi $s0, $s0, -4

move $a0, $s3
move $a1, $s2

jal memcpy

mul $s7, $s1, $a2 #multiply index of size -1 by 8 
add $s0, $s7, $s0 #increment the address
addi $s0, $s0, 4 #also get rid of the size bs

lw $s4, 0($s0)
lh $s5, 4($s0)
lh $s6, 6($s0)

sw $s4, 0($s3)
sh $s5, 4($s3)
sh $s6, 6($s3)

addi $s0, $s0, -4
sub $s0, $s0, $s7

move $a0, $s0
li $a1, 0

jal heapify_down

move $v0, $s1


j dequeue_exit

dequeue_fail:
li $v0, -1

j dequeue_exit

dequeue_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
addi $sp, $sp, 36
jr $ra

# Part VIII
build_heap:
addi $sp, $sp, -24
sw $s0, 0($sp)
sw $s1, 4($sp)#res
sw $s2, 8($sp)#size
sw $s3, 12($sp)#index
sw $s4, 16($sp) #three
sw $ra, 20($sp)

move $s0, $a0

lh $s2, 0($s0)
beqz $s2, build_heap_empty

li $s1, 0 #res
li $s4, 3
addi $s2, $s2, -1
div $s2,$s4
mflo $s3

build_heap_loop:
bltz $s3, build_heap_done
move $a1, $s3
jal heapify_down
addi $s3, $s3, -1
add $s1, $s1, $v0
j build_heap_loop

build_heap_done:
move $v0, $s1
j build_heap_exit

build_heap_empty:
li $v0, 0
j build_heap_exit

build_heap_exit:
move $s1, $v0
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $ra, 20($sp)
addi $sp, $sp, 24
jr $ra

# Part IX
increment_time:
addi $sp, $sp, -36
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp) #average wait time
sw $s6, 24($sp) #counter for loop
sw $s7, 28($sp)
sw $ra, 32($sp)

move $s0, $a0 #queue
move $s1, $a1 #delta_min
move $s2, $a2 #fame level

lh $s4, 0($s0) #size
li $s5, 0 #holds the average
li $s6, 0 #counter

bltz $s1, increment_time_fail
bltz $s2, increment_time_fail

addi $s0, $s0, 4 #skip size and max size



increment_time_loop:
beq $s6, $s4, increment_time_avg1
lh $s7, 4($s0) #fame
blt $s7, $s2, boost_fame
boost_fame_done:
lh $s7, 6($s0) #wait time
add $s7, $s7, $s1
sh $s7, 6($s0)
addi $s0, $s0, 8 #increment address to next element
addi $s6, $s6, 1 #size counter
j increment_time_loop
boost_fame:
add $s7, $s7, $s1
sh $s7, 4($s0)
j boost_fame_done


increment_time_avg1:
li $s6, 0
increment_time_avg2:
beq $s6, $s4, increment_time_avg3
move $s0, $a0 #reset the pointer back to begining
addi $s0, $s0, 4
lh $s7, 6($s0)
add $s5, $s5, $s7
addi $s0, $s0, 8
addi $s6, $s6, 1
j increment_time_avg2

increment_time_avg3:
li $t9, 10
div $s5, $t9
mflo $s5

increment_time_done:
jal build_heap
move $v0, $s5
j increment_time_exit
increment_time_fail:
li $v0, -1
increment_time_exit:
move $v0, $s5
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
lw $ra, 32($sp)
addi $sp, $sp, 36
jr $ra

# Part X
admit_customers:
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $ra, 16($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2

li $s3, 0
move $a1, $s2

admit_customers_loop:
beq $s1, $s3, admit_customers_done
move $a1, $s2
jal dequeue
addi $s3, $s3, 1
j admit_customers_loop
admit_customers_done:
move $v0, $s3
j admit_customers_exit

admit_customers_fail:
li $v0, -1
j admit_customers_exit


admit_customers_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
jr $ra

# Part XI
seat_customers:
addi $sp, $sp, -24
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)

move $s0, $a0 #admitted
move $s1, $a1 #num_admitted
move $s2, $a2 #budget

blez $s1, seat_customers_fail
blez $s2, seat_customers_fail



seat_customers_loop:









seat_customers_done:


seat_customers_fail:
li $v0, -1
li $v1, -1

seat_customers_exit:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
addi $sp, $sp, 24




jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
