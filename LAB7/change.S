    .data
o1:       .asciz  "\nEnter the number of pennies, nickels, dimes, and quarters for week %d: "
    .align  2

i1:   .asciz  "%d%d%d%d"
    .align  2

o2:   .asciz  "\n\nOver four weeks you have collected %d pennnies, %d nickles, %d dimes, and %d quarters.\n\n"
    .align 2

o3:   .asciz  "This comes to $%d.%d\n\n"
    .align 2
o4:   .asciz  "Your weekly average is $%d.%d\n\n"
    .align 2
o5:   .asciz  "Your extimated yearly savings is $%d.%d\n\n"
    .align 2

p:      .word    0
n:      .word    0
d:      .word    0
q:      .word    0
    .text
//***********************************************
// takes two integers from x0 and x1 
// devides x0 by x1 
// returns whole number in x0 and remainder in x1
    .global divide
divide:
        stp     x29, x30, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!

        mov     x2, xzr // set itr to 0
        mov     x4, xzr // set sum to 0

// for loop that stops when sum >= x0
lp:
        add     x2, x2, #1
        add     x4, x4, x1
        cmp     w4, w0
        bgt     isRem
        beq     noRem
        b       lp

// branched to when there is a remainder
isRem:
        sub     x4, x4, x1
        sub     x1, x0, x4
        sub     x0, x2, #1
        ldp     x21, x22, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

// branched to when there is not a remainder
noRem:
        sub     x1, x4, x0
        mov     x0, x2 
        ldp     x21, x22, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
//***********************************************


//***********************************************
// Takes the number of coins for four weeks 
// finds total and projected yearly savings 
    .global main
main:
        stp     x29, x30, [sp, #-16]!
        stp     x25, x26, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!

        mov     x21, xzr // move zero to registers that will be added to
        mov     x23, xzr
        mov     x24, xzr
        mov     x25, xzr
        mov     x26, xzr


gt:        // loop 4 times to get the number of coins for the week
        add     x21, x21, #1
        ldr     x0, =o1
        mov     x1, x21
        bl      printf 
        
        ldr     x0, =i1
        ldr     x1, =p
        ldr     x2, =n 
        ldr     x3, =d
        ldr     x4, =q 
        bl      scanf

        ldr     x1, p
        ldr     x2, n 
        ldr     x3, d
        ldr     x4, q 

        add     x23, x23, x1
        add     x24, x24, x2
        add     x25, x25, x3
        add     x26, x26, x4

        cmp     x21, #4
        blt     gt

        ldr     x0, =o2
        mov     x1, x23
        mov     x2, x24
        mov     x3, x25
        mov     x4, x26 

        bl      printf // print toatal number of each coin

        lsl     x1, x24, #2
        add     x1, x24, x1
        // multiply x24 times 5


        lsl     x2, x25, #3
        add     x2, x25, x2
        add     x2, x25, x2
        // multiply x25 times 10


        lsl     x3, x26, #1 // x 2
        add     x3, x3, x26 // + 1
        lsl     x3, x3, #3 // 
        add     x3, x3, x26
        
        // multiply x26 times 25 

        mov     x0, xzr
        add     x4, x23, x1
        add     x5, x2, x3
        add     x0, x4, x5 
        mov     x25, x0

        mov     x1, xzr
        add     x1, x1, #100
        bl      divide

        mov     w2, w1
        mov     w1, w0
        ldr     x0, =o3
        bl      printf 

// weekly
        mov     x1, xzr
        add     x1, x1, #4
        mov     x0, x25
        bl      divide

        mov     x1, xzr
        add     x1, x1, #100
        bl      divide
        mov     w2, w1
        mov     w1, w0
        ldr     x0, =o4
        bl      printf 

// yearly
        lsl     x0, x25, #3
        lsl     x1, x25, #2
        add     x1, x1, x25
        add     x0, x0, x1

        mov     x1, #100
        bl      divide
        mov     w2, w1
        mov     w1, w0
        ldr     x0, =o5
        bl      printf 


        mov     x0, xzr
        ldp     x21, x22, [sp], #16
        ldp     x23, x24, [sp], #16
        ldp     x25, x26, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
//***********************************************
