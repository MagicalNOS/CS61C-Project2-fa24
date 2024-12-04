.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)

    # Save arguments
    mv s0, a0   # filename
    mv s1, a1   # rows pointer
    mv s2, a2   # cols pointer

    # Allocate memory for row and column counts
    li a0, 8
    jal malloc
    beq a0, x0, error_malloc
    mv s4, a0   # Save buffer for row/col counts

    # Open file
    mv a0, s0
    li a1, 0
    jal fopen
    blt a0, x0, error_open
    mv s3, a0   # Save file descriptor

    # Read row and column counts
    mv a0, s3
    mv a1, s4
    li a2, 8
    jal fread
    li t0, 8
    bne a0, t0, error_read

    # Get row and column counts and store them
    lw t1, 0(s4)  # rows
    lw t2, 4(s4)  # cols
    sw t1, 0(s1)  # Store rows
    sw t2, 0(s2)  # Store cols

    # Calculate matrix size and allocate memory
    mul s6, t1, t2   # Save total number of elements in s6
    slli s6, s6, 2   # Multiply by 4 for int size
    mv a0, s6
    jal malloc
    beq a0, x0, error_malloc
    mv s5, a0   # Save matrix pointer

    # Read matrix data
    mv a0, s3
    mv a1, s5
    mv a2, s6    
    jal fread
    bne a0, s6, error_read

    # Close file
    mv a0, s3
    jal fclose
    blt a0, x0, error_close

    # Set return value
    mv a0, s5

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32

    jr ra

error_malloc:
    li a0, 26
    j exit

error_open:
    li a0, 27
    j exit

error_read:
    li a0, 29
    j exit

error_close:
    li a0, 28
    j exit