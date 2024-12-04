.globl matmul

.text
matmul:
    # Error checks
    ble a1, x0, error_process
    ble a2, x0, error_process
    ble a4, x0, error_process
    ble a5, x0, error_process
    bne a2, a4, error_process

    # Prologue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    # Save parameters to saved registers
    mv s0, a0    # s0 = pointer to m0
    mv s1, a1    # s1 = num rows of m0
    mv s2, a2    # s2 = num cols of m0 = num rows of m1
    mv s3, a3    # s3 = pointer to m1
    mv s4, a5    # s4 = num cols of m1
    mv s5, a6    # s5 = pointer to result matrix d

    # Initialize loop counters
    mv s6, x0    # s6 = current row of m0 (i)
    
outer_loop_start:
    mv s7, x0    # s7 = current col of m1 (j)
    mv s10, s3   # Reset m1 pointer for each row of m0
    
inner_loop_start:
    # Prepare for dot product
    slli t0, s6, 2      # t0 = i * 4
    mul t1, s6, s2      
    slli t1, t1, 2      # t1 = i * width_m0 * 4
    add t2, s0, t1      # t2 = address of current row in m0
    
    slli t3, s7, 2      # t3 = j * 4
    add t4, s10, t3     # t4 = address of current column in m1

    # Set up arguments for dot
    mv a0, t2           # a0 = address of current row in m0
    mv a1, t4           # a1 = address of current column in m1
    mv a2, s2           # a2 = length of vectors to multiply
    li a3, 1            # a3 = stride of m0 vector
    mv a4, s4           # a4 = stride of m1 vector

    # Call dot
    jal ra, dot

    # Store result
    slli t0, s6, 2      # t0 = i * 4
    mul t1, s6, s4      
    slli t1, t1, 2      # t1 = i * width_result * 4
    add t2, s5, t1      # t2 = row address in result
    slli t3, s7, 2      # t3 = j * 4
    add t4, t2, t3      # t4 = exact address in result
    sw a0, 0(t4)        # Store dot product result

    # Increment inner loop counter and check
    addi s7, s7, 1      # j++
    blt s7, s4, inner_loop_start

inner_loop_end:
    # Increment outer loop counter and check
    addi s6, s6, 1      # i++
    blt s6, s1, outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    ret

error_process:
    li a0, 38
    j exit