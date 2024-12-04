.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    ebreak
    # Prologue
    addi sp, sp, -16
    sw t1, 0(sp)
    sw t2, 4(sp)
    sw t3, 8(sp)
    sw t4, 12(sp)

    li t1, -2147483648   #current max
    mv t2, a1            #store nums
    mv t4, x0            #current max position

    bgt a1, x0, loop_start
    li a0, 36
    j exit

loop_start:
    beq t2, x0, loop_end

    lw t3, 0(a0)

    addi a0, a0, 4
    addi t2, t2, -1

    bgt t3, t1, loop_continue
    j loop_start

loop_continue:
    mv t1, t3

    sub t4, a1, t2
    addi t4, t4, -1

    j loop_start

loop_end:
    # Epilogue

    mv a0, t4

    lw t1, 0(sp)
    lw t2, 4(sp)
    lw t3, 8(sp)
    lw t4, 12(sp)
    addi sp, sp, 16

    jr ra
