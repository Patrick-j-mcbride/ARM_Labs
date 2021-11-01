    .data
iMsg:       .asciz  "Enter a number: "
    .align  2

inpt:   .asciz  "%d"
    .align  2

opt:   .asciz  "\n%d\n"
    .align 2
num:    .word    0
    .align 2

    .text
//***********************************************
    .global isprime
isprime:
        stp     x29, x30, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!

        mov     x21, x0         // save input 

        cmp     x0, #1
        ble     false           // return if n <=1

        mov     x22, #2

top:
        cmp     x22, x21        // compare itr to n
        beq     true            // return true 

        mov     x0, x21         // put n into x0
        mov     x1, x22         // put itr into x1
        bl      divide

        cmp     x1, xzr         // check if remainder is 0
        beq     false           // branch if remainder is 0
        add     x22, x22, #1      // move itr        
        b       top

false:
        mov     x0, xzr
        b       exit
true:
        mov     x0, #1
        b       exit
exit:
        ldp     x21, x22, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

        
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
    .global main
main:
        stp     x29, x30, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!

        ldr     x0, =iMsg 
        bl      printf 

        ldr     x0, =inpt
        ldr     x1, =num
        bl      scanf // read input 

        mov     x21, xzr
        ldr     x22, num

up: 
        add     x21, x21, #1
        cmp     x21, x22
        bge     fsh
    
        mov     x0, x21
        bl      isprime
        cmp     x0, xzr 
        beq     up

pnt:
        mov     x1, x21 
        ldr     x0, =opt
        bl      printf
        b       up
fsh:
        mov     x0, xzr
        ldp     x21, x22, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
//***********************************************
