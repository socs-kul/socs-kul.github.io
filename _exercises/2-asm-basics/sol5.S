.data
   number: .word 12345
   result: .word 0

.text
.globl main
main:
   lw t0, number # Load number into t0
   li t1, 10                      
   li t2, 0 # Initialize sum (t2) to 0

add_digits:
    beq t0, zero, end # If num is 0, jump to end
    rem t3, t0, t1 # Get last digit (num % 10)
    add t2, t2, t3 # Add last digit to sum
    div t0, t0, t1 # Remove last digit (num /= 10)
    j add_digits # Repeat

end:
    la t0, result
    sw t1, (t0) # Store the result