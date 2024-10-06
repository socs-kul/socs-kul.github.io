.data
    year: .word 2000
    result: .word 0 # To store the result (0 or 1)

.text
.globl main
main:
    lw t0, year # Load year into t0

    # Check if the year is divisible by 4
    li t1, 4                 
    rem t2, t0, t1 # t2 = year % 4
    bnez t2, not_leap # If not divisible by 4, go to not_leap

    # Check if the year is divisible by 100
    li t1, 100               
    rem t2, t0, t1 # t2 = year % 100
    beqz t2, check_400 # If divisible by 100, check 400

    # Year is a leap year (divisible by 4 and not 100)
    li t3, 1 # Set result to 1 (leap year)
    j store_result

check_400:
    # Check if the year is divisible by 400
    li t1, 400               
    rem t2, t0, t1 # t2 = year % 400
    beqz t2, leap # If divisible by 400, it is a leap year

not_leap:
    # Year is not a leap year
    li t3, 0 # Set result to 0 (not a leap year)
    j store_result

leap:
    # Year is a leap year
    li t3, 1 # Set result to 1 (leap year)

store_result:
    la t0, result # Load address of result
    sw t3, (t0) # Store the result