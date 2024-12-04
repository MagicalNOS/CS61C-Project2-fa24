.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)

    lw t0, 0(a1)
    mv s0, t0
    
    lw t0, 4(a1)
    mv s1, t0

    lw t0, 8(a1)
    mv s2, t0

    lw t0, 12(a1)
    mv s3, t0

    mv s4, a2

    # Read pretrained m0
    addi sp, sp, -8
    mv a0, s0
    mv a1, sp
    addi a2, sp, 4
    jal read_matrix
    mv s0, a0
     
    # Read pretrained m1
    addi sp, sp, -8
    mv a0, s1
    mv a1, sp
    addi a2, sp, 4
    jal read_matrix
    mv s1, a0

    # Read input matrix
    addi sp, sp, -8
    mv a0, s1
    mv a1, sp
    addi a2, sp, 4
    jal read_matrix
    mv s2, a0

    # Compute h = matmul(m0, input)
    lw t1, 16(sp)
    lw t2, 4(sp)
    mul t0, t1, t2
    slli t0, t0, 2

    mv a0, t0
    jal malloc

    mv a6, a0
    mv a0, s0
    lw a1, 20(sp)
    lw a2, 16(sp)
    mv a3, s1
    lw a4, 4(sp)
    lw a5, 0(sp)
    jal matmul
    mv s5, a6

    # Compute h = relu(h)
    mv a0, s5
    jal relu

    # Compute o = matmul(m1, h)
    lw t1, 8(sp)
    lw t2, 16(sp)
    mul t0, t1, t2
    slli t0, t0, 2

    mv a0, t0
    jal malloc

    mv a6, a0
    mv a0, s1
    lw a1, 12(sp)
    lw a2, 8(sp)
    mv a3, s5
    lw a4, 16(sp)
    lw a5, 4(sp)
    jal matmul
    mv s6, a6

    # Write output matrix o
    mv a0, s3
    mv a1, s6
    lw a2, 8(sp)
    lw a3, 16(sp)

    # Compute and return argmax(o)
    mv a0, s6
    lw t1, 8(sp)
    lw t2, 16(sp)
    mul t0, t1, t2
    mv a1, t0
    jal argmax
    mv s7, a0

    # If enabled, print argmax(o) and newline
    beq s0, x0, print_argmax

    mv a0, s6
    jal free

    mv a0, s5
    jal free

    mv a0, s7
    addi sp, sp 24
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36
    
    jr ra

print_argmax:
    mv a0, s7
    jal print_int
    li t0, '\n'
    jal print_char

    mv a0, s6
    jal free

    mv a0, s5
    jal free

    mv a0, s7
    addi sp, sp 24
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36

    jr ra
