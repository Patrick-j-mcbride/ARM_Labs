            .data
            .align 8
xLow:       .quad   1
xHigh:      .quad   2
rows:       .quad   3 
o1:         .asciz  "\nThis program will create a table for f(x) = (x^3 -x^2 -2x)/( ( (x-2)^4 )/11 ) + 3)\n\nEnter the lowest value of x: "
            .align  2
i1:         .asciz  "%lf"
            .align  2
i2:         .asciz  "%lf            "
            .align  2  
i3:         .asciz  "%lf\n"
            .align  2          
o2:         .asciz  "\nEnter the highest value of x: "
            .align  2
o3:         .asciz  "\nEnter the number of rows for the table: "
            .align 2
            .text
            .align 2

.global fx
fx:
            stp     x29, x30, [sp, #-16]!
            
            fmov    d7, #2.0
            fsub    d3, d0, d7

            fmul    d4, d3, d3
            fmul    d4, d4, d4 

            fmov    d7, #1.0
            fsub    d5, d0, d7

            fmul    d3, d3, d5

            fmov    d7, #3.0
            fmov    d6, #11.0
            fmul    d7, d7, d6
            fadd    d4, d4, d7

            fdiv    d3, d3, d4

            fmov    d7, #11
            fmul    d4, d0, d7

            fmul    d0, d3, d4

            ldp     x29, x30, [sp], #16
            ret

// Takes no arguments. Prompts for and stores input from user. 
// returns rows in x0 and inc in d0
.global getPut
getPut:
            stp     x29, x30, [sp, #-16]!

            ldr     x0, =o1
            bl      printf          // print program message and prompt for lowest x value

            ldr     x0, =i1
            ldr     x1, =xLow
            bl      scanf           // read lowest x value

            ldr     x0, =o2     
            bl      printf          // prompt for highest x value

            ldr     x0, =i1
            ldr     x1, =xHigh
            bl      scanf           // read highest x value

            ldr     x0, =o3     
            bl      printf          // prompt for number of rows

            ldr     x0, =i1
            ldr     x1, =rows
            bl      scanf           // read number of rows

            ldr     x3, =rows   
            ldr     d3, [x3]        // load rows into d3
            fcvtas  x10, d3         // convert rows to int 

            ldr     x2, =xHigh
            ldr     d2, [x2]        // load xHigh into d2

            ldr     x1, =xLow
            ldr     d1, [x1]        // load xLow into d1

            fsub    d0, d2, d1      // high - low into d0 
        
            fdiv    d0, d0, d3      // d0 / rows

            mov     x0, x10
            ldp     x29, x30, [sp], #16
            ret

.global main
main:
            stp     x29, x30, [sp, #-16]!
            stp     x27, x28, [sp, #-16]!

            bl      getPut      // returns num rows in x0

            mov     x28, x0

            fmov    d3, d0     // move

top:
            cmp     w28, wzr    // compare itr 0
            blt     done        // branch if itr < 0

            fmov    d0, d1
            ldr     x0, =i2
            bl      printf      // print x

            fmov    d0, d1      // move x into d0
            bl      fx          // calculate f(x+move)

            ldr     x0, =i3     
            bl      printf      // print f(x)

            fadd    d1, d1, d3  // add move to x

            sub     w28, w28, #1  // itr--
            b       top

done:
            mov     x0, xzr
            ldp     x27, x28, [sp], #16
            ldp     x29, x30, [sp], #16
            ret


