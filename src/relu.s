.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    ebreak
    # Prologue
    addi sp, sp, -8
    sw t1, 4(sp)
    sw t2, 0(sp)

    mv t2, a1

    bgt a1, x0, loop_start 

    li a0 36
    j exit

loop_start:

    lw t1, 0(a0)

    blt t1, x0, loop_continue

    addi a0, a0, 4
    addi t2, t2, -1

    bgt t2,x0, loop_start
    j loop_end    

loop_continue:
    sw x0, 0(a0)
    j loop_start

loop_end:

    # Epilogue
    lw t1, 4(sp)
    lw t2, 0(sp)
    addi sp, sp, 8
    jr ra
