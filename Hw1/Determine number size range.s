.data
input1: .word 16
input2: .word 33
input3: .word 254
str1: .string "The number "
str2: .string " is roughly between 2^"
str3: .string " and 2^"
str4: .string "\n"
.text
main:
    la a0, input1 # a0 = input1
    lw a0, 0(a0)  # load 32-bit word
    jal ra, determine_size

    la a0, input2 # a0 = input2
    lw a0, 0(a0)  # load 32-bit word
    jal ra, determine_size
    
    la a0, input3 # a0 = input3
    lw a0, 0(a0)  # load 32-bit word
    jal ra, determine_size
    # End program
    li a7, 10 # syscall for program termination
    ecall


determine_size:
    # Preserve ra (return address)
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, a0 # a1 = input
    
    la a0, str1
    li a7, 4  
    ecall

    mv a0, a1
    li a7, 1
    ecall

    # Call count_leading_zeros
    jal ra, count_leading_zeros

    # Restore ra
    lw ra, 0(sp)
    addi sp, sp, 4

    mv t3, a0
    
    la a0, str2
    li a7, 4  
    ecall
 
    # Subtract it from 64 to get the position
    li t1, 64
    sub t1, t1, t3  # t1 will now hold the bit_position
    mv t2, t1       # move the value to t2 to preserve it

    # Now, check if the bit_position is zero (which means input number was 0)
    beqz t1, print_zero

    # Subtract 1 from bit_position and print the value
    addi a0, t1, -1
    li a7, 1  # Assuming syscall code 1 is for printing integers in your environment
    ecall

    la a0, str3
    li a7, 4  
    ecall

    # Then print the bit_position (from t2)
    mv a0, t2
    li a7, 1
    ecall

    la a0, str4
    li a7, 4  
    ecall
    
    ret


print_zero:
    li  a0, 0     # Load the integer value 0 to a0
    li  a7, 1     # syscall code for print integer
    ecall
    ret


count_leading_zeros:
    srli t1, a0, 1
    or   a0, a0, t1

    srli t1, a0, 2
    or   a0, a0, t1

    srli t1, a0, 4
    or   a0, a0, t1

    srli t1, a0, 8
    or   a0, a0, t1

    srli t1, a0, 16
    or   a0, a0, t1

    # Start of population count
    li   t2, 0x55555555
    srli t1, a0, 1
    and  t1, t1, t2
    sub  a0, a0, t1

    li   t2, 0x33333333
    srli t1, a0, 2
    and  t1, t1, t2
    and  a0, a0, t2
    add  a0, a0, t1

    srli t1, a0, 4
    add  a0, a0, t1
    li   t2, 0x0f0f0f0f
    and  a0, a0, t2

    srli t1, a0, 8
    add  a0, a0, t1

    srli t1, a0, 16
    add  a0, a0, t1

    # 64 - (x & 0x3f)
    andi a0, a0, 0x3f
    li   t1, 64
    sub  a0, t1, a0

    ret
