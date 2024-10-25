.data
    x: .word 4
    y: .word 5
    z: .space 4

.text

.globl main
square:
    mul a0, a0, a0  #1 Arguments are in a0, a1, a2, a3, a4, a5, a6, a7
    ret

sum:
    add a0, a0, a1
    ret             # 2 Use ret instead of j back
    
square_distance:
    addi sp, sp, -16 
    sw a0, 0(sp) 
    sw a1, 4(sp)    
    sw ra, 8(sp)    # 3 Save ra 
    sw s0, 12(sp)   # Save s0 

    jal square	    #
    mv s0, a0	    #
    mv a0, a1	    #
    jal square	    #
    mv a1, s0	    #
    jal sum	        # 5 Use jal instead of j

    lw ra, 8(sp)    # 6 Restore ra
    lw s0, 12(sp)   # Restore s0
    addi sp, sp, 16 # 7 Restore sp
    ret
    
    
main:
    lw a0, x
    lw a1, y
    jal square_distance
    sw a0, z, t0