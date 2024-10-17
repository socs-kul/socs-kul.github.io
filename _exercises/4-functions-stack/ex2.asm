.data
    x: .word 4
    y: .word 5
    z: .space 4

.text

.globl main
square:
    mul s0, s0, s0  #1
    ret

sum:
    add a0, a0, a1
    j back          # 2
    
square_distance:
    addi sp, sp, -12 
    mv t0, ra       # 3
    sw a0, 0(sp) 
    sw a1, 4(sp)    
 
    mv s0, a0       # 4 This whole block is a mess...
    jal square	    #
    mv a0, s0	    #
    mv s0, a1	    #
    jal square	    #
    mv a1, s0	    #
    j sum	        # 5
back:

    mv ra, t0       # 6 Is this the correct way to do it?
                    # 7 What misses here
    ret
    
    
main:
    lw a0, x
    lw a1, y
    jal square_distance
    sw a0, z, t0