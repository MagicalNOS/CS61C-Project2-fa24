.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    
    # Prologue
    ble a2, x0, error_uses 
    ble a3, x0, error_stride
    ble a4, x0, error_stride

    addi sp, sp, -24
    sw t1, 0(sp)
    sw t2, 4(sp)
    sw t3, 8(sp)
    sw t4, 12(sp)
    sw t5, 16(sp)
    sw t6, 20(sp)
    
    mv t3, x0 
    mv t4, x0
    mv t5, x0
    

loop_start:
    lw t1, 0(a0)
    lw t2, 0(a1)
    mv t6, t1

    slli t3, a3, 2
    slli t4, a4, 2

loop_continue:
    addi t6, t6, -1
    add t5, t5, t2
    bne t6, x0, loop_continue

    addi a2, a2, -1
    add a0, a0, t3
    add a1, a1, t4

    lw t1, 0(a0)
    lw t2, 0(a1)
    mv t6, t1

    bne a2, x0, loop_continue

loop_end:
    mv a0, t5

    lw t1, 0(sp)
    lw t2, 4(sp)
    lw t3, 8(sp)
    lw t4, 12(sp)
    lw t5, 16(sp)
    lw t6, 20(sp)
    addi sp, sp, 24

    jr ra


error_uses:
    li a0 36
    j exit


error_stride:
    li a0, 37
    j exit

