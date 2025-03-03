.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    sw s5, 24(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    mv a0, s0
    li a1, 1

    jal fopen
    blt a0, x0, error_open
    mv s4, a0

    mv a0, s4
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)
    mv a1, sp
    li a2, 2
    li a3, 4
    jal fwrite
    li t0, 2
    bne a0, t0, error_write
    addi sp, sp, 8

    mv a0, s4
    mv a1, s1
    mul s5, s2, s3
    mv a2, s5
    li a3, 4
    jal fwrite
    bne s5, a0, error_write

    mv a0, s4
    jal fclose
    bne a0, x0, error_close


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28


    jr ra


error_write:
    li a0, 30
    j exit

error_open:
    li a0, 27
    j exit

error_close:
    li a0, 28
    j exit