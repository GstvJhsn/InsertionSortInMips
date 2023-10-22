.data
.text
main:
    la $s0, data       # The address of the array stored in s0
    lw $s1, datalen    # The length of the array stored in s1
    jal InsertionSort
    nop
    j printArray
    nop

InsertionSort:
    addi $t0, $zero, 1   # I = 1 --> t0

OUTER: # OUTER LOOP STARTS HERE
    beq $t0, $s1, SORTED  # if i > size, jump to SORTED
    nop
    sll $t4, $t0, 2      # t4 = i * 4
    add $t4, $t4, $s0    # add the address + 4 bits to t4
    lw $t4, 0($t4)       # load a[i] --> t4
    addi $t1, $t0, -1    # J = I-1

INNER: # INNER LOOP STARTS HERE
    slt $t2, $t1, $zero  # t2 = 1 if j < 0
    bne $t2, $zero, outOfloop
    nop
    sll $t3, $t1, 2      # t3 = J * 4
    add $t3, $t3, $s0    # add the address + 4 bits to t3
    lw $t3, 0($t3)       # load a[j] --> t3
    sltu $t5, $t3, $t4   # t5 = 1 if t3 < array[i]
    bne $t5, $zero, outOfloop
    nop
    addi $t6, $t1, 1     # store J + 1 in t6
    sll $t6, $t6, 2
    add $t6, $t6, $s0
    sw $t3, 0($t6)       # store array[j] in t3
    addi $t1, $t1, -1    # j - 1 in t1
    j INNER
    nop

outOfloop:
    addi $t8, $t1, 1     # add 1 to J
    sll $t8, $t8, 2
    add $t8, $t8, $s0
    sw $t4, 0($t8)       # store at the first index
    addiu $t0, $t0, 1
    j OUTER
    nop

SORTED:
    jr $ra               # jump to the return address

printArray:
    li $t0, 0            # set print iterator to 0. i = 0

printLoop:
    lw $t4, ($s0)        # Array(i) ---> t4
    # Print value Array[i]
    li $v0, 1
    move $a0, $t4        # move array value to a0
    syscall
    # Print new line
    li $v0, 11
    li $a0, 10
    syscall
    addu $t0, $t0, 1     # i + 1
    addu $s0, $s0, 4     # array address + 4
    bltu $t0, $s1, printLoop  # if i < size ---> loop
    nop

exit:
    li $v0, 10
    syscall
